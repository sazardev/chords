import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_filter.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/runtime/global_error_handler.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:test/test.dart';

/// Tests del manejador puro que transforma errores capturados en logs.
void main() {
  group('reportCapturedError', () {
    test('registra un error en el canal de framework con su origen', () {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(
        sinks: <LogSink>[sink],
        filter: const LogFilter.minimum(AppLogLevel.warning),
      );
      final StackTrace stack = StackTrace.current;

      reportCapturedError(
        logger,
        origin: 'plataforma',
        error: const FormatException('caída'),
        stackTrace: stack,
      );

      final LogEntry entry = sink.entries.single;
      expect(entry.level, AppLogLevel.error);
      expect(entry.channel, LogChannel.framework);
      expect(entry.message, contains('plataforma'));
      expect(entry.error, isA<FormatException>());
      expect(entry.stackTrace, stack);
      expect(entry.context['origin'], 'plataforma');
    });
  });
}
