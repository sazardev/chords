import 'package:chords/core/analytics/analytics_events.dart';
import 'package:test/test.dart';

/// Tests del catálogo central de eventos y parámetros.
void main() {
  group('catálogo de eventos', () {
    test('los nombres cumplen el formato de Firebase', () {
      final RegExp pattern = RegExp(r'^[a-z][a-z0-9_]{0,39}$');
      for (final String name in kAllAnalyticsEventNames) {
        expect(
          pattern.hasMatch(name),
          isTrue,
          reason: 'nombre inválido: $name',
        );
      }
    });

    test('no hay nombres duplicados', () {
      expect(
        kAllAnalyticsEventNames.toSet(),
        hasLength(kAllAnalyticsEventNames.length),
      );
    });
  });
}
