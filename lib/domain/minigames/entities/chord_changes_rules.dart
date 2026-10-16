import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:meta/meta.dart';

/// Reglas de una partida de "cambios de acorde" según la dificultad.
@immutable
class ChordChangesRules {
  /// Crea las reglas.
  const ChordChangesRules({
    required this.goal,
    required this.perChordMs,
    required this.minRatio,
    this.totalMs = 60000,
  });

  /// Reglas de un nivel.
  factory ChordChangesRules.of(MiniGameLevel level) => switch (level) {
    MiniGameLevel.easy => const ChordChangesRules(
      goal: 8,
      perChordMs: 12000,
      minRatio: 0.6,
    ),
    MiniGameLevel.medium => const ChordChangesRules(
      goal: 12,
      perChordMs: 9000,
      minRatio: 0.8,
    ),
    MiniGameLevel.hard => const ChordChangesRules(
      goal: 16,
      perChordMs: 7000,
      minRatio: 1,
    ),
  };

  /// Cambios limpios que dan el 100 % (tres estrellas).
  final int goal;

  /// Milisegundos para tocar cada acorde antes de darlo por fallado.
  final int perChordMs;

  /// Proporción mínima de notas del acorde que tienen que sonar.
  final double minRatio;

  /// Duración de la partida.
  final int totalMs;
}
