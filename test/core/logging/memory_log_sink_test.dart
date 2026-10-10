import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:test/test.dart';

/// Tests del sink en memoria: buffer acotado, consultas y flujo.
void main() {
  LogEntry entry(
    AppLogLevel level,
    LogChannel channel, {
    int sequence = 1,
    String message = 'mensaje',
    Object? error,
  }) => LogEntry(
    sequence: sequence,
    time: DateTime.utc(2026),
    level: level,
    channel: channel,
    message: message,
    error: error,
  );

  group('MemoryLogSink', () {
    test('descarta los eventos antiguos al superar la capacidad', () {
      final MemoryLogSink sink = MemoryLogSink(capacity: 2)
        ..write(entry(AppLogLevel.info, LogChannel.ui))
        ..write(entry(AppLogLevel.info, LogChannel.ui, sequence: 2))
        ..write(entry(AppLogLevel.info, LogChannel.ui, sequence: 3));

      expect(sink.length, 2);
      expect(sink.entries.first.sequence, 2);
      expect(sink.entries.last.sequence, 3);
    });

    test('cuenta errores y avisos retenidos', () {
      final MemoryLogSink sink = MemoryLogSink()
        ..write(entry(AppLogLevel.error, LogChannel.ui, error: 'e'))
        ..write(entry(AppLogLevel.warning, LogChannel.ui))
        ..write(entry(AppLogLevel.info, LogChannel.ui));

      expect(sink.errorCount, 1);
      expect(sink.warningCount, 1);
      expect(sink.length, 3);
    });

    test('filtra por severidad, canal, error y texto', () {
      final MemoryLogSink sink = MemoryLogSink()
        ..write(
          entry(AppLogLevel.info, LogChannel.audio, message: 'reproducir'),
        )
        ..write(
          entry(
            AppLogLevel.error,
            LogChannel.chords,
            message: 'banco',
            error: 'x',
          ),
        );

      expect(sink.filter(minimum: AppLogLevel.warning).length, 1);
      expect(sink.filter(channel: LogChannel.audio).length, 1);
      expect(sink.filter(hasError: true).length, 1);
      expect(sink.filter(query: 'banco').length, 1);
      expect(sink.filter(query: 'zzz').length, 0);
    });

    test('emite cada evento por el stream', () async {
      final MemoryLogSink sink = MemoryLogSink();
      final Future<LogEntry> next = sink.stream.first;

      sink.write(entry(AppLogLevel.info, LogChannel.ui));

      expect((await next).message, 'mensaje');
    });

    test('clear vacía el buffer sin emitir', () async {
      final MemoryLogSink sink = MemoryLogSink()
        ..write(entry(AppLogLevel.info, LogChannel.ui))
        ..clear();

      expect(sink.length, 0);
    });
  });
}
