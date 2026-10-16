import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:flutter/foundation.dart';

/// Estado inmutable de una partida de "cambios de acorde".
@immutable
class ChordChangesState {
  /// Crea el estado.
  const ChordChangesState({
    this.level = MiniGameLevel.easy,
    this.phase = MiniGamePhase.intro,
    this.target,
    this.changes = 0,
    this.misses = 0,
    this.goal = 1,
    this.totalMs = 60000,
    this.msLeft = 0,
    this.chordMsLeft = 0,
    this.chordMs = 1,
    this.readyMs = 0,
    this.heardNotes = 0,
    this.targetNotes = 0,
    this.micStatus = MicStatus.idle,
    this.level01 = 0,
    this.score = const MiniGameScore(),
    this.isNewBest = false,
    this.lastClean,
  });

  /// Dificultad elegida.
  final MiniGameLevel level;

  /// Fase de la partida.
  final MiniGamePhase phase;

  /// Acorde que hay que tocar ahora.
  final Chord? target;

  /// Cambios limpios conseguidos.
  final int changes;

  /// Acordes que se dieron por fallados (tiempo agotado o saltados).
  final int misses;

  /// Cambios limpios que dan el 100 %.
  final int goal;

  /// Duración de la partida.
  final int totalMs;

  /// Milisegundos que quedan de la partida.
  final int msLeft;

  /// Milisegundos que quedan para el acorde actual.
  final int chordMsLeft;

  /// Milisegundos que se dan a cada acorde.
  final int chordMs;

  /// Milisegundos que faltan para empezar (cuenta atrás inicial).
  final int readyMs;

  /// Notas del acorde actual que ya se han oído.
  final int heardNotes;

  /// Notas del acorde actual.
  final int targetNotes;

  /// Estado del micrófono.
  final MicStatus micStatus;

  /// Nivel de entrada del micrófono (0-1).
  final double level01;

  /// Marcador.
  final MiniGameScore score;

  /// Si la partida terminada es un récord.
  final bool isNewBest;

  /// Resultado del último acorde: `true` limpio, `false` fallado, `null`
  /// ninguno aún.
  final bool? lastClean;

  /// Segundos transcurridos de la partida.
  int get elapsedSeconds => (totalMs - msLeft) ~/ 1000;

  /// Copia el estado con los cambios indicados.
  ChordChangesState copyWith({
    MiniGameLevel? level,
    MiniGamePhase? phase,
    Chord? target,
    int? changes,
    int? misses,
    int? goal,
    int? totalMs,
    int? msLeft,
    int? chordMsLeft,
    int? chordMs,
    int? readyMs,
    int? heardNotes,
    int? targetNotes,
    MicStatus? micStatus,
    double? level01,
    MiniGameScore? score,
    bool? isNewBest,
    bool? lastClean,
  }) => ChordChangesState(
    level: level ?? this.level,
    phase: phase ?? this.phase,
    target: target ?? this.target,
    changes: changes ?? this.changes,
    misses: misses ?? this.misses,
    goal: goal ?? this.goal,
    totalMs: totalMs ?? this.totalMs,
    msLeft: msLeft ?? this.msLeft,
    chordMsLeft: chordMsLeft ?? this.chordMsLeft,
    chordMs: chordMs ?? this.chordMs,
    readyMs: readyMs ?? this.readyMs,
    heardNotes: heardNotes ?? this.heardNotes,
    targetNotes: targetNotes ?? this.targetNotes,
    micStatus: micStatus ?? this.micStatus,
    level01: level01 ?? this.level01,
    score: score ?? this.score,
    isNewBest: isNewBest ?? this.isNewBest,
    lastClean: lastClean ?? this.lastClean,
  );
}
