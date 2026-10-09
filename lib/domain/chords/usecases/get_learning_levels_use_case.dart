import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';

/// Caso de uso: construye el itinerario de aprendizaje por niveles.
class GetLearningLevelsUseCase {
  /// Crea el caso de uso.
  const GetLearningLevelsUseCase(this._repository);

  final ChordRepository _repository;

  /// Niveles del itinerario.
  List<LearningLevel> get levels => LearningLevel.values;

  /// Acordes del nivel indicado (máximo 10 por nivel).
  List<String> chordIdsOf(int level) {
    final List<String> ids = _repository
        .chordsByLevel(level)
        .map((Chord chord) => chord.id)
        .toList();
    return ids.length > 10 ? ids.sublist(0, 10) : ids;
  }
}
