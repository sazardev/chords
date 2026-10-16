/// Todas las posiciones candidatas de un acorde (raíz + calidad).
///
/// Une las formas del catálogo con los voicings que encuentra el buscador,
/// descarta las repetidas y las deja ordenadas de la más sencilla a la más
/// difícil, de modo que la primera es siempre la que conviene aprender antes.
library;

import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import '../chord_variant_draft.dart';
import 'shape_variants.dart';
import 'variant_difficulty.dart';
import 'voicing_search.dart';

/// Máximo de posiciones por acorde (las formas del catálogo no se recortan).
const int kMaxVariantsPerChord = 12;

/// Voicings buscados que se conservan como mínimo aunque haya muchas formas.
const int kMinSearchedVariants = 3;

/// Dificultad mínima de un voicing buscado: no son los acordes de siempre.
const int kSearchedFloor = 2;

/// Posiciones de [root] y [quality] sin repetir y en orden de aprendizaje.
///
/// Las formas del catálogo (curadas a mano) entran siempre; los voicings que
/// encuentra el buscador completan hasta [kMaxVariantsPerChord], los más
/// sencillos primero.
List<VariantDraft> buildChordDrafts(ChordRoot root, ChordQuality quality) {
  final Set<String> seen = <String>{};
  final List<VariantDraft> shapes = <VariantDraft>[
    for (final VariantDraft d in buildShapeVariants(root, quality))
      if (seen.add(d.frets.join(','))) d,
  ];
  final List<VariantDraft> searched = <VariantDraft>[
    for (final VariantDraft d in buildSearchedVoicings(root, quality))
      if (seen.add(d.frets.join(','))) _rate(d, quality),
  ]..sort(byLearningOrder);
  final int room = math.max(
    kMinSearchedVariants,
    kMaxVariantsPerChord - shapes.length,
  );
  return <VariantDraft>[...shapes, ...searched.take(room)]
    ..sort(byLearningOrder);
}

VariantDraft _rate(VariantDraft draft, ChordQuality quality) {
  final VariantDraft? playable = withPlayableFingering(draft);
  final int floor = math.max(kSearchedFloor, quality.minDifficulty);
  return playable == null ? draft : rated(playable, floor: floor);
}

/// Orden de aprendizaje: primero las formas de siempre (de la más fácil a la
/// más difícil) y después los voicings buscados, también por dificultad.
///
/// La primera es la recomendada. Dentro de cada dificultad van antes las
/// tríadas que los shells y los drops, y las de traste más bajo.
int byLearningOrder(VariantDraft a, VariantDraft b) {
  final int byGroup = (a.kind == VariantKind.shape ? 0 : 1).compareTo(
    b.kind == VariantKind.shape ? 0 : 1,
  );
  if (byGroup != 0) {
    return byGroup;
  }
  final int byDifficulty = a.difficulty.level.compareTo(b.difficulty.level);
  if (byDifficulty != 0) {
    return byDifficulty;
  }
  final int byKind = _kindRank(a).compareTo(_kindRank(b));
  if (byKind != 0) {
    return byKind;
  }
  final int byFret = _lowestFret(a).compareTo(_lowestFret(b));
  return byFret != 0 ? byFret : a.id.compareTo(b.id);
}

/// 0 formas del catálogo, 1 tríadas, 2 shells y voicings buscados.
int _kindRank(VariantDraft draft) => switch (draft.kind) {
  VariantKind.shape => 0,
  VariantKind.triad => 1,
  _ => 2,
};

int _lowestFret(VariantDraft draft) {
  final List<int> pressed = <int>[
    for (final int fret in draft.frets)
      if (fret > 0) fret,
  ];
  return pressed.isEmpty ? 0 : pressed.reduce(math.min);
}
