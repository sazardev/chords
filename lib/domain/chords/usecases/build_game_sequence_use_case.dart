import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/essential_chords.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';

/// Caso de uso: genera la secuencia de acordes del modo juego.
///
/// Las primeras rondas usan acordes esenciales y la serie incorpora cejillas
/// según sube el nivel.
class BuildGameSequenceUseCase {
  /// Crea el caso de uso.
  const BuildGameSequenceUseCase(this._repository);

  final ChordRepository _repository;

  /// Construye [count] rondas a partir del nivel [fromLevel] (1-5).
  List<GameRound> call({required int fromLevel, int count = 5}) {
    final int level = fromLevel.clamp(1, 5);
    final List<String> pool = <String>[];
    if (level <= 2) {
      for (final String id in kEssentialChordIds) {
        if (_repository.chordById(id) != null) {
          pool.add(id);
        }
      }
    }
    for (final Chord chord in _repository.chordsByLevel(level)) {
      pool.add(chord.id);
    }
    if (pool.isEmpty) {
      pool.addAll(kEssentialChordIds);
    }
    return <GameRound>[
      for (int i = 0; i < count; i++)
        GameRound(
          index: i,
          chordId: pool[i % pool.length],
          timeLimitMs: 5000 + i * 500,
        ),
    ];
  }
}
