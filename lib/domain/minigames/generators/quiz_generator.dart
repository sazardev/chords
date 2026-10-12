import 'dart:math' as math;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';

/// Fabrica las preguntas de un minijuego.
abstract interface class QuizGenerator {
  /// Genera la pregunta número [index] (desde 0) de una partida.
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index);
}

/// Opciones barajadas junto al índice de la correcta.
typedef ShuffledChoices = ({List<QuizChoice> choices, int answer});

/// Baraja [correct] entre [distractors] y devuelve dónde quedó.
ShuffledChoices shuffleChoices(
  math.Random random,
  QuizChoice correct,
  Iterable<QuizChoice> distractors,
) {
  final List<QuizChoice> all = <QuizChoice>[correct, ...distractors]
    ..shuffle(random);
  return (choices: all, answer: all.indexOf(correct));
}

/// Elige hasta [count] elementos distintos de [pool], siempre con [keep].
List<T> pickDistinct<T>(
  math.Random random,
  Iterable<T> pool,
  int count, {
  required T keep,
}) {
  final List<T> others = pool.where((T item) => item != keep).toList()
    ..shuffle(random);
  return <T>[keep, ...others.take(math.max(0, count - 1))];
}

/// Cuerda y traste al azar; con [naturalsOnly] solo notas sin sostenido.
FretPosition randomPosition(
  math.Random random, {
  required int maxFret,
  bool naturalsOnly = false,
  int? stringNumber,
}) {
  FretPosition position;
  int attempts = 0;
  do {
    position = FretPosition(
      stringNumber ?? 1 + random.nextInt(6),
      random.nextInt(maxFret + 1),
    );
    attempts++;
  } while (naturalsOnly &&
      !isNaturalPitchClass(position.pitchClass) &&
      attempts < 50);
  return position;
}

/// Opción de nota a partir de su clase de tono.
QuizChoice noteChoice(int pitchClass) =>
    QuizChoice(ChoiceType.note, noteNameOfPitchClass(pitchClass));

/// Clases de tono de las siete notas naturales.
const List<int> kNaturalPitchClasses = <int>[0, 2, 4, 5, 7, 9, 11];

/// Todas las clases de tono.
const List<int> kAllPitchClasses = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

/// Opciones de traste en el orden dado.
List<QuizChoice> fretChoices(Iterable<int> frets) => <QuizChoice>[
  for (final int fret in frets) QuizChoice(ChoiceType.fret, '$fret'),
];
