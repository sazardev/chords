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

  /// Acordes que suenan exactamente las clases de tono indicadas.
  List<Chord> chordsByPitchClasses(Set<int> pitchClasses);
}
