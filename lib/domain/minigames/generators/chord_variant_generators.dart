import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_inversion.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/services/chord_inversion.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';

/// Posición del acorde que suena: la recomendada en fácil, una al azar (de
/// dificultad razonable y con la raíz en el bajo) después, para que no se
/// reconozca por una sola forma.
int soundingVariantIndex(math.Random random, Chord chord, MiniGameLevel level) {
  if (level == MiniGameLevel.easy) {
    return easiestVariantIndex(chord);
  }
  final List<int> candidates = <int>[
    for (int i = 0; i < chord.variants.length; i++)
      if (chord.variants[i].difficulty.level <= 3 &&
          !chord.variants[i].tags.contains('inversion'))
        i,
  ];
  return candidates.isEmpty
      ? easiestVariantIndex(chord)
      : candidates[random.nextInt(candidates.length)];
}

/// ¿Qué variante es?: suena un acorde con una raíz dada y hay que decir cuál
/// de las variantes parecidas (`C`, `C7`, `Cmaj7`, `C6`, `Csus4`…) es.
class ChordVariantEarGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ChordVariantEarGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ChordQuality> qualities = studyQualities(_repository, level);
    final Chord chord = pickChord(_repository, random, level, qualities);
    final int root = chord.root.pitchClass;
    final List<Chord> others = <Chord>[
      for (final ChordQuality q in nearestQualities(
        random,
        chord.quality,
        qualities,
        choiceCountFor(level) - 1,
      ))
        if (chordOfRoot(_repository, root, q) case final Chord other) other,
    ];
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      chordChoice(chord),
      others.map(chordChoice),
    );
    final int variant = soundingVariantIndex(random, chord, level);
    return QuizQuestion(
      kind: MiniGameKind.chordVariantEar,
      cues: <SoundCue>[ChordCue(chord.id, variantIndex: variant)],
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: chord.id,
      variantIndex: variant,
      note: noteNameOfPitchClass(root),
    );
  }
}

/// Una posición del banco con su inversión.
typedef _Voicing = ({Chord chord, int variant, ChordInversion inversion});

/// Inversiones: ¿en estado fundamental, primera, segunda o tercera?
///
/// En fácil y medio se lee el diagrama; en difícil solo se escucha.
class InversionGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const InversionGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<_Voicing> voicings = _voicings(level);
    final List<ChordInversion> available = <ChordInversion>{
      for (final _Voicing v in voicings) v.inversion,
    }.toList()..shuffle(random);
    final ChordInversion wanted = available.first;
    final List<_Voicing> matching = <_Voicing>[
      for (final _Voicing v in voicings)
        if (v.inversion == wanted) v,
    ];
    final _Voicing pick = matching[random.nextInt(matching.length)];
    final bool ear = level == MiniGameLevel.hard;
    return QuizQuestion(
      kind: MiniGameKind.inversion,
      cues: ear
          ? <SoundCue>[ChordCue(pick.chord.id, variantIndex: pick.variant)]
          : const <SoundCue>[],
      choices: <QuizChoice>[
        for (final ChordInversion i in _options(pick.chord))
          QuizChoice(ChoiceType.inversion, i.name),
      ],
      answer: <int>[_options(pick.chord).indexOf(pick.inversion)],
      chordId: pick.chord.id,
      variantIndex: pick.variant,
      diagram: ear ? QuizDiagram.none : QuizDiagram.fingers,
      params: <String, String>{'chord': pick.chord.name},
    );
  }

  /// Opciones de respuesta: fundamental, 1ª y 2ª, y la 3ª si el acorde tiene
  /// séptima (o sexta) que pueda ir en el bajo.
  List<ChordInversion> _options(Chord chord) => <ChordInversion>[
    ChordInversion.root,
    ChordInversion.first,
    ChordInversion.second,
    if (chord.quality.intervals.any(
      (int i) => inversionOf(chord.quality, i) == ChordInversion.third,
    ))
      ChordInversion.third,
  ];

  /// Posiciones con nombre de inversión del nivel; si el banco no tiene
  /// ninguna con ese filtro se amplía a todos los acordes de tres notas o más.
  List<_Voicing> _voicings(MiniGameLevel level) {
    final int maxNotes = level == MiniGameLevel.easy ? 3 : 99;
    final List<_Voicing> strict = _collect(
      (Chord c) => c.quality.intervals.length <= maxNotes && _isTriad(c, level),
    );
    if (strict.isNotEmpty) {
      return strict;
    }
    final List<_Voicing> any = _collect((Chord c) => true);
    if (any.isEmpty) {
      throw StateError('El banco no tiene posiciones con inversión');
    }
    return any;
  }

  List<_Voicing> _collect(bool Function(Chord chord) keep) => <_Voicing>[
    for (final Chord chord in _repository.chords)
      if (keep(chord)) ..._voicingsOf(chord),
  ];

  /// Las posiciones de [chord] cuyo bajo es una de sus notas básicas.
  Iterable<_Voicing> _voicingsOf(Chord chord) sync* {
    for (int v = 0; v < chord.variants.length; v++) {
      final ChordInversion? inversion = variantInversion(
        chord,
        chord.variants[v],
      );
      if (inversion != null && _options(chord).contains(inversion)) {
        yield (chord: chord, variant: v, inversion: inversion);
      }
    }
  }

  /// En fácil solo mayores y menores; después, cualquier acorde.
  bool _isTriad(Chord chord, MiniGameLevel level) =>
      level != MiniGameLevel.easy ||
      chord.quality == ChordQuality.major ||
      chord.quality == ChordQuality.minor;
}

/// Raíz y bajo: ¿en qué cuerda está la raíz más grave? ¿qué nota hace de bajo?
///
/// Se lee el diagrama de una posición del banco. En difícil se prefieren las
/// inversiones, donde el bajo ya no es la raíz.
class RootAndBassGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const RootAndBassGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<ChordQuality> qualities = studyQualities(_repository, level);
    final bool bassFirst = random.nextBool() || level == MiniGameLevel.hard;
    for (int attempt = 0; attempt < 40; attempt++) {
      final Chord chord = pickChord(_repository, random, level, qualities);
      final int variant = _variantFor(random, chord, level);
      final ChordVariant position = chord.variants[variant];
      final QuizQuestion? question = bassFirst
          ? _bass(random, level, chord, variant, position)
          : _rootString(random, level, chord, variant, position);
      if (question != null) {
        return question;
      }
    }
    final Chord fallback = _repository.chords.first;
    return _bass(random, level, fallback, 0, fallback.variants.first) ??
        (throw StateError('El banco no tiene posiciones con bajo'));
  }

  int _variantFor(math.Random random, Chord chord, MiniGameLevel level) {
    final int maxDifficulty = switch (level) {
      MiniGameLevel.easy => 2,
      MiniGameLevel.medium => 3,
      MiniGameLevel.hard => 5,
    };
    final List<int> candidates = <int>[
      for (int i = 0; i < chord.variants.length; i++)
        if (chord.variants[i].difficulty.level <= maxDifficulty &&
            (level != MiniGameLevel.hard ||
                chord.variants[i].tags.contains('inversion')))
          i,
    ];
    return candidates.isEmpty
        ? easiestVariantIndex(chord)
        : candidates[random.nextInt(candidates.length)];
  }

  QuizQuestion? _rootString(
    math.Random random,
    MiniGameLevel level,
    Chord chord,
    int variant,
    ChordVariant position,
  ) {
    final int? rootIndex = rootStringIndex(chord, position);
    if (rootIndex == null) {
      return null;
    }
    final int rootPc = chord.root.pitchClass;
    final List<int> others = <int>[
      for (final int s in soundingStrings(position.frets))
        if (pitchClassAtString(s, position.frets[s]) != rootPc) 6 - s,
    ]..shuffle(random);
    if (others.length < 2) {
      return null;
    }
    final List<int> numbers = <int>[
      6 - rootIndex,
      ...others.take(choiceCountFor(level) - 1),
    ]..sort();
    return QuizQuestion(
      kind: MiniGameKind.rootAndBass,
      choices: <QuizChoice>[
        for (final int n in numbers) QuizChoice(ChoiceType.stringNumber, '$n'),
      ],
      answer: <int>[numbers.indexOf(6 - rootIndex)],
      chordId: chord.id,
      variantIndex: variant,
      diagram: QuizDiagram.fingers,
      detail: 'rootString',
      params: <String, String>{'chord': chord.name},
    );
  }

  QuizQuestion? _bass(
    math.Random random,
    MiniGameLevel level,
    Chord chord,
    int variant,
    ChordVariant position,
  ) {
    final int? bass = bassPitchClass(position);
    if (bass == null) {
      return null;
    }
    final List<int> tones = pitchClassesOfChord(chord).toList()
      ..remove(bass)
      ..shuffle(random);
    final List<int> decoys = <int>[
      ...tones,
      for (final int pc in (kAllPitchClasses.toList()..shuffle(random)))
        if (pc != bass && !tones.contains(pc)) pc,
    ];
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      noteChoice(bass),
      decoys.take(choiceCountFor(level, hard: 5) - 1).map(noteChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.rootAndBass,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: chord.id,
      variantIndex: variant,
      diagram: QuizDiagram.fingers,
      detail: 'bassNote',
      params: <String, String>{'chord': chord.name},
    );
  }
}
