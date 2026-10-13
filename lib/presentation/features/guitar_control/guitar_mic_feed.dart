import 'dart:async';

import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:flutter/foundation.dart';

/// Entrada pasiva del micrófono para el control con la guitarra.
///
/// Se suscribe a las lecturas y niveles que ya llegan (no abre el micrófono),
/// lleva la cuenta de si llega sonido y descarta lo que suena por el altavoz
/// de la propia app ([mutedUntil]). Un temporizador avisa cada [pollEvery] para
/// que el oyente avance sus relojes.
class GuitarMicFeed {
  /// Crea la entrada sobre [_audio]; [clock] permite controlar el tiempo.
  GuitarMicFeed(this._audio, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AudioRepository _audio;
  final DateTime Function() _clock;

  /// Cada cuánto avisa el temporizador.
  static const Duration pollEvery = Duration(milliseconds: 120);
  static const Duration _hearingWindow = Duration(milliseconds: 1500);

  StreamSubscription<PitchReading>? _readings;
  StreamSubscription<double>? _levels;
  Timer? _timer;
  DateTime? _lastLevelAt;
  bool _hearing = false;
  double _level = 0;

  /// Si está suscrita al micrófono.
  bool get listening => _readings != null;

  /// Si llega sonido del micrófono.
  bool get hearing => _hearing;

  /// Nivel de entrada (0-1).
  double get level => _level;

  /// Hasta cuándo se descarta el audio (suena la propia app); `null` si no.
  DateTime? mutedUntil;

  /// Si ahora mismo se descarta el audio.
  bool get muted {
    final DateTime? until = mutedUntil;
    return until != null && _clock().isBefore(until);
  }

  /// Empieza a escuchar si aún no lo hacía.
  ///
  /// [onReading] recibe cada lectura, [onChange] avisa de que cambió el
  /// nivel y [onTick] cada [pollEvery].
  void start({
    required ValueChanged<PitchReading> onReading,
    required VoidCallback onChange,
    required VoidCallback onTick,
  }) {
    _readings ??= _audio.readings.listen(onReading);
    _levels ??= _audio.levels.listen((double level) {
      _level = level;
      _lastLevelAt = _clock();
      _hearing = true;
      onChange();
    });
    _timer ??= Timer.periodic(pollEvery, (_) => onTick());
  }

  /// Deja de escuchar y olvida el estado.
  void stop() {
    unawaited(_readings?.cancel());
    unawaited(_levels?.cancel());
    _timer?.cancel();
    _readings = null;
    _levels = null;
    _timer = null;
    _hearing = false;
    _level = 0;
  }

  /// Recalcula si llega sonido; `true` si cambió.
  bool refreshHearing() {
    final DateTime? last = _lastLevelAt;
    final bool hearing =
        last != null && _clock().difference(last) < _hearingWindow;
    final bool changed = hearing != _hearing;
    _hearing = hearing;
    return changed;
  }
}
