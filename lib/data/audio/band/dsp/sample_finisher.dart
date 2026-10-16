import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/dsp/dsp_kit.dart';

/// Deja una muestra lista para tocar: sin valores no finitos, sin continua,
/// con fundidos sin clics y normalizada a un pico concreto.
///
/// [peak] es el pico final (nunca más de 0,98). Con [loopable] no se aplica
/// el fundido final, para que el bucle empalme.
Float64List finishSample(
  Float64List samples, {
  required double peak,
  bool loopable = false,
  double fadeOutSeconds = 0.012,
}) {
  _sanitize(samples);
  if (!loopable) {
    _removeDc(samples);
  }
  _fade(samples, loopable ? 0 : samplesOf(fadeOutSeconds));
  double maximum = 0;
  for (final double value in samples) {
    maximum = math.max(maximum, value.abs());
  }
  final double target = peak.clamp(0.0, 0.98);
  final double gain = maximum > 1e-9 ? target / maximum : 0;
  for (int i = 0; i < samples.length; i++) {
    samples[i] = (samples[i] * gain).clamp(-0.999, 0.999);
  }
  return samples;
}

void _sanitize(Float64List samples) {
  for (int i = 0; i < samples.length; i++) {
    final double value = samples[i];
    if (value.isNaN || value.isInfinite) {
      samples[i] = 0;
    }
  }
}

/// Filtro de un polo que quita la componente continua y el retumbo
/// inaudible.
void _removeDc(Float64List samples) {
  const double r = 0.9985;
  double previousIn = 0;
  double previousOut = 0;
  for (int i = 0; i < samples.length; i++) {
    final double input = samples[i];
    final double output = input - previousIn + r * previousOut;
    previousIn = input;
    previousOut = output;
    samples[i] = output;
  }
}

/// Fundido de entrada de medio milisegundo y de salida de [outSamples].
void _fade(Float64List samples, int outSamples) {
  final int length = samples.length;
  final int fadeIn = math.min(length ~/ 4, samplesOf(0.0006));
  for (int i = 0; i < fadeIn; i++) {
    samples[i] *= i / fadeIn;
  }
  final int fadeOut = math.min(length ~/ 2, outSamples);
  for (int i = 0; i < fadeOut; i++) {
    samples[length - 1 - i] *= i / fadeOut;
  }
}
