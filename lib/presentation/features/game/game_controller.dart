import 'dart:async' show StreamSubscription, unawaited;

import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/build_game_sequence_use_case.dart';
import 'package:chords/domain/chords/usecases/evaluate_chord_match_use_case.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
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

/// Controlador del modo juego "toca el acorde".
class GameController extends ChangeNotifier {
  /// Crea el controlador.
  GameController(this._audio, this._chords, this._preferences)
    : _buildSequence = BuildGameSequenceUseCase(_chords),
      _evaluate = const EvaluateChordMatchUseCase();

  final AudioRepository _audio;
  final ChordRepository _chords;
  final PreferencesRepository _preferences;
  final BuildGameSequenceUseCase _buildSequence;
  final EvaluateChordMatchUseCase _evaluate;

  List<GameRound> _rounds = const <GameRound>[];
  int _current = 0;
  int _score = 0;
  int _streak = 0;
  GamePhase _phase = GamePhase.idle;
  MicStatus _micStatus = MicStatus.idle;
  double _match = 0;
  int _best = 0;

  StreamSubscription<PitchReading>? _subscription;
  StreamSubscription<MicStatus>? _statusSubscription;

  /// Rondas de la serie actual.
  List<GameRound> get rounds => _rounds;

  /// Índice de la ronda en curso.
  int get currentIndex => _current;

  /// Puntuación de la partida.
  int get score => _score;

  /// Racha de aciertos.
  int get streak => _streak;

  /// Mejor puntuación histórica.
  int get bestScore => _best;

  /// Fase actual.
  GamePhase get phase => _phase;

  /// Estado del micrófono.
  MicStatus get micStatus => _micStatus;

  /// Proporción de notas detectadas (0-1).
  double get matchRatio => _match;

  /// Ronda en curso.
  GameRound? get currentRound =>
      _current < _rounds.length ? _rounds[_current] : null;

  /// Carga la mejor puntuación persistida.
  void loadBestScore() {
    _best = _preferences.bestScore;
    notifyListeners();
  }

  /// Empieza una partida desde el nivel indicado.
  void start({required int level}) {
    _rounds = _buildSequence(fromLevel: level);
    _current = 0;
    _score = 0;
    _streak = 0;
    _match = 0;
    _phase = GamePhase.idle;
    notifyListeners();
  }

  /// Escucha la ronda actual y la evalúa.
  Future<void> playRound() async {
    final GameRound? round = currentRound;
    if (round == null) {
      return;
    }
    _phase = GamePhase.listening;
    _match = 0;
    notifyListeners();

    final Set<int> detected = <int>{};
    final List<String> targetNotes =
        _chords.chordById(round.chordId)?.easiestVariant.notes ??
        const <String>[];
    await _subscription?.cancel();
    _subscription = _audio.readings.listen((PitchReading reading) {
      if (!reading.isReliable) {
        return;
      }
      detected.add(_pitchClassOf(reading.note));
      _match = _evaluate.call(targetNotes, detected);
      notifyListeners();
    });
    unawaited(_audio.startListening());
    _micStatus = MicStatus.listening;
    _statusSubscription = _audio.statusStream.listen((MicStatus next) {
      _micStatus = next;
      notifyListeners();
    });

    await Future<void>.delayed(Duration(milliseconds: round.timeLimitMs));
    await _audio.stopListening();
    await _subscription?.cancel();
    _subscription = null;
    await _statusSubscription?.cancel();
    _statusSubscription = null;
    _micStatus = MicStatus.idle;
    _resolveRound(round);
  }

  /// Avanza a la ronda siguiente o termina la partida.
  void next() {
    if (_current < _rounds.length - 1) {
      _current++;
      _phase = GamePhase.idle;
      _match = 0;
    } else {
      _phase = GamePhase.idle;
    }
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
    final GameResult result = _evaluate.resultFor(_match);
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
    if (result.scored) {
      _score += result.outcome == GameOutcome.success ? 100 : 50;
      _streak++;
    } else {
      _streak = 0;
    }
    _phase =
        result.outcome == GameOutcome.fail ||
            result.outcome == GameOutcome.timeout
        ? GamePhase.lost
        : GamePhase.won;
    unawaited(_preferences.saveBestScore(_score));
    _best = _preferences.bestScore;
    notifyListeners();
  }

  int _pitchClassOf(String label) {
    const List<String> names = <String>[
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    final String note = label.replaceAll(RegExp('[0-9-]'), '');
    return names.indexOf(note);
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_statusSubscription?.cancel());
    super.dispose();
  }
}
