/// Planes de búsqueda de voicings sobre grupos de cuerdas.
///
/// Un plan dice en qué cuerdas buscar y si se admiten inversiones. El
/// buscador (`voicing_search.dart`) los recorre para cada acorde.
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';

/// Tipo de voicing que produce un plan.
enum VoicingKind {
  /// Tres notas del acorde en tres cuerdas contiguas (tríadas e inversiones).
  triad,

  /// Raíz, tercera y séptima (sin quinta) salteando una cuerda.
  shell,

  /// Cuatro notas en cuatro cuerdas contiguas (drop 2, drop 3, cerrados).
  fourString,
}

/// Plan: grupo de cuerdas (0 = sexta) y si vale cualquier nota en el bajo.
class VoicingPlan {
  /// Crea el plan.
  const VoicingPlan(this.kind, this.strings, {this.anyBass = false});

  /// Tipo de voicing.
  final VoicingKind kind;

  /// Cuerdas que suenan, de la más grave a la más aguda.
  final List<int> strings;

  /// `true` si se buscan también las inversiones (una por nota del bajo).
  final bool anyBass;

  /// Si el plan tiene sentido para [quality].
  bool applies(ChordQuality quality) {
    final int tones = quality.intervals.length;
    final int required = quality.requiredIntervals.length;
    return switch (kind) {
      VoicingKind.triad => tones == 3,
      VoicingKind.shell =>
        tones >= 4 && required == 3 && quality.requiredIntervals.contains(0),
      VoicingKind.fourString => tones >= 4 && required <= 4,
    };
  }
}

/// Planes de búsqueda del generador.
const List<VoicingPlan> kVoicingPlans = <VoicingPlan>[
  VoicingPlan(VoicingKind.triad, <int>[1, 2, 3]),
  VoicingPlan(VoicingKind.triad, <int>[2, 3, 4], anyBass: true),
  VoicingPlan(VoicingKind.triad, <int>[3, 4, 5], anyBass: true),
  VoicingPlan(VoicingKind.shell, <int>[0, 2, 3]),
  VoicingPlan(VoicingKind.shell, <int>[1, 3, 4]),
  VoicingPlan(VoicingKind.fourString, <int>[0, 1, 2, 3]),
  VoicingPlan(VoicingKind.fourString, <int>[1, 2, 3, 4]),
  VoicingPlan(VoicingKind.fourString, <int>[2, 3, 4, 5], anyBass: true),
];
