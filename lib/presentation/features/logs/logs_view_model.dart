import 'dart:async';

import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/log_entry.dart';
import 'package:chords/core/logging/sinks/memory_log_sink.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

/// Modelo de vista del visor de logs dentro de la app.
///
/// Expone los eventos retenidos por el [MemoryLogSink] con un filtro opcional
/// por severidad y un resumen de errores y avisos, y se refresca en cuanto
/// llega un evento nuevo.
class LogsViewModel extends ChangeNotifier {
  /// Crea el modelo sobre el sink en memoria indicado.
  LogsViewModel(this._sink) {
    _subscription = _sink.stream.listen((_) => notifyListeners());
  }

  final MemoryLogSink _sink;
  late final StreamSubscription<LogEntry> _subscription;
  AppLogLevel? _level;

  /// Filtro de severidad actual; `null` muestra todo.
  AppLogLevel? get levelFilter => _level;

  /// Eventos retenidos que cumplen el filtro, del más antiguo al más nuevo.
  List<LogEntry> get entries => _sink.filter(minimum: _level);

  /// Número total de eventos retenidos.
  int get total => _sink.length;

  /// Número de errores retenidos.
  int get errorCount => _sink.errorCount;

  /// Número de avisos retenidos.
  int get warningCount => _sink.warningCount;

  /// Cambia el filtro de severidad mostrado.
  void setLevelFilter(AppLogLevel? level) {
    _level = level;
    notifyListeners();
  }

  /// Vacía el buffer de eventos.
  void clear() {
    _sink.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
