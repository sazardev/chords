import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/live_analytics_events.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de los eventos semánticos del micrófono y la afinación en vivo.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  test('liveSessionEnded resume duración, lecturas y notas escuchadas', () {
    service.liveSessionEnded(
      duration: const Duration(seconds: 30),
      readings: 120,
      reliableReadings: 90,
      notesHeard: <String>['E', 'A', 'D'],
      suggestions: 4,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.liveSessionEnded]!;
    expect(parameters[AnalyticsParam.durationMs], 30000);
    expect(parameters[AnalyticsParam.readings], 120);
    expect(parameters[AnalyticsParam.reliableReadings], 90);
    expect(parameters[AnalyticsParam.notesHeard], 'E,A,D');
    expect(parameters[AnalyticsParam.suggestions], 4);
  });

  test('micPermission refleja el resultado del permiso', () {
    service.micPermission(granted: false);

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.micPermission]!;
    expect(parameters[AnalyticsParam.granted], 0);
  });
}
