import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/minigame_analytics_events.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de los eventos semánticos de los minijuegos.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  test('miniGameStarted registra el juego y la dificultad', () {
    service.miniGameStarted(game: 'guessNote', level: 'hard');

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.miniGameStarted]!;
    expect(parameters[AnalyticsParam.gameId], 'guessNote');
    expect(parameters[AnalyticsParam.gameLevel], 'hard');
  });

  test('miniGameFinished resume el resultado de la partida', () {
    service.miniGameFinished(
      game: 'interval',
      level: 'easy',
      percent: 80,
      stars: 2,
      correct: 8,
      total: 10,
      bestStreak: 5,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.miniGameFinished]!;
    expect(parameters[AnalyticsParam.percent], 80);
    expect(parameters[AnalyticsParam.stars], 2);
    expect(parameters[AnalyticsParam.correct], 8);
    expect(parameters[AnalyticsParam.total], 10);
    expect(parameters[AnalyticsParam.bestStreak], 5);
  });
}
