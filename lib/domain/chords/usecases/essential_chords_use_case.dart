import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';

/// Identificadores de los acordes abiertos esenciales.
///
/// Son los primeros acordes que aprende cualquier guitararrista y la base del
/// itinerario de aprendizaje y del modo juego.
const List<String> kEssentialChordIds = <String>[
  'C-maj',
  'G-maj',
  'D-maj',
  'A-maj',
  'E-maj',
  'A-min',
  'E-min',
  'D-min',
];

/// Caso de uso: acordes recomendados para empezar.
class EssentialChordsUseCase {
  /// Crea el caso de uso.
  const EssentialChordsUseCase();

  /// Devuelve los acordes esenciales presentes en [chords].
  List<Chord> call(List<Chord> chords) {
    final List<Chord> result = <Chord>[];
    for (final String id in kEssentialChordIds) {
      for (final Chord chord in chords) {
        if (chord.id == id) {
          result.add(chord);
          break;
        }
      }
    }
    return result;
  }

  /// `true` si el acorde forma parte del grupo esencial.
  bool isEssential(Chord chord) => kEssentialChordIds.contains(chord.id);
}

/// Caso de uso: patrones de arpegio disponibles para practicar.
class GetArpeggioPatternsUseCase {
  /// Crea el caso de uso.
  const GetArpeggioPatternsUseCase();

  /// Patrones ordenados de más fácil a más difícil.
  List<ArpeggioPattern> call() => ArpeggioPattern.all;

  /// Patrón por identificador (o `null`).
  ArpeggioPattern? byId(String id) {
    for (final ArpeggioPattern pattern in ArpeggioPattern.all) {
      if (pattern.id == id) {
        return pattern;
      }
    }
    return null;
  }
}
