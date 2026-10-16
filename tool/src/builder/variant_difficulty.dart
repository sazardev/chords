/// Dificultad final de una posición ya digitada.
library;

import 'dart:math' as math;

import 'package:chords/domain/chords/entities/difficulty.dart';

import '../chord_variant_draft.dart';
import '../fingering/physical_difficulty.dart';

/// Resuelve un nivel de dificultad tolerante (por defecto intermedio).
Difficulty difficultyForLevel(int level) =>
    Difficulty.fromLevel(level) ?? Difficulty.medium;

/// Pone a [draft] la dificultad que exige su digitación.
///
/// El nivel nunca baja de [floor] (lo que exige entender el acorde) y la
/// opinión de la forma, [hint], solo puede subirlo un punto sobre lo que
/// exige la mano.
VariantDraft rated(VariantDraft draft, {int floor = 1, int hint = 1}) {
  final int physical = physicalDifficulty(draft.frets, draft.fingers);
  final int cappedHint = math.min(hint, physical + 1);
  final int level = math.max(physical, math.max(floor, cappedHint));
  return draft.withDifficulty(difficultyForLevel(level));
}
