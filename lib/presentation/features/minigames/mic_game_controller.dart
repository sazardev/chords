import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mic_challenge_judge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/minigames/mic_game_state.dart';
import 'package:chords/presentation/features/minigames/mic_listening.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter/foundation.dart';

/// Controlador de los minijuegos en los que se toca la guitarra.
///
/// Responsabilidad única: pedir el reto, escuchar el micrófono mientras corre
/// el tiempo y decidir si se superó, apoyándose en [MicChallengeJudge].
///
/// La partida fluye sola para que la persona no suelte la guitarra: cada reto
/// empieza a escuchar en cuanto aparece (el eco antes reproduce su melodía) y
/// el micrófono se queda abierto al resolverlo, de modo que el reto siguiente,
/// repetir o salir se pueden ordenar tocando cuerdas al aire. El micrófono se
/// cierra al salir de la partida.
class MicGameController extends ChangeNotifier {
  /// Crea el controlador; [guitar] se silencia mientras suena la referencia.
  MicGameController(
    this._audio,
    this._player,
    this._progress, {
    BuildMicChallengesUseCase? buildChallenges,
    this.confirmations = 3,
    this._guitar,
  }) : _build = buildChallenges ?? BuildMicChallengesUseCase(),
       _listening = MicListening(_audio, confirmations: confirmations);

  final AudioRepository _audio;
  final SoundCuePlayer _player;
  final MiniGameProgressController _progress;
  final BuildMicChallengesUseCase _build;
  final GuitarCommandListener? _guitar;
  final MicListening _listening;

  /// Lecturas seguidas que confirman una nota.
  final int confirmations;

  MicGameState _state = const MicGameState(kind: MiniGameKind.playNote);
  Future<void>? _starting;
  int _run = 0;
  int _cuesPlaying = 0;

  /// Estado actual de la partida.
  MicGameState get state => _state;

  /// Prepara la pantalla de bienvenida de un juego.
  ///
  /// No avisa a los oyentes: la pantalla que lo llama aún se está creando.
  /// Si se maneja la app con la guitarra abre ya el micrófono, para que la
  /// bienvenida también responda a las cuerdas.
  void open(MiniGameKind kind) {
    _run++;
    _listening.stop();
    _player.cancel();
    _state = MicGameState(kind: kind);
    if (_guitar?.enabled ?? false) {
      unawaited(_audio.requestAccess());
    }
  }

  /// Empieza una partida en la dificultad indicada.
  void start(MiniGameLevel level) {
    final MiniGameKind kind = _state.kind;
    _state = MicGameState(
      kind: kind,
      level: level,
      phase: MiniGamePhase.asking,
      challenges: _build(kind, level),
    );
    _progress.started(kind, level);
    notifyListeners();
    unawaited(_begin());
  }

  /// Reproduce la nota o la melodía de referencia del reto.
  ///
  /// El micrófono sigue abierto pero no se juzga lo que suena por el altavoz.
  Future<void> hear() async {
    final MicChallenge? challenge = _state.challenge;
    if (challenge == null) {
      return;
    }
    _cuesPlaying++;
    _guitar?.muteFor(_player.lengthOf(challenge.cues));
    await _player.play(challenge.cues);
    _cuesPlaying--;
    if (_cuesPlaying == 0) {
      _listening.judge?.settle();
    }
  }

  /// Empieza a escuchar la guitarra (llamadas seguidas comparten la espera).
  Future<void> listen() => _starting ??= _listen().whenComplete(() {
    _starting = null;
  });

  /// Da el reto por fallado y pasa al resultado (la persona se rinde).
  Future<void> skip() => _resolve(isCorrect: false);

  /// Repite el reto fallado: vuelve a escuchar sin volver a puntuar.
  Future<void> retry() async {
    if (_state.phase != MiniGamePhase.feedback || _state.wasCorrect) {
      return;
    }
    _run++;
    _state = _state.copyWith(
      phase: MiniGamePhase.asking,
      progress: 0,
      retried: true,
      clearHeard: true,
    );
    notifyListeners();
    await _begin();
  }

  /// Pasa al reto siguiente o termina la partida.
  Future<void> next() async {
    if (_state.phase != MiniGamePhase.feedback) {
      return;
    }
    _run++;
    if (_state.index + 1 >= _state.total) {
      final bool record = await _progress.finished(
        _state.kind,
        _state.level,
        _state.score,
      );
      _state = _state.copyWith(
        phase: MiniGamePhase.finished,
        isNewBest: record,
      );
      notifyListeners();
      return;
    }
    _state = _state.copyWith(
      phase: MiniGamePhase.asking,
      index: _state.index + 1,
      progress: 0,
      retried: false,
      clearHeard: true,
    );
    notifyListeners();
    await _begin();
  }

  /// Sale de la partida: corta el sonido y el micrófono sin avisar.
  void leave() {
    _run++;
    _player.cancel();
    unawaited(_stopMic());
  }

  /// Arranca el reto actual: el eco suena primero y luego se escucha.
  Future<void> _begin() async {
    final MicChallenge? challenge = _state.challenge;
    if (challenge == null) {
      return;
    }
    final int run = _run;
    if (challenge.isSequence) {
      _state = _state.copyWith(playingCue: true);
      notifyListeners();
      await hear();
      if (run != _run) {
        return;
      }
      _state = _state.copyWith(playingCue: false);
    }
    await listen();
  }

  Future<void> _listen() async {
    final MicChallenge? challenge = _state.challenge;
    if (challenge == null || _state.phase != MiniGamePhase.asking) {
      return;
    }
    _player.cancel();
    final MicStatus status = await _listening.start(
      challenge,
      onReading: _onReading,
      onLevel: _onLevel,
      onTick: _onTick,
    );
    if (status != MicStatus.listening) {
      _state = _state.copyWith(micStatus: status, phase: MiniGamePhase.asking);
      notifyListeners();
      await _audio.stopListening();
      return;
    }
    _state = _state.copyWith(
      phase: MiniGamePhase.listening,
      micStatus: status,
      progress: 0,
      msLeft: challenge.timeLimitMs,
    );
    notifyListeners();
  }

  void _onReading(PitchReading reading) {
    final MicChallengeJudge? judge = _listening.judge;
    if (judge == null ||
        _state.phase != MiniGamePhase.listening ||
        _cuesPlaying > 0 ||
        (_guitar?.claims(reading) ?? false)) {
      return;
    }
    judge.feed(reading);
    _state = _state.copyWith(progress: judge.progress, heard: judge.lastHeard);
    if (judge.isComplete) {
      unawaited(_resolve(isCorrect: true));
      return;
    }
    notifyListeners();
  }

  void _onLevel(double level) {
    if (_state.phase == MiniGamePhase.listening) {
      _state = _state.copyWith(level01: level);
      notifyListeners();
    }
  }

  void _onTick() {
    if (_state.phase != MiniGamePhase.listening) {
      return;
    }
    final int left = _state.msLeft - MicListening.tick.inMilliseconds;
    if (left <= 0) {
      unawaited(_resolve(isCorrect: false));
      return;
    }
    _state = _state.copyWith(msLeft: left);
    notifyListeners();
  }

  /// Cierra el reto. El micrófono sigue abierto para oír la orden siguiente.
  Future<void> _resolve({required bool isCorrect}) async {
    if (_state.phase == MiniGamePhase.feedback) {
      return;
    }
    _listening.stop();
    _state = _state.copyWith(
      phase: MiniGamePhase.feedback,
      wasCorrect: isCorrect,
      score: _state.retried
          ? _state.score
          : _state.score.record(isCorrect: isCorrect),
      level01: 0,
    );
    notifyListeners();
  }

  Future<void> _stopMic() async {
    _listening.stop();
    await _audio.stopListening();
  }

  @override
  void dispose() {
    _listening.stop();
    super.dispose();
  }
}
