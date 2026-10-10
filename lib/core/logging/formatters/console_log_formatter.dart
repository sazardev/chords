import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_formatter.dart';

/// Formatea un evento para consola en una sola línea legible.
///
/// Ejemplo: `12:00:00.123 INFO  chords    banco listo [12ms] count=156`.
String formatConsoleLog(LogEntry entry) {
  final StringBuffer buffer = StringBuffer()
    ..write(_clock(entry.time))
    ..write(' ')
    ..write(entry.level.label.padRight(5))
    ..write(' ')
    ..write(entry.channel.label.padRight(11))
    ..write(' ')
    ..write(entry.message);
  final Duration duration = entry.duration ?? Duration.zero;
  if (entry.duration != null) {
    buffer.write(' [${duration.inMilliseconds}ms]');
  }
  for (final MapEntry<String, Object?> item in entry.context.entries) {
    if (item.key == 'durationMs') {
      continue;
    }
    buffer.write(' ${item.key}=${item.value}');
  }
  if (entry.error != null) {
    buffer.write(' :: ${entry.error}');
  }
  return buffer.toString();
}

/// Formateador de consola listo para inyectar en un `ConsoleLogSink`.
const LogFormatter consoleLogFormatter = formatConsoleLog;

/// Renderiza la hora local compacta como `HH:MM:SS.mmm`.
String _clock(DateTime time) {
  final String hh = time.hour.toString().padLeft(2, '0');
  final String mm = time.minute.toString().padLeft(2, '0');
  final String ss = time.second.toString().padLeft(2, '0');
  final String ms = time.millisecond.toString().padLeft(3, '0');
  return '$hh:$mm:$ss.$ms';
}
