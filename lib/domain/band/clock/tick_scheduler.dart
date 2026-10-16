import 'dart:async';

import 'package:chords/domain/band/clock/monotonic_clock.dart';
import 'package:chords/domain/band/clock/swing_grid.dart';
import 'package:chords/domain/band/clock/tick.dart';

/// Crea el temporizador de un solo disparo (inyectable en las pruebas).
typedef TimerFactory = Timer Function(Duration delay, void Function() action);

/// Planificador de semicorcheas con plazos absolutos.
///
/// Un `Timer.periodic` acumula deriva y jitter; este planificador calcula el
/// plazo de cada semicorchea desde un ancla (`ancla + n·intervalo`, con
/// aritmética entera en microsegundos) y lo compara con un reloj monótono.
/// Cada aviso se arma para el siguiente plazo, así que un retraso no se
/// arrastra: el n-ésimo golpe cae siempre en el mismo instante.
///
/// * **Swing**: retrasa la semicorchea o corchea par según [SwingGrid].
/// * **Tempo en marcha**: [setBpm] reancla en el siguiente plazo, sin saltos.
/// * **Adelanto**: [lead] avisa un poco antes del golpe para que quien lo
///   toque pueda humanizar hacia delante o hacia atrás.
class TickScheduler {
  /// Crea el planificador.
  ///
  /// [onTick] recibe cada semicorchea; [clock] y [timerFactory] se sustituyen
  /// en las pruebas.
  TickScheduler({
    required this.onTick,
    MonotonicClock? clock,
    TimerFactory? timerFactory,
  }) : _clock = clock ?? StopwatchClock(),
       _timerFactory = timerFactory ?? Timer.new;

  /// Recibe cada semicorchea cuando llega su hora.
  final void Function(Tick tick) onTick;

  final MonotonicClock _clock;
  final TimerFactory _timerFactory;

  /// Cuánto antes del golpe se avisa.
  Duration lead = Duration.zero;

  Timer? _timer;
  bool _running = false;
  int _bpm = 100;
  double _swing = 0;
  SwingGrid _grid = SwingGrid.eighth;
  int _anchorIndex = 0;
  int _anchorMicros = 0;
  int _next = 0;
  int? _pausedRemaining;

  /// Retraso (µs) a partir del cual se da el golpe por perdido y se reancla
  /// en vez de disparar todos los atrasados de golpe.
  static const int _maxCatchUpMicros = 1000000;

  /// `true` si el planificador está en marcha (no parado ni en pausa).
  bool get isRunning => _running;

  /// Índice de la próxima semicorchea que se disparará.
  int get nextIndex => _next;

  /// Arranca desde la semicorchea 0; la primera suena tras [delay].
  void start({
    required int bpm,
    double swing = 0,
    SwingGrid grid = SwingGrid.eighth,
    Duration delay = Duration.zero,
  }) {
    stop();
    _bpm = bpm;
    _swing = swing.clamp(0.0, 1.0);
    _grid = grid;
    _next = 0;
    _anchorIndex = 0;
    _anchorMicros = _clock.now.inMicroseconds + delay.inMicroseconds;
    _running = true;
    _arm();
  }

  /// Cambia el tempo sin saltos: la próxima semicorchea conserva su hora y
  /// las siguientes usan el intervalo nuevo.
  void setBpm(int bpm) {
    if (bpm == _bpm) {
      return;
    }
    final int keep = _nominal(_next);
    _bpm = bpm;
    _anchorIndex = _next;
    _anchorMicros = keep;
    if (_running) {
      _arm();
    }
  }

  /// Cambia el swing (0 recto, 1 tresillo completo) y su rejilla.
  void setSwing(double swing, SwingGrid grid) {
    _swing = swing.clamp(0.0, 1.0);
    _grid = grid;
    if (_running) {
      _arm();
    }
  }

  /// Pausa recordando cuánto faltaba para la próxima semicorchea.
  void pause() {
    if (!_running) {
      return;
    }
    final int remaining = _due(_next) - _clock.now.inMicroseconds;
    _pausedRemaining = remaining < 0 ? 0 : remaining;
    _running = false;
    _cancel();
  }

  /// Reanuda una pausa sin perder el compás.
  void resume() {
    final int? remaining = _pausedRemaining;
    if (remaining == null) {
      return;
    }
    _pausedRemaining = null;
    // Reancla para que la próxima semicorchea caiga tras lo que faltaba.
    _anchorIndex = _next;
    _anchorMicros =
        _clock.now.inMicroseconds +
        remaining +
        lead.inMicroseconds -
        _swingOffset(_next);
    _running = true;
    _arm();
  }

  /// Para y olvida la posición.
  void stop() {
    _running = false;
    _pausedRemaining = null;
    _cancel();
  }

  /// Instante musical de la semicorchea [index] (con swing).
  Duration scheduledAt(int index) =>
      Duration(microseconds: _nominal(index) + _swingOffset(index));

  /// Duración nominal de una semicorchea en microsegundos.
  int get _stepMicros => 15000000 ~/ _bpm;

  int _nominal(int index) =>
      _anchorMicros + (index - _anchorIndex) * 15000000 ~/ _bpm;

  /// Plazo de aviso de [index]: su instante musical menos el adelanto.
  int _due(int index) =>
      _nominal(index) + _swingOffset(index) - lead.inMicroseconds;

  int _swingOffset(int index) {
    final int position = index % 4;
    return switch (_grid) {
      SwingGrid.eighth =>
        position >= 2 ? (_swing * _stepMicros * 2 / 3).round() : 0,
      SwingGrid.sixteenth =>
        position.isOdd ? (_swing * _stepMicros / 3).round() : 0,
    };
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void _arm() {
    _timer?.cancel();
    final int wait = _due(_next) - _clock.now.inMicroseconds;
    _timer = _timerFactory(Duration(microseconds: wait < 0 ? 0 : wait), _fire);
  }

  void _fire() {
    _timer = null;
    int now = _clock.now.inMicroseconds;
    if (_running && now - _due(_next) > _maxCatchUpMicros) {
      _anchorIndex = _next;
      _anchorMicros = now + lead.inMicroseconds - _swingOffset(_next);
    }
    while (_running && _due(_next) <= now) {
      final int index = _next++;
      onTick(
        Tick(
          index: index,
          scheduledAt: scheduledAt(index),
          lateness: Duration(microseconds: now - _due(index)),
        ),
      );
      now = _clock.now.inMicroseconds;
    }
    if (_running) {
      _arm();
    }
  }
}
