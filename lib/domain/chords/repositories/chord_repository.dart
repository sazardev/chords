import 'package:chords/domain/chords/entities/chord.dart';

/// Repositorio de acordes: única fuente de verdad del banco de acordes.
abstract interface class ChordRepository {
  /// Acordes cargados (vacío antes de [load]).
  List<Chord> get chords;

  /// `true` si el banco ya se cargó.
  bool get isLoaded;

  /// Carga el banco completo de acordes.
  Future<void> load();

  /// Busca un acorde por identificador.
  Chord? chordById(String id);

  /// Acordes que suenan las clases de tono indicadas.
  List<Chord> chordsByPitchClasses(Set<int> pitchClasses);

  /// Acordes asociados a un género (p. ej. `Blues`).
  List<Chord> chordsByGenre(String genre);

  /// Acordes de un nivel de aprendizaje (1-5).
  List<Chord> chordsByLevel(int level);

  /// Orden recomendado de estudio: esenciales primero, luego por dificultad.
  List<Chord> essentialFirst(List<Chord> chords);
}
