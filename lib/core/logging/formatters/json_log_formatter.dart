import 'dart:convert';

import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_formatter.dart';

/// Formatea un evento como JSON de una sola línea.
///
/// Pensado para exportar trazas estructuradas o enviarlas a un agregador;
/// conserva severidad, canal, contexto y error de forma consultable.
String formatJsonLog(LogEntry entry) => jsonEncode(<String, Object?>{
  'seq': entry.sequence,
  'time': entry.time.toIso8601String(),
  'level': entry.level.label,
  'channel': entry.channel.label,
  'message': entry.message,
  if (entry.error != null) 'error': '${entry.error}',
  if (entry.stackTrace != null) 'stack': '${entry.stackTrace}',
  'context': entry.context,
});

/// Formateador JSON listo para inyectar en un `ConsoleLogSink`.
const LogFormatter jsonLogFormatter = formatJsonLog;
