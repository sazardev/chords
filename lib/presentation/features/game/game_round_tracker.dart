import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/game_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';

/// Deja constancia de las rondas y de la serie (log y analítica).
///
/// Responsabilidad única: traducir lo ocurrido en la partida a registros; no
/// decide nada del juego.
class GameRoundTracker {
  /// Crea el registrador.
  const GameRoundTracker();

  /// Registra una ronda resuelta con lo esperado y lo escuchado.
  void round({
    required GameRound round,
    required List<String> expected,
    required List<String> heard,
    required GameResult result,
  }) {
    appLogger.info(
      'juego: ronda ${round.index + 1} ${result.outcome.name} — '
      'esperado [${expected.join(', ')}] escuchado [${heard.join(', ')}] '
      'acierto ${(result.matchedRatio * 100).round()}%',
      channel: LogChannel.game,
      context: <String, Object?>{
        'expected': expected.join(','),
        'heard': heard.join(','),
        'matchRatio': result.matchedRatio,
        'outcome': result.outcome.name,
      },
    );
    analytics.gameRoundPlayed(
      index: round.index,
      chordId: round.chordId,
      expectedNotes: expected,
      heardNotes: heard,
      matchRatio: result.matchedRatio,
      outcome: result.outcome.name,
      timeLimitMs: round.timeLimitMs,
    );
  }

  /// Registra el cierre de la serie con su puntuación.
  void finished({
    required List<GameRound> rounds,
    required int score,
    required int best,
  }) {
    final List<GameRound> resolved = rounds
        .where((GameRound round) => round.isResolved)
        .toList();
    int won = 0;
    int partial = 0;
    int failed = 0;
    for (final GameRound round in resolved) {
      switch (round.result!.outcome) {
        case GameOutcome.success:
          won++;
        case GameOutcome.partial:
          partial++;
        case GameOutcome.fail:
        case GameOutcome.timeout:
          failed++;
      }
    }
    appLogger.info(
      'juego: serie terminada — $won/${resolved.length} aciertos, '
      'puntuación $score (récord $best)',
      channel: LogChannel.game,
      context: <String, Object?>{
        'won': won,
        'partial': partial,
        'failed': failed,
        'score': score,
      },
    );
    analytics.gameFinished(
      score: score,
      best: best,
      rounds: resolved.length,
      won: won,
      partial: partial,
      failed: failed,
    );
  }
}
