/// Informe de validación del banco de acordes.
library;

/// Problema encontrado al validar el banco de acordes.
class ValidationIssue {
  /// Crea un problema de validación.
  const ValidationIssue(this.path, this.message);

  /// Ruta JSON donde se detectó el problema.
  final String path;

  /// Descripción del problema.
  final String message;

  @override
  String toString() => '$path: $message';
}

/// Resultado de validar el banco.
class ValidationReport {
  /// Crea el informe de validación.
  const ValidationReport({
    required this.chordCount,
    required this.variantCount,
    required this.issues,
  });

  /// Número de acordes validados.
  final int chordCount;

  /// Número de posiciones validadas.
  final int variantCount;

  /// Problemas encontrados (vacío si todo es correcto).
  final List<ValidationIssue> issues;

  /// `true` si no se encontró ningún problema.
  bool get isValid => issues.isEmpty;
}
