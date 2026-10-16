import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/drum_parts.dart';
import 'package:chords/data/audio/band/dsp/biquad.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';

/// Charles: [open] 0 cerrado, 1 abierto, 2 pedal.
///
/// Cuadrados inarmónicos pasados por un pasa-altos más un poco de ruido; el
/// abierto deja caer los platos lentamente y el pedal es sordo y breve.
Float64List renderHat(int open, DrumKit kit, {required bool hard}) {
  final (double, double) shape = switch (open) {
    0 => (0.03, 0.14),
    1 => (0.2, 0.55),
    _ => (0.035, 0.16),
  };
  final Float64List out = silence(shape.$2);
  final double scale = kit == DrumKit.jazz ? 0.85 : 1;
  addMetal(out, tau: shape.$1, amp: hard ? 1 : 0.6, scale: scale);
  addNoiseBurst(
    out,
    noise: Noise(80 + open),
    tau: shape.$1 * 0.8,
    amp: hard ? 0.5 : 0.3,
    highPassHz: 7000,
  );
  Biquad.highPass(open == 2 ? 3800 : 5200, 0.8, kBandRate).apply(out);
  Biquad.lowPass(12500, 0.7, kBandRate).apply(out);
  return out;
}

/// Ride: ping con parciales inarmónicos; [bell] es la campana.
Float64List renderRide({required bool bell, required bool hard}) {
  final Float64List out = silence(bell ? 1.2 : 1.7);
  if (bell) {
    addDamped(out, 720, 0.45, 0.5);
    addDamped(out, 1310, 0.35, 0.6);
    addDamped(out, 2140, 0.25, 0.5);
    addDamped(out, 3300, 0.2, 0.35);
  } else {
    for (final double hz in <double>[2950, 3720, 4630, 5870, 7210, 8800]) {
      addDamped(out, hz, 0.5, 0.2);
    }
    addNoiseBurst(
      out,
      noise: Noise(85),
      tau: 0.45,
      amp: 0.25,
      highPassHz: 5000,
    );
  }
  addNoiseBurst(
    out,
    noise: Noise(86),
    tau: 0.004,
    amp: hard ? 0.9 : 0.4,
    highPassHz: 5500,
  );
  return out;
}

/// Crash: ruido brillante que crece un poco y se apaga despacio.
Float64List renderCrash({required bool hard}) {
  final Float64List out = silence(2.3);
  addNoiseBurst(
    out,
    noise: Noise(90),
    tau: hard ? 0.85 : 0.6,
    amp: 1,
    highPassHz: 3400,
    attack: 0.004,
  );
  addMetal(out, tau: 0.5, amp: 0.8, scale: 1.7);
  Biquad.highPass(2800, 0.7, kBandRate).apply(out);
  Biquad.lowPass(11000, 0.7, kBandRate).apply(out);
  return out;
}

/// Pandereta: ruido agudo del parche y los cascabeles que vibran.
Float64List renderTambourine({required bool hard}) {
  final Float64List out = silence(0.5);
  addNoiseBurst(
    out,
    noise: Noise(91),
    tau: 0.07,
    amp: hard ? 0.8 : 0.5,
    highPassHz: 5500,
    attack: 0.003,
  );
  for (final double hz in <double>[5400, 6700, 8100, 9500]) {
    addDamped(out, hz, 0.14, 0.15, start: samplesOf(0.004));
  }
  return out;
}

/// Cencerro: dos cuadrados (540 y 800 Hz) con un pasa-banda, como el 808.
Float64List renderCowbell({required bool hard}) {
  final Float64List out = silence(0.4);
  for (final double hz in <double>[540, 800]) {
    final double w = kTwoPi * hz / kBandRate;
    double phase = 0;
    for (int i = 0; i < out.length; i++) {
      phase += w;
      final double t = i / kBandRate;
      out[i] +=
          (phase % kTwoPi < 3.1416 ? 1.0 : -1.0) *
          (decayAt(t, 0.012) * 0.7 + decayAt(t, 0.11) * 0.3);
    }
  }
  Biquad.bandPass(850, 1.4, kBandRate).apply(out);
  for (int i = 0; i < out.length; i++) {
    out[i] *= hard ? 1 : 0.6;
  }
  return out;
}
