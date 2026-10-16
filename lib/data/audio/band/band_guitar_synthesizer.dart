import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/acoustic_guitar.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/dsp/sample_finisher.dart';
import 'package:chords/data/audio/band/electric_guitar.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Pico de una muestra de guitarra.
const double _guitarPeak = 0.8;

/// Cuánto se empuja la señal normalizada contra el compresor.
const double _compressDrive = 2.4;

/// Sintetiza un golpe de guitarra del tipo [kind] sobre las notas [notes].
Float64List renderGuitar(
  GuitarKind kind,
  GuitarStroke stroke,
  List<int> notes,
) {
  final Float64List raw = switch (kind) {
    GuitarKind.acoustic => renderAcoustic(stroke, notes, nylon: false),
    GuitarKind.nylon => renderAcoustic(stroke, notes, nylon: true),
    GuitarKind.clean => renderCleanElectric(stroke, notes),
    GuitarKind.distorted => renderDistorted(stroke, notes),
  };
  if (kind != GuitarKind.distorted) {
    _compress(raw);
  }
  return finishSample(raw, peak: _guitarPeak, fadeOutSeconds: 0.06);
}

/// Compresión suave: sube la cola de las cuerdas respecto al ataque, como
/// hace un micrófono o una pastilla con un compresor, para que la guitarra
/// limpia no quede por debajo de la batería y el bajo.
void _compress(Float64List samples) {
  double peak = 1e-9;
  for (final double value in samples) {
    peak = math.max(peak, value.abs());
  }
  for (int i = 0; i < samples.length; i++) {
    samples[i] = softClip(samples[i] / peak * _compressDrive);
  }
}
