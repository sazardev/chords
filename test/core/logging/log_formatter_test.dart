import 'dart:convert';

import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/formatters/console_log_formatter.dart';
import 'package:chords/core/logging/formatters/json_log_formatter.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:test/test.dart';

/// Tests de los formateadores de eventos de log.
void main() {
  final LogEntry entry = LogEntry(
    sequence: 12,
    time: DateTime.utc(2026, 1, 1, 12),
    level: AppLogLevel.error,
    channel: LogChannel.chords,
    message: 'fallo de carga',
    error: 'boom',
    context: <String, Object?>{'count': 3, 'durationMs': 12.0},
  );

  group('consoleLogFormatter', () {
    test('incluye nivel, canal, duración, contexto y error', () {
      final String line = formatConsoleLog(entry);

      expect(line, contains('ERROR'));
      expect(line, contains('chords'));
      expect(line, contains('fallo de carga'));
      expect(line, contains('[12ms]'));
      expect(line, contains('count=3'));
      expect(line, contains(':: boom'));
    });
  });

  group('jsonLogFormatter', () {
    test('serializa los campos consultables', () {
      final Object? decoded = jsonDecode(formatJsonLog(entry));

      expect(decoded, isA<Map<String, Object?>>());
      final Map<String, Object?> map = decoded! as Map<String, Object?>;
      expect(map['seq'], 12);
      expect(map['level'], 'ERROR');
      expect(map['channel'], 'chords');
      expect(map['message'], 'fallo de carga');
      expect(map['error'], 'boom');
    });
  });
}
