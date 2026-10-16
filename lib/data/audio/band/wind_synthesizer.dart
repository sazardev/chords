import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/biquad.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/dsp/sample_finisher.dart';
import 'package:chords/data/audio/band/rendered_sound.dart';
import 'package:chords/data/audio/band/sustained_partials.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Pico de una muestra de viento.
const double _windPeak = 0.7;

/// Sintetiza el acorde [notes] de un acordeón o de unos metales.
///
/// Con [NoteLength.long] el sonido es sostenido (lleva un tramo de bucle);
/// con las demás es un golpe corto o medio que se cierra solo.
RenderedSound renderWind(WindKind kind, NoteLength length, List<int> notes) {
  if (length == NoteLength.long) {
    return _sustained(kind, notes);
  }
  final double seconds = length == NoteLength.short ? 0.26 : 0.7;
  final Float64List out = silence(seconds);
  final double hold = seconds * 0.5;
  for (final int midi in notes) {
    _voice(out, kind, midiHz(midi), null);
  }
  if (kind == WindKind.brass) {
    _brassBreath(out, notes.length);
  }
  applyAttackRelease(out, attack: kind == WindKind.brass ? 0.012 : 0.02);
  for (int i = samplesOf(hold); i < out.length; i++) {
    out[i] *= decayAt((i - samplesOf(hold)) / kBandRate, 0.06);
  }
  return RenderedSound(
    finishSample(out, peak: _windPeak, fadeOutSeconds: 0.04),
  );
}

void _voice(Float64List out, WindKind kind, double hz, LoopPlan? plan) {
  switch (kind) {
    case WindKind.accordion:
      // Dos juegos de lengüetas afinados algo distinto: el "musette".
      for (final double cents in <double>[-6, 6]) {
        addHarmonics(
          out,
          hz,
          14,
          (int k) => 0.55 / math.pow(k, 0.85) * _nasal(hz * k),
          plan: plan,
          detuneCents: cents,
        );
      }
    case WindKind.brass:
      addHarmonics(
        out,
        hz,
        16,
        (int k) => 0.7 / math.pow(k, 0.95) * _brassSpectrum(k),
        plan: plan,
      );
  }
}

/// Realce de la caja del acordeón entre 1 y 3 kHz.
double _nasal(double hz) =>
    1 + 1.4 * math.exp(-math.pow((hz - 1700) / 900, 2).toDouble());

/// Metales: los armónicos medios sobresalen un poco.
double _brassSpectrum(int k) => k >= 2 && k <= 6 ? 1.35 : 1;

/// Soplido del ataque de los metales.
void _brassBreath(Float64List out, int voices) {
  addNoiseBurst(
    out,
    noise: Noise(voices + 90),
    tau: 0.02,
    amp: 0.6 * voices,
    bandHz: 2200,
    bandQ: 0.8,
  );
}

RenderedSound _sustained(WindKind kind, List<int> notes) {
  final LoopPlan plan = LoopPlan(kind == WindKind.brass ? 0.1 : 0.06);
  final Float64List out = Float64List(plan.totalSamples);
  for (final int midi in notes) {
    _voice(out, kind, midiHz(midi), plan);
  }
  if (kind == WindKind.accordion) {
    applyTremolo(out, 5, 0.06);
  }
  Biquad.lowPass(
    kind == WindKind.brass ? 5200 : 6500,
    0.7,
    kBandRate,
  ).apply(out);
  applyAttackRelease(out, attack: kind == WindKind.brass ? 0.04 : 0.025);
  finishSample(out, peak: _windPeak, loopable: true);
  return RenderedSound(out, loopStart: plan.attackSamples);
}
