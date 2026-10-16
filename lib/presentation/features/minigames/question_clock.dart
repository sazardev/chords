import 'dart:async';

import 'package:flutter/foundation.dart';

/// Reloj de una pregunta con tiempo.
///
/// Es una costura pequeña para que el controlador del juego no dependa de un
/// `Timer` real: las pruebas lo sustituyen por uno que avanza a mano.
abstract interface class QuestionClock {
  /// Milisegundos que separan dos avisos.
  static const int tickMs = 250;

  /// Empieza a avisar con [onTick] cada [tickMs]; sustituye al aviso anterior.
  void start(VoidCallback onTick);

  /// Deja de avisar.
  void stop();
}

/// Reloj real, apoyado en un `Timer` periódico.
class PeriodicQuestionClock implements QuestionClock {
  Timer? _timer;

  @override
  void start(VoidCallback onTick) {
    stop();
    _timer = Timer.periodic(
      const Duration(milliseconds: QuestionClock.tickMs),
      (Timer _) => onTick(),
    );
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
