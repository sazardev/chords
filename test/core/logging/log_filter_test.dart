import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_filter.dart';
import 'package:test/test.dart';

/// Tests del filtro de eventos por severidad y canal.
void main() {
  group('LogFilter', () {
    test('acepta por encima o igual de la severidad mínima', () {
      const LogFilter filter = LogFilter.minimum(AppLogLevel.warning);

      expect(filter.accepts(AppLogLevel.error, LogChannel.ui), isTrue);
      expect(filter.accepts(AppLogLevel.warning, LogChannel.ui), isTrue);
      expect(filter.accepts(AppLogLevel.info, LogChannel.ui), isFalse);
      expect(filter.accepts(AppLogLevel.debug, LogChannel.ui), isFalse);
    });

    test('restringe por conjunto de canales cuando se indica', () {
      const LogFilter filter = LogFilter(
        minimum: AppLogLevel.debug,
        channels: <LogChannel>{LogChannel.audio, LogChannel.microphone},
      );

      expect(filter.accepts(AppLogLevel.debug, LogChannel.audio), isTrue);
      expect(filter.accepts(AppLogLevel.debug, LogChannel.microphone), isTrue);
      expect(filter.accepts(AppLogLevel.error, LogChannel.ui), isFalse);
    });
  });
}
