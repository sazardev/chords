import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Raíces que se trabajan en cada nivel: notas naturales en fácil.
List<int> rootsFor(MiniGameLevel level) =>
    level == MiniGameLevel.easy ? kNaturalPitchClasses : kAllPitchClasses;

/// Calidades que tiene el banco, en el orden de la enumeración.
///
/// Se recorre `ChordQuality.values` y se queda con las que el banco usa: así
/// los juegos aprovechan solos las calidades que se añadan.
List<ChordQuality> bankQualities(ChordRepository repository) => <ChordQuality>[
  for (final ChordQuality quality in ChordQuality.values)
    if (repository.chords.any((Chord chord) => chord.quality == quality))
      quality,
];

/// Calidades que se estudian en cada nivel.
///
/// Fácil: mayor, menor y séptima. Medio: las de hasta cuatro notas.
/// Difícil: todas las del banco, incluidas las extendidas.
List<ChordQuality> studyQualities(
  ChordRepository repository,
  MiniGameLevel level,
) {
  final List<ChordQuality> all = bankQualities(repository);
  final List<ChordQuality> picked = switch (level) {
    MiniGameLevel.easy => <ChordQuality>[
      for (final ChordQuality q in all)
        if (q == ChordQuality.major ||
            q == ChordQuality.minor ||
            q == ChordQuality.seven)
          q,
    ],
    MiniGameLevel.medium => <ChordQuality>[
      for (final ChordQuality q in all)
        if (q.intervals.length <= 4) q,
    ],
    MiniGameLevel.hard => all,
  };
  return picked.length >= 3 ? picked : all;
}

/// Acorde del banco con la raíz y la calidad dadas; `null` si no existe.
Chord? chordOfRoot(
  ChordRepository repository,
  int root,
  ChordQuality quality,
) => repository.chordById(ChordSymbol(root, quality).chordId);

/// Un acorde al azar del banco con una de las [qualities]; en fácil, solo con
/// raíz natural. Si no hay ninguno, cualquiera del banco.
Chord pickChord(
  ChordRepository repository,
  math.Random random,
  MiniGameLevel level,
  Iterable<ChordQuality> qualities,
) {
  final List<int> roots = rootsFor(level);
  final List<Chord> pool = <Chord>[
    for (final Chord chord in repository.chords)
      if (qualities.contains(chord.quality) &&
          roots.contains(chord.root.pitchClass))
        chord,
  ];
  final List<Chord> source = pool.isEmpty ? repository.chords : pool;
  return source[random.nextInt(source.length)];
}

/// Opción de respuesta que nombra un acorde (`value` = su id).
QuizChoice chordChoice(Chord chord) =>
    QuizChoice(ChoiceType.chord, chord.id, label: chord.name);

/// `true` si dos acordes suenan las mismas notas (`C6` y `Am7`, o dos
/// aumentados a una tercera mayor): no se pueden dar como respuestas
/// distintas porque ambas serían correctas.
bool sameNotes(ChordSymbol a, ChordSymbol b) =>
    a.pitchClasses.length == b.pitchClasses.length &&
    a.pitchClasses.containsAll(b.pitchClasses);

/// Opción de respuesta que nombra una cifra (`value` = su id en el banco).
QuizChoice symbolChoice(ChordSymbol symbol) =>
    QuizChoice(ChoiceType.chord, symbol.chordId, label: symbol.name);

/// Hasta [count] cifras de [candidates] aptas como distractores de [answer]:
/// distintas de ella, sin sus mismas notas y sin repetirse.
List<ChordSymbol> distractorSymbols(
  ChordSymbol answer,
  Iterable<ChordSymbol> candidates,
  int count,
) {
  final List<ChordSymbol> picked = <ChordSymbol>[];
  for (final ChordSymbol candidate in candidates) {
    if (picked.length >= count) {
      break;
    }
    if (!sameNotes(answer, candidate) && !picked.contains(candidate)) {
      picked.add(candidate);
    }
  }
  return picked;
}

/// Notas distintas (módulo octava) en las que difieren dos calidades.
int qualityDistance(ChordQuality a, ChordQuality b) {
  final Set<int> left = <int>{for (final int i in a.intervals) i % 12};
  final Set<int> right = <int>{for (final int i in b.intervals) i % 12};
  return left.difference(right).length + right.difference(left).length;
}

/// Hasta [count] calidades de [pool] distintas de [answer], las más parecidas
/// primero (empates al azar): las que más cuesta distinguir.
List<ChordQuality> nearestQualities(
  math.Random random,
  ChordQuality answer,
  Iterable<ChordQuality> pool,
  int count,
) {
  final List<(ChordQuality, int, double)> ranked =
      <(ChordQuality, int, double)>[
        for (final ChordQuality q in pool)
          if (q != answer) (q, qualityDistance(answer, q), random.nextDouble()),
      ]..sort(((ChordQuality, int, double) a, (ChordQuality, int, double) b) {
        final int byDistance = a.$2.compareTo(b.$2);
        return byDistance != 0 ? byDistance : a.$3.compareTo(b.$3);
      });
  return <ChordQuality>[
    for (final (ChordQuality, int, double) r in ranked.take(count)) r.$1,
  ];
}

/// Número de opciones de respuesta según el nivel.
int choiceCountFor(
  MiniGameLevel level, {
  int easy = 3,
  int medium = 4,
  int hard = 6,
}) => switch (level) {
  MiniGameLevel.easy => easy,
  MiniGameLevel.medium => medium,
  MiniGameLevel.hard => hard,
};
