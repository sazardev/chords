import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';

/// Eventos de analítica del modo juego.
///
/// Amplía [AnalyticsService] con el ciclo completo de una partida: inicio,
/// ronda resuelta —incluyendo lo que el micrófono escuchó frente a lo que se
/// esperaba— y cierre con el marcador.
extension GameAnalyticsEvents on AnalyticsService {
  /// Ha comenzado una partida desde [level] con [rounds] rondas.
  void gameStarted({required int level, required int rounds}) => event(
    AnalyticsEventName.gameStarted,
    parameters: <String, Object?>{
      AnalyticsParam.level: level,
      AnalyticsParam.rounds: rounds,
    },
  );

  /// Se ha resuelto la ronda [index] de [chordId].
  void gameRoundPlayed({
    required int index,
    required String chordId,
    required List<String> expectedNotes,
    required List<String> heardNotes,
    required double matchRatio,
    required String outcome,
    required int timeLimitMs,
  }) => event(
    AnalyticsEventName.gameRoundPlayed,
    parameters: <String, Object?>{
      AnalyticsParam.roundIndex: index,
      AnalyticsParam.chordId: chordId,
      AnalyticsParam.expectedNotes: expectedNotes.join(','),
      AnalyticsParam.heardNotes: heardNotes.join(','),
      AnalyticsParam.matchRatio: matchRatio,
      AnalyticsParam.outcome: outcome,
      AnalyticsParam.timeLimitMs: timeLimitMs,
    },
  );

  /// Ha terminado la serie de [rounds] rondas con el marcador indicado.
  void gameFinished({
    required int score,
    required int best,
    required int rounds,
    required int won,
    required int partial,
    required int failed,
  }) => event(
    AnalyticsEventName.gameFinished,
    parameters: <String, Object?>{
      AnalyticsParam.score: score,
      AnalyticsParam.bestScore: best,
      AnalyticsParam.rounds: rounds,
      AnalyticsParam.won: won,
      AnalyticsParam.partial: partial,
      AnalyticsParam.failed: failed,
    },
  );
}
