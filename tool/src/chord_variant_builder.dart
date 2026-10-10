/// Constructor de posiciones candidatas a partir del catálogo de formas y de
/// la búsqueda de tríadas.
///
/// Cada estrategia de construcción vive en su propio archivo pequeño: las
/// formas movibles (transposición de cejillo) y las tríadas (búsqueda de la
/// digitación más económica sobre un grupo de cuerdas).
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';

import 'chord_shape_catalog.dart';
import 'chord_shape_spec.dart';
import 'chord_theory.dart';
import 'chord_variant_draft.dart';

/// Forma movible ya transportada a una raíz concreta.
class TransposedShape {
  /// Crea la forma transportada.
  const TransposedShape(this.barre, this.frets);

  /// Traste donde cae el cejillo (0 = posición abierta).
  final int barre;

  /// Trastes por cuerda (`-1` = cuerda muda).
  final List<int> frets;
}

/// Posiciones derivadas de las formas movibles transportadas.
///
/// Cada forma del catálogo se transpone a la raíz pedida; si la transposición
/// se sale del mástil razonable, la forma se descarta.
List<VariantDraft> buildShapeVariants(ChordRoot root, ChordQuality quality) {
  final List<VariantDraft> result = <VariantDraft>[];
  for (final MovableShapeSpec spec in kMovableShapes) {
    if (spec.qualityId != quality.id) {
      continue;
    }
    final TransposedShape? shape = transposeShape(spec, root);
    if (shape == null) {
      continue;
    }
    result.add(draftFromShape(spec, shape));
  }
  return result;
}

/// Transporta una forma a la raíz indicada.
///
/// Devuelve `null` si algún traste queda por encima del traste 14, donde la
/// posición deja de ser práctica.
TransposedShape? transposeShape(MovableShapeSpec spec, ChordRoot root) {
  final int openPc = kStringTuning[spec.rootString] % 12;
  final int offset = spec.fretOffsets[spec.rootString]!;
  final int barre = (root.pitchClass - openPc - offset) % 12;
  final List<int> frets = <int>[];
  for (int string = 0; string < kStringCount; string++) {
    final int? relative = spec.fretOffsets[string];
    if (relative == null) {
      frets.add(-1);
      continue;
    }
    final int fret = barre + relative;
    if (fret > 14) {
      return null;
    }
    frets.add(fret);
  }
  return TransposedShape(barre, frets);
}

/// Convierte una forma transportada en posición candidata.
VariantDraft draftFromShape(MovableShapeSpec spec, TransposedShape shape) {
  final List<int> barredStrings = <int>[
    for (int string = 0; string < kStringCount; string++)
      if (shape.barre > 0 && shape.frets[string] == shape.barre) string,
  ];
  return VariantDraft(
    id: '${spec.id}-${shape.barre}',
    frets: shape.frets,
    fingers: List<int>.of(
      shape.barre == 0 ? spec.fingersOpen : spec.fingersBarre,
    ),
    difficulty: difficultyForLevel(
      shape.barre == 0 ? spec.difficultyOpen : spec.difficultyBarre,
    ),
    tags: shapeTags(spec, shape.barre),
    barreFret: barredStrings.length >= 2 ? shape.barre : null,
    barreFrom: barredStrings.length >= 2 ? barredStrings.first : null,
    barreToString: barredStrings.length >= 2 ? barredStrings.last : null,
    positionLabel: shapePositionLabel(spec, shape.barre),
  );
}

/// Etiquetas de una forma transportada.
List<String> shapeTags(MovableShapeSpec spec, int barre) => <String>[
  ...spec.tags,
  if (barre == 0) 'open' else 'barre',
  if (barre >= 7) 'high-position',
];

/// Etiqueta legible de una forma transportada.
String shapePositionLabel(MovableShapeSpec spec, int barre) =>
    barre == 0 ? spec.positionLabel : '${spec.positionLabel} · traste $barre';

/// Posiciones de tríadas e inversiones sobre grupos de cuerdas.
///
/// Para cada grupo de cuerdas se prueba cada permutación de los intervalos y
/// se conserva la digitación más económica.
List<VariantDraft> buildTriadVariants(ChordRoot root, ChordQuality quality) {
  if (quality.intervals.length > 3) {
    return const <VariantDraft>[];
  }
  final List<VariantDraft> result = <VariantDraft>[];
  for (final List<int> stringSet in kTriadStringSets) {
    final VariantDraft? best = bestTriadAssignment(stringSet, root, quality);
    if (best != null) {
      result.add(best);
    }
  }
  return result;
}

/// Digitación más económica de un grupo de cuerdas para la calidad pedida.
VariantDraft? bestTriadAssignment(
  List<int> stringSet,
  ChordRoot root,
  ChordQuality quality,
) {
  VariantDraft? best;
  int bestCost = 1 << 30;
  for (final List<int> assignment in assignmentsFor(quality.intervals)) {
    final List<int>? frets = triadFrets(stringSet, root, assignment);
    if (frets == null) {
      continue;
    }
    final int cost = assignmentCost(stringSet, frets);
    if (cost >= bestCost) {
      continue;
    }
    bestCost = cost;
    best = draftFromTriad(stringSet, root, assignment, frets);
  }
  return best;
}

/// Trastes de una permutación sobre el grupo de cuerdas.
///
/// Devuelve `null` si alguna nota no cabe en el mástil razonable.
List<int>? triadFrets(
  List<int> stringSet,
  ChordRoot root,
  List<int> assignment,
) {
  final List<int> frets = List<int>.filled(kStringCount, -1);
  for (int index = 0; index < stringSet.length; index++) {
    final int? fret = fretForNoteOnString(
      stringSet[index],
      noteNameOfPitchClass((root.pitchClass + assignment[index]) % 12),
    );
    if (fret == null || fret > 12) {
      return null;
    }
    frets[stringSet[index]] = fret;
  }
  return frets;
}

/// Coste de una digitación: castiga los trastes altos y los estiramientos.
int assignmentCost(List<int> stringSet, List<int> frets) {
  final List<int> pressed = stringSet.map((int s) => frets[s]).toList();
  final int maxFret = pressed.reduce(_max);
  final int minFret = pressed.reduce(_min);
  final int span = maxFret - minFret;
  return maxFret * 3 + span * 2 + pressed.fold<int>(0, _add);
}

/// Convierte una permutación aceptada en posición candidata.
VariantDraft draftFromTriad(
  List<int> stringSet,
  ChordRoot root,
  List<int> assignment,
  List<int> frets,
) {
  final int maxFret = stringSet.map((int s) => frets[s]).reduce(_max);
  final int minFret = stringSet.map((int s) => frets[s]).reduce(_min);
  final int span = maxFret - minFret;
  final String lowestNote = noteNameOfPitchClass(
    (root.pitchClass + assignment.first) % 12,
  );
  return VariantDraft(
    id: 'triad-${_setId(stringSet)}-$lowestNote',
    frets: frets,
    fingers: triadFingers(stringSet, frets),
    difficulty: difficultyForLevel(span <= 2 && maxFret <= 5 ? 2 : 3),
    tags: const <String>['triad', 'inversion'],
    positionLabel: 'Triada ${_setLabel(stringSet)} · bajo en $lowestNote',
  );
}

/// Dedos para una tríada: por orden de traste dentro del grupo de cuerdas.
List<int> triadFingers(List<int> stringSet, List<int> frets) {
  final List<int> fingers = List<int>.filled(kStringCount, 0);
  final Map<int, int> byFret = <int, int>{};
  int next = 1;
  for (final int string in stringSet) {
    final int fret = frets[string];
    if (fret == 0) {
      continue;
    }
    fingers[string] = byFret.putIfAbsent(fret, () => next++);
  }
  return fingers;
}

/// Permutaciones de los intervalos de la calidad sobre 3 cuerdas.
///
/// Las calidades de dos notas (power chords) duplican una de las dos notas
/// para cubrir el grupo de 3 cuerdas.
List<List<int>> assignmentsFor(List<int> intervals) {
  if (intervals.length == 1) {
    return <List<int>>[
      <int>[intervals[0], intervals[0], intervals[0]],
    ];
  }
  if (intervals.length == 2) {
    final int a = intervals[0];
    final int b = intervals[1];
    return <List<int>>[
      <int>[a, b, a],
      <int>[a, a, b],
      <int>[b, a, a],
      <int>[a, b, b],
      <int>[b, a, b],
      <int>[b, b, a],
    ];
  }
  return _permutations(intervals);
}

/// Permutaciones de los intervalos de la calidad (hasta 3 notas).
List<List<int>> _permutations(List<int> items) {
  if (items.length == 1) {
    return <List<int>>[
      <int>[items[0]],
    ];
  }
  if (items.length == 2) {
    return <List<int>>[
      <int>[items[0], items[1]],
      <int>[items[1], items[0]],
    ];
  }
  final List<List<int>> result = <List<int>>[];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (j == i) {
        continue;
      }
      for (int k = 0; k < 3; k++) {
        if (k == i || k == j) {
          continue;
        }
        result.add(<int>[items[i], items[j], items[k]]);
      }
    }
  }
  return result;
}

/// Identificador corto del grupo de cuerdas.
String _setId(List<int> stringSet) => switch (stringSet.first) {
  1 => 'adg',
  2 => 'dgb',
  _ => 'gbe',
};

/// Etiqueta legible del grupo de cuerdas.
String _setLabel(List<int> stringSet) => switch (stringSet.first) {
  1 => 'A-D-G',
  2 => 'D-G-B',
  _ => 'G-B-e',
};

/// Resuelve un nivel de dificultad tolerante (por defecto intermedio).
Difficulty difficultyForLevel(int level) =>
    Difficulty.fromLevel(level) ?? Difficulty.medium;

int _max(int a, int b) => a > b ? a : b;

int _min(int a, int b) => a < b ? a : b;

int _add(int a, int b) => a + b;
