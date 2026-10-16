import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/question_clock.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter/foundation.dart';

/// Controlador de los minijuegos de preguntas de opciones.
///
/// Responsabilidad única: llevar la partida —preguntas, respuestas, marcador
/// y repeticiones del sonido—. Cómo suena cada pregunta lo resuelve
/// [SoundCuePlayer], cómo se guarda el récord, [MiniGameProgressController] y
/// el reloj de los juegos con tiempo, [QuestionClock].
class QuizController extends ChangeNotifier {
  /// Crea el controlador con sus colaboradores.
  QuizController(
    this._chords,
    this._player,
    this._progress, {
    BuildQuizUseCase? buildQuiz,
    QuestionClock? clock,
  }) : _buildQuiz = buildQuiz ?? BuildQuizUseCase(_chords),
       _clock = clock ?? PeriodicQuestionClock();

  final ChordRepository _chords;
  final SoundCuePlayer _player;
  final MiniGameProgressController _progress;
  final BuildQuizUseCase _buildQuiz;
  final QuestionClock _clock;

  QuizState _state = const QuizState(kind: MiniGameKind.guessNote);

  /// Estado actual de la partida.
  QuizState get state => _state;

  /// Prepara la pantalla de bienvenida de un juego.
  ///
  /// No avisa a los oyentes: la pantalla que lo llama aún se está creando.
  void open(MiniGameKind kind) {
    _player.cancel();
    _clock.stop();
    _state = QuizState(kind: kind);
  }

  /// Empieza una partida en la dificultad indicada.
  Future<void> start(MiniGameLevel level) async {
    if (!_chords.isLoaded) {
      await _chords.load();
    }
    final MiniGameKind kind = _state.kind;
    _state = QuizState(
      kind: kind,
      level: level,
      phase: MiniGamePhase.asking,
      questions: _buildQuiz(kind, level),
      replaysLeft: level.replays,
      msLeft: kind.timed ? kind.timeLimitMs(level) : 0,
    );
    _progress.started(kind, level);
    notifyListeners();
    _armClock();
    unawaited(_playCurrent());
  }

  /// Vuelve a escuchar la pregunta actual si quedan repeticiones.
  ///
  /// Tras responder se puede escuchar de nuevo sin gastar repeticiones.
  Future<void> replay() async {
    if (_state.isPlaying) {
      return;
    }
    if (_state.phase == MiniGamePhase.asking && _state.replaysLeft > 0) {
      _state = _state.copyWith(replaysLeft: _state.replaysLeft - 1);
    } else if (_state.phase != MiniGamePhase.feedback) {
      return;
    }
    await _playCurrent();
  }

  /// Registra la opción elegida.
  void answer(int choice) {
    final QuizQuestion? question = _state.question;
    if (question == null || _state.phase != MiniGamePhase.asking) {
      return;
    }
    if (question.isSequence && _state.isPlaying) {
      return;
    }
    final List<int> input = <int>[..._state.input, choice];
    final int step = input.length - 1;
    final bool wrong = question.answer[step] != choice;
    if (!wrong && input.length < question.answer.length) {
      _state = _state.copyWith(input: input);
      notifyListeners();
      return;
    }
    _resolve(input, isCorrect: !wrong);
  }

  /// Pasa a la pregunta siguiente o termina la partida.
  Future<void> next() async {
    if (_state.phase != MiniGamePhase.feedback) {
      return;
    }
    if (_state.index + 1 >= _state.total) {
      await _finish();
      return;
    }
    _state = _state.copyWith(
      phase: MiniGamePhase.asking,
      index: _state.index + 1,
      input: const <int>[],
      replaysLeft: _state.level.replays,
      msLeft: _state.kind.timed ? _state.kind.timeLimitMs(_state.level) : 0,
      timedOut: false,
    );
    notifyListeners();
    _armClock();
    unawaited(_playCurrent());
  }

  /// Sale de la partida: corta el sonido sin avisar a la interfaz.
  void leave() {
    _player.cancel();
    _clock.stop();
  }

  /// Nombre estándar de un acorde del banco; el propio id si no existe.
  String chordName(String chordId) =>
      _chords.chordById(chordId)?.name ?? chordId;

  /// Acorde del banco por identificador.
  Chord? chordOf(String chordId) => _chords.chordById(chordId);

  void _resolve(List<int> input, {required bool isCorrect}) {
    _player.cancel();
    _clock.stop();
    _state = _state.copyWith(
      phase: MiniGamePhase.feedback,
      input: input,
      isPlaying: false,
      wasCorrect: isCorrect,
      score: _state.score.record(isCorrect: isCorrect, bonus: _speedBonus()),
    );
    notifyListeners();
  }

  /// Puntos extra por responder rápido en un juego con tiempo (0 a 5).
  int _speedBonus() {
    final MiniGameKind kind = _state.kind;
    if (!kind.timed) {
      return 0;
    }
    return (_state.msLeft * 5 / kind.timeLimitMs(_state.level)).floor();
  }

  /// Pone en marcha el reloj de la pregunta si el juego es con tiempo.
  void _armClock() {
    if (_state.kind.timed) {
      _clock.start(_onTick);
    }
  }

  void _onTick() {
    if (_state.phase != MiniGamePhase.asking) {
      return;
    }
    final int left = _state.msLeft - QuestionClock.tickMs;
    if (left > 0) {
      _state = _state.copyWith(msLeft: left);
      notifyListeners();
      return;
    }
    _state = _state.copyWith(msLeft: 0, timedOut: true);
    _resolve(const <int>[], isCorrect: false);
  }

  Future<void> _finish() async {
    final bool record = await _progress.finished(
      _state.kind,
      _state.level,
      _state.score,
    );
    _state = _state.copyWith(phase: MiniGamePhase.finished, isNewBest: record);
    notifyListeners();
  }

  Future<void> _playCurrent() async {
    final QuizQuestion? question = _state.question;
    if (question == null || !question.hasSound) {
      return;
    }
    final int shown = _state.index;
    _state = _state.copyWith(isPlaying: true);
    notifyListeners();
    await _player.play(question.cues);
    if (_state.index == shown && _state.phase == MiniGamePhase.asking) {
      _state = _state.copyWith(isPlaying: false);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player.cancel();
    _clock.stop();
    super.dispose();
  }
}
