import 'dart:async';

import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/guitar_command_detector.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_listen_state.dart';
import 'package:chords/presentation/features/guitar_control/guitar_mic_feed.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_sink.dart';
import 'package:flutter/foundation.dart';

/// Escucha la guitarra para manejar la app sin tocar la pantalla.
///
/// Es un oyente pasivo: no abre ni cierra el micrófono, solo lee lo que ya
/// llega mientras haya una pantalla con acciones registradas (la barra
/// `GuitarCommandBar`). Quien necesita el micrófono —el juego, la práctica—
/// sigue siendo su dueño. Mientras se oye la propia app (la referencia que
/// suena por el altavoz) se silencia con [muteFor] para que no se tome por una
/// orden.
///
/// Las notas que no son una orden de la pantalla pasan al menú global
/// (`GuitarNavSink`): la nota aguda lo abre o lo cierra y, con el menú
/// abierto, las órdenes de la pantalla se pausan y cada nota elige una opción.
/// Con el modo global encendido escucha aunque la pantalla no tenga acciones.
class GuitarCommandListener extends ChangeNotifier {
  /// Crea el oyente sobre [audio].
  ///
  /// [clock] y [detector] permiten controlar el tiempo en las pruebas; [nav]
  /// es el menú global que recibe las notas que no son órdenes y [onFired]
  /// da un aviso táctil al reconocer una orden.
  GuitarCommandListener(
    AudioRepository audio, {
    DateTime Function()? clock,
    GuitarCommandDetector? detector,
    GuitarNavSink? nav,
    this.onFired,
  }) : _nav = nav,
       _clock = clock ?? DateTime.now,
       _feed = GuitarMicFeed(audio, clock: clock),
       _detector = detector ?? GuitarCommandDetector() {
    nav?.addListener(_onNavChanged);
  }

  final DateTime Function() _clock;
  final GuitarMicFeed _feed;
  final GuitarCommandDetector _detector;

  /// Aviso (p. ej. vibración) al reconocer una orden tocada en la guitarra.
  final VoidCallback? onFired;

  Object? _owner;
  List<GuitarAction> _actions = const <GuitarAction>[];
  String? _headline;
  final GuitarNavSink? _nav;
  bool _enabled = true;
  bool _wasArmed = false;
  GuitarCommand? _lastFired;
  bool _disposed = false;

  /// Si [reading] es del modo guitarra y la pantalla debe ignorarla: el menú
  /// está abierto o es la nota aguda que lo abre.
  bool claims(PitchReading reading) {
    final GuitarNavSink? nav = _nav;
    return nav != null &&
        nav.active &&
        (nav.menuOpen ||
            reading.frequency >= GuitarCommandDetector.wakeFrequency);
  }

  /// Si la persona permite manejar la app con la guitarra.
  bool get enabled => _enabled;

  /// Estado de la escucha para pintar la barra.
  GuitarListenState get state => GuitarListenState(
    armed: _enabled && _detector.isArmed,
    hearing: _feed.hearing,
    level: _feed.level,
    lastFired: _lastFired,
    listening: _feed.listening,
    headline: _headline,
    actions: _actions,
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
  void attach(Object owner, List<GuitarAction> actions, {String? headline}) {
    final bool changed =
        _owner != owner || _signature(actions) != _signature(_actions);
    final bool retitled = _headline != headline;
    _headline = headline;
    _owner = owner;
    _actions = List<GuitarAction>.unmodifiable(actions);
    if (changed) {
      _lastFired = null;
      _detector.arm(_clock());
    }
    _sync();
    if (changed || retitled) {
      _notifyLater();
    }
  }

  /// Quita las acciones de [owner], si siguen siendo las vigentes.
  void detach(Object owner) {
    if (_owner != owner) {
      return;
    }
    _owner = null;
    _headline = null;
    _actions = const <GuitarAction>[];
    if (_nav?.active ?? false) {
      _detector.arm(_clock());
    } else {
      _detector.disarm();
    }
    _sync();
    _notifyLater();
  }

  /// Ignora el micrófono durante [duration] (suena la propia app).
  void muteFor(Duration duration) {
    final DateTime until = _clock().add(duration);
    _feed.mutedUntil = until;
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

  bool get _shouldListen =>
      _enabled && (_actions.isNotEmpty || (_nav?.active ?? false));

  void _onNavChanged() {
    _sync();
    if (_nav?.active ?? false) {
      _detector.arm(_clock());
    }
  }

  void _sync() {
    if (_shouldListen) {
      _feed.start(
        onReading: _onReading,
        onChange: notifyListeners,
        onTick: _onTick,
      );
    } else {
      _feed.stop();
      _wasArmed = false;
    }
  }

  void _onReading(PitchReading reading) {
    if (_feed.muted) {
      return;
    }
    final GuitarNote? note = _detector.feedNote(reading, _clock());
    if (note != null) {
      _route(note);
    }
  }

  /// Reparte una nota firme: la aguda abre o cierra el menú, con el menú
  /// abierto elige una opción y, si no, es una orden de la pantalla.
  void _route(GuitarNote note) {
    final GuitarNavSink? nav = _nav;
    if (nav != null && nav.active && note.high) {
      onFired?.call();
      _detector.arm(_clock());
      nav.onWake();
    } else if (nav != null && nav.menuOpen) {
      onFired?.call();
      nav.onMenuNote(note.pitchClass);
      _detector.arm(_clock());
    } else if (!note.high) {
      _fireCommand(note.pitchClass);
    }
  }

  void _fireCommand(int pitchClass) {
    final GuitarCommand? command = GuitarCommand.ofPitchClass(pitchClass);
    if (command != null &&
        _actions.any((GuitarAction a) => a.command == command)) {
      onFired?.call();
      trigger(command);
    }
  }

  void _onTick() {
    final DateTime now = _clock();
    _detector.poll(now);
    _nav?.tick(now);
    final bool armed = _detector.isArmed;
    if (_feed.refreshHearing() || armed != _wasArmed) {
      _wasArmed = armed;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _nav?.removeListener(_onNavChanged);
    _feed.stop();
    super.dispose();
  }
}
