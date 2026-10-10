/// Definición de una forma movible de acorde.
library;

/// Definición de una forma movible de acorde.
class MovableShapeSpec {
  /// Crea una forma movible.
  const MovableShapeSpec({
    required this.qualityId,
    required this.id,
    required this.rootString,
    required this.positionLabel,
    required this.fretOffsets,
    required this.fingersOpen,
    required this.fingersBarre,
    required this.difficultyOpen,
    required this.difficultyBarre,
    required this.tags,
  });

  /// Identificador de la calidad de acorde (coincide con `ChordQuality.id`).
  final String qualityId;

  /// Identificador estable de la forma (p. ej. `e-shape`).
  final String id;

  /// Índice de cuerda (0 = sexta) donde vive la nota raíz al aire.
  final int rootString;

  /// Etiqueta legible de la posición (p. ej. `Forma de Mi`).
  final String positionLabel;

  /// Trastes relativos al cejillo por cuerda; `null` = cuerda muda.
  final List<int?> fretOffsets;

  /// Digitación cuando el cejillo está en el traste 0 (posición abierta).
  final List<int> fingersOpen;

  /// Digitación cuando el cejillo está en un traste > 0.
  final List<int> fingersBarre;

  /// Dificultad asignada en posición abierta (1-5).
  final int difficultyOpen;

  /// Dificultad asignada con cejillo (1-5).
  final int difficultyBarre;

  /// Etiquetas descriptivas de la forma.
  final List<String> tags;
}
