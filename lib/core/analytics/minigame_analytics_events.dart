import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';

/// Eventos de analítica de los minijuegos de oído, mástil y práctica.
extension MiniGameAnalyticsEvents on AnalyticsService {
  /// Ha comenzado una partida de [game] en la dificultad [level].
  void miniGameStarted({required String game, required String level}) => event(
    AnalyticsEventName.miniGameStarted,
    parameters: <String, Object?>{
      AnalyticsParam.gameId: game,
      AnalyticsParam.gameLevel: level,
    },
  );

  /// Ha terminado una partida con su resultado.
  void miniGameFinished({
    required String game,
    required String level,
    required int percent,
    required int stars,
    required int correct,
    required int total,
    required int bestStreak,
  }) => event(
    AnalyticsEventName.miniGameFinished,
    parameters: <String, Object?>{
      AnalyticsParam.gameId: game,
      AnalyticsParam.gameLevel: level,
      AnalyticsParam.percent: percent,
      AnalyticsParam.stars: stars,
      AnalyticsParam.correct: correct,
      AnalyticsParam.total: total,
      AnalyticsParam.bestStreak: bestStreak,
    },
  );
}
