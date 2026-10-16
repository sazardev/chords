import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';

/// Shaker: ruido agudo que crece un instante y cae rápido.
Float64List renderShaker({required bool hard}) {
  final Float64List out = silence(0.18);
  addNoiseBurst(
    out,
    noise: Noise(100),
    tau: hard ? 0.045 : 0.035,
    amp: 1,
    bandHz: 7200,
    bandQ: 0.9,
    attack: hard ? 0.006 : 0.01,
  );
  return out;
}

/// Claves: dos maderas que suenan agudas y secas.
Float64List renderClaves() {
  final Float64List out = silence(0.16);
  addDamped(out, 2480, 0.014, 0.9);
  addDamped(out, 5250, 0.007, 0.35);
  addNoiseBurst(out, noise: Noise(101), tau: 0.002, amp: 0.3, highPassHz: 3000);
  return out;
}

/// Güiro: el rascado a lo largo de las muescas, como una ráfaga de ruido
/// modulada por una onda de pulsos.
Float64List renderGuiro({required bool hard}) {
  final Float64List out = silence(0.3);
  final Noise noise = Noise(102);
  final int length = samplesOf(0.17);
  double low = 0;
  for (int i = 0; i < length; i++) {
    final double t = i / kBandRate;
    // Muescas cada ~7 ms que se espacian al final del rascado.
    final double phase = 140 * t - 40 * t * t;
    final double ridge = 0.35 + 0.65 * (math.sin(kTwoPi * phase) > 0 ? 1 : 0);
    final double x = noise.next();
    low += 0.5 * (x - low);
    out[i] = (x - low) * ridge * decayAt(t, 0.085) * (hard ? 1 : 0.6);
  }
  return out;
}
