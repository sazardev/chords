import 'dart:async' show unawaited;

import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/pitch_math.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Frecuencia del clic del metrónomo (Mi6: agudo y corto).
const double _clickHz = 1318.5;

/// Frecuencia del Do más grave que usa el bajo del acompañamiento (Do2).
const double _bassC = 65.406;

/// La "banda" del jam: rasguea, toca el bajo y marca el metrónomo.
///
/// Responsabilidad única: convertir cada golpe del patrón en sonido.
class JamBand {
  /// Crea la banda sobre el audio y el banco de acordes.
  const JamBand(this._audio, this._chords);

  final AudioRepository _audio;
  final ChordRepository _chords;

  /// Acorde del banco para una cifra.
  Chord? chordOf(ChordSymbol symbol) => _chords.chordById(symbol.chordId);

  /// Toca el golpe [stroke] sobre [chord]; en un silencio, el clic si
  /// [click] lo pide.
  void play(StrumStroke stroke, ChordSymbol chord, {required bool click}) {
    switch (stroke) {
      case StrumStroke.down:
      case StrumStroke.up:
        final Chord? bank = chordOf(chord);
        if (bank != null) {
          unawaited(_audio.playChord(bank, bank.easiestVariant));
        }
      case StrumStroke.bass:
        unawaited(
          _audio.playReferenceTone(shiftBySemitones(_bassC, chord.root)),
        );
      case StrumStroke.rest:
        if (click) {
          this.click(accent: false);
        }
    }
  }

  /// Clic del metrónomo; más agudo si es el primer pulso.
  void click({required bool accent}) =>
      unawaited(_audio.playReferenceTone(accent ? _clickHz * 2 : _clickHz));
}
