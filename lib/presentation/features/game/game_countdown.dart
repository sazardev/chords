import 'dart:async';

import 'package:flutter/foundation.dart';

/// Cuenta atrás que da tiempo a colocar la mano antes de cada ronda.
///
/// Cuenta en segundos: avisa con [onTick] cada vez que baja y con [onDone]
/// al llegar a cero. Sin [delay] no cuenta: la ronda espera a que se pida.
class GameCountdown {
  /// Crea la cuenta atrás de [delay] (`null` la desactiva).
  GameCountdown(this.delay, {required this.onTick, required this.onDone});

  /// Duración de la cuenta atrás; `null` si no hay.
  final Duration? delay;

  /// Se llama al empezar y cada segundo que pasa.
  final VoidCallback onTick;

  /// Se llama al llegar a cero.
  final VoidCallback onDone;

  Timer? _timer;
  int _remaining = 0;

  /// Segundos que faltan; 0 si no está contando.
  int get remaining => _remaining;

  /// Empieza a contar desde el principio; no hace nada sin [delay].
  void start() {
    stop();
    final Duration? total = delay;
    if (total == null) {
      return;
    }
    _remaining = total.inSeconds < 1 ? 1 : total.inSeconds;
    onTick();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      _remaining--;
      if (_remaining <= 0) {
        stop();
        onDone();
        return;
      }
      onTick();
    });
  }

  /// Detiene la cuenta sin avisar.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _remaining = 0;
  }
}
