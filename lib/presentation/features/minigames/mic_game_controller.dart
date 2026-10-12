import 'dart:async';

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mic_challenge_judge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/minigames/mic_game_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter/foundation.dart';

/// Controlador de los minijuegos en los que se toca la guitarra.
///
/// Responsabilidad única: pedir el reto, escuchar el micrófono mientras corre
/// el tiempo y decidir si se superó, apoyándose en [MicChallengeJudge].
class MicGameController extends ChangeNotifier {
  /// Crea el controlador con sus colaboradores.
  MicGameController(
    this._audio,
    this._player,
    this._progress, {
    BuildMicChallengesUseCase? buildChallenges,
    this.confirmations = 3,
  }) : _build = buildChallenges ?? BuildMicChallengesUseCase();

  final AudioRepository _audio;
  final SoundCuePlayer _player;
  final MiniGameProgressController _progress;
  final BuildMicChallengesUseCase _build;

  /// Lecturas seguidas que confirman una nota.
  final int confirmations;

  static const Duration _tick = Duration(milliseconds: 250);

  MicGameState _state = const MicGameState(kind: MiniGameKind.playNote);
  MicChallengeJudge? _judge;
  StreamSubscription<PitchReading>? _readings;
  StreamSubscription<double>? _levels;
  Timer? _timer;

  /// Estado actual de la partida.
  MicGameState get state => _state;

  /// Prepara la pantalla de bienvenida de un juego.
  ///
  /// No avisa a los oyentes: la pantalla que lo llama aún se está creando.
  void open(MiniGameKind kind) {
    unawaited(_stopListening());
    _player.cancel();
    _state = MicGameState(kind: kind);
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
  }

  /// Reproduce la nota o la melodía de referencia del reto.
  Future<void> hear() async {
    final MicChallenge? challenge = _state.challenge;
    if (challenge != null) {
      await _player.play(challenge.cues);
    }
  }

  /// Empieza a escuchar la guitarra; reintenta si el micrófono falló.
  Future<void> listen() async {
    final MicChallenge? challenge = _state.challenge;
    if (challenge == null || _state.phase == MiniGamePhase.listening) {
      return;
    }
    _player.cancel();
    _judge = MicChallengeJudge(
      challenge.pitchClasses,
      confirmations: confirmations,
    );
    await _readings?.cancel();
    _readings = _audio.readings.listen(_onReading);
    await _levels?.cancel();
    _levels = _audio.levels.listen(_onLevel);
    final MicStatus status = await _audio.requestAccess();
    if (status != MicStatus.listening) {
      _state = _state.copyWith(micStatus: status, phase: MiniGamePhase.asking);
      notifyListeners();
      await _stopListening();
      return;
    }
    _state = _state.copyWith(
      phase: MiniGamePhase.listening,
      micStatus: status,
      progress: 0,
      msLeft: challenge.timeLimitMs,
    );
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (_) => _onTick());
    notifyListeners();
  }

  /// Da el reto por fallado y pasa al resultado (la persona se rinde).
  Future<void> skip() => _resolve(isCorrect: false);

  /// Pasa al reto siguiente o termina la partida.
  Future<void> next() async {
    if (_state.phase != MiniGamePhase.feedback) {
      return;
    }
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
    } else {
      _state = _state.copyWith(
        phase: MiniGamePhase.asking,
        index: _state.index + 1,
        progress: 0,
      );
    }
    notifyListeners();
  }

  /// Sale de la partida: corta el sonido y el micrófono sin avisar.
  void leave() {
    _player.cancel();
    unawaited(_stopListening());
  }

  void _onReading(PitchReading reading) {
    final MicChallengeJudge? judge = _judge;
    if (judge == null || _state.phase != MiniGamePhase.listening) {
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
    final int left = _state.msLeft - _tick.inMilliseconds;
    if (left <= 0) {
      unawaited(_resolve(isCorrect: false));
      return;
    }
    _state = _state.copyWith(msLeft: left);
    notifyListeners();
  }

  Future<void> _resolve({required bool isCorrect}) async {
    if (_state.phase == MiniGamePhase.feedback) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    _state = _state.copyWith(
      phase: MiniGamePhase.feedback,
      wasCorrect: isCorrect,
      score: _state.score.record(isCorrect: isCorrect),
      level01: 0,
    );
    notifyListeners();
    await _stopListening();
  }

  Future<void> _stopListening() async {
    final bool wasListening = _judge != null;
    _timer?.cancel();
    _timer = null;
    _judge = null;
    await _readings?.cancel();
    _readings = null;
    await _levels?.cancel();
    _levels = null;
    if (wasListening) {
      await _audio.stopListening();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_readings?.cancel());
    unawaited(_levels?.cancel());
    super.dispose();
  }
}
