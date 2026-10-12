import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/tuner_analytics_events.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de los eventos del afinador y de la práctica de acordes.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  test('tunerSessionEnded resume duración y cuerdas afinadas', () {
    service.tunerSessionEnded(
      duration: const Duration(seconds: 45),
      tunedStrings: 6,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.tunerSessionEnded]!;
    expect(parameters[AnalyticsParam.durationMs], 45000);
    expect(parameters[AnalyticsParam.tunedStrings], 6);
  });

  test('practiceSessionEnded marca si el acorde quedó completo', () {
    service.practiceSessionEnded(
      chordId: 'C-maj',
      variantId: 'c-open',
      duration: const Duration(seconds: 20),
      matchedStrings: 5,
      totalStrings: 5,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.practiceSessionEnded]!;
    expect(parameters[AnalyticsParam.chordId], 'C-maj');
    expect(parameters[AnalyticsParam.matchedStrings], 5);
    expect(parameters[AnalyticsParam.completed], 1);
  });
}
