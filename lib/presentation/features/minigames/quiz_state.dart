import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:flutter/foundation.dart';

/// Estado inmutable de una partida de preguntas de opciones.
@immutable
class QuizState {
  /// Crea el estado.
  const QuizState({
    required this.kind,
    this.level = MiniGameLevel.easy,
    this.phase = MiniGamePhase.intro,
    this.questions = const <QuizQuestion>[],
    this.index = 0,
    this.input = const <int>[],
    this.score = const MiniGameScore(),
    this.replaysLeft = 0,
    this.isPlaying = false,
    this.wasCorrect = false,
    this.isNewBest = false,
  });

  /// Juego en curso.
  final MiniGameKind kind;

  /// Dificultad elegida.
  final MiniGameLevel level;

  /// Fase de la partida.
  final MiniGamePhase phase;

  /// Preguntas de la partida.
  final List<QuizQuestion> questions;

  /// Posición de la pregunta actual.
  final int index;

  /// Opciones elegidas en la pregunta actual (varias en las secuencias).
  final List<int> input;

  /// Marcador.
  final MiniGameScore score;

  /// Veces que aún se puede repetir el sonido.
  final int replaysLeft;

  /// `true` mientras suena la pregunta.
  final bool isPlaying;

  /// Si la última respuesta fue correcta.
  final bool wasCorrect;

  /// Si la partida terminada es un récord.
  final bool isNewBest;

  /// Pregunta actual; `null` fuera de partida.
  QuizQuestion? get question =>
      index < questions.length ? questions[index] : null;

  /// Número de preguntas de la partida.
  int get total => questions.length;

  /// `true` si se puede volver a escuchar la pregunta.
  bool get canReplay =>
      !isPlaying &&
      (phase == MiniGamePhase.feedback ||
          (phase == MiniGamePhase.asking && replaysLeft > 0));

  /// Copia el estado con los cambios indicados.
  QuizState copyWith({
    MiniGamePhase? phase,
    int? index,
    List<int>? input,
    MiniGameScore? score,
    int? replaysLeft,
    bool? isPlaying,
    bool? wasCorrect,
    bool? isNewBest,
  }) => QuizState(
    kind: kind,
    level: level,
    phase: phase ?? this.phase,
    questions: questions,
    index: index ?? this.index,
    input: input ?? this.input,
    score: score ?? this.score,
    replaysLeft: replaysLeft ?? this.replaysLeft,
    isPlaying: isPlaying ?? this.isPlaying,
    wasCorrect: wasCorrect ?? this.wasCorrect,
    isNewBest: isNewBest ?? this.isNewBest,
  );
}
