/// Posición candidata construida por el generador.
///
/// Es un paso intermedio antes de convertirla en `ChordVariant`: lleva los
/// datos crudos de trastes, dedos y cejillo tal y como los dedujo el
/// constructor.
library;

import 'package:chords/domain/chords/entities/difficulty.dart';

import 'fingering/fingering_rules.dart';

/// Posición candidata todavía sin enlazar a un acorde.
class VariantDraft {
  /// Crea la candidata.
  const VariantDraft({
    required this.id,
    required this.positionLabel,
    required this.frets,
    required this.fingers,
    required this.difficulty,
    required this.tags,
    this.barreFret,
    this.barreFrom,
    this.barreToString,
  });

  /// Identificador corto de la posición.
  final String id;

  /// Etiqueta legible de la posición.
  final String positionLabel;

  /// Trastes por cuerda (`-1` = cuerda muda).
  final List<int> frets;

  /// Dedos por cuerda.
  final List<int> fingers;

  /// Dificultad estimada.
  final Difficulty difficulty;

  /// Etiquetas descriptivas.
  final List<String> tags;

  /// Traste del cejillo, si la posición lo usa.
  final int? barreFret;

  /// Primera cuerda cejillada.
  final int? barreFrom;

  /// Última cuerda cejillada.
  final int? barreToString;

  /// La misma posición con otra digitación; el cejillo se deduce de ella.
  VariantDraft withFingers(List<int> newFingers) {
    final ({int fret, int from, int to})? barre = barreOf(frets, newFingers);
    return VariantDraft(
      id: id,
      positionLabel: positionLabel,
      frets: frets,
      fingers: newFingers,
      difficulty: difficulty,
      tags: tags,
      barreFret: barre?.fret,
      barreFrom: barre?.from,
      barreToString: barre?.to,
    );
  }
}
