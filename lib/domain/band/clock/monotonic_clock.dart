/// Reloj monótono: solo avanza, nunca salta con cambios de hora del sistema.
abstract interface class MonotonicClock {
  /// Tiempo transcurrido desde un origen arbitrario.
  Duration get now;
}

/// Reloj real, apoyado en un [Stopwatch].
class StopwatchClock implements MonotonicClock {
  /// Crea el reloj y lo arranca.
  StopwatchClock() : _watch = Stopwatch()..start();

  final Stopwatch _watch;

  @override
  Duration get now => _watch.elapsed;
}
