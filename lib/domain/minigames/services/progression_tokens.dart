import 'package:chords/domain/theory/entities/chord_progression.dart';

/// Grados (en símbolos) de los compases de [progression], sin repetir
/// compases seguidos: lo que se oye y se lee como progresión.
List<String> progressionTokens(ChordProgression progression) {
  final List<String> tokens = <String>[];
  for (final String bar in progression.bars) {
    for (final String token in bar.split(' ')) {
      if (tokens.isEmpty || tokens.last != token) {
        tokens.add(token);
      }
    }
  }
  return tokens;
}
