import 'dart:typed_data';

import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/dsp/sample_finisher.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Clic del metrónomo: un "tic" de madera corto; el del primer pulso es más
/// agudo.
Float64List renderClick(ClickAccent accent) {
  final bool strong = accent == ClickAccent.accent;
  final Float64List out = silence(0.07);
  final double hz = strong ? 2300 : 1650;
  addSine(out, hz, 0.8);
  addSine(out, hz * 2.4, 0.3);
  for (int i = 0; i < out.length; i++) {
    out[i] *= decayAt(i / kBandRate, 0.011);
  }
  return finishSample(out, peak: strong ? 0.85 : 0.65, fadeOutSeconds: 0.01);
}
