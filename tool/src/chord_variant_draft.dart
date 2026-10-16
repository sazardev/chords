/// Posición candidata construida por el generador.
///
/// Es un paso intermedio antes de convertirla en `ChordVariant`: lleva los
/// datos crudos de trastes, dedos y cejillo tal y como los dedujo el
/// constructor.
library;

import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import 'fingering/fingering_rules.dart';

/// Posición candidata todavía sin enlazar a un acorde.
class VariantDraft {
  /// Crea la candidata.
  const VariantDraft({
    required this.id,
    required this.frets,
    required this.fingers,
    required this.difficulty,
    this.shapeLabel,
    this.barreFret,
    this.barreFrom,
    this.barreToString,
  });

  /// Identificador corto de la posición (`e-shape-3`, `drop2-4321-b0`).
  final String id;

  /// Nombre de la forma del catálogo; `null` en los voicings buscados.
  final String? shapeLabel;

  /// Trastes por cuerda (`-1` = cuerda muda).
  final List<int> frets;

  /// Dedos por cuerda.
  final List<int> fingers;

  /// Dificultad estimada.
  final Difficulty difficulty;

  /// Traste del cejillo, si la posición lo usa.
  final int? barreFret;

  /// Primera cuerda cejillada.
  final int? barreFrom;

  /// Última cuerda cejillada.
  final int? barreToString;

  /// Tipo de posición deducido del identificador.
  VariantKind get kind => VariantIdentity.parse(id).kind;

  /// La misma posición con otra digitación; el cejillo se deduce de ella.
  VariantDraft withFingers(List<int> newFingers) {
    final ({int fret, int from, int to})? barre = barreOf(frets, newFingers);
    return VariantDraft(
      id: id,
      shapeLabel: shapeLabel,
      frets: frets,
      fingers: newFingers,
      difficulty: difficulty,
      barreFret: barre?.fret,
      barreFrom: barre?.from,
      barreToString: barre?.to,
    );
  }

  /// La misma posición con otra dificultad.
  VariantDraft withDifficulty(Difficulty newDifficulty) => VariantDraft(
    id: id,
    shapeLabel: shapeLabel,
    frets: frets,
    fingers: fingers,
    difficulty: newDifficulty,
    barreFret: barreFret,
    barreFrom: barreFrom,
    barreToString: barreToString,
  );
}
