import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';

/// Caso de uso: acordes sugeridos a partir de notas detectadas.
///
/// Un acorde coincide exactamente si su posición más fácil contiene las mimas
/// clases de tono detectadas, o parcialmente si el acorde contiene todas las
/// notas detectadas. Dentro de cada grupo van primero los acordes de uso
/// corriente (mayor, menor, séptima…) y, a igual uso, los más fáciles.
class MatchChordsByPitchClassesUseCase {
  /// Crea el caso de uso.
  const MatchChordsByPitchClassesUseCase();

  /// Devuelve los acordes sugeridos ordenados por calidad de coincidencia.
  List<Chord> call(List<Chord> chords, Set<int> detected) {
    if (detected.isEmpty) {
      return const <Chord>[];
    }
    final List<Chord> exact = <Chord>[];
    final List<Chord> partial = <Chord>[];
    for (final Chord chord in chords) {
      final Set<int> chordNotes = chord.easiestVariant.notes
          .map(pitchClassOfNote)
          .toSet();
      if (chordNotes.length == detected.length &&
          chordNotes.containsAll(detected)) {
        exact.add(chord);
      } else if (detected.containsAll(chordNotes)) {
        partial.add(chord);
      }
    }
    return <Chord>[
      ...exact..sort(_byCommonness),
      ...partial..sort(_byCommonness),
    ];
  }

  /// Los acordes de uso corriente primero y, a igual uso, los más fáciles.
  int _byCommonness(Chord a, Chord b) {
    final int byUse = b.quality.popularity.compareTo(a.quality.popularity);
    return byUse != 0
        ? byUse
        : a.difficulty.level.compareTo(b.difficulty.level);
  }
}
