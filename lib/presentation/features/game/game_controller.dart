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
import 'package:chords/presentation/features/game/game_score_controller.dart';
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
}

/// Controlador de la partida del modo "toca el acorde".
///
/// Responsabilidad única: gestionar la secuencia de rondas y las fases. La
/// escucha del micrófono vive en [GameAudioController] y la puntuación en
/// [GameScoreController].
class GameController extends ChangeNotifier {
  /// Crea el controlador con sus colaboradores.
  GameController(this._audio, this._chords, this._score, this._tuner)
    : _buildSequence = BuildGameSequenceUseCase(_chords),
      _evaluate = const EvaluateChordMatchUseCase();

  final AudioRepository _audio;
  final ChordRepository _chords;
  final GameScoreController _score;
  final GameAudioController _tuner;
  final BuildGameSequenceUseCase _buildSequence;
  final EvaluateChordMatchUseCase _evaluate;

  List<GameRound> _rounds = const <GameRound>[];
  int _current = 0;
  GamePhase _phase = GamePhase.idle;

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
  }

  /// Escucha la ronda actual y la resuelve al terminar.
  Future<void> playRound() async {
    final GameRound? round = currentRound;
    if (round == null) {
      return;
    }
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
    }
    _phase = GamePhase.idle;
    notifyListeners();
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
  }

  bool _advances(GameResult? result) =>
      result != null &&
      (result.outcome == GameOutcome.success ||
          result.outcome == GameOutcome.partial);

  /// Acorde del objetivo (para mostrar su diagrama).
  Chord? chordOf(String chordId) => _chords.chordById(chordId);

  /// Nombre legible del acorde objetivo.
  String nameOf(String chordId) => chordOf(chordId)?.name ?? chordId;

  /// Reproduce el acorde objetivo para escucharlo antes de tocarlo.
  Future<void> playTarget(String chordId) async {
    final Chord? chord = chordOf(chordId);
    if (chord == null) {
      return;
    }
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
    _trackRound(round, targetNotes, result);
    if (round.index == _rounds.length - 1) {
      _trackFinished();
    }
    notifyListeners();
  }

  void _trackRound(
    GameRound round,
    List<String> targetNotes,
    GameResult result,
  ) {
    final List<String> heard = _tuner.heardNotes;
    appLogger.info(
      'juego: ronda ${round.index + 1} ${result.outcome.name} — '
      'esperado [${targetNotes.join(', ')}] escuchado [${heard.join(', ')}] '
      'acierto ${(result.matchedRatio * 100).round()}%',
      channel: LogChannel.game,
      context: <String, Object?>{
        'expected': targetNotes.join(','),
        'heard': heard.join(','),
        'matchRatio': result.matchedRatio,
        'outcome': result.outcome.name,
      },
    );
    analytics.gameRoundPlayed(
      index: round.index,
      chordId: round.chordId,
      expectedNotes: targetNotes,
      heardNotes: heard,
      matchRatio: result.matchedRatio,
      outcome: result.outcome.name,
      timeLimitMs: round.timeLimitMs,
    );
  }

  void _trackFinished() {
    final List<GameRound> resolved = _rounds
        .where((GameRound round) => round.isResolved)
        .toList();
    int won = 0;
    int partial = 0;
    int failed = 0;
    for (final GameRound round in resolved) {
      switch (round.result!.outcome) {
        case GameOutcome.success:
          won++;
        case GameOutcome.partial:
          partial++;
        case GameOutcome.fail:
        case GameOutcome.timeout:
          failed++;
      }
    }
    appLogger.info(
      'juego: serie terminada — $won/${resolved.length} aciertos, '
      'puntuación ${_score.score} (récord ${_score.bestScore})',
      channel: LogChannel.game,
      context: <String, Object?>{
        'won': won,
        'partial': partial,
        'failed': failed,
        'score': _score.score,
      },
    );
    analytics.gameFinished(
      score: _score.score,
      best: _score.bestScore,
      rounds: resolved.length,
      won: won,
      partial: partial,
      failed: failed,
    );
  }
}
