import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';

/// Bombo: tono que cae más un chasquido del pedal; el de caja de ritmos es un
/// seno largo y grave con saturación.
Float64List renderKick(DrumKit kit, {required bool hard}) {
  final (double, double, double, double) setup = switch (kit) {
    DrumKit.acoustic => (hard ? 175 : 130, 52, 0.17, 0.5),
    DrumKit.jazz => (hard ? 210 : 170, 78, 0.12, 0.34),
    DrumKit.electronic => (hard ? 135 : 110, 46, 0.42, 0.95),
  };
  final Float64List out = silence(setup.$4);
  addSweepTone(
    out,
    startHz: setup.$1,
    endHz: setup.$2,
    pitchTau: 0.03,
    ampTau: setup.$3,
  );
  if (kit != DrumKit.electronic) {
    addNoiseBurst(
      out,
      noise: Noise(11),
      tau: 0.004,
      amp: hard ? 0.35 : 0.12,
      bandHz: 3200,
      bandQ: 0.8,
    );
  }
  for (int i = 0; i < out.length; i++) {
    out[i] = softClip(out[i] * (kit == DrumKit.electronic ? 1.8 : 1.3));
  }
  return out;
}

/// Tom con su altura: 0 agudo, 1 medio, 2 grave.
Float64List renderTom(int size, DrumKit kit, {required bool hard}) {
  const List<double> tops = <double>[235, 170, 120];
  final double top = tops[size] * (kit == DrumKit.jazz ? 1.15 : 1);
  final Float64List out = silence(kit == DrumKit.electronic ? 0.7 : 0.55);
  addSweepTone(
    out,
    startHz: top * (hard ? 1.35 : 1.15),
    endHz: top * 0.8,
    pitchTau: 0.05,
    ampTau: kit == DrumKit.electronic ? 0.3 : 0.17,
  );
  addNoiseBurst(
    out,
    noise: Noise(21 + size),
    tau: 0.006,
    amp: hard ? 0.3 : 0.1,
    bandHz: 2400,
  );
  return out;
}

/// Conga: [mode] 0 abierta, 1 slap, 2 apagada.
Float64List renderConga(int mode) {
  final Float64List out = silence(mode == 0 ? 0.42 : 0.28);
  final double hz = mode == 1 ? 430 : 330;
  addSweepTone(
    out,
    startHz: hz * 1.12,
    endHz: hz,
    pitchTau: 0.03,
    ampTau: switch (mode) {
      0 => 0.11,
      1 => 0.045,
      _ => 0.035,
    },
  );
  if (mode == 0) {
    addDamped(out, hz * 2.3, 0.05, 0.22);
  }
  final Noise noise = Noise(30 + mode);
  addNoiseBurst(
    out,
    noise: noise,
    tau: mode == 1 ? 0.02 : 0.008,
    amp: mode == 1 ? 0.9 : 0.25,
    bandHz: mode == 1 ? 2600 : 1800,
    bandQ: 0.9,
  );
  return out;
}

/// Bongó agudo (hembra) o grave (macho).
Float64List renderBongo({required bool high}) {
  final Float64List out = silence(0.3);
  final double hz = high ? 480 : 330;
  addSweepTone(
    out,
    startHz: hz * 1.1,
    endHz: hz,
    pitchTau: 0.02,
    ampTau: high ? 0.07 : 0.09,
  );
  addNoiseBurst(
    out,
    noise: Noise(high ? 41 : 42),
    tau: 0.007,
    amp: 0.35,
    bandHz: 2800,
  );
  return out;
}

/// Timbal: golpe de aro (el "paila"): cuerpo metálico y brillante.
Float64List renderTimbale() {
  final Float64List out = silence(0.45);
  addDamped(out, 540, 0.09, 0.7);
  addDamped(out, 1080, 0.07, 0.4);
  addDamped(out, 1830, 0.2, 0.3);
  addDamped(out, 2650, 0.16, 0.2);
  addNoiseBurst(out, noise: Noise(51), tau: 0.006, amp: 0.7, highPassHz: 2500);
  return out;
}

/// Cajón: [slap] golpea el borde (seco) en vez del centro (grave).
Float64List renderCajon({required bool slap}) {
  final Float64List out = silence(slap ? 0.22 : 0.4);
  if (slap) {
    addDamped(out, 190, 0.03, 0.5);
    addNoiseBurst(
      out,
      noise: Noise(61),
      tau: 0.035,
      amp: 0.9,
      bandHz: 2300,
      bandQ: 0.7,
    );
  } else {
    addSweepTone(out, startHz: 120, endHz: 68, pitchTau: 0.04, ampTau: 0.14);
    addNoiseBurst(out, noise: Noise(62), tau: 0.01, amp: 0.25, lowPassHz: 1200);
  }
  return out;
}
