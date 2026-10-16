import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/dsp/biquad.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/strum_mixer.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Eléctrica limpia: cuerdas de pastilla de puente, un realce en los medios y
/// un coro suave que la ensancha.
Float64List renderCleanElectric(GuitarStroke stroke, List<int> notes) {
  final (double, double) setup = switch (stroke) {
    GuitarStroke.mute => (0.34, 0.07),
    GuitarStroke.chop => (0.2, 0.035),
    GuitarStroke.bass => (1.4, 0.9),
    _ => (2.0, 1.4),
  };
  final Float64List out = silence(setup.$1);
  _pick(out, stroke, notes, pickPosition: 0.08, velocity: 0.8);
  applyDecay(out, setup.$2);
  Biquad.lowPass(5200, 0.7, kBandRate).apply(out);
  Biquad.peaking(1900, 0.9, 3.5, kBandRate).apply(out);
  Biquad.highPass(85, 0.7, kBandRate).apply(out);
  return _chorus(out);
}

/// Eléctrica saturada: power chords con ganancia alta y pantalla de
/// altavoz. El palm-mute es corto y seco.
Float64List renderDistorted(GuitarStroke stroke, List<int> notes) {
  final bool tight =
      stroke == GuitarStroke.powerMute ||
      stroke == GuitarStroke.mute ||
      stroke == GuitarStroke.chop;
  final double seconds = switch (stroke) {
    GuitarStroke.powerMute || GuitarStroke.mute => 0.24,
    GuitarStroke.chop => 0.14,
    GuitarStroke.bass => 1.2,
    _ => 1.6,
  };
  final Float64List out = silence(seconds);
  _pick(out, stroke, notes, pickPosition: 0.07, velocity: 0.9);
  Biquad.highPass(90, 0.7, kBandRate).apply(out);
  if (tight) {
    Biquad.lowPass(2300, 0.7, kBandRate).apply(out);
  }
  _clip(out, stroke == GuitarStroke.bass ? 5 : 11);
  applyDecay(out, tight ? 0.055 : 1.1);
  _cabinet(out);
  return out;
}

/// Pulsa las notas según el golpe: un power chord usa las tres primeras.
void _pick(
  Float64List out,
  GuitarStroke stroke,
  List<int> notes, {
  required double pickPosition,
  required double velocity,
}) {
  final List<int> played = switch (stroke) {
    GuitarStroke.bass => <int>[notes.first],
    GuitarStroke.up => notes.reversed.take(4).toList(),
    _ => notes,
  };
  addStrum(
    out,
    StrumSpec(
      notes: played,
      seconds: out.length / kBandRate,
      spacingMs: stroke == GuitarStroke.chop ? 3 : 6,
      velocity: stroke == GuitarStroke.up ? velocity * 0.75 : velocity,
      pickPosition: pickPosition,
      seed: 5,
    ),
  );
}

/// Saturación asimétrica: el sesgo añade armónicos pares, como una válvula.
void _clip(Float64List samples, double drive) {
  double peak = 1e-9;
  for (final double value in samples) {
    peak = math.max(peak, value.abs());
  }
  const double bias = 0.18;
  final double offset = softClip(bias);
  for (int i = 0; i < samples.length; i++) {
    samples[i] = softClip(samples[i] / peak * drive + bias) - offset;
  }
}

/// Altavoz de guitarra: corta los agudos ásperos y realza los medios.
void _cabinet(Float64List samples) {
  Biquad.lowPass(4300, 0.75, kBandRate).apply(samples);
  Biquad.lowPass(5200, 0.6, kBandRate).apply(samples);
  Biquad.peaking(2100, 0.9, 4, kBandRate).apply(samples);
  Biquad.peaking(130, 1, 2.5, kBandRate).apply(samples);
  Biquad.highPass(80, 0.7, kBandRate).apply(samples);
}

/// Coro: la señal más una copia retrasada 12 ms que oscila ±4 ms.
Float64List _chorus(Float64List dry) {
  final Float64List out = Float64List.fromList(dry);
  for (int i = 0; i < dry.length; i++) {
    final double t = i / kBandRate;
    final double delay =
        (0.012 + 0.004 * math.sin(kTwoPi * 0.35 * t)) * kBandRate;
    final double position = i - delay;
    if (position < 0) {
      continue;
    }
    final int base = position.floor();
    final double fraction = position - base;
    final double wet =
        dry[base] * (1 - fraction) + dry[math.min(base + 1, i)] * fraction;
    out[i] += 0.55 * wet;
  }
  return out;
}
