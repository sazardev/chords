import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_sink.dart';

/// Sink que reenvía avisos y errores del registro a las analíticas.
///
/// Los errores viajan al backend como errores agrupables (Crashlytics) y los
/// avisos como evento `app_warning`, de modo que el registro local y la
/// telemetría remota cuenten la misma historia sin duplicar los eventos de
/// negocio que ya emite cada controlador.
class AnalyticsLogSink implements LogSink {
  /// Crea el sink con el servicio de analíticas y la severidad mínima.
  AnalyticsLogSink(this._analytics, {this.minimum = AppLogLevel.warning});

  final AnalyticsService _analytics;

  /// Severidad mínima que se reenvía al proveedor.
  final AppLogLevel minimum;

  /// Orígenes cuyos errores se consideran fatales en Crashlytics.
  static const Set<String> _fatalOrigins = <String>{
    'plataforma',
    'zona asíncrona',
  };

  @override
  void write(LogEntry entry) {
    if (entry.level.value < minimum.value) {
      return;
    }
    final Map<String, Object?> context = <String, Object?>{
      AnalyticsParam.channel: entry.channel.label,
      AnalyticsParam.message: _clip(entry.message),
      ...entry.context,
    };
    final Object? error = entry.error;
    if (error != null) {
      _analytics.recordError(
        error,
        entry.stackTrace ?? StackTrace.empty,
        fatal: _isFatal(entry),
        origin: entry.context['origin']?.toString(),
        context: context,
      );
      return;
    }
    _analytics.event(AnalyticsEventName.appWarning, parameters: context);
  }

  bool _isFatal(LogEntry entry) =>
      _fatalOrigins.contains(entry.context['origin']?.toString());

  String _clip(String value) =>
      value.length <= 100 ? value : value.substring(0, 100);

  @override
  Future<void> flush() => _analytics.flush();

  @override
  Future<void> close() async {}
}
