import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/services/chord_query.dart';

/// Caso de uso: filtrar acordes por raíz, calidad, género, nivel y texto.
class SearchChordsUseCase {
  /// Crea el caso de uso.
  const SearchChordsUseCase();

  /// Devuelve los acordes que cumplen los filtros indicados.
  ///
  /// El texto de búsqueda se interpreta con [ChordQuery]: cifrado (`Cm7`),
  /// nombres en español (`Re menor 7`), listas de notas (`C E G`) o texto
  /// libre. Con texto, los acordes que mejor coinciden van primero; a igual
  /// relevancia se respeta el orden de [chords].
  List<Chord> call(List<Chord> chords, ChordFilters filters) {
    final ChordQuery query = ChordQuery.parse(filters.query);
    final List<({Chord chord, int relevance})> found =
        <({Chord chord, int relevance})>[];
    for (final Chord chord in chords) {
      final int? relevance = _accepts(chord, filters)
          ? query.relevance(chord)
          : null;
      if (relevance != null) {
        found.add((chord: chord, relevance: relevance));
      }
    }
    return <Chord>[
      for (final int level in const <int>[0, 1, 2])
        for (final ({Chord chord, int relevance}) item in found)
          if (item.relevance == level) item.chord,
    ];
  }

  bool _accepts(Chord chord, ChordFilters filters) =>
      _matchesFacets(chord, filters) && _matchesLevel(chord, filters);

  bool _matchesFacets(Chord chord, ChordFilters filters) {
    if (filters.root != null && chord.root != filters.root) {
      return false;
    }
    if (filters.quality != null && chord.quality != filters.quality) {
      return false;
    }
    if (filters.genre != null &&
        !chord.quality.genres.contains(filters.genre)) {
      return false;
    }
    return true;
  }

  bool _matchesLevel(Chord chord, ChordFilters filters) {
    if (filters.level != null &&
        LearningLevel.of(chord).level != filters.level) {
      return false;
    }
    if (filters.maxDifficulty != null &&
        chord.difficulty.level > filters.maxDifficulty!) {
      return false;
    }
    return true;
  }
}
