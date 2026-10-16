import 'dart:typed_data';

import 'package:chords/data/audio/band/acoustic_guitar.dart';
import 'package:chords/data/audio/band/dsp/sample_finisher.dart';
import 'package:chords/data/audio/band/electric_guitar.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Pico de una muestra de guitarra.
const double _guitarPeak = 0.8;

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
  return finishSample(raw, peak: _guitarPeak, fadeOutSeconds: 0.06);
}
