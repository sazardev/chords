import 'package:chords/domain/band/services/chord_voicing.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Última nota MIDI que toca el bajo caminante (Fa♯3).
const int _walkTop = 54;

/// Traduce las letras de una pista de bajo a notas MIDI según el acorde.
class BassLine {
  /// Crea el traductor.
  const BassLine([this._voicing = const ChordVoicing()]);

  final ChordVoicing _voicing;

  /// Nota de la letra [token] sobre [chord]; [next] es el acorde que viene.
  ///
  /// `null` si la letra no es una nota (silencio o sostenido).
  int? noteFor(String token, ChordSymbol chord, ChordSymbol next) {
    final int root = _voicing.bassRoot(chord.root);
    return switch (token) {
      'R' || 'r' => root,
      '5' => root + _fifth(chord),
      'O' => root + 12,
      '3' => root + _third(chord),
      '7' => root + _seventh(chord),
      '6' => root + 9,
      'F' => root - 5 >= kBassLow ? root - 5 : root + _fifth(chord),
      'a' => _approach(root, chord, next),
      _ => null,
    };
  }

  /// Nota del bajo caminante en la negra [beat] (0-3) del compás [bar].
  ///
  /// El primer tiempo es la raíz, el último se aproxima a la raíz del acorde
  /// siguiente y los de en medio alternan entre tercera, quinta y sexta.
  /// [previous] es la nota anterior: se elige la octava más cercana.
  int walking(
    int beat,
    int bar,
    ChordSymbol chord,
    ChordSymbol next, {
    int? previous,
  }) {
    final int root = _voicing.bassRoot(chord.root);
    final int note = switch (beat) {
      0 => root,
      1 => root + (bar.isEven ? _third(chord) : _fifth(chord)),
      2 => root + (bar.isEven ? _fifth(chord) : _third(chord)),
      _ => _approach(root, chord, next),
    };
    return beat == 0 ? root : _nearest(note, previous ?? root);
  }

  /// Aproximación cromática a la raíz de [next].
  int _approach(int root, ChordSymbol chord, ChordSymbol next) {
    final int target = _voicing.bassRoot(next.root);
    if (target == root) {
      return root + _fifth(chord);
    }
    final bool fromBelow = target > root || root - target > 6;
    return fromBelow && target - 1 >= kBassLow ? target - 1 : target + 1;
  }

  /// La octava de [note] más cercana a [reference] dentro del registro.
  int _nearest(int note, int reference) {
    int best = note;
    while (best < kBassLow) {
      best += 12;
    }
    while (best > _walkTop) {
      best -= 12;
    }
    for (final int shift in <int>[-12, 12]) {
      final int candidate = best + shift;
      final bool inRange = candidate >= kBassLow && candidate <= _walkTop;
      if (inRange && (candidate - reference).abs() < (best - reference).abs()) {
        best = candidate;
      }
    }
    return best;
  }

  int _fifth(ChordSymbol chord) => switch (chord.quality.id) {
    'dim' => 6,
    'aug' => 8,
    _ => 7,
  };

  int _third(ChordSymbol chord) => switch (chord.quality.id) {
    'min' || 'm7' || 'm6' || 'dim' => 3,
    'sus4' => 5,
    'sus2' => 2,
    _ => 4,
  };

  int _seventh(ChordSymbol chord) => chord.quality.id == 'maj7' ? 11 : 10;
}
