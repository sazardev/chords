/// Línea de código normalizada: sin comentarios, con el contenido de las
/// cadenas vaciado y con la profundidad de llaves antes y después.
class ScannedLine {
  /// Crea una línea normalizada.
  const ScannedLine({
    required this.number,
    required this.indent,
    required this.code,
    required this.depthBefore,
    required this.depthAfter,
  });

  /// Número de línea (1-indexado).
  final int number;

  /// Número de espacios de sangría.
  final int indent;

  /// Código sin comentarios y con el interior de las cadenas en blanco.
  final String code;

  /// Profundidad de llaves al inicio de la línea.
  final int depthBefore;

  /// Profundidad de llaves al final de la línea.
  final int depthAfter;

  /// `true` si la línea no aporta código (vacía, comentario o solo llaves).
  bool get isCodeEmpty => code.trim().isEmpty;

  /// `true` si la línea solo contiene una llave de cierre.
  bool get isLoneClosingBrace => code.trim() == '}';

  /// Contenido de código sin espacios exteriores.
  String get trimmed => code.trim();

  /// `true` si la línea abre un bloque que termina más abajo.
  bool get opensBlock => depthAfter > depthBefore;
}
