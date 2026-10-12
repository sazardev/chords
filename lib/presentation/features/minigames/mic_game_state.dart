import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:flutter/foundation.dart';

/// Estado inmutable de una partida de juegos de micrófono.
@immutable
class MicGameState {
  /// Crea el estado.
  const MicGameState({
    required this.kind,
    this.level = MiniGameLevel.easy,
    this.phase = MiniGamePhase.intro,
    this.challenges = const <MicChallenge>[],
    this.index = 0,
    this.progress = 0,
    this.heard,
    this.level01 = 0,
    this.msLeft = 0,
    this.micStatus = MicStatus.idle,
    this.score = const MiniGameScore(),
    this.wasCorrect = false,
    this.isNewBest = false,
  });

  /// Juego en curso.
  final MiniGameKind kind;

  /// Dificultad elegida.
  final MiniGameLevel level;

  /// Fase de la partida.
  final MiniGamePhase phase;

  /// Retos de la partida.
  final List<MicChallenge> challenges;

  /// Posición del reto actual.
  final int index;

  /// Notas acertadas del reto actual.
  final int progress;

  /// Última clase de tono oída con fiabilidad.
  final int? heard;

  /// Nivel de entrada del micrófono (0-1).
  final double level01;

  /// Milisegundos que quedan para tocar.
  final int msLeft;

  /// Estado del micrófono.
  final MicStatus micStatus;

  /// Marcador.
  final MiniGameScore score;

  /// Si el último reto se superó.
  final bool wasCorrect;

  /// Si la partida terminada es un récord.
  final bool isNewBest;

  /// Reto actual; `null` fuera de partida.
  MicChallenge? get challenge =>
      index < challenges.length ? challenges[index] : null;

  /// Número de retos de la partida.
  int get total => challenges.length;

  /// Copia el estado con los cambios indicados.
  MicGameState copyWith({
    MiniGamePhase? phase,
    int? index,
    int? progress,
    int? heard,
    double? level01,
    int? msLeft,
    MicStatus? micStatus,
    MiniGameScore? score,
    bool? wasCorrect,
    bool? isNewBest,
  }) => MicGameState(
    kind: kind,
    level: level,
    phase: phase ?? this.phase,
    challenges: challenges,
    index: index ?? this.index,
    progress: progress ?? this.progress,
    heard: heard ?? this.heard,
    level01: level01 ?? this.level01,
    msLeft: msLeft ?? this.msLeft,
    micStatus: micStatus ?? this.micStatus,
    score: score ?? this.score,
    wasCorrect: wasCorrect ?? this.wasCorrect,
    isNewBest: isNewBest ?? this.isNewBest,
  );
}
