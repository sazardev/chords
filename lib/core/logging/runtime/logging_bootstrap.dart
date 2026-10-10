import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/formatters/console_log_formatter.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_filter.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/runtime/frame_performance_monitor.dart';
import 'package:chords/core/logging/sinks/console_log_sink.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// Construye y activa el sistema de logging para el entorno indicado.
///
/// Selecciona los sinks (consola y memoria), fija el filtro por severidad
/// mínima, arranca el monitor de fluidez y deja el logger disponible de forma
/// global a través de [appLogger]. Devuelve el logger creado.
AppLogger bootstrapLogging({
  required AppLogLevel minLevel,
  String appName = 'app',
  bool console = true,
  bool memory = true,
  bool frameMonitor = true,
  bool inAppDiagnostics = false,
}) {
  final List<LogSink> sinks = <LogSink>[];
  MemoryLogSink? memorySink;
  if (console) {
    sinks.add(ConsoleLogSink(consoleLogFormatter, debugPrint));
  }
  if (memory) {
    memorySink = MemoryLogSink();
    sinks.add(memorySink);
  }
  final AppLogger logger = AppLogger(
    sinks: sinks,
    filter: LogFilter.minimum(minLevel),
    name: appName,
  );
  configureAppLogger(logger);
  if (memorySink != null) {
    registerAppMemorySink(memorySink);
  }
  setAppLogDiagnosticsEnabled(enabled: inAppDiagnostics && memorySink != null);
  if (frameMonitor) {
    FramePerformanceMonitor(logger).start();
  }
  logger.info(
    'logging activo',
    channel: LogChannel.boot,
    context: <String, Object?>{
      'app': appName,
      'minLevel': minLevel.label,
      'sinks': sinks.length,
    },
  );
  return logger;
}
