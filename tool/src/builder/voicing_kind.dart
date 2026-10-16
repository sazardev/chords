/// Clasificación de los voicings que encuentra el buscador.
library;

import 'package:chords/domain/chords/entities/variant_identity.dart';

import '../chord_theory.dart';
import 'voicing_plan.dart';

/// Tipo del voicing que ocupa [plan] con los trastes [frets].
///
/// Los de tres notas son tríadas o shells; los de cuatro son un drop 2, un
/// drop 3 o un voicing cualquiera.
VariantKind voicingKind(VoicingPlan plan, List<int> frets) =>
    switch (plan.kind) {
      VoicingKind.triad => VariantKind.triad,
      VoicingKind.shell => VariantKind.shell,
      VoicingKind.fourString => _dropKind(plan, frets) ?? VariantKind.voicing,
    };

/// `drop2` o `drop3` si los cuatro sonidos lo forman.
///
/// Un drop 2 es un acorde cerrado con la segunda voz por arriba bajada una
/// octava; un drop 3, el mismo con la tercera. Se reconocen por las alturas.
VariantKind? _dropKind(VoicingPlan plan, List<int> frets) {
  final List<int> pitches = <int>[
    for (final int s in plan.strings) kStringTuning[s] + frets[s],
  ]..sort();
  final bool closedWithoutLow = pitches[3] - pitches[1] < 12;
  final int lifted = pitches[0] + 12;
  if (closedWithoutLow && pitches[2] < lifted && lifted < pitches[3]) {
    return VariantKind.drop2;
  }
  if (closedWithoutLow && pitches[1] < lifted && lifted < pitches[2]) {
    return VariantKind.drop3;
  }
  return null;
}
