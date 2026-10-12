import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';

/// Eventos de analítica de ajustes, onboarding y diagnóstico.
///
/// Amplía [AnalyticsService] con los cambios de preferencias y el recorrido de
/// primer uso, para medir qué personalizan los usuarios y dónde abandonan.
extension SettingsAnalyticsEvents on AnalyticsService {
  /// Ha cambiado el ajuste [setting] al valor indicado.
  void settingChanged({required String setting, Object? value}) => event(
    AnalyticsEventName.settingChanged,
    parameters: <String, Object?>{
      AnalyticsParam.setting: setting,
      AnalyticsParam.settingValue: ?value,
    },
  );

  /// El usuario ha alcanzado el paso [step] del onboarding.
  void onboardingStep({required int step}) => event(
    AnalyticsEventName.onboardingStep,
    parameters: <String, Object?>{AnalyticsParam.step: step},
  );

  /// El onboarding se ha completado.
  void onboardingCompleted() => event(AnalyticsEventName.onboardingCompleted);

  /// El onboarding se ha reiniciado desde ajustes.
  void onboardingReset() => event(AnalyticsEventName.onboardingReset);

  /// Se ha abierto el visor de diagnóstico en la app.
  void diagnosticsOpened() => event(AnalyticsEventName.diagnosticsOpened);
}
