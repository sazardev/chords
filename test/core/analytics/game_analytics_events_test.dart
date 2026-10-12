import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/game_analytics_events.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de los eventos semánticos del modo juego.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  test('gameStarted registra el nivel y el número de rondas', () {
    service.gameStarted(level: 2, rounds: 5);

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.gameStarted]!;
    expect(parameters[AnalyticsParam.level], 2);
    expect(parameters[AnalyticsParam.rounds], 5);
  });

  test('gameRoundPlayed envía lo esperado frente a lo escuchado', () {
    service.gameRoundPlayed(
      index: 2,
      chordId: 'C-maj',
      expectedNotes: <String>['C', 'E', 'G'],
      heardNotes: <String>['C', 'E'],
      matchRatio: 0.67,
      outcome: 'partial',
      timeLimitMs: 8000,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.gameRoundPlayed]!;
    expect(parameters[AnalyticsParam.expectedNotes], 'C,E,G');
    expect(parameters[AnalyticsParam.heardNotes], 'C,E');
    expect(parameters[AnalyticsParam.matchRatio], 0.67);
    expect(parameters[AnalyticsParam.outcome], 'partial');
  });

  test('gameFinished resume el marcador de la serie', () {
    service.gameFinished(
      score: 300,
      best: 500,
      rounds: 5,
      won: 3,
      partial: 1,
      failed: 1,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.gameFinished]!;
    expect(parameters[AnalyticsParam.score], 300);
    expect(parameters[AnalyticsParam.bestScore], 500);
    expect(parameters[AnalyticsParam.won], 3);
    expect(parameters[AnalyticsParam.partial], 1);
    expect(parameters[AnalyticsParam.failed], 1);
  });
}
