import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';

/// Una progresión del catálogo que contiene un acorde, vista en la tonalidad
/// en la que ese acorde cae en su grado.
class ProgressionUse {
  /// Crea el uso.
  const ProgressionUse({
    required this.progression,
    required this.tonic,
    required this.degree,
    required this.chords,
  });

  /// Progresión del catálogo.
  final ChordProgression progression;

  /// Tónica (0 = Do) con la que el acorde cae en [degree].
  final int tonic;

  /// Grado que ocupa el acorde (`IV`, `V7`).
  final String degree;

  /// Los acordes de la progresión en esa tonalidad, sin repetir seguidos.
  final List<ChordSymbol> chords;
}

typedef _Scored = ({ProgressionUse use, int score, int order});

/// Progresiones del catálogo que incluyen un acorde.
///
/// Las progresiones se escriben en grados y valen en cualquier tono: un acorde
/// está en una si alguno de sus grados tiene su misma calidad. Se prefieren
/// las que lo usan como tónica y, después, las que lo traen en el tono con el
/// que el catálogo presenta la progresión.
List<ProgressionUse> progressionsWith(
  ChordSymbol chord, {
  List<ChordProgression> catalog = kProgressions,
  int limit = 6,
}) {
  final List<_Scored> found = <_Scored>[];
  for (final (int order, ChordProgression progression) in catalog.indexed) {
    final ({ProgressionUse use, int score})? best = _bestUse(
      progression,
      chord,
    );
    if (best != null) {
      found.add((use: best.use, score: best.score, order: order));
    }
  }
  found.sort(
    (_Scored a, _Scored b) => a.score != b.score
        ? a.score.compareTo(b.score)
        : a.order.compareTo(b.order),
  );
  return <ProgressionUse>[
    for (final _Scored item in found.take(limit)) item.use,
  ];
}

({ProgressionUse use, int score})? _bestUse(
  ChordProgression progression,
  ChordSymbol chord,
) {
  ({ProgressionUse use, int score})? best;
  for (final List<RomanChord> bar in progression.romanBars) {
    for (final RomanChord roman in bar) {
      if (roman.quality != chord.quality) {
        continue;
      }
      final int tonic = (chord.root - roman.offset) % 12;
      final int score =
          (roman.offset == 0 ? 0 : 10) + (tonic == progression.tonic ? 0 : 5);
      if (best == null || score < best.score) {
        best = (
          use: ProgressionUse(
            progression: progression,
            tonic: tonic,
            degree: roman.label,
            chords: _distinct(progression.barsIn(tonic)),
          ),
          score: score,
        );
      }
    }
  }
  return best;
}

/// Acordes de la progresión en orden, sin repetir los consecutivos.
List<ChordSymbol> _distinct(List<List<ChordSymbol>> bars) {
  final List<ChordSymbol> result = <ChordSymbol>[];
  for (final List<ChordSymbol> bar in bars) {
    for (final ChordSymbol symbol in bar) {
      if (result.isEmpty || result.last != symbol) {
        result.add(symbol);
      }
    }
  }
  return result;
}
