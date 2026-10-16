import 'dart:async';

import 'package:chords/domain/band/clock/monotonic_clock.dart';

/// Reloj manual para probar el planificador.
class ManualClock implements MonotonicClock {
  @override
  Duration now = Duration.zero;
}

/// Temporizador falso: no corre solo, lo dispara quien lo maneja.
class FakeTimer implements Timer {
  /// Crea el temporizador con su plazo y su acción.
  FakeTimer(this.due, this._action);

  /// Instante (en el reloj manual) en que debe dispararse.
  final Duration due;
  final void Function() _action;
  bool _active = true;

  @override
  bool get isActive => _active;

  @override
  int get tick => 0;

  @override
  void cancel() => _active = false;

  /// Ejecuta la acción.
  void fire() {
    _active = false;
    _action();
  }
}

/// Fábrica de temporizadores falsos sobre un [ManualClock].
class FakeTimers {
  /// Crea la fábrica.
  FakeTimers(this.clock);

  /// Reloj manual.
  final ManualClock clock;

  /// Todos los temporizadores creados, en orden.
  final List<FakeTimer> created = <FakeTimer>[];

  /// Retardos pedidos al crear cada temporizador.
  final List<Duration> requested = <Duration>[];

  /// Para pasar como `timerFactory`.
  Timer create(Duration delay, void Function() action) {
    final FakeTimer timer = FakeTimer(clock.now + delay, action);
    created.add(timer);
    requested.add(delay);
    return timer;
  }

  /// Temporizador activo (el último creado que no se canceló).
  FakeTimer? get active {
    for (final FakeTimer timer in created.reversed) {
      if (timer.isActive) {
        return timer;
      }
    }
    return null;
  }

  /// Dispara el temporizador activo con [lateness] de retraso: el reloj
  /// avanza hasta su plazo más el retraso.
  bool fireNext({Duration lateness = Duration.zero}) {
    final FakeTimer? timer = active;
    if (timer == null) {
      return false;
    }
    final Duration at = timer.due + lateness;
    if (at > clock.now) {
      clock.now = at;
    }
    timer.fire();
    return true;
  }
}
