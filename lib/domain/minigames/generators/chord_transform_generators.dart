import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Opciones de un acorde transformado: el correcto y los que resultan de
/// equivocarse (el sentido contrario, un semitono de más o de menos…).
ShuffledChoices transformChoices(
  math.Random random,
  ChordSymbol answer,
  List<ChordSymbol> plausible,
  int count,
) {
  final List<ChordSymbol> near = <ChordSymbol>[
    for (final int step in <int>[1, -1, 2, -2]) answer.transpose(step),
  ]..shuffle(random);
  return shuffleChoices(
    random,
    symbolChoice(answer),
    distractorSymbols(answer, <ChordSymbol>[
      ...plausible,
      ...near,
    ], count - 1).map(symbolChoice),
  );
}

/// Transporta: subir o bajar semitonos y tocar con capo.
class TransposeChordGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const TransposeChordGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<String> kinds = switch (level) {
      MiniGameLevel.easy => <String>['capoSounds', 'up'],
      _ => <String>['capoSounds', 'capoShape', 'up', 'down'],
    };
    final String kind = kinds[random.nextInt(kinds.length)];
    final int count = choiceCountFor(level, hard: 5);
    final int amount =
        1 +
        random.nextInt(
          kind.startsWith('capo')
              ? choiceCountFor(level, easy: 4, medium: 7, hard: 9)
              : choiceCountFor(level, easy: 4, medium: 6, hard: 11),
        );
    return switch (kind) {
      'capoSounds' => _capo(random, level, amount, count, shapeFirst: true),
      'capoShape' => _capo(random, level, amount, count, shapeFirst: false),
      _ => _semitones(random, level, kind == 'up' ? amount : -amount, count),
    };
  }

  QuizQuestion _semitones(
    math.Random random,
    MiniGameLevel level,
    int amount,
    int count,
  ) {
    final Chord chord = pickChord(
      _repository,
      random,
      level,
      studyQualities(_repository, level),
    );
    final ChordSymbol from = ChordSymbol(chord.root.pitchClass, chord.quality);
    final ChordSymbol answer = from.transpose(amount);
    final ShuffledChoices shuffled = transformChoices(
      random,
      answer,
      <ChordSymbol>[from.transpose(-amount), from],
      count,
    );
    return QuizQuestion(
      kind: MiniGameKind.transposeChord,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      detail: amount > 0 ? 'up' : 'down',
      params: <String, String>{'chord': from.name, 'n': '${amount.abs()}'},
    );
  }

  /// Con capo: de la forma al acorde que suena ([shapeFirst]) o del acorde que
  /// se quiere a la forma que hay que tocar.
  QuizQuestion _capo(
    math.Random random,
    MiniGameLevel level,
    int capo,
    int count, {
    required bool shapeFirst,
  }) {
    final List<Chord> open = <Chord>[
      for (final Chord c in chordPoolFor(_repository, level))
        if (c.variants.any((ChordVariant v) => v.tags.contains('open'))) c,
    ];
    final List<Chord> source = open.isEmpty ? _repository.chords : open;
    final Chord chord = source[random.nextInt(source.length)];
    final ChordSymbol shape = ChordSymbol(chord.root.pitchClass, chord.quality);
    final ChordSymbol sounds = shape.transpose(capo);
    final ShuffledChoices shuffled = shapeFirst
        ? transformChoices(random, sounds, <ChordSymbol>[
            shape.transpose(-capo),
          ], count)
        : transformChoices(random, shape, <ChordSymbol>[
            sounds.transpose(capo),
          ], count);
    return QuizQuestion(
      kind: MiniGameKind.transposeChord,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      detail: shapeFirst ? 'capoSounds' : 'capoShape',
      params: <String, String>{
        'chord': shapeFirst ? shape.name : sounds.name,
        'n': '$capo',
      },
    );
  }
}

/// Un salto armónico: cómo se llega de un acorde a otro.
typedef _Relation = ({String id, ChordSymbol? Function(ChordSymbol) apply});

ChordSymbol? _ifMajor(ChordSymbol s, int step) =>
    s.quality == ChordQuality.major
    ? ChordSymbol((s.root + step) % 12, ChordQuality.major)
    : null;

ChordSymbol? _ifTriad(ChordSymbol s, int step) =>
    s.quality == ChordQuality.major || s.quality == ChordQuality.minor
    ? s.transpose(step)
    : null;

final List<_Relation> _relations = <_Relation>[
  (
    id: 'relative',
    apply: (ChordSymbol s) => switch (s.quality) {
      ChordQuality.major => ChordSymbol((s.root + 9) % 12, ChordQuality.minor),
      ChordQuality.minor => ChordSymbol((s.root + 3) % 12, ChordQuality.major),
      _ => null,
    },
  ),
  (id: 'dominant', apply: (ChordSymbol s) => _ifMajor(s, 7)),
  (id: 'subdominant', apply: (ChordSymbol s) => _ifMajor(s, 5)),
  (id: 'fifthUp', apply: (ChordSymbol s) => _ifTriad(s, 7)),
  (id: 'fifthDown', apply: (ChordSymbol s) => _ifTriad(s, 5)),
  (
    id: 'parallel',
    apply: (ChordSymbol s) => switch (s.quality) {
      ChordQuality.major => ChordSymbol(s.root, ChordQuality.minor),
      ChordQuality.minor => ChordSymbol(s.root, ChordQuality.major),
      _ => null,
    },
  ),
  (
    id: 'tritone',
    apply: (ChordSymbol s) => s.quality == ChordQuality.seven
        ? ChordSymbol((s.root + 6) % 12, ChordQuality.seven)
        : null,
  ),
];

/// Relaciones que se preguntan en cada nivel.
List<String> relationsFor(MiniGameLevel level) => switch (level) {
  MiniGameLevel.easy => <String>['relative', 'dominant'],
  MiniGameLevel.medium => <String>[
    'relative',
    'dominant',
    'subdominant',
    'fifthUp',
    'fifthDown',
  ],
  MiniGameLevel.hard => <String>[for (final _Relation r in _relations) r.id],
};

/// Relativo, dominante, subdominante, círculo de quintas, paralelo y
/// sustitución de tritono.
class ChordNeighborGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ChordNeighborGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<String> ids = relationsFor(level);
    final String id = ids[random.nextInt(ids.length)];
    final _Relation relation = _relations.firstWhere(
      (_Relation r) => r.id == id,
    );
    final ChordSymbol source = _source(random, level, id);
    final ChordSymbol answer = relation.apply(source)!;
    final List<ChordSymbol> plausible =
        <ChordSymbol>[
            for (final _Relation other in _relations)
              if (other.id != id && other.apply(source) != null)
                other.apply(source)!,
          ]
          ..shuffle(random)
          ..addAll(<ChordSymbol>[source.transpose(7), source.transpose(5)]);
    final ShuffledChoices shuffled = transformChoices(
      random,
      answer,
      plausible,
      choiceCountFor(level, hard: 5),
    );
    return QuizQuestion(
      kind: MiniGameKind.chordNeighbors,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      detail: id == 'relative'
          ? (source.quality == ChordQuality.major
                ? 'relativeMinor'
                : 'relativeMajor')
          : id,
      params: <String, String>{'chord': source.name},
    );
  }

  ChordSymbol _source(math.Random random, MiniGameLevel level, String id) {
    final List<ChordQuality> qualities = switch (id) {
      'tritone' => <ChordQuality>[ChordQuality.seven],
      'dominant' || 'subdominant' => <ChordQuality>[ChordQuality.major],
      _ => <ChordQuality>[ChordQuality.major, ChordQuality.minor],
    };
    final Chord chord = pickChord(_repository, random, level, qualities);
    return ChordSymbol(chord.root.pitchClass, chord.quality);
  }
}
