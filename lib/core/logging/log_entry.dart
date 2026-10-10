import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';

/// Evento de log inmutable.
class LogEntry {
  /// Crea un evento de log.
  const LogEntry({
    required this.sequence,
    required this.time,
    required this.level,
    required this.channel,
    required this.message,
    this.error,
    this.stackTrace,
    this.context = const <String, Object?>{},
  });

  /// Número de secuencia incremental (1 = primer evento).
  final int sequence;

  /// Instante del evento.
  final DateTime time;

  /// Nivel de severidad.
  final AppLogLevel level;

  /// Canal de origen.
  final LogChannel channel;

  /// Mensaje legible.
  final String message;

  /// Error asociado si existe.
  final Object? error;

  /// Traza asociada si existe.
  final StackTrace? stackTrace;

  /// Datos estructurados de contexto.
  final Map<String, Object?> context;

  /// Si el evento incluye error.
  bool get hasError => error != null;

  /// Duración registrada en el contexto (si aplica).
  Duration? get duration {
    final Object? value = context['durationMs'];
    if (value is num) {
      return Duration(microseconds: (value * 1000).round());
    }
    return null;
  }

  @override
  String toString() =>
      '${time.toIso8601String()} ${level.label} ${channel.label} $message';
}
