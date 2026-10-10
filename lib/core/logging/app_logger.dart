import 'dart:async';

import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_filter.dart';
import 'package:chords/core/logging/log_sink.dart';

/// Fachada de registro de la aplicación.
///
/// Es el único punto que el resto de capas usa para registrar. Asigna el
/// número de secuencia y la marca de tiempo, aplica el [LogFilter] y reparte
/// cada evento aceptado entre los sinks configurados. Es puro y sin Flutter,
/// con reloj y sinks inyectados, de modo que se testea de forma aislada.
class AppLogger {
  /// Crea el logger con los sinks, filtro y reloj indicados.
  AppLogger({
    required List<LogSink> sinks,
    LogFilter? filter,
    DateTime Function()? clock,
    this.name = 'app',
  }) : _sinks = List<LogSink>.unmodifiable(sinks),
       _filter = filter ?? const LogFilter.minimum(AppLogLevel.debug),
       _clock = clock ?? DateTime.now;

  final List<LogSink> _sinks;
  final LogFilter _filter;
  final DateTime Function() _clock;
  int _sequence = 0;

  /// Nombre del logger, usado como origen en las trazas.
  final String name;

  /// Registra un evento si supera el filtro.
  void log(
    AppLogLevel level,
    String message, {
    LogChannel channel = LogChannel.ui,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    if (!_filter.accepts(level, channel)) {
      return;
    }
    _emit(
      level: level,
      channel: channel,
      message: message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Registra un evento de depuración.
  void debug(
    String message, {
    LogChannel channel = LogChannel.ui,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) => log(
    AppLogLevel.debug,
    message,
    channel: channel,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  /// Registra un suceso informativo.
  void info(
    String message, {
    LogChannel channel = LogChannel.ui,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) => log(
    AppLogLevel.info,
    message,
    channel: channel,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  /// Registra un aviso recuperable.
  void warning(
    String message, {
    LogChannel channel = LogChannel.ui,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) => log(
    AppLogLevel.warning,
    message,
    channel: channel,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  /// Registra un error de una operación fallida.
  void error(
    String message, {
    LogChannel channel = LogChannel.ui,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const <String, Object?>{},
  }) => log(
    AppLogLevel.error,
    message,
    channel: channel,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  /// Cronometra una operación asíncrona y registra su resultado.
  ///
  /// Registra el tiempo (`durationMs`), avisa si supera [slowThreshold] y, si
  /// la operación lanza una excepción, la registra como error y la relanza.
  Future<T> track<T>(
    Future<T> Function() operation, {
    required String name,
    required LogChannel channel,
    AppLogLevel level = AppLogLevel.info,
    Duration slowThreshold = const Duration(milliseconds: 500),
    Map<String, Object?> context = const <String, Object?>{},
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final T result = await operation();
      _report(
        name,
        channel,
        level,
        stopwatch.elapsed,
        slowThreshold,
        null,
        null,
        context,
      );
      return result;
    } on Exception catch (error, stackTrace) {
      _report(
        name,
        channel,
        AppLogLevel.error,
        stopwatch.elapsed,
        slowThreshold,
        error,
        stackTrace,
        context,
      );
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  /// Cronometra una operación síncrona y registra su resultado.
  ///
  /// Versión síncrona de [track]; relanza tras registrar cualquier excepción.
  T trackSync<T>(
    T Function() operation, {
    required String name,
    required LogChannel channel,
    AppLogLevel level = AppLogLevel.info,
    Duration slowThreshold = const Duration(milliseconds: 500),
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final T result = operation();
      _report(
        name,
        channel,
        level,
        stopwatch.elapsed,
        slowThreshold,
        null,
        null,
        context,
      );
      return result;
    } on Exception catch (error, stackTrace) {
      _report(
        name,
        channel,
        AppLogLevel.error,
        stopwatch.elapsed,
        slowThreshold,
        error,
        stackTrace,
        context,
      );
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  void _report(
    String name,
    LogChannel channel,
    AppLogLevel successLevel,
    Duration elapsed,
    Duration slowThreshold,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context,
  ) {
    final Map<String, Object?> data = <String, Object?>{
      ...context,
      'durationMs': elapsed.inMicroseconds / 1000,
    };
    if (error != null) {
      log(
        AppLogLevel.error,
        '$name falló en ${elapsed.inMilliseconds}ms',
        channel: channel,
        error: error,
        stackTrace: stackTrace,
        context: data,
      );
      return;
    }
    if (elapsed >= slowThreshold) {
      log(
        AppLogLevel.warning,
        '$name lento: ${elapsed.inMilliseconds}ms',
        channel: channel,
        context: data,
      );
      return;
    }
    log(
      successLevel,
      '$name en ${elapsed.inMilliseconds}ms',
      channel: channel,
      context: data,
    );
  }

  void _emit({
    required AppLogLevel level,
    required LogChannel channel,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    required Map<String, Object?> context,
  }) {
    final LogEntry entry = LogEntry(
      sequence: ++_sequence,
      time: _clock(),
      level: level,
      channel: channel,
      message: message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
    for (final LogSink sink in _sinks) {
      sink.write(entry);
    }
  }
}
