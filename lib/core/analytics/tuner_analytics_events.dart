import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';

/// Eventos de analítica del afinador y de la práctica de acordes.
///
/// Resumen de cada sesión de micrófono guiada: cuánto duró y cuánto se logró.
extension TunerAnalyticsEvents on AnalyticsService {
  /// Ha terminado una sesión del afinador con [tunedStrings] de 6 afinadas.
  void tunerSessionEnded({
    required Duration duration,
    required int tunedStrings,
  }) => event(
    AnalyticsEventName.tunerSessionEnded,
    parameters: <String, Object?>{
      AnalyticsParam.durationMs: duration.inMilliseconds,
      AnalyticsParam.tunedStrings: tunedStrings,
    },
  );

  /// Ha terminado la práctica de [chordId] cuerda a cuerda.
  void practiceSessionEnded({
    required String chordId,
    required String variantId,
    required Duration duration,
    required int matchedStrings,
    required int totalStrings,
  }) => event(
    AnalyticsEventName.practiceSessionEnded,
    parameters: <String, Object?>{
      AnalyticsParam.chordId: chordId,
      AnalyticsParam.variantId: variantId,
      AnalyticsParam.durationMs: duration.inMilliseconds,
      AnalyticsParam.matchedStrings: matchedStrings,
      AnalyticsParam.totalStrings: totalStrings,
      AnalyticsParam.completed: matchedStrings == totalStrings ? 1 : 0,
    },
  );
}
