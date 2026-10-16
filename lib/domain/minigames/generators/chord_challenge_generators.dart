import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Tema de un reto con tiempo del banco.
enum RushTheme {
  /// Acordes abiertos.
  open,

  /// Acordes con cejilla.
  barre,

  /// Séptimas y acordes extendidos.
  seventh,
}

/// Una posición concreta del banco.
typedef _Position = ({Chord chord, int variant});

/// Reto con tiempo: se ve una posición del banco y hay que nombrar el acorde.
///
/// El tema decide qué posiciones salen (abiertas, con cejilla o séptimas) y
/// cuántas opciones parecidas hay; el reloj lo lleva el controlador del juego.
class RushChordGenerator implements QuizGenerator {
  /// Crea el generador de [kind] con el tema [theme].
  const RushChordGenerator(this._repository, this.kind, this.theme);

  final ChordRepository _repository;

  /// Juego que fabrica.
  final MiniGameKind kind;

  /// Tema del reto.
  final RushTheme theme;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<_Position> positions = _positions(level);
    final _Position pick = positions[random.nextInt(positions.length)];
    final List<Chord> pool = <Chord>{
      for (final _Position p in positions) p.chord,
    }.toList();
    final int count = choiceCountFor(level);
    final List<Chord> others = theme == RushTheme.seventh
        ? _sameRootSevenths(random, pick.chord, count - 1)
        : _related(random, pick.chord, pool, count - 1);
    final ShuffledChoices shuffled = shuffleChoices(
      random,
      chordChoice(pick.chord),
      others.map(chordChoice),
    );
    return QuizQuestion(
      kind: kind,
      choices: shuffled.choices,
      answer: <int>[shuffled.answer],
      chordId: pick.chord.id,
      variantIndex: pick.variant,
      diagram: QuizDiagram.fingers,
    );
  }

  List<_Position> _positions(MiniGameLevel level) {
    // Las cejillas empiezan en dificultad 3: se sube un nivel el tope.
    final int maxDifficulty =
        switch (level) {
          MiniGameLevel.easy => 2,
          MiniGameLevel.medium => 3,
          MiniGameLevel.hard => 5,
        } +
        (theme == RushTheme.barre && level != MiniGameLevel.hard ? 1 : 0);
    final List<_Position> found = <_Position>[
      for (final Chord chord in _repository.chords)
        if (_fitsTheme(chord, level))
          for (int v = 0; v < chord.variants.length; v++)
            if (_fitsVariant(chord.variants[v], maxDifficulty))
              (chord: chord, variant: v),
    ];
    return found.isEmpty
        ? <_Position>[
            (
              chord: _repository.chords.first,
              variant: easiestVariantIndex(_repository.chords.first),
            ),
          ]
        : found;
  }

  bool _fitsTheme(Chord chord, MiniGameLevel level) {
    if (theme == RushTheme.seventh) {
      return _isSeventh(chord.quality);
    }
    return switch (level) {
      MiniGameLevel.easy => chord.quality.popularity >= 5,
      MiniGameLevel.medium => chord.quality.popularity >= 3,
      MiniGameLevel.hard => true,
    };
  }

  bool _fitsVariant(ChordVariant variant, int maxDifficulty) {
    if (variant.difficulty.level > maxDifficulty) {
      return false;
    }
    return switch (theme) {
      RushTheme.open => variant.isShape && variant.tags.contains('open'),
      RushTheme.barre => variant.isShape && variant.tags.contains('barre'),
      RushTheme.seventh => true,
    };
  }

  bool _isSeventh(ChordQuality quality) =>
      quality.intervals.any((int i) => i % 12 == 10 || i % 12 == 11);

  /// Parecidos al acorde: misma raíz o misma calidad, sin sus mismas notas.
  List<Chord> _related(
    math.Random random,
    Chord answer,
    List<Chord> pool,
    int count,
  ) {
    final ChordSymbol symbol = ChordSymbol(
      answer.root.pitchClass,
      answer.quality,
    );
    return chordOptions(random, answer, pool, count + 3)
        .skip(1)
        .where(
          (Chord c) =>
              !sameNotes(symbol, ChordSymbol(c.root.pitchClass, c.quality)),
        )
        .take(count)
        .toList();
  }

  /// Séptimas de la misma raíz: lo que hay que distinguir leyendo el diagrama.
  List<Chord> _sameRootSevenths(math.Random random, Chord answer, int count) {
    final List<ChordQuality> sevenths = <ChordQuality>[
      for (final ChordQuality q in bankQualities(_repository))
        if (_isSeventh(q)) q,
    ];
    return <Chord>[
      for (final ChordQuality q in nearestQualities(
        random,
        answer.quality,
        sevenths,
        count,
      ))
        if (chordOfRoot(_repository, answer.root.pitchClass, q)
            case final Chord other)
          other,
    ];
  }
}

/// Memoria de acordes: repetir en orden una sucesión de acordes escuchada.
class ChordMemoryGenerator implements QuizGenerator {
  /// Crea el generador con el banco de acordes.
  const ChordMemoryGenerator(this._repository);

  final ChordRepository _repository;

  @override
  QuizQuestion generate(math.Random random, MiniGameLevel level, int index) {
    final List<Chord> options = _options(random, level);
    final int length = math.min(6, choiceCountFor(level, hard: 5) + index ~/ 3);
    final int gap = choiceCountFor(level, easy: 1000, medium: 900, hard: 800);
    final List<int> sequence = <int>[];
    while (sequence.length < length) {
      final int next = random.nextInt(options.length);
      if (sequence.isEmpty || sequence.last != next || options.length < 2) {
        sequence.add(next);
      }
    }
    return QuizQuestion(
      kind: MiniGameKind.chordMemory,
      cues: <SoundCue>[
        for (int i = 0; i < sequence.length; i++)
          ChordCue(
            options[sequence[i]].id,
            variantIndex: easiestVariantIndex(options[sequence[i]]),
            delayMs: i == 0 ? 0 : gap,
          ),
      ],
      choices: options.map(chordChoice).toList(),
      answer: sequence,
    );
  }

  /// Acordes que suenan distinto entre sí (sin las mismas notas).
  List<Chord> _options(math.Random random, MiniGameLevel level) {
    final int count = choiceCountFor(level, easy: 4, medium: 5);
    final List<ChordQuality> qualities = studyQualities(_repository, level);
    final List<Chord> reachable = chordPoolFor(_repository, level);
    final List<Chord> common = <Chord>[
      for (final Chord chord in reachable)
        if (qualities.contains(chord.quality)) chord,
    ];
    final List<Chord> pool = (common.length >= count ? common : reachable)
      ..shuffle(random);
    final List<Chord> picked = <Chord>[];
    for (final Chord chord in pool) {
      final ChordSymbol symbol = ChordSymbol(
        chord.root.pitchClass,
        chord.quality,
      );
      final bool repeated = picked.any(
        (Chord p) =>
            sameNotes(symbol, ChordSymbol(p.root.pitchClass, p.quality)),
      );
      if (!repeated) {
        picked.add(chord);
      }
      if (picked.length == count) {
        break;
      }
    }
    return picked;
  }
}
