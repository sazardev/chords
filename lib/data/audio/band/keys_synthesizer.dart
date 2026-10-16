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

/// Pico de una muestra de teclado.
const double _keysPeak = 0.72;

/// Segundos que dura cada longitud (la larga de piano y Rhodes se apaga sola).
const Map<NoteLength, double> _seconds = <NoteLength, double>{
  NoteLength.short: 0.3,
  NoteLength.medium: 0.85,
  NoteLength.long: 2.6,
};

/// Sintetiza el acorde [notes] en un teclado.
///
/// Piano y Rhodes suenan una vez y se apagan solos. El órgano y las cuerdas
/// con longitud [NoteLength.long] son sostenidos: la muestra lleva un tramo
/// de bucle.
RenderedSound renderKeys(KeysKind kind, NoteLength length, List<int> notes) {
  final bool sustained =
      length == NoteLength.long &&
      (kind == KeysKind.organ || kind == KeysKind.pad);
  if (sustained) {
    return _sustained(kind, notes);
  }
  final Float64List out = silence(_seconds[length]!);
  for (final int midi in notes) {
    switch (kind) {
      case KeysKind.piano:
        _pianoNote(out, midiHz(midi), midi);
      case KeysKind.rhodes:
        _rhodesNote(out, midiHz(midi));
      case KeysKind.organ:
        _organNote(out, midiHz(midi), null);
      case KeysKind.pad:
        _padNote(out, midiHz(midi), null);
    }
  }
  _release(out, length, kind);
  return RenderedSound(
    finishSample(out, peak: _keysPeak, fadeOutSeconds: 0.05),
  );
}

/// Cierra la nota como lo haría el apagador: corto, medio o suelto.
void _release(Float64List out, NoteLength length, KeysKind kind) {
  final double hold = switch (length) {
    NoteLength.short => 0.12,
    NoteLength.medium => 0.5,
    NoteLength.long => 2.2,
  };
  final double damper = switch (kind) {
    KeysKind.piano || KeysKind.rhodes => 0.09,
    _ => 0.05,
  };
  for (int i = samplesOf(hold); i < out.length; i++) {
    out[i] *= decayAt((i - samplesOf(hold)) / kBandRate, damper);
  }
  if (kind == KeysKind.pad || kind == KeysKind.organ) {
    applyAttackRelease(out, attack: kind == KeysKind.pad ? 0.1 : 0.008);
  }
}

/// Piano: parciales con algo de inarmonicidad, dos cuerdas ligeramente
/// desafinadas que laten y un golpe de martillo.
void _pianoNote(Float64List out, double hz, int midi) {
  final double tau0 = (3.0 * math.pow(261 / hz, 0.55)).clamp(0.6, 6.0);
  final int harmonics = hz < 200 ? 12 : (hz < 500 ? 8 : 5);
  final double inharmonic = 0.00018 * math.pow(hz / 261, 2);
  for (int k = 1; k <= harmonics; k++) {
    final double fk = hz * k * math.sqrt(1 + inharmonic * k * k);
    final double amp = math.exp(-(k - 1) * 0.2) / k;
    final double tau = tau0 / (1 + 0.9 * math.pow(k - 1, 0.8));
    addDamped(out, fk * 1.0006, tau, amp * 0.6, phase: k * 0.3);
    addDamped(out, fk * 0.9995, tau * 1.05, amp * 0.6, phase: k * 0.7);
  }
  addNoiseBurst(
    out,
    noise: Noise(midi),
    tau: 0.006,
    amp: 0.2,
    lowPassHz: 1200,
    attack: 0.0015,
  );
}

/// Piano eléctrico: modulación de frecuencia a la octava con un índice que
/// cae (el "ladrido" de la pala) y un tintineo agudo de la lengüeta.
void _rhodesNote(Float64List out, double hz) {
  final double tau = (2.2 * math.pow(261 / hz, 0.4)).clamp(0.8, 4.0);
  final double w = kTwoPi * hz / kBandRate;
  final double decayStep = math.exp(-1 / (tau * kBandRate));
  final double indexStep = math.exp(-1 / (0.28 * kBandRate));
  final double bellStep = math.exp(-1 / (0.035 * kBandRate));
  double envelope = 1;
  double index = 1.9;
  double bell = 1;
  for (int i = 0; i < out.length; i++) {
    final double phase = w * i;
    final double tone =
        math.sin(phase + (0.35 + index) * math.sin(phase)) +
        0.5 * math.sin(phase * 1.003 + 0.2 * index * math.sin(phase * 1.003));
    final double ping = bell * 0.22 * math.sin(phase * 7 + 1.1);
    out[i] += envelope * (tone + ping) * 0.6;
    envelope *= decayStep;
    index *= indexStep;
    bell *= bellStep;
  }
}

/// Armónicos del órgano: 16', 8', 5⅓', 4', 2⅔', 2', 1⅗' y 1' con las barras
/// de un ajuste de rock (888000000 ampliado).
const List<(double, double)> _drawbars = <(double, double)>[
  (0.5, 0.8),
  (1, 1.0),
  (1.5, 0.6),
  (2, 0.75),
  (3, 0.35),
  (4, 0.4),
  (5, 0.12),
  (8, 0.1),
];

void _organNote(Float64List out, double hz, LoopPlan? plan) {
  for (final (double ratio, double amp) in _drawbars) {
    final double f = hz * ratio;
    addSustained(out, plan?.snap(f) ?? f, amp * 0.5);
  }
}

void _padNote(Float64List out, double hz, LoopPlan? plan) {
  for (final double cents in <double>[-9, 9]) {
    addHarmonics(
      out,
      hz,
      10,
      (int k) => 0.5 / math.pow(k, 1.25),
      plan: plan,
      detuneCents: cents,
    );
  }
}

/// Órgano o cuerdas sostenidos: ataque + un periodo que se repite.
RenderedSound _sustained(KeysKind kind, List<int> notes) {
  final bool organ = kind == KeysKind.organ;
  final LoopPlan plan = LoopPlan(organ ? 0.06 : 0.5);
  final Float64List out = Float64List(plan.totalSamples);
  for (final int midi in notes) {
    if (organ) {
      _organNote(out, midiHz(midi), plan);
    } else {
      _padNote(out, midiHz(midi), plan);
    }
  }
  if (organ) {
    applyTremolo(out, 6, 0.1);
    addNoiseBurst(
      out,
      noise: Noise(notes.length),
      tau: 0.004,
      amp: 0.5 * notes.length,
      bandHz: 2600,
    );
  } else {
    Biquad.lowPass(4200, 0.7, kBandRate).apply(out);
  }
  // El ataque solo se aplica al principio; el bucle no se toca.
  applyAttackRelease(out, attack: organ ? 0.012 : 0.4);
  finishSample(out, peak: _keysPeak, loopable: true);
  return RenderedSound(out, loopStart: plan.attackSamples);
}
