import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';

/// Acordes asequibles para el nivel: dificultad 1, hasta 2 o hasta 3.
List<Chord> chordPoolFor(ChordRepository repository, MiniGameLevel level) {
  final int maxDifficulty = switch (level) {
    MiniGameLevel.easy => 1,
    MiniGameLevel.medium => 2,
    MiniGameLevel.hard => 3,
  };
  final List<Chord> pool = repository.chords
      .where((Chord chord) => chord.difficulty.level <= maxDifficulty)
      .toList();
  return pool.length >= 3 ? pool : repository.chords;
}

/// Índice de la posición más fácil del acorde.
int easiestVariantIndex(Chord chord) =>
    chord.variants.indexOf(chord.easiestVariant);

/// Elige [count] acordes con [answer], prefiriendo los parecidos.
///
/// Los parecidos comparten raíz o calidad (`C` junto a `Cm` o `G`), que es
/// justo lo que cuesta distinguir al oído y en un diagrama. Nunca incluye un
/// acorde con las mismas notas que la respuesta (`C6` y `Am7`), porque
/// ambos serían correctos.
List<Chord> chordOptions(
  math.Random random,
  Chord answer,
  List<Chord> pool,
  int count,
) {
  final Set<int> notes = pitchClassesOfChord(answer);
  final List<Chord> others = pool
      .where(
        (Chord c) => c != answer && !_sameNotes(pitchClassesOfChord(c), notes),
      )
      .toList();
  final List<Chord> related =
      others
          .where(
            (Chord c) => c.root == answer.root || c.quality == answer.quality,
          )
          .toList()
        ..shuffle(random);
  final List<Chord> rest =
      others.where((Chord c) => !related.contains(c)).toList()..shuffle(random);
  final int near = (count - 1) ~/ 2;
  final List<Chord> picked = <Chord>[
    ...related.take(near),
    ...rest,
    ...related.skip(near),
  ].take(count - 1).toList();
  return <Chord>[answer, ...picked];
}

bool _sameNotes(Set<int> a, Set<int> b) =>
    a.length == b.length && a.containsAll(b);

List<QuizChoice> _chordChoices(List<Chord> chords) => <QuizChoice>[
  for (final Chord chord in chords)
    QuizChoice(ChoiceType.chord, chord.id, label: chord.name),
];

/// Calidades que se distinguen según el nivel.
List<ChordQuality> qualitiesFor(MiniGameLevel level) => switch (level) {
  MiniGameLevel.easy => const <ChordQuality>[
    ChordQuality.major,
    ChordQuality.minor,
  ],
  MiniGameLevel.medium => const <ChordQuality>[
    ChordQuality.major,
    ChordQuality.minor,
    ChordQuality.seven,
  ],
  MiniGameLevel.hard => const <ChordQuality>[
    ChordQuality.major,
    ChordQuality.minor,
    ChordQuality.seven,
    ChordQuality.minorSeven,
    ChordQuality.majorSeven,
    ChordQuality.suspendedFourth,
  ],
};

/// Mayor o menor: suena un acorde y hay que reconocer su calidad.
class ChordQualityGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ChordQualityGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ChordQuality> qualities = qualitiesFor(level)
        .where(
          (ChordQuality q) =>
              _repository.chords.any((Chord c) => c.quality == q),
        )
        .toList();
    final ChordQuality quality = qualities[random.nextInt(qualities.length)];
    final List<Chord> candidates = _repository.chords
        .where((Chord chord) => chord.quality == quality)
        .toList();
    final Chord chord = candidates[random.nextInt(candidates.length)];
    return QuizQuestion(
      kind: MiniGameKind.chordQuality,
      cues: <SoundCue>[
        ChordCue(chord.id, variantIndex: easiestVariantIndex(chord)),
      ],
      choices: <QuizChoice>[
        for (final ChordQuality q in qualities)
          QuizChoice(ChoiceType.quality, q.id),
      ],
      answer: <int>[qualities.indexOf(quality)],
    );
  }
}

/// Reconocer el acorde: suena y hay que decir cómo se llama.
class NameChordGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const NameChordGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<Chord> pool = chordPoolFor(_repository, level);
    final Chord answer = pool[random.nextInt(pool.length)];
    final int count = switch (level) {
      MiniGameLevel.easy => 3,
      MiniGameLevel.medium => 4,
      MiniGameLevel.hard => 6,
    };
    final List<Chord> options = chordOptions(random, answer, pool, count)
      ..shuffle(random);
    return QuizQuestion(
      kind: MiniGameKind.nameChord,
      cues: <SoundCue>[
        ChordCue(answer.id, variantIndex: easiestVariantIndex(answer)),
      ],
      choices: _chordChoices(options),
      answer: <int>[options.indexOf(answer)],
      chordId: answer.id,
    );
  }
}

/// Leer el diagrama: se ve una posición y hay que decir qué acorde es.
class ReadDiagramGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ReadDiagramGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<Chord> pool = chordPoolFor(_repository, level);
    final Chord answer = pool[random.nextInt(pool.length)];
    final int count = level == MiniGameLevel.hard ? 6 : 4;
    final List<Chord> options = chordOptions(random, answer, pool, count)
      ..shuffle(random);
    return QuizQuestion(
      kind: MiniGameKind.readDiagram,
      choices: _chordChoices(options),
      answer: <int>[options.indexOf(answer)],
      chordId: answer.id,
      variantIndex: easiestVariantIndex(answer),
      diagram: QuizDiagram.fingers,
    );
  }
}

/// ¿Qué dedo?: se ve la posición sin números y hay que decir el dedo.
class FingerQuizGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const FingerQuizGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<Chord> pool = chordPoolFor(
      _repository,
      level,
    ).where((Chord chord) => _pressedStrings(chord).isNotEmpty).toList();
    final List<Chord> source = pool.isEmpty ? _repository.chords : pool;
    final Chord chord = source[random.nextInt(source.length)];
    final List<int> pressed = _pressedStrings(chord);
    final int stringIndex = pressed[random.nextInt(pressed.length)];
    final int finger = chord.easiestVariant.fingers[stringIndex];
    return QuizQuestion(
      kind: MiniGameKind.fingerQuiz,
      choices: <QuizChoice>[
        for (int f = 1; f <= 4; f++) QuizChoice(ChoiceType.finger, '$f'),
      ],
      answer: <int>[finger - 1],
      chordId: chord.id,
      variantIndex: easiestVariantIndex(chord),
      stringNumber: 6 - stringIndex,
      diagram: QuizDiagram.plain,
    );
  }

  /// Índices (0 = sexta) de las cuerdas pisadas con un dedo del 1 al 4.
  List<int> _pressedStrings(Chord chord) {
    final List<int> frets = chord.easiestVariant.frets;
    final List<int> fingers = chord.easiestVariant.fingers;
    return <int>[
      for (int s = 0; s < frets.length; s++)
        if (frets[s] > 0 && fingers[s] >= 1 && fingers[s] <= 4) s,
    ];
  }
}
