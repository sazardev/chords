import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';

/// Caja: dos tonos del parche más el ruido de los bordones.
///
/// La de jazz es más grave y suelta; la electrónica, seca y brillante.
Float64List renderSnare(DrumKit kit, {required bool hard}) {
  final double level = hard ? 1 : 0.55;
  final (double, double, double, double) setup = switch (kit) {
    DrumKit.acoustic => (190, 0.075, 0.14, 0.4),
    DrumKit.jazz => (165, 0.06, 0.2, 0.42),
    DrumKit.electronic => (215, 0.045, 0.09, 0.28),
  };
  final Float64List out = silence(setup.$4);
  addDamped(out, setup.$1, setup.$2, 0.8 * level);
  addDamped(out, setup.$1 * 1.75, setup.$2 * 0.6, 0.45 * level);
  addNoiseBurst(
    out,
    noise: Noise(71),
    tau: setup.$3,
    amp: 0.9 * (0.5 + 0.5 * level),
    highPassHz: kit == DrumKit.jazz ? 1400 : 2000,
    lowPassHz: 9500,
  );
  return out;
}

/// Aro de la caja (cross-stick): clic de madera con un cuerpo hueco.
Float64List renderRimshot({required bool hard}) {
  final Float64List out = silence(0.16);
  addDamped(out, 420, 0.018, 0.9);
  addDamped(out, 1700, 0.008, 0.5);
  addNoiseBurst(
    out,
    noise: Noise(72),
    tau: 0.006,
    amp: hard ? 0.5 : 0.25,
    bandHz: 1900,
  );
  return out;
}

/// Palmada electrónica: varias ráfagas de ruido muy seguidas y su cola.
Float64List renderClap({required bool hard}) {
  final Float64List out = silence(0.34);
  final Noise noise = Noise(73);
  for (final int offsetMs in <int>[0, 9, 19, 31]) {
    addNoiseBurst(
      out,
      noise: noise,
      tau: 0.0035,
      amp: 0.8,
      bandHz: 1250,
      bandQ: 1.3,
      start: samplesOf(offsetMs / 1000),
    );
  }
  addNoiseBurst(
    out,
    noise: noise,
    tau: hard ? 0.1 : 0.07,
    amp: 0.7,
    bandHz: 1100,
    bandQ: 1.1,
    start: samplesOf(0.033),
  );
  return out;
}

/// Palmas flamencas: [muted] son las sordas (mano ahuecada).
Float64List renderPalma({required bool muted}) {
  final Float64List out = silence(muted ? 0.14 : 0.3);
  final Noise noise = Noise(muted ? 75 : 74);
  addNoiseBurst(
    out,
    noise: noise,
    tau: muted ? 0.012 : 0.02,
    amp: 1,
    bandHz: muted ? 950 : 1900,
    bandQ: muted ? 1.4 : 1.1,
  );
  addNoiseBurst(
    out,
    noise: noise,
    tau: muted ? 0.01 : 0.06,
    amp: muted ? 0.2 : 0.5,
    bandHz: muted ? 700 : 1500,
    start: samplesOf(0.007),
  );
  return out;
}
