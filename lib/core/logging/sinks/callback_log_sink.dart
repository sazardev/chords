import 'dart:async';

import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/log_sink.dart';

/// Sink que reenvía cada evento a un receptor.
///
/// Útil para encadenar logs a métricas, tests o un segundo logger sin escribir
/// un sink dedicado para cada caso.
class CallbackLogSink implements LogSink {
  /// Crea el sink con el receptor invocado por cada evento.
  const CallbackLogSink(this.onEntry);

  /// Receptor invocado con cada evento aceptado.
  final void Function(LogEntry entry) onEntry;

  @override
  void write(LogEntry entry) {
    onEntry(entry);
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}
}
