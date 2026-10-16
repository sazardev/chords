import 'dart:async';
import 'dart:math' as math;

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/chord_changes_rules.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/domain/minigames/services/chord_change_judge.dart';
import 'package:chords/domain/minigames/services/chord_hearing.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';
import 'package:chords/domain/minigames/usecases/next_chord_change_use_case.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/minigames/audio_chord_hearing.dart';
import 'package:chords/presentation/features/minigames/chord_changes_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/question_clock.dart';
import 'package:flutter/foundation.dart';

/// Controlador de "cambios de acorde": cuántos cambios limpios en 60 s.
///
/// Pide acordes uno tras otro; cada vez que el micrófono oye el acorde pedido
/// (ver [ChordChangeJudge]) suma un cambio limpio y pide otro distinto. Si un
/// acorde agota su tiempo se da por fallado y se pasa al siguiente. Cómo se
/// oye lo decide [ChordHearing], intercambiable; el tiempo lo lleva un
/// [QuestionClock] y el récord, [MiniGameProgressController].
class ChordChangesController extends ChangeNotifier {
  /// Crea el controlador con sus colaboradores.
  ChordChangesController(
    this._audio,
    this._chords,
    this._progress, {
    ChordHearing? hearing,
    QuestionClock? clock,
    NextChordChangeUseCase? next,
    this._guitar,
  }) : _hearing = hearing ?? AudioChordHearing(_audio, ignore: _guitar?.claims),
       _clock = clock ?? PeriodicQuestionClock(),
       _next = next ?? NextChordChangeUseCase(_chords);

  final AudioRepository _audio;
  final ChordRepository _chords;
  final MiniGameProgressController _progress;
  final ChordHearing _hearing;
  final QuestionClock _clock;
  final NextChordChangeUseCase _next;
  final GuitarCommandListener? _guitar;

  /// Cuenta atrás antes del primer acorde.
  static const int _readyMs = 3000;

  /// Ticks que se ignora el micrófono tras mostrar un acorde (el anterior aún
  /// se apaga) y tras oír la referencia por el altavoz.
  static const int _settleTicks = 2;
  static const int _referenceTicks = 12;

  ChordChangesState _state = const ChordChangesState();
  ChordChangeJudge? _judge;
  StreamSubscription<Set<int>>? _detections;
  StreamSubscription<double>? _levels;
  ChordChangesRules _rules = ChordChangesRules.of(MiniGameLevel.easy);
  int _deafTicks = 0;
  int _run = 0;

  /// Estado actual de la partida.
  ChordChangesState get state => _state;

  /// Prepara la pantalla de bienvenida.
  ///
  /// No avisa a los oyentes: la pantalla que lo llama aún se está creando. Si
  /// se maneja la app con la guitarra abre ya el micrófono para que la
  /// bienvenida responda a las cuerdas.
  void open() {
    _run++;
    _stopListening();
    _state = const ChordChangesState();
    if (_guitar?.enabled ?? false) {
      unawaited(_audio.requestAccess());
    }
  }

  /// Empieza una partida en la dificultad indicada.
  ///
  /// Abre el micrófono y, tras la cuenta atrás, pide el primer acorde. Si el
  /// micrófono falla deja el estado para que la pantalla ofrezca reintentar
  /// llamando de nuevo a este método.
  Future<void> start(MiniGameLevel level) async {
    final int run = ++_run;
    _stopListening();
    if (!_chords.isLoaded) {
      await _chords.load();
    }
    _rules = ChordChangesRules.of(level);
    _state = ChordChangesState(
      level: level,
      phase: MiniGamePhase.asking,
      goal: _rules.goal,
      totalMs: _rules.totalMs,
      msLeft: _rules.totalMs,
      chordMs: _rules.perChordMs,
      chordMsLeft: _rules.perChordMs,
      readyMs: _readyMs,
    );
    _progress.started(MiniGameKind.chordChanges, level);
    notifyListeners();
    final MicStatus status = await _hearing.open();
    if (run != _run) {
      return;
    }
    _state = _state.copyWith(micStatus: status);
    notifyListeners();
    if (status != MicStatus.listening) {
      await _hearing.close();
      return;
    }
    _detections = _hearing.detections.listen(_onDetection);
    _levels = _hearing.levels.listen(_onLevel);
    _clock.start(_onTick);
  }

  /// Da el acorde actual por fallado y pasa al siguiente.
  void skip() {
    if (_state.phase == MiniGamePhase.listening) {
      _resolve(clean: false);
    }
  }

  /// Reproduce el acorde pedido; el micrófono lo ignora mientras suena.
  Future<void> hear() async {
    final Chord? chord = _state.target;
    if (chord == null) {
      return;
    }
    _deafTicks = _referenceTicks;
    _guitar?.muteFor(const Duration(milliseconds: 2800));
    await _audio.playChord(chord, chord.easiestVariant);
  }

  /// Sale de la partida: corta el reloj y el micrófono sin avisar.
  void leave() {
    _run++;
    _stopListening();
    unawaited(_hearing.close());
  }

  void _stopListening() {
    _clock.stop();
    unawaited(_detections?.cancel());
    unawaited(_levels?.cancel());
    _detections = null;
    _levels = null;
    _judge = null;
  }

  void _onTick() {
    if (_state.phase == MiniGamePhase.asking) {
      _countDown();
      return;
    }
    if (_state.phase != MiniGamePhase.listening) {
      return;
    }
    _deafTicks = math.max(0, _deafTicks - 1);
    final int total = _state.msLeft - QuestionClock.tickMs;
    final int chord = _state.chordMsLeft - QuestionClock.tickMs;
    if (total <= 0) {
      unawaited(_finish());
    } else if (chord <= 0) {
      _state = _state.copyWith(msLeft: total);
      _resolve(clean: false);
    } else {
      _state = _state.copyWith(msLeft: total, chordMsLeft: chord);
      notifyListeners();
    }
  }

  void _countDown() {
    final int left = _state.readyMs - QuestionClock.tickMs;
    if (left > 0) {
      _state = _state.copyWith(readyMs: left);
      notifyListeners();
      return;
    }
    _state = _state.copyWith(readyMs: 0, phase: MiniGamePhase.listening);
    _present(_next(_state.level));
  }

  /// Muestra [chord] como el acorde que hay que tocar ahora.
  void _present(Chord chord, {Chord? previous}) {
    final Set<int> target = pitchClassesOfChord(chord);
    _judge = ChordChangeJudge(
      target: target,
      previous: previous == null
          ? const <int>{}
          : pitchClassesOfChord(previous),
      minRatio: _rules.minRatio,
    );
    _deafTicks = _settleTicks;
    _state = _state.copyWith(
      target: chord,
      chordMsLeft: _rules.perChordMs,
      heardNotes: 0,
      targetNotes: target.length,
    );
    notifyListeners();
  }

  void _onDetection(Set<int> detected) {
    final ChordChangeJudge? judge = _judge;
    if (judge == null ||
        _state.phase != MiniGamePhase.listening ||
        _deafTicks > 0) {
      return;
    }
    judge.feed(detected);
    if (judge.isMatch) {
      _resolve(clean: true);
      return;
    }
    _state = _state.copyWith(heardNotes: judge.heardNotes.length);
    notifyListeners();
  }

  void _onLevel(double level) {
    if (_state.phase == MiniGamePhase.listening) {
      _state = _state.copyWith(level01: level);
      notifyListeners();
    }
  }

  /// Anota un acorde limpio o fallado y pide el siguiente.
  void _resolve({required bool clean}) {
    final int bonus = clean
        ? (_state.chordMsLeft * 5 / _state.chordMs).floor()
        : 0;
    final Chord? previous = _state.target;
    _state = _state.copyWith(
      changes: _state.changes + (clean ? 1 : 0),
      misses: _state.misses + (clean ? 0 : 1),
      score: _state.score.record(isCorrect: clean, bonus: bonus),
      lastClean: clean,
    );
    _present(_next(_state.level, previous: previous), previous: previous);
  }

  Future<void> _finish() async {
    final int run = _run;
    _stopListening();
    if (!(_guitar?.enabled ?? false)) {
      await _hearing.close();
    }
    final MiniGameScore result = _state.score.againstGoal(_state.goal);
    final bool record = await _progress.finished(
      MiniGameKind.chordChanges,
      _state.level,
      result,
    );
    if (run != _run) {
      return;
    }
    _state = _state.copyWith(
      phase: MiniGamePhase.finished,
      msLeft: 0,
      score: result,
      isNewBest: record,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }
}
