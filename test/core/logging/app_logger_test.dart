import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_filter.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:test/test.dart';

/// Tests de la fachada de logging y del cronometraje de operaciones.
void main() {
  group('AppLogger niveles', () {
    test('asigna secuencia, canal y reparte a los sinks', () {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink])
        ..info('hola')
        ..warning('cuidado', channel: LogChannel.audio);

      expect(sink.length, 2);
      expect(logger.name, 'app');
      expect(sink.entries.first.sequence, 1);
      expect(sink.entries.last.sequence, 2);
      expect(sink.entries.first.level, AppLogLevel.info);
      expect(sink.entries.last.channel, LogChannel.audio);
    });

    test('descarta los eventos por debajo del filtro', () {
      final MemoryLogSink sink = MemoryLogSink();
      AppLogger(
          sinks: <LogSink>[sink],
          filter: const LogFilter.minimum(AppLogLevel.warning),
        )
        ..info('no entra')
        ..warning('si entra');

      expect(sink.length, 1);
      expect(sink.entries.single.message, 'si entra');
    });

    test('conserva error y traza en el evento', () {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink]);
      final StackTrace stack = StackTrace.current;

      logger.error('fallo', error: 'boom', stackTrace: stack);

      expect(sink.entries.single.hasError, isTrue);
      expect(sink.entries.single.error, 'boom');
      expect(sink.entries.single.stackTrace, stack);
    });
  });

  group('AppLogger track', () {
    test('registra éxito y duración', () async {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink]);

      final int result = await logger.track<int>(
        () async => 42,
        name: 'operacion',
        channel: LogChannel.performance,
        slowThreshold: const Duration(seconds: 10),
      );

      expect(result, 42);
      final LogEntry entry = sink.entries.single;
      expect(entry.level, AppLogLevel.info);
      expect(entry.channel, LogChannel.performance);
      expect(entry.message, contains('operacion'));
      expect(entry.duration, isNotNull);
    });

    test('marca las operaciones lentas como aviso', () async {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink]);

      await logger.track<int>(
        () async => 1,
        name: 'lenta',
        channel: LogChannel.performance,
        slowThreshold: Duration.zero,
      );

      expect(sink.entries.single.level, AppLogLevel.warning);
    });

    test('registra el error como error y lo relanza', () async {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink]);

      await expectLater(
        logger.track<int>(
          () async => throw const FormatException('boom'),
          name: 'falla',
          channel: LogChannel.performance,
        ),
        throwsA(isA<FormatException>()),
      );

      final LogEntry entry = sink.entries.single;
      expect(entry.level, AppLogLevel.error);
      expect(entry.error, isA<FormatException>());
    });

    test('trackSync cronometra y registra', () {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink]);

      final String value = logger.trackSync<String>(
        () => 'ok',
        name: 'sync',
        channel: LogChannel.boot,
        slowThreshold: const Duration(seconds: 10),
      );

      expect(value, 'ok');
      expect(sink.entries.single.level, AppLogLevel.info);
      expect(sink.entries.single.message, contains('sync'));
    });
  });
}
