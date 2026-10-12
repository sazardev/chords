import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:flutter/foundation.dart';

/// Estado inmutable de una partida de "arma el acorde".
@immutable
class BuildChordState {
  /// Crea el estado.
  const BuildChordState({
    this.level = MiniGameLevel.easy,
    this.phase = MiniGamePhase.intro,
    this.rounds = const <ChordRound>[],
    this.index = 0,
    this.placed = kEmptyBoard,
    this.wrong = const <int>[],
    this.hinted = false,
    this.solved = false,
    this.score = const MiniGameScore(),
    this.wasCorrect = false,
    this.isNewBest = false,
  });

  /// Tablero vacío: las seis cuerdas silenciadas.
  static const List<int> kEmptyBoard = <int>[-1, -1, -1, -1, -1, -1];

  /// Dificultad elegida.
  final MiniGameLevel level;

  /// Fase de la partida.
  final MiniGamePhase phase;

  /// Acordes de la partida.
  final List<ChordRound> rounds;

  /// Posición de la ronda actual.
  final int index;

  /// Traste colocado en cada cuerda (0 = sexta): `-1` muda, `0` al aire.
  final List<int> placed;

  /// Cuerdas (0 = sexta) mal colocadas tras comprobar.
  final List<int> wrong;

  /// Si se pidió la pista en esta ronda.
  final bool hinted;

  /// Si lo colocado formaba el acorde (aunque la pista le quite el acierto).
  final bool solved;

  /// Marcador.
  final MiniGameScore score;

  /// Si la ronda se resolvió bien.
  final bool wasCorrect;

  /// Si la partida terminada es un récord.
  final bool isNewBest;

  /// Ronda actual; `null` fuera de partida.
  ChordRound? get round => index < rounds.length ? rounds[index] : null;

  /// Número de rondas de la partida.
  int get total => rounds.length;

  /// `true` si el nivel permite pedir pista.
  bool get hintsAllowed => level != MiniGameLevel.hard;

  /// `true` si se enseña la posición de referencia.
  bool get revealsTarget => hinted || phase == MiniGamePhase.feedback;

  /// Copia el estado con los cambios indicados.
  BuildChordState copyWith({
    MiniGamePhase? phase,
    int? index,
    List<int>? placed,
    List<int>? wrong,
    bool? hinted,
    bool? solved,
    MiniGameScore? score,
    bool? wasCorrect,
    bool? isNewBest,
  }) => BuildChordState(
    level: level,
    phase: phase ?? this.phase,
    rounds: rounds,
    index: index ?? this.index,
    placed: placed ?? this.placed,
    wrong: wrong ?? this.wrong,
    hinted: hinted ?? this.hinted,
    solved: solved ?? this.solved,
    score: score ?? this.score,
    wasCorrect: wasCorrect ?? this.wasCorrect,
    isNewBest: isNewBest ?? this.isNewBest,
  );
}
