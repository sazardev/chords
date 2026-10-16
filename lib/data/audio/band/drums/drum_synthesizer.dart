import 'dart:typed_data';

import 'package:chords/data/audio/band/drums/membrane_drums.dart';
import 'package:chords/data/audio/band/drums/metal_drums.dart';
import 'package:chords/data/audio/band/drums/shaken_drums.dart';
import 'package:chords/data/audio/band/drums/snare_drums.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/dsp/sample_finisher.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';

/// Genera la muestra de una voz de batería o percusión.
typedef _Renderer = Float64List Function(DrumKit kit, {required bool hard});

/// Cómo se sintetiza cada voz.
final Map<DrumVoice, _Renderer> _renderers = <DrumVoice, _Renderer>{
  DrumVoice.kick: renderKick,
  DrumVoice.snare: renderSnare,
  DrumVoice.rimshot: (DrumKit k, {required bool hard}) =>
      renderRimshot(hard: hard),
  DrumVoice.clap: (DrumKit k, {required bool hard}) => renderClap(hard: hard),
  DrumVoice.hatClosed: (DrumKit k, {required bool hard}) =>
      renderHat(0, k, hard: hard),
  DrumVoice.hatOpen: (DrumKit k, {required bool hard}) =>
      renderHat(1, k, hard: hard),
  DrumVoice.hatPedal: (DrumKit k, {required bool hard}) =>
      renderHat(2, k, hard: hard),
  DrumVoice.ride: (DrumKit k, {required bool hard}) =>
      renderRide(bell: false, hard: hard),
  DrumVoice.rideBell: (DrumKit k, {required bool hard}) =>
      renderRide(bell: true, hard: hard),
  DrumVoice.crash: (DrumKit k, {required bool hard}) => renderCrash(hard: hard),
  DrumVoice.tomHigh: (DrumKit k, {required bool hard}) =>
      renderTom(0, k, hard: hard),
  DrumVoice.tomMid: (DrumKit k, {required bool hard}) =>
      renderTom(1, k, hard: hard),
  DrumVoice.tomLow: (DrumKit k, {required bool hard}) =>
      renderTom(2, k, hard: hard),
  DrumVoice.shaker: (DrumKit k, {required bool hard}) =>
      renderShaker(hard: hard),
  DrumVoice.tambourine: (DrumKit k, {required bool hard}) =>
      renderTambourine(hard: hard),
  DrumVoice.cowbell: (DrumKit k, {required bool hard}) =>
      renderCowbell(hard: hard),
  DrumVoice.claves: (DrumKit k, {required bool hard}) => renderClaves(),
  DrumVoice.congaOpen: (DrumKit k, {required bool hard}) => renderConga(0),
  DrumVoice.congaSlap: (DrumKit k, {required bool hard}) => renderConga(1),
  DrumVoice.congaMute: (DrumKit k, {required bool hard}) => renderConga(2),
  DrumVoice.bongoHigh: (DrumKit k, {required bool hard}) =>
      renderBongo(high: true),
  DrumVoice.bongoLow: (DrumKit k, {required bool hard}) =>
      renderBongo(high: false),
  DrumVoice.timbale: (DrumKit k, {required bool hard}) => renderTimbale(),
  DrumVoice.guiro: (DrumKit k, {required bool hard}) => renderGuiro(hard: hard),
  DrumVoice.palma: (DrumKit k, {required bool hard}) =>
      renderPalma(muted: false),
  DrumVoice.palmaMuted: (DrumKit k, {required bool hard}) =>
      renderPalma(muted: true),
  DrumVoice.cajon: (DrumKit k, {required bool hard}) =>
      renderCajon(slap: false),
  DrumVoice.cajonSlap: (DrumKit k, {required bool hard}) =>
      renderCajon(slap: true),
};

/// Pico de cada voz (capa fuerte): equilibra la mezcla de la batería.
const Map<DrumVoice, double> _levels = <DrumVoice, double>{
  DrumVoice.kick: 0.95,
  DrumVoice.snare: 0.9,
  DrumVoice.rimshot: 0.78,
  DrumVoice.clap: 0.85,
  DrumVoice.hatClosed: 0.55,
  DrumVoice.hatOpen: 0.6,
  DrumVoice.hatPedal: 0.45,
  DrumVoice.ride: 0.6,
  DrumVoice.rideBell: 0.6,
  DrumVoice.crash: 0.75,
  DrumVoice.tomHigh: 0.88,
  DrumVoice.tomMid: 0.9,
  DrumVoice.tomLow: 0.92,
  DrumVoice.shaker: 0.72,
  DrumVoice.tambourine: 0.72,
  DrumVoice.cowbell: 0.85,
  DrumVoice.claves: 0.85,
  DrumVoice.congaOpen: 0.8,
  DrumVoice.congaSlap: 0.78,
  DrumVoice.congaMute: 0.72,
  DrumVoice.bongoHigh: 0.75,
  DrumVoice.bongoLow: 0.78,
  DrumVoice.timbale: 0.85,
  DrumVoice.guiro: 0.7,
  DrumVoice.palma: 0.85,
  DrumVoice.palmaMuted: 0.75,
  DrumVoice.cajon: 0.9,
  DrumVoice.cajonSlap: 0.85,
};

/// Factor de pico de la capa suave respecto a la fuerte.
const double _softLayer = 0.62;

/// Sintetiza [voice] en el kit [kit]; [hard] elige la capa fuerte o la suave.
///
/// El resultado ya está listo para tocar: sin NaN, con fundidos y con el pico
/// de su voz.
Float64List renderDrum(DrumVoice voice, DrumKit kit, {required bool hard}) {
  final Float64List raw = _renderers[voice]!(kit, hard: hard);
  final double level = _levels[voice]! * (hard ? 1 : _softLayer);
  return finishSample(
    raw,
    peak: level,
    fadeOutSeconds: raw.length / kBandRate > 1 ? 0.08 : 0.02,
  );
}
