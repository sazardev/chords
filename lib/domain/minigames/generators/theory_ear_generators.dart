import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/ear_progression_pool.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/generators/theory_quiz_generators.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';

/// Pausa entre acordes de una cadencia o progresión.
const int _chordGapMs = 1100;

/// Sonidos de una serie de cifras, con la posición más fácil de cada una.
List<SoundCue> chordCues(ChordRepository repository, List<ChordSymbol> chords) {
  final List<SoundCue> cues = <SoundCue>[];
  for (final ChordSymbol symbol in chords) {
    final Chord? chord = repository.chordById(symbol.chordId);
    cues.add(
      ChordCue(
        symbol.chordId,
        variantIndex: chord == null ? 0 : easiestVariantIndex(chord),
        delayMs: cues.isEmpty ? 0 : _chordGapMs,
      ),
    );
  }
  return cues;
}

/// Encuentra la tónica: suena una cadencia y hay que decir la nota "casa".
class FindTonicGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const FindTonicGenerator(this._repository);

  final ChordRepository _repository;

  static const List<String> _majorCadence = <String>['I', 'IV', 'V', 'I'];
  static const List<String> _minorCadence = <String>['i', 'iv', 'V', 'i'];

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final int tonic = randomTonic(random, level);
    final bool minor = level == MiniGameLevel.hard && random.nextBool();
    final List<String> cadence = minor ? _minorCadence : _majorCadence;
    final List<ChordSymbol> chords = <ChordSymbol>[
      for (final String degree in cadence)
        RomanChord.parse(degree).inKey(tonic),
    ];
    final List<int> pool = <int>[
      (tonic + 5) % 12,
      (tonic + 7) % 12,
      (tonic + 9) % 12,
      (tonic + 2) % 12,
      (tonic + 4) % 12,
    ]..shuffle(random);
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      noteChoice(tonic),
      pool.take(level == MiniGameLevel.easy ? 2 : 3).map(noteChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.findTonic,
      cues: chordCues(_repository, chords),
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
    );
  }
}

/// Progresión al oído: suenan cuatro acordes y hay que reconocer los grados.
class ProgressionEarGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ProgressionEarGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<String> available = <String>[
      for (final String progression in earProgressionsFor(level))
        if (_isPlayable(progression)) progression,
    ];
    final String answer = available[random.nextInt(available.length)];
    final List<String> pool = level == MiniGameLevel.hard
        ? _mostSimilar(random, answer, available, 6)
        : available;
    final int tonic = randomTonic(random, MiniGameLevel.easy);
    final List<ChordSymbol> chords = <ChordSymbol>[
      for (final String degree in answer.split(' '))
        RomanChord.parse(degree).inKey(tonic),
    ];
    return QuizQuestion(
      kind: MiniGameKind.progressionEar,
      cues: chordCues(_repository, chords),
      choices: <QuizChoice>[
        for (final String progression in pool)
          QuizChoice(
            ChoiceType.progression,
            progression,
            label: progression.split(' ').join(' – '),
          ),
      ],
      answer: <int>[pool.indexOf(answer)],
      keyTonic: tonic,
    );
  }

  /// `true` si todos los acordes de la progresión están en el banco.
  bool _isPlayable(String progression) => progression
      .split(' ')
      .every(
        (String degree) =>
            _repository.chordById(RomanChord.parse(degree).inKey(0).chordId) !=
            null,
      );

  /// [answer] y las [count] - 1 progresiones de [pool] que más se le parecen.
  List<String> _mostSimilar(
    math.Random random,
    String answer,
    List<String> pool,
    int count,
  ) {
    final List<String> others = pool.where((String p) => p != answer).toList()
      ..shuffle(random)
      ..sort(
        (String a, String b) => progressionSimilarity(
          answer,
          b,
        ).compareTo(progressionSimilarity(answer, a)),
      );
    return <String>[answer, ...others.take(count - 1)]..shuffle(random);
  }
}
