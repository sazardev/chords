/// Hallazgo individual producido por una regla de auditoría.
library;

import 'audit_severity.dart';

/// Hallazgo individual producido por una regla de auditoría.
class AuditFinding {
  /// Crea un hallazgo.
  const AuditFinding({
    required this.ruleId,
    required this.ruleTitle,
    required this.path,
    required this.line,
    required this.message,
    required this.severity,
  });

  /// Identificador estable de la regla origen.
  final String ruleId;

  /// Título legible de la regla origen.
  final String ruleTitle;

  /// Ruta relativa del archivo analizado.
  final String path;

  /// Línea del hallazgo (1-indexada; `0` si aplica a todo el archivo).
  final int line;

  /// Descripción del problema y sugerencia de corrección.
  final String message;

  /// Gravedad del hallazgo.
  final AuditSeverity severity;

  /// Ubicación legible en forma `ruta:linea`.
  String get location => line > 0 ? '$path:$line' : path;

  @override
  String toString() => '$location [$severity] $ruleId: $message';
}
