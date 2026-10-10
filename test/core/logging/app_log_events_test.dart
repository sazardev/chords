import 'package:chords/core/logging/app_log_events.dart';
import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:test/test.dart';

/// Tests de los helpers semánticos: navegación, permisos y solicitudes.
void main() {
  group('AppLogEvents.navigation', () {
    test('registra el destino en el canal de navegación', () {
      final MemoryLogSink sink = MemoryLogSink();
      AppLogger(sinks: <LogSink>[sink]).navigation(to: '/chords', from: '/');

      final LogEntry entry = sink.entries.single;
      expect(entry.channel, LogChannel.router);
      expect(entry.message, contains('/chords'));
      expect(entry.context['from'], '/');
    });
  });

  group('AppLogEvents.permission', () {
    test('concedida como info y denegada como aviso', () {
      final MemoryLogSink sink = MemoryLogSink();
      AppLogger(sinks: <LogSink>[sink])
        ..permission('micrófono', granted: true)
        ..permission('micrófono', granted: false, reason: 'denegado');

      expect(sink.entries.first.level, AppLogLevel.info);
      expect(sink.entries.last.level, AppLogLevel.warning);
      expect(sink.entries.last.channel, LogChannel.microphone);
      expect(sink.entries.last.error, 'denegado');
    });
  });

  group('AppLogEvents.request', () {
    test('cronometra la solicitud y registra el resultado', () async {
      final MemoryLogSink sink = MemoryLogSink();
      final AppLogger logger = AppLogger(sinks: <LogSink>[sink]);

      final int value = await logger.request<int>(
        'cargar banco',
        channel: LogChannel.chords,
        run: () async => 7,
      );

      expect(value, 7);
      expect(sink.entries.single.channel, LogChannel.chords);
      expect(sink.entries.single.message, contains('cargar banco'));
      expect(sink.entries.single.duration, isNotNull);
    });
  });
}
