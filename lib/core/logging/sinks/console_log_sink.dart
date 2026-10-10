import 'dart:async';

import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_formatter.dart';
import 'package:chords/core/logging/log_sink.dart';

/// Sink que escribe cada evento formateado mediante una función de salida.
///
/// El escritor se inyecta (p. ej. `debugPrint` o un recolector en tests), de
/// modo que el sink permanece puro y sin dependencia de Flutter.
class ConsoleLogSink implements LogSink {
  /// Crea el sink con un formateador y un escritor inyectados.
  const ConsoleLogSink(this.formatter, this.writer);

  /// Convierte el evento en texto antes de escribirlo.
  final LogFormatter formatter;

  /// Función de escritura de cada línea ya formateada.
  final void Function(String line) writer;

  @override
  void write(LogEntry entry) {
    writer(formatter(entry));
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}
}
