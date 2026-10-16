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
    this.anchorSemitones = 0,
    this.openOnly = false,
    this.maxBarre = 12,
  });

  /// Identificador de la calidad de acorde (coincide con `ChordQuality.id`).
  final String qualityId;

  /// Identificador estable de la forma (p. ej. `e-shape`).
  final String id;

  /// Índice de la cuerda de anclaje (0 = sexta): la nota más grave de la
  /// forma, que fija dónde cae al transportarla.
  final int rootString;

  /// Etiqueta legible de la posición (p. ej. `Forma de Mi`).
  final String positionLabel;

  /// Trastes relativos al cejillo por cuerda; `null` = cuerda muda.
  final List<int?> fretOffsets;

  /// Digitación cuando el cejillo está en el traste 0 (posición abierta).
  ///
  /// Si se deja a ceros, el generador busca la digitación más natural.
  final List<int> fingersOpen;

  /// Digitación cuando el cejillo está en un traste > 0.
  final List<int> fingersBarre;

  /// Dificultad mínima en posición abierta (1-5).
  final int difficultyOpen;

  /// Dificultad mínima con cejillo o desplazada (1-5).
  final int difficultyBarre;

  /// Etiquetas descriptivas de la forma.
  final List<String> tags;

  /// Semitonos entre la raíz del acorde y la nota de la cuerda de anclaje
  /// (0 si el bajo es la raíz; 4 si es una primera inversión mayor…).
  final int anchorSemitones;

  /// `true` si la forma solo tiene sentido en posición abierta.
  final bool openOnly;

  /// Traste más alto donde se admite el cejillo de esta forma.
  final int maxBarre;
}
