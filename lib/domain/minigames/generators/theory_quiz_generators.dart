import 'dart:math' as math;

import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';

/// Tónicas de las tonalidades más habituales en guitarra (Do, Sol, Re, La,
/// Mi y Fa): las que se aprenden primero.
const List<int> kGuitarKeys = <int>[0, 7, 2, 9, 4, 5];

/// Tónica al azar: tonos de guitarra en fácil y medio, cualquiera en difícil.
int randomTonic(math.Random random, MiniGameLevel level) =>
    level == MiniGameLevel.hard
    ? random.nextInt(12)
    : kGuitarKeys[random.nextInt(kGuitarKeys.length)];

/// Escalas que se preguntan en cada dificultad.
List<ScaleType> scalesFor(MiniGameLevel level) => switch (level) {
  MiniGameLevel.easy => const <ScaleType>[ScaleType.major],
  MiniGameLevel.medium => const <ScaleType>[
    ScaleType.major,
    ScaleType.naturalMinor,
    ScaleType.minorPentatonic,
    ScaleType.majorPentatonic,
  ],
  MiniGameLevel.hard => ScaleType.classics,
};

/// ¿Qué nota está en la escala?: una nota de la escala y tres que no.
class ScaleNoteGenerator implements QuizGenerator {
  /// Crea el generador.
  const ScaleNoteGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ScaleType> scales = scalesFor(level);
    final ScaleType scale = scales[random.nextInt(scales.length)];
    final int tonic = randomTonic(random, level);
    final List<int> inside = scale.pitchClasses(tonic).skip(1).toList();
    final List<int> outside = <int>[
      for (int pc = 0; pc < 12; pc++)
        if (!scale.contains(tonic, pc)) pc,
    ]..shuffle(random);
    final int correct = inside[random.nextInt(inside.length)];
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      noteChoice(correct),
      outside.take(3).map(noteChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.scaleNote,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      keyTonic: tonic,
      scaleId: scale.id,
    );
  }
}

/// Grados que se preguntan: I-IV-V en fácil y los siete después.
List<int> degreesFor(MiniGameLevel level) => level == MiniGameLevel.easy
    ? const <int>[1, 4, 5]
    : const <int>[1, 2, 3, 4, 5, 6, 7];

/// Tonalidad al azar; las menores solo aparecen en difícil.
MusicalKey randomKey(math.Random random, MiniGameLevel level) => MusicalKey(
  randomTonic(random, level),
  minor: level == MiniGameLevel.hard && random.nextBool(),
);

/// Acorde del grado: "en Sol mayor, ¿cuál es el IV?".
class KeyChordGenerator implements QuizGenerator {
  /// Crea el generador.
  const KeyChordGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final MusicalKey key = randomKey(random, level);
    final List<int> degrees = degreesFor(level);
    final int degree = degrees[random.nextInt(degrees.length)];
    final List<DiatonicChord> harmony = key.harmony();
    final DiatonicChord answer = harmony[degree - 1];
    final List<DiatonicChord> others =
        harmony.where((DiatonicChord c) => c != answer).toList()
          ..shuffle(random);
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      _choice(answer),
      others.take(level == MiniGameLevel.easy ? 2 : 3).map(_choice),
    );
    return QuizQuestion(
      kind: MiniGameKind.keyChord,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      keyTonic: key.tonic,
      scaleId: key.scale.id,
      degree: degree,
    );
  }

  QuizChoice _choice(DiatonicChord chord) => QuizChoice(
    ChoiceType.chord,
    chord.symbol.chordId,
    label: chord.symbol.name,
  );
}

/// ¿Qué grado es?: "en Do mayor, ¿qué grado es Mi?".
class ScaleDegreeGenerator implements QuizGenerator {
  /// Crea el generador.
  const ScaleDegreeGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final MusicalKey key = randomKey(random, level);
    final List<int> degrees = degreesFor(level);
    final int degree = degrees[random.nextInt(degrees.length)];
    final int pitchClass = key.pitchClasses[degree - 1];
    final List<int> all = degreesFor(MiniGameLevel.hard);
    final List<int> options = level == MiniGameLevel.hard
        ? all
        : (pickDistinct(random, all, 4, keep: degree)..sort());
    return QuizQuestion(
      kind: MiniGameKind.scaleDegree,
      choices: <QuizChoice>[
        for (final int d in options) QuizChoice(ChoiceType.degree, '$d'),
      ],
      answer: <int>[options.indexOf(degree)],
      keyTonic: key.tonic,
      scaleId: key.scale.id,
      note: noteChoice(pitchClass).value,
    );
  }
}
