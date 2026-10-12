import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';

/// Eventos de analítica de la afinación en vivo y el micrófono.
///
/// Amplía [AnalyticsService] con el ciclo de una sesión de escucha y con el
/// resultado del permiso de micrófono, incluyendo el resumen de lo escuchado.
extension LiveAnalyticsEvents on AnalyticsService {
  /// Ha comenzado una sesión de afinación en vivo.
  void liveSessionStarted() => event(AnalyticsEventName.liveSessionStarted);

  /// Ha terminado la sesión, con su duración y lo escuchado.
  void liveSessionEnded({
    required Duration duration,
    required int readings,
    required int reliableReadings,
    required List<String> notesHeard,
    required int suggestions,
  }) => event(
    AnalyticsEventName.liveSessionEnded,
    parameters: <String, Object?>{
      AnalyticsParam.durationMs: duration.inMilliseconds,
      AnalyticsParam.readings: readings,
      AnalyticsParam.reliableReadings: reliableReadings,
      AnalyticsParam.notesHeard: notesHeard.join(','),
      AnalyticsParam.suggestions: suggestions,
    },
  );

  /// Resultado de la solicitud de permiso de micrófono.
  void micPermission({required bool granted}) => event(
    AnalyticsEventName.micPermission,
    parameters: <String, Object?>{AnalyticsParam.granted: granted ? 1 : 0},
  );
}
