import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/dsp/biquad.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';

/// Suma un tono que cae de [startHz] a [endHz] (constante de tiempo
/// [pitchTau]) con una envolvente exponencial [ampTau]: el cuerpo de un
/// bombo, un tom o una conga.
void addSweepTone(
  Float64List out, {
  required double startHz,
  required double endHz,
  required double pitchTau,
  required double ampTau,
  double amp = 1,
  double attack = 0.0008,
}) {
  double phase = 0;
  final int rise = math.max(1, samplesOf(attack));
  for (int i = 0; i < out.length; i++) {
    final double t = i / kBandRate;
    final double hz = endHz + (startHz - endHz) * decayAt(t, pitchTau);
    phase += kTwoPi * hz / kBandRate;
    final double ramp = i < rise ? i / rise : 1;
    out[i] += amp * ramp * decayAt(t, ampTau) * math.sin(phase);
  }
}

/// Suma una ráfaga de ruido filtrado: `ruido → pasa-altos → pasa-bajos`,
/// con envolvente exponencial [tau], que empieza en [start] muestras.
void addNoiseBurst(
  Float64List out, {
  required Noise noise,
  required double tau,
  required double amp,
  double highPassHz = 0,
  double lowPassHz = 0,
  double bandHz = 0,
  double bandQ = 1,
  int start = 0,
  double attack = 0.0004,
}) {
  final Biquad? high = highPassHz > 0
      ? Biquad.highPass(highPassHz, 0.7, kBandRate)
      : null;
  final Biquad? low = lowPassHz > 0
      ? Biquad.lowPass(lowPassHz, 0.7, kBandRate)
      : null;
  final Biquad? band = bandHz > 0
      ? Biquad.bandPass(bandHz, bandQ, kBandRate)
      : null;
  final int rise = math.max(1, samplesOf(attack));
  final int reach = math.min(out.length, start + samplesOf(tau * 9));
  for (int i = start; i < reach; i++) {
    double x = noise.next();
    x = band?.next(x) ?? x;
    x = high?.next(x) ?? x;
    x = low?.next(x) ?? x;
    final int n = i - start;
    final double ramp = n < rise ? n / rise : 1;
    out[i] += amp * ramp * decayAt(n / kBandRate, tau) * x;
  }
}

/// Frecuencias de los seis cuadrados inarmónicos de un charles (estilo 808).
const List<double> kMetalFrequencies = <double>[
  205.3,
  304.4,
  369.6,
  522.7,
  540,
  800,
];

/// Suma el metal de un plato: seis ondas cuadradas inarmónicas escaladas por
/// [scale], con caída [tau].
void addMetal(
  Float64List out, {
  required double tau,
  required double amp,
  double scale = 1,
  int start = 0,
}) {
  for (final double base in kMetalFrequencies) {
    final double w = kTwoPi * base * scale / kBandRate;
    double phase = 0;
    for (int i = start; i < out.length; i++) {
      phase += w;
      final double square = math.sin(phase) >= 0 ? 1.0 : -1.0;
      out[i] +=
          amp /
          kMetalFrequencies.length *
          square *
          decayAt((i - start) / kBandRate, tau);
    }
  }
}
