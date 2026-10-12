import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/chord_analytics_events.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de los eventos semánticos del dominio de acordes.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  test('chordViewed describe el acorde abierto', () {
    service.chordViewed(
      chordId: 'C-maj',
      chordName: 'C',
      quality: 'maj',
      difficulty: 1,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.chordViewed]!;
    expect(parameters[AnalyticsParam.chordId], 'C-maj');
    expect(parameters[AnalyticsParam.chordName], 'C');
    expect(parameters[AnalyticsParam.quality], 'maj');
    expect(parameters[AnalyticsParam.difficulty], 1);
  });

  test('chordPlayed distingue rasgueo y arpegio con patrón', () {
    service
      ..chordPlayed(chordId: 'C-maj', variantId: 'C-maj-open')
      ..chordPlayed(
        chordId: 'C-maj',
        variantId: 'C-maj-open',
        arpeggio: true,
        patternId: 'up-4',
      );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.chordPlayed]!;
    expect(parameters[AnalyticsParam.variantId], 'C-maj-open');
    expect(parameters[AnalyticsParam.arpeggio], 1);
    expect(parameters[AnalyticsParam.patternId], 'up-4');
  });

  test('filterChanged envía filtro, valor y resultados', () {
    service.filterChanged(filter: 'root', value: 'C', results: 12);

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.filterChanged]!;
    expect(parameters[AnalyticsParam.filter], 'root');
    expect(parameters[AnalyticsParam.filterValue], 'C');
    expect(parameters[AnalyticsParam.results], 12);
  });

  test('chordMasteryChanged registra el estado nuevo y el total', () {
    service.chordMasteryChanged(
      chordId: 'C-maj',
      mastered: true,
      totalMastered: 3,
    );

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.chordMasteryChanged]!;
    expect(parameters[AnalyticsParam.mastered], 1);
    expect(parameters[AnalyticsParam.totalMastered], 3);
  });
}
