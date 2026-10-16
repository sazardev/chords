import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/biquad.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/dsp/sample_finisher.dart';
import 'package:chords/data/audio/guitar_string_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Pico de una nota de bajo: el bajo manda en la mezcla.
const double _bassPeak = 0.9;

/// Sintetiza una nota de bajo.
///
/// Los eléctricos y el contrabajo salen de una cuerda Karplus-Strong afinada
/// (la misma del resto de la app) con distinta pulsación y color; el
/// sintetizado mezcla un sub con una sierra filtrada. Todos pasan por una
/// saturación suave que añade armónicos: sin ella, un Mi grave de 41 Hz no se
/// oiría en el altavoz de un móvil.
Float64List renderBass(BassKind kind, int midi, NoteLength length) {
  final double hz = midiHz(midi);
  final (double, double, double) shape = switch (length) {
    NoteLength.short => (0.24, 0.1, 0.03),
    NoteLength.medium => (0.6, 0.35, 0.07),
    NoteLength.long => (1.5, 1.0, 0.14),
  };
  final int n = samplesOf(shape.$1);
  final Float64List raw = switch (kind) {
    BassKind.finger => _finger(hz, n, midi),
    BassKind.pick => _pick(hz, n, midi),
    BassKind.upright => _upright(hz, n, midi),
    BassKind.synth => _synth(hz, n, length),
  };
  for (int i = 0; i < n; i++) {
    raw[i] *= decayAt(i / kBandRate, shape.$2);
  }
  return finishSample(raw, peak: _bassPeak, fadeOutSeconds: shape.$3);
}

Float64List _string(
  double hz,
  int n,
  int midi, {
  required double velocity,
  required double pickPosition,
}) => const GuitarStringVoice().render(
  hz,
  n,
  velocity: velocity,
  pickPosition: pickPosition,
  seed: 31 + midi * 7,
);

/// Eléctrico de dedos: redondo, con un sub que da cuerpo.
Float64List _finger(double hz, int n, int midi) {
  final Float64List out = _string(
    hz,
    n,
    midi,
    velocity: 0.5,
    pickPosition: 0.3,
  );
  Biquad.lowPass(2300, 0.7, kBandRate).apply(out);
  Biquad.peaking(750, 1, 4, kBandRate).apply(out);
  return _saturate(out, 3);
}

/// Eléctrico de púa: más ataque, más brillo y un chasquido.
Float64List _pick(double hz, int n, int midi) {
  final Float64List out = _string(
    hz,
    n,
    midi,
    velocity: 0.95,
    pickPosition: 0.1,
  );
  Biquad.lowPass(4200, 0.7, kBandRate).apply(out);
  addNoiseBurst(
    out,
    noise: Noise(midi),
    tau: 0.004,
    amp: _rms(out) * 1.6,
    highPassHz: 2200,
  );
  return _saturate(out, 2.6);
}

/// Contrabajo: cuerda suave, madera resonante y el golpe del dedo.
Float64List _upright(double hz, int n, int midi) {
  final Float64List out = _string(
    hz,
    n,
    midi,
    velocity: 0.35,
    pickPosition: 0.22,
  );
  Biquad.lowPass(1100, 0.8, kBandRate).apply(out);
  Biquad.peaking(110, 1.2, 6, kBandRate).apply(out);
  Biquad.peaking(260, 1.5, 4, kBandRate).apply(out);
  final double body = _rms(out);
  addDamped(out, math.max(hz, 70), 0.025, body * 1.2);
  addNoiseBurst(
    out,
    noise: Noise(midi + 5),
    tau: 0.006,
    amp: body * 0.9,
    bandHz: 700,
  );
  return _saturate(out, 2);
}

/// Bajo sintético: sub con caída de tono y sierra filtrada.
Float64List _synth(double hz, int n, NoteLength length) {
  final Float64List out = Float64List(n);
  addSweepTone(
    out,
    startHz: hz * 1.6,
    endHz: hz,
    pitchTau: 0.03,
    ampTau: length == NoteLength.long ? 1.4 : 0.4,
    amp: 0.55,
  );
  final Float64List saw = Float64List(n);
  double phase = 0;
  final double step = hz / kBandRate;
  for (int i = 0; i < n; i++) {
    phase += step;
    phase -= phase.floorToDouble();
    saw[i] = (2 * phase - 1) * decayAt(i / kBandRate, 0.25);
  }
  Biquad.lowPass(1500, 1.1, kBandRate).apply(saw);
  for (int i = 0; i < n; i++) {
    out[i] += saw[i] * 0.9;
  }
  // Armónicos de la nota: dan altura donde el altavoz no llega al sub.
  for (int k = 2; k <= 5; k++) {
    addDamped(out, hz * k, length == NoteLength.long ? 0.7 : 0.25, 0.5 / k);
  }
  return _saturate(out, 3.2);
}

/// Lleva la señal a pico 1 y la satura con [drive]: los armónicos que añade
/// se oyen donde el altavoz no llega a la fundamental.
Float64List _saturate(Float64List samples, double drive) {
  double peak = 1e-9;
  for (final double value in samples) {
    peak = math.max(peak, value.abs());
  }
  for (int i = 0; i < samples.length; i++) {
    samples[i] = softClip(samples[i] / peak * drive);
  }
  return samples;
}

/// Nivel RMS de los primeros 0,15 s.
double _rms(Float64List samples) {
  final int count = math.min(samples.length, samplesOf(0.15));
  double energy = 0;
  for (int i = 0; i < count; i++) {
    energy += samples[i] * samples[i];
  }
  return math.sqrt(energy / math.max(1, count));
}
