import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/services/caged_shape.dart';
import 'package:chords/domain/minigames/services/voicing_flaws.dart';

/// Diagrama incorrecto: varios diagramas de un mismo acorde y uno con un
/// error (nota ajena, cuerda sin mutear o falta una nota que lo define).
///
/// Los correctos son posiciones del banco; el erróneo sale de estropear otra
/// posición y se comprueba que de verdad deja de ser el acorde.
class WrongDiagramGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const WrongDiagramGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final int valid = choiceCountFor(level, hard: 4) - 1;
    final List<ChordQuality> qualities = <ChordQuality>[
      for (final ChordQuality q in studyQualities(_repository, level))
        if (q.intervals.length >= 3) q,
    ];
    for (int attempt = 0; attempt < 200; attempt++) {
      final Chord chord = pickChord(_repository, random, level, qualities);
      final QuizQuestion? question = _build(random, chord, valid);
      if (question != null) {
        return question;
      }
    }
    for (final Chord chord in _repository.chords) {
      final QuizQuestion? question = _build(random, chord, valid);
      if (question != null) {
        return question;
      }
    }
    throw StateError('El banco no tiene posiciones para un diagrama erróneo');
  }

  QuizQuestion? _build(math.Random random, Chord chord, int valid) {
    final Map<String, ChordVariant> unique = <String, ChordVariant>{
      for (final ChordVariant v in chord.variants) _key(v.frets): v,
    };
    if (unique.length < valid + 1) {
      return null;
    }
    final List<ChordVariant> shuffled = unique.values.toList()..shuffle(random);
    final List<ChordVariant> shown = shuffled.take(valid).toList();
    final FlawedVoicing? flawed = flawVoicing(random, chord, shuffled[valid]);
    if (flawed == null || unique.containsKey(_key(flawed.frets))) {
      return null;
    }
    final QuizChoice wrong = _choice(flawed.frets);
    final ShuffledChoices all = shuffleChoices(
      random,
      wrong,
      shown.map((ChordVariant v) => _choice(v.frets)),
    );
    return QuizQuestion(
      kind: MiniGameKind.wrongDiagram,
      choices: all.choices,
      answer: <int>[all.answer],
      chordId: chord.id,
      stringNumber: flawed.stringNumber,
      note: noteNameOfPitchClass(flawed.pitchClass),
      detail: flawed.error.name,
      params: <String, String>{'chord': chord.name},
    );
  }

  String _key(List<int> frets) => frets.join(',');

  QuizChoice _choice(List<int> frets) =>
      QuizChoice(ChoiceType.diagram, _key(frets));
}

/// Forma CAGED: reconocer la forma de un diagrama o saber en qué traste va
/// la cejilla para tocar un acorde con una forma dada.
class CagedShapeGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const CagedShapeGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<(Chord, int, CagedShape)> shapes = _shapeVariants(level);
    final bool barre =
        shapes.isEmpty || random.nextDouble() < _barreShare(level);
    return (barre ? _barreQuestion(random, level) : null) ??
        _shapeQuestion(random, level, shapes);
  }

  double _barreShare(MiniGameLevel level) =>
      level == MiniGameLevel.easy ? 0.35 : 0.5;

  /// Diagrama → forma.
  QuizQuestion _shapeQuestion(
    math.Random random,
    MiniGameLevel level,
    List<(Chord, int, CagedShape)> options,
  ) {
    final (Chord, int, CagedShape) pick = options.isEmpty
        ? (_repository.chords.first, 0, CagedShape.e)
        : options[random.nextInt(options.length)];
    final List<CagedShape> others =
        CagedShape.values.where((CagedShape s) => s != pick.$3).toList()
          ..shuffle(random);
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      _shapeChoice(pick.$3),
      others.take(choiceCountFor(level, hard: 5) - 1).map(_shapeChoice),
    );
    return QuizQuestion(
      kind: MiniGameKind.cagedShape,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: pick.$1.id,
      variantIndex: pick.$2,
      diagram: QuizDiagram.fingers,
      detail: 'shape',
      params: <String, String>{'chord': pick.$1.name},
    );
  }

  /// Formas CAGED del banco según el nivel: abiertas en fácil, con cejilla o
  /// sin cuerdas al aire en medio y todas en difícil. Si el filtro del nivel
  /// no deja ninguna se usan todas.
  List<(Chord, int, CagedShape)> _shapeVariants(MiniGameLevel level) {
    final List<(Chord, int, CagedShape)> all = <(Chord, int, CagedShape)>[
      for (final Chord chord in _repository.chords)
        for (int v = 0; v < chord.variants.length; v++)
          if (CagedShape.ofVariant(chord.variants[v]) case final CagedShape s)
            (chord, v, s),
    ];
    bool fits((Chord, int, CagedShape) item) {
      final Set<String> tags = item.$1.variants[item.$2].tags.toSet();
      return switch (level) {
        MiniGameLevel.easy => tags.contains('open'),
        MiniGameLevel.medium =>
          tags.contains('open') ||
              tags.contains('barre') ||
              tags.contains('movable'),
        MiniGameLevel.hard => true,
      };
    }

    final List<(Chord, int, CagedShape)> picked = all.where(fits).toList();
    return picked.length >= 3 ? picked : all;
  }

  /// Acorde + forma → traste de la cejilla.
  QuizQuestion? _barreQuestion(math.Random random, MiniGameLevel level) {
    final bool minor = level == MiniGameLevel.hard && random.nextBool();
    final ChordQuality quality = minor
        ? ChordQuality.minor
        : ChordQuality.major;
    final List<CagedShape> shapes = _barreShapes(level, minor: minor);
    final List<int> roots = kAllPitchClasses.toList()..shuffle(random);
    for (final int root in roots) {
      final CagedShape shape = shapes[random.nextInt(shapes.length)];
      final int fret = shape.barreFretFor(root);
      final Chord? chord = chordOfRoot(_repository, root, quality);
      if (fret == 0 || chord == null) {
        continue;
      }
      return _barreFor(random, level, chord, shape, fret);
    }
    return null;
  }

  List<CagedShape> _barreShapes(MiniGameLevel level, {required bool minor}) {
    if (minor) {
      return <CagedShape>[CagedShape.e, CagedShape.a, CagedShape.d];
    }
    return level == MiniGameLevel.easy
        ? <CagedShape>[CagedShape.e, CagedShape.a]
        : CagedShape.values;
  }

  QuizQuestion _barreFor(
    math.Random random,
    MiniGameLevel level,
    Chord chord,
    CagedShape shape,
    int fret,
  ) {
    final int root = chord.root.pitchClass;
    final List<int> distractors =
        <int>{
            for (final CagedShape other in CagedShape.values)
              if (other != shape) other.barreFretFor(root),
            for (final int d in <int>[-2, -1, 1, 2]) fret + d,
          }.where((int f) => f >= 1 && f <= 12 && f != fret).toList()
          ..shuffle(random);
    final List<int> frets = <int>[
      fret,
      ...distractors.take(choiceCountFor(level, hard: 4) - 1),
    ]..sort();
    return QuizQuestion(
      kind: MiniGameKind.cagedShape,
      choices: fretChoices(frets),
      answer: <int>[frets.indexOf(fret)],
      chordId: chord.id,
      detail: 'barre',
      params: <String, String>{'chord': chord.name, 'shape': shape.letter},
    );
  }

  QuizChoice _shapeChoice(CagedShape shape) =>
      QuizChoice(ChoiceType.shape, shape.letter, label: shape.letter);
}
