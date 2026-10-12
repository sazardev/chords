import 'package:chords/core/analytics/analytics_events.dart';
import 'package:chords/core/analytics/analytics_log_sink.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:test/test.dart';

import '../../fakes/fake_analytics_backend.dart';

/// Tests del puente entre el registro local y las analíticas remotas.
void main() {
  LogEntry entry(
    AppLogLevel level, {
    Object? error,
    Map<String, Object?> context = const <String, Object?>{},
  }) => LogEntry(
    sequence: 1,
    time: DateTime.utc(2026),
    level: level,
    channel: LogChannel.microphone,
    message: 'escucha detenida',
    error: error,
    context: context,
  );

  late FakeAnalyticsBackend backend;
  late AnalyticsLogSink sink;

  setUp(() {
    backend = FakeAnalyticsBackend();
    sink = AnalyticsLogSink(AnalyticsService(backend));
  });

  test('ignora los eventos por debajo de la severidad mínima', () {
    sink
      ..write(entry(AppLogLevel.debug))
      ..write(entry(AppLogLevel.info));

    expect(backend.events, isEmpty);
    expect(backend.errors, isEmpty);
  });

  test('los avisos viajan como evento app_warning con su canal', () {
    sink.write(entry(AppLogLevel.warning));

    expect(backend.events, <String>[AnalyticsEventName.appWarning]);
    final Map<String, Object?> parameters =
        backend.lastParameters[AnalyticsEventName.appWarning]!;
    expect(parameters[AnalyticsParam.channel], 'microphone');
    expect(parameters[AnalyticsParam.message], 'escucha detenida');
  });

  test('los errores van al backend con su origen y fatalidad', () {
    sink.write(
      entry(
        AppLogLevel.error,
        error: StateError('boom'),
        context: <String, Object?>{'origin': 'plataforma'},
      ),
    );

    expect(backend.errors.single, contains('boom'));
    expect(backend.fatals.single, isTrue);
    expect(backend.events, <String>[AnalyticsEventName.appError]);
  });

  test('un error de framework no se marca fatal', () {
    sink.write(
      entry(
        AppLogLevel.error,
        error: StateError('render'),
        context: <String, Object?>{'origin': 'framework'},
      ),
    );

    expect(backend.errors.single, contains('render'));
    expect(backend.fatals.single, isFalse);
  });

  test('los avisos sin error no se derivan como errores', () {
    sink.write(
      entry(
        AppLogLevel.warning,
        context: <String, Object?>{'origin': 'framework'},
      ),
    );

    expect(backend.errors, isEmpty);
  });

  test('flush delega en el servicio de analíticas', () async {
    await sink.flush();

    expect(backend.flushes, 1);
  });
}
