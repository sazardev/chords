import 'dart:async';

import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_sink.dart';

/// Sink en memoria con buffer acotado, consultas y flujo reactivo.
///
/// Retiene como máximo [capacity] eventos (descarta los más antiguos) y expone
/// consultas por severidad, canal o texto además de un `stream` para vistas
/// reactivas, como el visor de diagnóstico de la app.
class MemoryLogSink implements LogSink {
  /// Crea el sink con una capacidad máxima de eventos retenidos.
  MemoryLogSink({this.capacity = 500});

  /// Número máximo de eventos retenidos.
  final int capacity;

  final List<LogEntry> _entries = <LogEntry>[];
  final StreamController<LogEntry> _controller =
      StreamController<LogEntry>.broadcast();

  @override
  void write(LogEntry entry) {
    _entries.add(entry);
    if (_entries.length > capacity) {
      _entries.removeRange(0, _entries.length - capacity);
    }
    if (!_controller.isClosed) {
      _controller.add(entry);
    }
  }

  /// Flujo de eventos nuevos, para vistas que se reajustan en caliente.
  Stream<LogEntry> get stream => _controller.stream;

  /// Eventos retenidos en orden de llegada (copia inmutable).
  List<LogEntry> get entries => List<LogEntry>.unmodifiable(_entries);

  /// Número de eventos retenidos.
  int get length => _entries.length;

  /// Número de errores retenidos.
  int get errorCount => _countOf(AppLogLevel.error);

  /// Número de avisos retenidos.
  int get warningCount => _countOf(AppLogLevel.warning);

  /// Eventos que cumplen los criterios indicados (copia inmutable).
  List<LogEntry> filter({
    AppLogLevel? minimum,
    LogChannel? channel,
    bool? hasError,
    String? query,
  }) {
    final Iterable<LogEntry> selected = _entries.where((LogEntry entry) {
      if (minimum != null && entry.level.value < minimum.value) {
        return false;
      }
      if (channel != null && entry.channel != channel) {
        return false;
      }
      if (hasError != null && entry.hasError != hasError) {
        return false;
      }
      if (query != null &&
          !entry.message.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    });
    return List<LogEntry>.unmodifiable(selected);
  }

  /// Vacía el buffer sin emitir eventos.
  void clear() => _entries.clear();

  int _countOf(AppLogLevel level) =>
      _entries.where((LogEntry entry) => entry.level == level).length;

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {
    await _controller.close();
  }
}
