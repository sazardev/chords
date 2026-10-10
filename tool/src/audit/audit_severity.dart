/// Gravedad de un hallazgo de auditoría.
///
/// Determina si un hallazgo bloquea la integración cuando se usa
/// `--fail-on`.
enum AuditSeverity {
  /// Recomendación de estilo; nunca bloquea por defecto.
  info('info'),

  /// Desviación que conviene corregir pronto.
  warning('warning'),

  /// Violación de las reglas del proyecto.
  error('error');

  /// Crea una gravedad a partir de su etiqueta.
  const AuditSeverity(this.label);

  /// Etiqueta mostrada en los informes.
  final String label;

  /// Peso numérico para ordenar y comparar gravedades.
  int get weight => switch (this) {
    AuditSeverity.info => 0,
    AuditSeverity.warning => 1,
    AuditSeverity.error => 2,
  };

  /// Interpreta una etiqueta; `null` si no es válida.
  static AuditSeverity? parse(String value) {
    for (final AuditSeverity severity in AuditSeverity.values) {
      if (severity.label == value) {
        return severity;
      }
    }
    return null;
  }
}
