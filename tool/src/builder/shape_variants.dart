/// Posiciones derivadas de las formas movibles transportadas.
///
/// Cada forma del catálogo se transpone a la raíz pedida; si la transposición
/// se sale del mástil razonable, la forma se descarta.
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

import '../chord_shape_catalog.dart';
import '../chord_shape_spec.dart';
import '../chord_theory.dart';
import '../chord_variant_draft.dart';
import '../fingering/fingering_rules.dart';
import '../fingering/fingering_solver.dart';
import 'variant_difficulty.dart';

/// Forma movible ya transportada a una raíz concreta.
class TransposedShape {
  /// Crea la forma transportada.
  const TransposedShape(this.barre, this.frets);

  /// Traste donde cae el cejillo (0 = posición abierta).
  final int barre;

  /// Trastes por cuerda (`-1` = cuerda muda).
  final List<int> frets;
}

/// Posiciones que dan las formas del catálogo para [root] y [quality].
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
    final VariantDraft? playable = withPlayableFingering(
      draftFromShape(spec, shape),
    );
    if (playable != null) {
      result.add(
        rated(
          playable,
          floor: quality.minDifficulty,
          hint: shape.barre == 0 ? spec.difficultyOpen : spec.difficultyBarre,
        ),
      );
    }
  }
  return result;
}

/// Deja a la posición una digitación que la mano pueda hacer.
///
/// Conserva la del catálogo si es válida; si no, busca otra. Devuelve `null`
/// si ninguna digitación es posible (p. ej. una apertura de más de cuatro
/// trastes). El cejillo se deduce siempre de los dedos finales.
VariantDraft? withPlayableFingering(VariantDraft draft) {
  final List<int>? fingers = fingeringIssues(draft.frets, draft.fingers).isEmpty
      ? draft.fingers
      : solveFingering(draft.frets);
  return fingers == null ? null : draft.withFingers(fingers);
}

/// Transporta una forma a la raíz indicada.
///
/// Se elige la posición más baja que cabe en el mástil (con el cejillo
/// negativo si la forma no usa cuerdas al aire, p. ej. `x3434x` en Si baja un
/// traste). Devuelve `null` si algún traste queda por encima del 14, si la
/// forma solo vale abierta y cae más arriba o si el cejillo pasa del máximo.
TransposedShape? transposeShape(MovableShapeSpec spec, ChordRoot root) {
  final int openPc = kStringTuning[spec.rootString] % 12;
  final int offset = spec.fretOffsets[spec.rootString]!;
  final int minOffset = spec.fretOffsets.whereType<int>().reduce(
    (int a, int b) => a < b ? a : b,
  );
  int barre = (root.pitchClass + spec.anchorSemitones - openPc - offset) % 12;
  if (barre - 12 + minOffset >= 0) {
    barre -= 12;
  }
  if ((spec.openOnly && barre != 0) || barre > spec.maxBarre) {
    return null;
  }
  final List<int> frets = <int>[
    for (final int? relative in spec.fretOffsets)
      if (relative == null) -1 else barre + relative,
  ];
  return frets.any((int f) => f > 14) ? null : TransposedShape(barre, frets);
}

/// Convierte una forma transportada en posición candidata.
VariantDraft draftFromShape(MovableShapeSpec spec, TransposedShape shape) =>
    VariantDraft(
      id: '${spec.id}-${shape.barre + _minOffset(spec)}',
      shapeLabel: spec.positionLabel,
      frets: shape.frets,
      fingers: List<int>.of(
        shape.barre == 0 ? spec.fingersOpen : spec.fingersBarre,
      ),
      difficulty: difficultyForLevel(1),
    );

int _minOffset(MovableShapeSpec spec) =>
    spec.fretOffsets.whereType<int>().reduce((int a, int b) => a < b ? a : b);
