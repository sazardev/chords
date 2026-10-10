import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';

/// Caso de uso: filtrar acordes por raíz, calidad, género, nivel y texto.
class SearchChordsUseCase {
  /// Crea el caso de uso.
  const SearchChordsUseCase();

  /// Devuelve los acordes que cumplen los filtros indicados.
  List<Chord> call(List<Chord> chords, ChordFilters filters) {
    final String query = filters.query.trim().toLowerCase();
    return chords
        .where((Chord chord) => _accepts(chord, filters, query))
        .toList();
  }

  bool _accepts(Chord chord, ChordFilters filters, String query) =>
      _matchesFacets(chord, filters) &&
      _matchesLevel(chord, filters) &&
      (query.isEmpty || _matchesQuery(chord, query));

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

  /// Coincidencia del texto libre con nombre, alias, géneros y posiciones.
  bool _matchesQuery(Chord chord, String query) {
    final Iterable<String> haystack = <String>[
      chord.name.toLowerCase(),
      chord.displayName.toLowerCase(),
      LearningLevel.of(chord).title.toLowerCase(),
      ...chord.aliases.map((String alias) => alias.toLowerCase()),
      ...chord.quality.genres.map((String genre) => genre.toLowerCase()),
      ...chord.variants.map(
        (ChordVariant variant) => variant.positionLabel.toLowerCase(),
      ),
    ];
    return haystack.any((String item) => item.contains(query));
  }
}
