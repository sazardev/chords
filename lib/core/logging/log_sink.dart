import 'package:chords/core/logging/log_entry.dart';

/// Destino de los eventos de log.
///
/// Un sink recibe cada [LogEntry] aceptado por el filtro y decide cómo
/// mostrarlo o persistirlo. Es la frontera pura con el medio de salida, de
/// modo que el núcleo del logging nunca depende de consola, red o almacén.
abstract interface class LogSink {
  /// Escribe un evento ya aceptado por el filtro.
  void write(LogEntry entry);

  /// Vuelca lo pendiente si el sink bufferiza.
  Future<void> flush();

  /// Libera los recursos del sink.
  Future<void> close();
}
