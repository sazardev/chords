import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/services/progression_tokens.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';

/// Progresiones que se distinguen al oído, de las más fáciles a las más
/// parecidas entre sí.
const List<String> kEarProgressions = <String>[
  'I IV V I',
  'I V vi IV',
  'vi IV I V',
  'I vi IV V',
  'ii V I I',
  'I bVII IV I',
];

/// Progresiones del catálogo (rock, blues, jazz, latino…) en grados
/// separados por espacios, sin las que ya están en [kEarProgressions].
///
/// Recorre el catálogo entero, así que las progresiones que se añadan
/// aparecen solas en el nivel difícil.
List<String> catalogEarProgressions() {
  final Set<String> known = kEarProgressions.toSet();
  final Set<String> found = <String>{};
  for (final ChordProgression progression in kProgressions) {
    final List<String> tokens = progressionTokens(progression);
    final String text = tokens.join(' ');
    if (tokens.length >= 3 && tokens.length <= 8 && !known.contains(text)) {
      found.add(text);
    }
  }
  return found.toList();
}

/// Progresiones que se distinguen al oído en cada nivel: las clásicas en fácil
/// y medio, y también las del catálogo en difícil.
List<String> earProgressionsFor(MiniGameLevel level) => switch (level) {
  MiniGameLevel.easy => kEarProgressions.take(2).toList(),
  MiniGameLevel.medium => kEarProgressions.take(4).toList(),
  MiniGameLevel.hard => <String>[
    ...kEarProgressions,
    ...catalogEarProgressions(),
  ],
};

/// Parecido entre dos progresiones: acordes en el mismo lugar y en común.
int progressionSimilarity(String a, String b) {
  final List<String> left = a.split(' ');
  final List<String> right = b.split(' ');
  int score = 0;
  for (int i = 0; i < left.length && i < right.length; i++) {
    if (left[i] == right[i]) {
      score += 2;
    }
  }
  return score + left.toSet().intersection(right.toSet()).length;
}
