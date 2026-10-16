import 'package:chords/presentation/features/minigames/question_clock.dart';
import 'package:flutter/foundation.dart';

/// Reloj de pruebas que solo avanza cuando se le dice.
///
/// Sustituye al `Timer` real de los juegos con tiempo: cada [tick] equivale a
/// [QuestionClock.tickMs] milisegundos y no deja temporizadores pendientes.
class ManualQuestionClock implements QuestionClock {
  VoidCallback? _onTick;

  /// `true` si alguien está esperando los avisos.
  bool get running => _onTick != null;

  @override
  void start(VoidCallback onTick) => _onTick = onTick;

  @override
  void stop() => _onTick = null;

  /// Avanza [count] avisos (por defecto uno).
  void tick([int count = 1]) {
    for (int i = 0; i < count; i++) {
      _onTick?.call();
    }
  }

  /// Avanza [milliseconds] milisegundos, en avisos de [QuestionClock.tickMs].
  void elapse(int milliseconds) =>
      tick((milliseconds / QuestionClock.tickMs).ceil());
}
