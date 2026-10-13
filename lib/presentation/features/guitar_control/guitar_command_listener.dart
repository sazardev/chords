import 'dart:async';

import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/guitar_command_detector.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
import 'package:flutter/foundation.dart';

/// Escucha la guitarra para manejar la app sin tocar la pantalla.
///
/// Es un oyente pasivo: no abre ni cierra el micrófono, solo lee lo que ya
/// llega mientras haya una pantalla con acciones registradas (la barra
/// `GuitarCommandBar`). Quien necesita el micrófono —el juego, la práctica—
/// sigue siendo su dueño. Mientras se oye la propia app (la referencia que
/// suena por el altavoz) se silencia con [muteFor] para que no se tome por una
/// orden.
class GuitarCommandListener extends ChangeNotifier {
  /// Crea el oyente sobre [_audio].
  ///
  /// [clock] y [detector] permiten controlar el tiempo en las pruebas;
  /// [onFired] da un aviso táctil al reconocer una orden.
  GuitarCommandListener(
    this._audio, {
    DateTime Function()? clock,
    GuitarCommandDetector? detector,
    this.onFired,
  }) : _clock = clock ?? DateTime.now,
       _detector = detector ?? GuitarCommandDetector();

  final AudioRepository _audio;
  final DateTime Function() _clock;
  final GuitarCommandDetector _detector;

  /// Aviso (p. ej. vibración) al reconocer una orden tocada en la guitarra.
  final VoidCallback? onFired;

  static const Duration _pollEvery = Duration(milliseconds: 120);
  static const Duration _hearingWindow = Duration(milliseconds: 1500);

  Object? _owner;
  List<GuitarAction> _actions = const <GuitarAction>[];
  bool _enabled = true;
  bool _hearing = false;
  bool _wasArmed = false;
  double _level = 0;
  GuitarCommand? _lastFired;
  DateTime? _lastLevelAt;
  DateTime? _mutedUntil;
  StreamSubscription<PitchReading>? _readings;
  StreamSubscription<double>? _levels;
  Timer? _timer;
  bool _disposed = false;

  /// Acciones de la pantalla activa (vacío si no hay ninguna).
  List<GuitarAction> get actions => _actions;

  /// Si la persona permite manejar la app con la guitarra.
  bool get enabled => _enabled;

  /// Estado de la escucha para pintar la barra.
  GuitarListenState get state => GuitarListenState(
    armed: _enabled && _detector.isArmed,
    hearing: _hearing,
    level: _level,
    lastFired: _lastFired,
  );

  /// Permite o impide manejar la app con la guitarra; los botones siguen.
  set enabled(bool value) {
    if (value == _enabled) {
      return;
    }
    _enabled = value;
    _sync();
    notifyListeners();
  }

  /// Registra las acciones de la pantalla [owner] (la más reciente manda).
  ///
  /// Si cambian las acciones visibles se vuelve a esperar el silencio previo.
  void attach(Object owner, List<GuitarAction> actions) {
    final bool changed =
        _owner != owner || _signature(actions) != _signature(_actions);
    _owner = owner;
    _actions = List<GuitarAction>.unmodifiable(actions);
    if (changed) {
      _lastFired = null;
      _detector.arm(_clock());
    }
    _sync();
    if (changed) {
      _notifyLater();
    }
  }

  /// Quita las acciones de [owner], si siguen siendo las vigentes.
  void detach(Object owner) {
    if (_owner != owner) {
      return;
    }
    _owner = null;
    _actions = const <GuitarAction>[];
    _detector.disarm();
    _sync();
    _notifyLater();
  }

  /// Ignora el micrófono durante [duration] (suena la propia app).
  void muteFor(Duration duration) {
    final DateTime until = _clock().add(duration);
    _mutedUntil = until;
    _detector.arm(until);
  }

  /// Ejecuta la acción de [command], si la pantalla la ofrece.
  void trigger(GuitarCommand command) {
    for (final GuitarAction action in _actions) {
      if (action.command == command) {
        _lastFired = command;
        _detector.arm(_clock());
        notifyListeners();
        action.onTrigger();
        return;
      }
    }
  }

  /// Avisa fuera del fotograma en curso: se registra al montar y desmontar
  /// widgets, momento en el que no se puede reconstruir otros.
  void _notifyLater() {
    scheduleMicrotask(() {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  String _signature(List<GuitarAction> actions) =>
      actions.map((GuitarAction a) => a.signature).join('|');

  bool get _shouldListen => _enabled && _actions.isNotEmpty;

  void _sync() {
    if (_shouldListen) {
      _readings ??= _audio.readings.listen(_onReading);
      _levels ??= _audio.levels.listen(_onLevel);
      _timer ??= Timer.periodic(_pollEvery, (_) => _onTick());
      return;
    }
    unawaited(_readings?.cancel());
    unawaited(_levels?.cancel());
    _timer?.cancel();
    _readings = null;
    _levels = null;
    _timer = null;
    _hearing = false;
    _wasArmed = false;
    _level = 0;
  }

  void _onLevel(double level) {
    _level = level;
    _lastLevelAt = _clock();
    if (!_hearing) {
      _hearing = true;
    }
    notifyListeners();
  }

  void _onReading(PitchReading reading) {
    final DateTime now = _clock();
    final DateTime? muted = _mutedUntil;
    if (muted != null && now.isBefore(muted)) {
      return;
    }
    final GuitarCommand? command = _detector.feed(reading, now, <GuitarCommand>{
      for (final GuitarAction a in _actions) a.command,
    });
    if (command != null) {
      onFired?.call();
      trigger(command);
    }
  }

  void _onTick() {
    final DateTime now = _clock();
    _detector.poll(now);
    final DateTime? lastLevel = _lastLevelAt;
    final bool hearing =
        lastLevel != null && now.difference(lastLevel) < _hearingWindow;
    final bool armed = _detector.isArmed;
    if (hearing != _hearing || armed != _wasArmed) {
      _hearing = hearing;
      _wasArmed = armed;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_readings?.cancel());
    unawaited(_levels?.cancel());
    _timer?.cancel();
    super.dispose();
  }
}
