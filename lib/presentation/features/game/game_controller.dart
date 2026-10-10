import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
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
    final List<String> targetNotes =
        chord?.easiestVariant.notes ?? const <String>[];
    await _tuner.playRound(
      targetNotes: targetNotes,
      timeLimitMs: round.timeLimitMs,
    );
    _resolveRound(round);
  }

  /// Avanza a la ronda siguiente o termina la partida.
  void next() {
    if (_current < _rounds.length - 1) {
      _current++;
    }
    _phase = GamePhase.idle;
    notifyListeners();
  }

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

  void _resolveRound(GameRound round) {
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
    notifyListeners();
  }
}
