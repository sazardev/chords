import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests de los eventos semánticos de ajustes, onboarding y diagnóstico.
void main() {
  late FakeAnalyticsBackend backend;
  late AnalyticsService service;

  setUp(() {
    backend = FakeAnalyticsBackend();
    service = AnalyticsService(backend);
  });

  test('settingChanged envía el ajuste y su valor', () {
    service.settingChanged(setting: 'theme_mode', value: 'dark');

    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.settingChanged]!;
    expect(parameters[AnalyticsParam.setting], 'theme_mode');
    expect(parameters[AnalyticsParam.settingValue], 'dark');
  });

  test('el recorrido del onboarding queda trazado', () {
    service
      ..onboardingStep(step: 2)
      ..onboardingCompleted()
      ..onboardingReset()
      ..diagnosticsOpened();

    expect(backend.events, <String>[
      AnalyticsEventName.onboardingStep,
      AnalyticsEventName.onboardingCompleted,
      AnalyticsEventName.onboardingReset,
      AnalyticsEventName.diagnosticsOpened,
    ]);
    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.onboardingStep]!;
    expect(parameters[AnalyticsParam.step], 2);
  });
}
