import 'package:chords/domain/chords/entities/game_outcome.dart';

/// Una ronda del modo juego "toca el acorde".
class GameRound {
  /// Crea una ronda.
  const GameRound({
    required this.index,
    required this.chordId,
    required this.timeLimitMs,
    this.result,
  });

  /// Posición de la ronda dentro de la serie.
  final int index;

  /// Acorde objetivo.
  final String chordId;

  /// Tiempo límite para acertar en milisegundos.
  final int timeLimitMs;

  /// Resultado registrado (`null` mientras la ronda está en curso).
  final GameResult? result;

  /// `true` si la ronda ya se ha resuelto.
  bool get isResolved => result != null;
}

/// Resultado de una ronda jugada.
class GameResult {
  /// Crea un resultado.
  const GameResult({required this.outcome, required this.matchedRatio});

  /// Resultado de acierto.
  const GameResult.success() : outcome = GameOutcome.success, matchedRatio = 1;

  /// Resultado de fallo.
  const GameResult.fail() : outcome = GameOutcome.fail, matchedRatio = 0;

  /// Resultado fuera de tiempo.
  const GameResult.timeout() : outcome = GameOutcome.timeout, matchedRatio = 0;

  /// Tipo de resultado.
  final GameOutcome outcome;

  /// Proporción de notas detectadas (0-1).
  final double matchedRatio;

  /// Si la ronda sumó puntos.
  bool get scored =>
      outcome == GameOutcome.success || outcome == GameOutcome.partial;
}
