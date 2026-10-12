import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de la fachada de analíticas: eventos, pantallas y errores.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  group('AnalyticsService', () {
    test('registra la apertura con el flavor', () {
      service.appOpened(flavor: 'prod');

      expect(backend.events, <String>[AnalyticsEventName.appOpen]);
      expect(
        backend.lastParameters[AnalyticsEventName.appOpen],
        containsPair(AnalyticsParam.flavor, 'prod'),
      );
    });

    test('encadena pantallas y deduplica repeticiones consecutivas', () {
      service
        ..screen('home')
        ..screen('home')
        ..screen('chords')
        ..screen('chords')
        ..screen('chord-detail', from: 'chords');

      expect(backend.screens, <String>['home', 'chords', 'chord-detail']);
      expect(backend.previousScreens, <String?>[null, 'home', 'chords']);
      expect(service.currentScreen, 'chord-detail');
    });

    test('screenPopped restaura la pantalla anterior', () {
      service
        ..screen('learn')
        ..screen('chord-detail')
        ..screenPopped();

      expect(service.currentScreen, 'learn');
      expect(backend.screens, <String>['learn', 'chord-detail', 'learn']);
      expect(backend.previousScreens.last, 'chord-detail');
    });

    test('recordError deriva al backend, marca fatal y cuenta el evento', () {
      service.recordError(
        StateError('fallo'),
        StackTrace.empty,
        fatal: true,
        origin: 'plataforma',
        context: <String, Object?>{'channel': 'audio'},
      );

      expect(backend.errors.single, contains('fallo'));
      expect(backend.fatals.single, isTrue);
      expect(backend.events, <String>[AnalyticsEventName.appError]);
      final Map<String, Object?> parameters =
          backend.lastParameters[AnalyticsEventName.appError]!;
      expect(parameters[AnalyticsParam.origin], 'plataforma');
      expect(parameters['channel'], 'audio');
    });

    test('fija propiedades de usuario', () {
      service.setUserProperty('flavor', 'staging');

      expect(backend.properties, <String>['flavor=staging']);
    });

    test('flush delega en el backend', () async {
      await service.flush();

      expect(backend.flushes, 1);
    });
  });
}
