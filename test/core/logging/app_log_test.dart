import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:test/test.dart';

/// Tests del registro global del logger y del flag de diagnóstico.
void main() {
  tearDown(resetAppLogger);

  group('appLog', () {
    test('el logger por defecto es silencioso y seguro', () {
      resetAppLogger();
      expect(appLogger, isA<AppLogger>());
      appLogger.error('sin sinks');
      expect(appMemoryLogSink, isNull);
    });

    test('configureAppLogger registra logger y sink en memoria', () {
      final MemoryLogSink sink = MemoryLogSink();
      configureAppLogger(AppLogger(sinks: <LogSink>[sink]));
      registerAppMemorySink(sink);

      appLogger.warning('atención');

      expect(appMemoryLogSink, same(sink));
      expect(sink.length, 1);
    });

    test('el flag de diagnóstico se activa y desactiva', () {
      setAppLogDiagnosticsEnabled(enabled: true);
      expect(appLogDiagnosticsEnabled, isTrue);
      setAppLogDiagnosticsEnabled(enabled: false);
      expect(appLogDiagnosticsEnabled, isFalse);
    });
  });
}
