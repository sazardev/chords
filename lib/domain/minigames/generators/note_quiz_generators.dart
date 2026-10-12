import 'dart:math' as math;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';

/// Opciones de notas según el nivel: 4 naturales, 6 notas o las 12.
ShuffledChoices _noteOptions(
  math.Random random,
  MiniGameLevel level,
  int answerPitchClass,
) {
  final List<int> pool = level == MiniGameLevel.easy
      ? kNaturalPitchClasses
      : kAllPitchClasses;
  final int count = switch (level) {
    MiniGameLevel.easy => 4,
    MiniGameLevel.medium => 6,
    MiniGameLevel.hard => 12,
  };
  final List<int> picked = pickDistinct<int>(
    random,
    pool,
    count,
    keep: answerPitchClass,
  );
  return shuffleChoices(
    random,
    noteChoice(answerPitchClass),
    picked.skip(1).map(noteChoice),
  );
}

/// Adivina la nota: suena una nota y hay que decir cuál es.
class GuessNoteGenerator implements QuizGenerator {
  /// Crea el generador.
  const GuessNoteGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final FretPosition position = randomPosition(
      random,
      maxFret: kMaxFret,
      naturalsOnly: level == MiniGameLevel.easy,
    );
    final ShuffledChoices options = _noteOptions(
      random,
      level,
      position.pitchClass,
    );
    return QuizQuestion(
      kind: MiniGameKind.guessNote,
      cues: <SoundCue>[ToneCue(position.frequency)],
      choices: options.choices,
      answer: <int>[options.answer],
    );
  }
}

/// Nota del mástil: qué nota hay en una cuerda y traste.
class NoteAtFretGenerator implements QuizGenerator {
  /// Crea el generador.
  const NoteAtFretGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final FretPosition position = randomPosition(
      random,
      maxFret: level == MiniGameLevel.easy ? 5 : kMaxFret,
      naturalsOnly: level == MiniGameLevel.easy,
    );
    final ShuffledChoices options = _noteOptions(
      random,
      level,
      position.pitchClass,
    );
    return QuizQuestion(
      kind: MiniGameKind.noteAtFret,
      choices: options.choices,
      answer: <int>[options.answer],
      stringNumber: position.stringNumber,
      fret: position.fret,
    );
  }
}

/// Traste de la nota: en qué traste de una cuerda está una nota.
class FretOfNoteGenerator implements QuizGenerator {
  /// Crea el generador.
  const FretOfNoteGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final FretPosition position = randomPosition(
      random,
      maxFret: 11,
      naturalsOnly: level == MiniGameLevel.easy,
    );
    final int count = level == MiniGameLevel.hard ? 8 : 5;
    final List<int> frets = pickDistinct<int>(
      random,
      List<int>.generate(12, (int fret) => fret),
      count,
      keep: position.fret,
    )..sort();
    return QuizQuestion(
      kind: MiniGameKind.fretOfNote,
      choices: fretChoices(frets),
      answer: <int>[frets.indexOf(position.fret)],
      stringNumber: position.stringNumber,
      note: position.note,
    );
  }
}
