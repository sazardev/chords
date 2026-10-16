import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/biquad.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/strum_mixer.dart';
import 'package:chords/data/audio/guitar_body.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Guitarra acústica de acero o clásica de nailon: cuerdas Karplus-Strong
/// (las de siempre en la app) escalonadas y pasadas por la caja de
/// resonancia.
///
/// El nailon pulsa más suave, pierde brillo y se apaga antes; su rasgueado de
/// flamenco ([GuitarStroke.roll]) encadena cuatro golpes y un golpe de caja.
Float64List renderAcoustic(
  GuitarStroke stroke,
  List<int> notes, {
  required bool nylon,
}) {
  final Float64List mix = switch (stroke) {
    GuitarStroke.roll => _roll(notes),
    _ => _single(stroke, notes, nylon: nylon),
  };
  if (nylon) {
    Biquad.lowPass(3600, 0.7, kBandRate).apply(mix);
  }
  return const GuitarBody().process(mix);
}

Float64List _single(
  GuitarStroke stroke,
  List<int> notes, {
  required bool nylon,
}) {
  final (double, double, double, double) setup = switch (stroke) {
    GuitarStroke.up => (1.0, 0.6, 6, 0.55),
    GuitarStroke.mute => (0.32, 0.07, 5, 0.8),
    GuitarStroke.chop => (0.2, 0.035, 3, 0.85),
    GuitarStroke.bass => (1.5, 1.0, 0, 0.8),
    _ => (2.0, 1.4, 8, 0.85),
  };
  final List<int> played = switch (stroke) {
    GuitarStroke.bass => <int>[notes.first],
    GuitarStroke.up => notes.reversed.take(4).toList(),
    _ => notes,
  };
  final Float64List out = silence(setup.$1);
  addStrum(
    out,
    StrumSpec(
      notes: played,
      seconds: setup.$1,
      spacingMs: setup.$3,
      velocity: nylon ? setup.$4 - 0.25 : setup.$4,
      pickPosition: nylon ? 0.2 : 0.13,
    ),
  );
  if (stroke == GuitarStroke.mute || stroke == GuitarStroke.chop) {
    Biquad.lowPass(2000, 0.8, kBandRate).apply(out);
  }
  applyDecay(out, nylon ? setup.$2 * 0.8 : setup.$2);
  return out;
}

/// Rasgueado: abajo, arriba, abajo, arriba cada 60 ms más un golpe en la tapa.
Float64List _roll(List<int> notes) {
  final Float64List out = silence(1.3);
  for (int hit = 0; hit < 4; hit++) {
    final bool down = hit.isEven;
    addStrum(
      out,
      StrumSpec(
        notes: down ? notes : notes.reversed.take(4).toList(),
        seconds: 0.9,
        spacingMs: down ? 5 : 4,
        velocity: down ? 0.7 : 0.5,
        pickPosition: 0.2,
        seed: 9 + hit,
      ),
      startAt: samplesOf(hit * 0.06),
    );
  }
  addSweepTone(
    out,
    startHz: 160,
    endHz: 110,
    pitchTau: 0.02,
    ampTau: 0.03,
    amp: 0.5,
  );
  applyDecay(out, 0.9);
  return out;
}
