import 'dart:async';

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/game_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/build_game_sequence_use_case.dart';
import 'package:chords/domain/chords/usecases/evaluate_chord_match_use_case.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_countdown.dart';
import 'package:chords/presentation/features/game/game_round_tracker.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_mic_keeper.dart';
import 'package:flutter/foundation.dart';

/// Fase del modo juego.
enum GamePhase {
  /// Esperando a que el jugador pulse "listo".
  idle,

  /// Escuchando el micrófono.
  listening,

  /// Acorde reconocido.
  won,

  /// No se reconoció el acorde.
  lost,

  /// Se superó la última ronda: la serie terminó.
  finished,
}

/// Controlador de la partida del modo "toca el acorde".
///
/// Responsabilidad única: gestionar la secuencia de rondas y las fases. La
/// escucha del micrófono vive en [GameAudioController] y la puntuación en
/// [GameScoreController].
///
/// Si se da [readyDelay], cada ronda empieza sola tras una cuenta atrás que
/// deja tiempo para colocar la mano: la persona no necesita tocar el móvil
/// para pasar de un acorde a otro.
class GameController extends ChangeNotifier {
  /// Crea el controlador con sus colaboradores.
  GameController(
    this._audio,
    this._chords,
    this._score,
    this._tuner, {
    this.readyDelay,
    this._guitar,
    this._keeper,
  }) : _buildSequence = BuildGameSequenceUseCase(_chords),
       _evaluate = const EvaluateChordMatchUseCase();

  /// Cuenta atrás antes de escuchar cada ronda; `null` espera a [playRound].
  final Duration? readyDelay;

  /// Lo que dura el acorde de referencia al sonar (más su cola).
  static const Duration _chordRing = Duration(milliseconds: 2800);

  static const GameRoundTracker _tracker = GameRoundTracker();

  final AudioRepository _audio;
  final ChordRepository _chords;
  final GameScoreController _score;
  final GameAudioController _tuner;
  final GuitarCommandListener? _guitar;
  final GuitarMicKeeper? _keeper;
  final BuildGameSequenceUseCase _buildSequence;
  final EvaluateChordMatchUseCase _evaluate;

  List<GameRound> _rounds = const <GameRound>[];
  int _current = 0;
  GamePhase _phase = GamePhase.idle;
  late final GameCountdown _countdown = GameCountdown(
    readyDelay,
    onTick: notifyListeners,
    onDone: () => unawaited(playRound()),
  );

  /// Segundos que faltan para que empiece la ronda (0 si no hay cuenta atrás).
  int get readyIn => _countdown.remaining;

  /// Rondas de la serie actual.
  List<GameRound> get rounds => _rounds;

  /// Fase actual.
  GamePhase get phase => _phase;

  /// Ronda en curso.
  GameRound? get currentRound =>
      _current < _rounds.length ? _rounds[_current] : null;

  /// Empieza una partida desde el nivel indicado.
  void start({required int level}) {
    _rounds = _buildSequence(fromLevel: level);
    _current = 0;
    _phase = GamePhase.idle;
    _score.reset();
    appLogger.info(
      'juego: partida iniciada en nivel $level (${_rounds.length} rondas)',
      channel: LogChannel.game,
    );
    analytics.gameStarted(level: level, rounds: _rounds.length);
    notifyListeners();
    _keepMic();
    _armCountdown();
  }

  /// Avisa de que la pantalla se ve ([active]) o se abandona.
  ///
  /// Al verse retoma la cuenta atrás pendiente y, si se maneja la app con la
  /// guitarra, mantiene el micrófono abierto entre rondas; al abandonarla
  /// detiene la cuenta atrás y cierra el micrófono.
  void setActive({required bool active}) {
    if (!active) {
      _countdown.stop();
      unawaited(_keeper?.close());
      unawaited(_audio.stopListening());
      return;
    }
    _keepMic();
    if (_phase == GamePhase.idle) {
      _armCountdown();
    }
  }

  /// Deja el micrófono abierto entre rondas si hay una serie en marcha.
  void _keepMic() {
    if (currentRound != null && (_guitar?.enabled ?? false)) {
      unawaited(_keeper?.open());
    }
  }

  /// Escucha la ronda actual y la resuelve al terminar.
  Future<void> playRound() async {
    final GameRound? round = currentRound;
    if (round == null) {
      return;
    }
    _countdown.stop();
    _phase = GamePhase.listening;
    notifyListeners();

    final Chord? chord = _chords.chordById(round.chordId);
    final ChordVariant? variant = chord?.easiestVariant;
    final List<String> targetNotes = variant?.notes ?? const <String>[];
    final bool listened = await _tuner.playRound(
      targetNotes: targetNotes,
      frets: variant?.frets ?? const <int>[],
      timeLimitMs: round.timeLimitMs,
    );
    if (!listened) {
      _phase = GamePhase.idle;
      appLogger.warning(
        'juego: ronda ${round.index + 1} sin micrófono',
        channel: LogChannel.game,
      );
      notifyListeners();
      return;
    }
    _resolveRound(round, targetNotes);
  }

  /// Avanza a la ronda siguiente solo si la actual se superó.
  ///
  /// Tras un fallo o un tiempo agotado no deja avanzar: reintenta la misma
  /// ronda para que el jugador corrija lo que faltaba.
  void next() {
    final GameRound? round = currentRound;
    if (round != null && !_advances(round.result)) {
      retry();
      return;
    }
    if (_current < _rounds.length - 1) {
      _current++;
      _phase = GamePhase.idle;
    } else {
      _phase = GamePhase.finished;
    }
    notifyListeners();
    _armCountdown();
  }

  /// Repite la ronda actual sin avanzar de acorde.
  void retry() {
    final GameRound? round = currentRound;
    if (round == null) {
      return;
    }
    _rounds = <GameRound>[
      for (final GameRound item in _rounds)
        if (item.index == round.index)
          GameRound(
            index: item.index,
            chordId: item.chordId,
            timeLimitMs: item.timeLimitMs,
          )
        else
          item,
    ];
    _phase = GamePhase.idle;
    appLogger.info(
      'juego: reintento de la ronda ${round.index + 1}',
      channel: LogChannel.game,
    );
    notifyListeners();
    _armCountdown();
  }

  void _armCountdown() {
    if (_phase == GamePhase.idle && currentRound != null) {
      _countdown.start();
    } else {
      _countdown.stop();
    }
  }

  bool _advances(GameResult? result) =>
      result != null &&
      (result.outcome == GameOutcome.success ||
          result.outcome == GameOutcome.partial);

  /// Acorde del objetivo (para mostrar su diagrama).
  Chord? chordOf(String chordId) => _chords.chordById(chordId);

  /// Reproduce el acorde objetivo para escucharlo antes de tocarlo.
  Future<void> playTarget(String chordId) async {
    final Chord? chord = chordOf(chordId);
    if (chord == null) {
      return;
    }
    _guitar?.muteFor(_chordRing);
    await _audio.playChord(chord, chord.easiestVariant);
  }

  void _resolveRound(GameRound round, List<String> targetNotes) {
    final GameResult result = _evaluate.resultFor(_tuner.matchRatio);
    _rounds = <GameRound>[
      for (final GameRound item in _rounds)
        if (item.index == round.index)
          GameRound(
            index: item.index,
            chordId: item.chordId,
            timeLimitMs: item.timeLimitMs,
            result: result,
          )
        else
          item,
    ];
    _phase =
        result.outcome == GameOutcome.fail ||
            result.outcome == GameOutcome.timeout
        ? GamePhase.lost
        : GamePhase.won;
    _score.recognize(result);
    _tracker.round(
      round: round,
      expected: targetNotes,
      heard: _tuner.heardNotes,
      result: result,
    );
    if (round.index == _rounds.length - 1) {
      _tracker.finished(
        rounds: _rounds,
        score: _score.score,
        best: _score.bestScore,
      );
    }
    notifyListeners();
  }
}
