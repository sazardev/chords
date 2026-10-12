import 'dart:math' as math;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/audio/services/pitch_math.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';

/// Pausa entre las dos notas que se comparan.
const int _pairGapMs = 1000;

/// Nota de partida de los juegos de intervalos: media, audible en un móvil.
FretPosition _lowPosition(math.Random random) =>
    FretPosition(2 + random.nextInt(4), random.nextInt(5));

/// Intervalos de la partida: 3 en fácil, 6 en medio y los 12 en difícil.
List<int> intervalsFor(MiniGameLevel level) => switch (level) {
  MiniGameLevel.easy => const <int>[4, 7, 12],
  MiniGameLevel.medium => const <int>[3, 4, 5, 7, 9, 12],
  MiniGameLevel.hard => const <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
};

/// Intervalo: dos notas seguidas y hay que decir cuántos semitonos suben.
class IntervalGenerator implements QuizGenerator {
  /// Crea el generador.
  const IntervalGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<int> pool = intervalsFor(level);
    final int semitones = pool[random.nextInt(pool.length)];
    final double root = _lowPosition(random).frequency;
    return QuizQuestion(
      kind: MiniGameKind.interval,
      cues: <SoundCue>[
        ToneCue(root),
        ToneCue(shiftBySemitones(root, semitones), delayMs: _pairGapMs),
      ],
      choices: <QuizChoice>[
        for (final int value in pool) QuizChoice(ChoiceType.interval, '$value'),
      ],
      answer: <int>[pool.indexOf(semitones)],
    );
  }
}

/// Agudo o grave: dos notas y hay que decir cuál suena más aguda.
class HigherLowerGenerator implements QuizGenerator {
  /// Crea el generador.
  const HigherLowerGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final int distance = switch (level) {
      MiniGameLevel.easy => 6 + random.nextInt(7),
      MiniGameLevel.medium => 3 + random.nextInt(3),
      MiniGameLevel.hard => 1 + random.nextInt(2),
    };
    final bool secondIsHigher = random.nextBool();
    final double low = _lowPosition(random).frequency;
    final double high = shiftBySemitones(low, distance);
    final double first = secondIsHigher ? low : high;
    final double second = secondIsHigher ? high : low;
    final int answerIndex = secondIsHigher ? 1 : 0;
    return QuizQuestion(
      kind: MiniGameKind.higherLower,
      cues: <SoundCue>[
        ToneCue(first),
        ToneCue(second, delayMs: _pairGapMs),
      ],
      choices: const <QuizChoice>[
        QuizChoice(ChoiceType.order, 'first'),
        QuizChoice(ChoiceType.order, 'second'),
      ],
      answer: <int>[answerIndex],
    );
  }
}

/// Oído de afinador: la nota de referencia y otra floja, afinada o alta.
class TuneEarGenerator implements QuizGenerator {
  /// Crea el generador.
  const TuneEarGenerator();

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final int cents = switch (level) {
      MiniGameLevel.easy => 40,
      MiniGameLevel.medium => 20,
      MiniGameLevel.hard => 10,
    };
    final int verdict = random.nextInt(3) - 1;
    final double reference = FretPosition(1 + random.nextInt(6), 0).frequency;
    final double heard = reference * math.pow(2, verdict * cents / 1200);
    return QuizQuestion(
      kind: MiniGameKind.tuneEar,
      cues: <SoundCue>[
        ToneCue(reference),
        ToneCue(heard, delayMs: _pairGapMs + 200),
      ],
      choices: const <QuizChoice>[
        QuizChoice(ChoiceType.tuning, 'flat'),
        QuizChoice(ChoiceType.tuning, 'inTune'),
        QuizChoice(ChoiceType.tuning, 'sharp'),
      ],
      answer: <int>[verdict + 1],
    );
  }
}
