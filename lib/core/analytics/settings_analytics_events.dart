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

  /// La persona ha elegido o cambiado su perfil de guitarrista.
  void profileUpdated({
    required String guitar,
    required String hand,
    required String style,
    required String experience,
    required int genres,
  }) => event(
    AnalyticsEventName.profileUpdated,
    parameters: <String, Object?>{
      AnalyticsParam.guitar: guitar,
      AnalyticsParam.hand: hand,
      AnalyticsParam.playStyle: style,
      AnalyticsParam.experience: experience,
      AnalyticsParam.genreCount: genres,
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
