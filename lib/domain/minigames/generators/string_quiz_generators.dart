import 'dart:math' as math;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';

/// Cuerdas con las que se juega: tres separadas en fácil, las seis después.
List<int> _stringPool(MiniGameLevel level) => level == MiniGameLevel.easy
    ? const <int>[6, 3, 1]
    : const <int>[6, 5, 4, 3, 2, 1];

List<QuizChoice> _stringChoices(List<int> numbers) => <QuizChoice>[
  for (final int number in numbers)
    QuizChoice(ChoiceType.stringNumber, '$number'),
];

/// ¿Qué cuerda es?: suena una cuerda al aire.
class WhichStringGenerator implements QuizGenerator {
  /// Crea el generador.
  const WhichStringGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<int> pool = _stringPool(level);
    final int number = pool[random.nextInt(pool.length)];
    return QuizQuestion(
      kind: MiniGameKind.whichString,
      cues: <SoundCue>[ToneCue(FretPosition(number, 0).frequency)],
      choices: _stringChoices(pool),
      answer: <int>[pool.indexOf(number)],
    );
  }
}

/// ¿Qué traste es?: suena la cuerda al aire y después pulsada.
class WhichFretGenerator implements QuizGenerator {
  /// Crea el generador.
  const WhichFretGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final int maxFret = switch (level) {
      MiniGameLevel.easy => 5,
      MiniGameLevel.medium => 9,
      MiniGameLevel.hard => 12,
    };
    final int number = 1 + random.nextInt(6);
    final int fret = 1 + random.nextInt(maxFret);
    final List<int> frets = pickDistinct<int>(
      random,
      List<int>.generate(maxFret, (int i) => i + 1),
      level == MiniGameLevel.hard ? 12 : 6,
      keep: fret,
    )..sort();
    return QuizQuestion(
      kind: MiniGameKind.whichFret,
      cues: <SoundCue>[
        ToneCue(FretPosition(number, 0).frequency),
        ToneCue(FretPosition(number, fret).frequency, delayMs: 1000),
      ],
      choices: fretChoices(frets),
      answer: <int>[frets.indexOf(fret)],
      stringNumber: number,
    );
  }
}

/// Memoria de cuerdas: repetir en orden la secuencia escuchada.
class MemoryGenerator implements QuizGenerator {
  /// Crea el generador.
  const MemoryGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<int> pool = _stringPool(level);
    final int length = math.min(
      8,
      switch (level) {
            MiniGameLevel.easy => 3,
            MiniGameLevel.medium => 4,
            MiniGameLevel.hard => 5,
          } +
          index ~/ 3,
    );
    final int gap = switch (level) {
      MiniGameLevel.easy => 800,
      MiniGameLevel.medium => 650,
      MiniGameLevel.hard => 500,
    };
    final List<int> sequence = <int>[];
    while (sequence.length < length) {
      final int next = random.nextInt(pool.length);
      if (sequence.isEmpty || sequence.last != next) {
        sequence.add(next);
      }
    }
    return QuizQuestion(
      kind: MiniGameKind.memory,
      cues: <SoundCue>[
        for (int i = 0; i < sequence.length; i++)
          ToneCue(_openFrequency(pool[sequence[i]]), delayMs: i == 0 ? 0 : gap),
      ],
      choices: _stringChoices(pool),
      answer: sequence,
    );
  }

  double _openFrequency(int number) =>
      standardStringByNumber(number)!.frequency;
}
