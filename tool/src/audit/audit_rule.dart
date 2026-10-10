import 'audit_config.dart';
import 'audit_finding.dart';
import 'audit_severity.dart';
import 'metrics/source_metrics.dart';

/// Raíces de ruta que cubren el código fuente del proyecto.
///
/// Los tests quedan fuera a propósito: sus `main` agrupan muchos casos y sus
/// dobles implementan interfaces anchas, así que los presupuestos de forma
/// sólo aplican al código que se ejecuta en la app.
const Set<String> kSourceScopes = <String>{'lib/', 'bin/', 'tool/'};

/// Contrato de una regla de auditoría.
///
/// Las reglas son puras: reciben métricas ya calculadas y devuelven hallazgos
/// sin realizar entrada/salida, así se pueden probar de forma aislada.
abstract interface class AuditRule {
  /// Identificador estable de la regla (`kebab-case`).
  String get id;

  /// Título legible para los informes.
  String get title;

  /// Gravedad de los hallazgos que produce.
  AuditSeverity get severity;

  /// Raíces donde aplica la regla; vacío significa "en todas partes".
  Set<String> get rootPrefixes;

  /// Evalúa un archivo a partir de sus métricas.
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config);
}

/// Utilidades de ámbito compartidas por el motor y el comando `audit`.
extension AuditRuleScope on AuditRule {
  /// `true` si la regla debe evaluar la ruta indicada.
  bool appliesTo(String path) =>
      rootPrefixes.isEmpty ||
      rootPrefixes.any((String root) => path.startsWith(root));
}
