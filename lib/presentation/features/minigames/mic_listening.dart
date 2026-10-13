import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mic_challenge_judge.dart';
import 'package:flutter/foundation.dart';

/// Escucha de un reto de micrófono: abre el micrófono, juzga lo que se toca y
/// marca el tiempo.
///
/// Responsabilidad única: la mecánica de escuchar. Qué pasa al acertar o al
/// agotarse el tiempo lo decide quien la usa mediante las llamadas.
class MicListening {
  /// Crea la escucha sobre [_audio]; [confirmations] son las lecturas
  /// seguidas que confirman una nota.
  MicListening(this._audio, {this.confirmations = 3});

  final AudioRepository _audio;

  /// Lecturas seguidas que confirman una nota.
  final int confirmations;

  /// Cada cuánto avisa el reloj del reto.
  static const Duration tick = Duration(milliseconds: 250);

  MicChallengeJudge? _judge;
  StreamSubscription<PitchReading>? _readings;
  StreamSubscription<double>? _levels;
  Timer? _timer;

  /// Juez del reto en curso; `null` si no se está escuchando.
  MicChallengeJudge? get judge => _judge;

  /// Abre el micrófono y empieza a juzgar [challenge].
  ///
  /// Devuelve el estado del micrófono; si no está escuchando, no deja nada
  /// en marcha.
  Future<MicStatus> start(
    MicChallenge challenge, {
    required ValueChanged<PitchReading> onReading,
    required ValueChanged<double> onLevel,
    required VoidCallback onTick,
  }) async {
    _judge = MicChallengeJudge(
      challenge.pitchClasses,
      confirmations: confirmations,
    );
    await _readings?.cancel();
    _readings = _audio.readings.listen(onReading);
    await _levels?.cancel();
    _levels = _audio.levels.listen(onLevel);
    final MicStatus status = await _audio.requestAccess();
    if (status != MicStatus.listening) {
      stop();
      return status;
    }
    _timer?.cancel();
    _timer = Timer.periodic(tick, (Timer _) => onTick());
    return status;
  }

  /// Deja de juzgar lo que suena; el micrófono no se toca.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _judge = null;
    unawaited(_readings?.cancel());
    _readings = null;
    unawaited(_levels?.cancel());
    _levels = null;
  }
}
