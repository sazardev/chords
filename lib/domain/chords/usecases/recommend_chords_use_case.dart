import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/essential_chords.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';

/// Caso de uso: acordes recomendados para el perfil de la persona.
///
/// Puntúa cada acorde por encaje de **género** (sus calidades suenan en los
/// géneros favoritos), **dificultad** (cerca de la ideal para su experiencia y
/// nunca por encima de su máximo), **uso** de la calidad del acorde y **tipo
/// de guitarra** (power chords para
/// eléctrica, abiertos para acústica, nada de power chords en clásica). Los
/// acordes ya dominados no se recomiendan.
class RecommendChordsUseCase {
  /// Crea el caso de uso.
  const RecommendChordsUseCase();

  /// Hasta [limit] acordes recomendados, del mejor al peor.
  List<Chord> call(
    List<Chord> chords,
    PlayerProfile profile, {
    Set<String> mastered = const <String>{},
    int limit = 8,
  }) {
    final List<({Chord chord, double score, int order})> ranked =
        <({Chord chord, double score, int order})>[];
    for (int i = 0; i < chords.length; i++) {
      final Chord chord = chords[i];
      if (mastered.contains(chord.id) ||
          chord.difficulty.level > profile.experience.maxDifficulty) {
        continue;
      }
      ranked.add((chord: chord, score: _score(chord, profile), order: i));
    }
    ranked.sort(
      (
        ({Chord chord, double score, int order}) a,
        ({Chord chord, double score, int order}) b,
      ) => b.score != a.score
          ? b.score.compareTo(a.score)
          : a.order.compareTo(b.order),
    );
    return <Chord>[
      for (final ({Chord chord, double score, int order}) item in ranked.take(
        limit,
      ))
        item.chord,
    ];
  }

  double _score(Chord chord, PlayerProfile profile) =>
      _genreScore(chord, profile) +
      _difficultyScore(chord, profile) +
      _guitarScore(chord, profile.guitar) +
      _commonnessScore(chord) +
      (kEssentialChordIds.contains(chord.id)
          ? (profile.experience.maxDifficulty <= 2 ? 2.5 : 0.5)
          : 0);

  /// Los acordes de uso corriente puntúan más que los de jazz o alterados:
  /// con tantas calidades, un género afín no debe llenar la lista de rarezas.
  double _commonnessScore(Chord chord) => (chord.quality.popularity - 3) * 0.75;

  double _genreScore(Chord chord, PlayerProfile profile) {
    final int matches = chord.quality.genres
        .where(profile.genres.contains)
        .length;
    return matches * 3.0;
  }

  double _difficultyScore(Chord chord, PlayerProfile profile) {
    final int gap =
        (chord.difficulty.level - profile.experience.targetDifficulty).abs();
    return 2.0 - gap * 0.75;
  }

  double _guitarScore(Chord chord, GuitarType guitar) {
    final ChordVariant easiest = chord.easiestVariant;
    final bool open = easiest.tags.contains('open');
    final bool power = chord.quality == ChordQuality.power;
    return switch (guitar) {
      GuitarType.acoustic => open ? 1.0 : 0.0,
      GuitarType.electric => power ? 2.0 : 0.0,
      GuitarType.classical => power ? -2.0 : (open ? 1.0 : 0.0),
    };
  }
}
