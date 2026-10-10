import 'audit_finding.dart';
import 'audit_severity.dart';

/// Informe agregado de una ejecución de auditoría.
class AuditReport {
  /// Crea el informe.
  const AuditReport({required this.filesAnalyzed, required this.findings});

  /// Informe vacío.
  const AuditReport.empty()
    : filesAnalyzed = 0,
      findings = const <AuditFinding>[];

  /// Número de archivos analizados.
  final int filesAnalyzed;

  /// Hallazgos detectados, en orden de descubrimiento.
  final List<AuditFinding> findings;

  /// Número de hallazgos de la gravedad indicada.
  int countOf(AuditSeverity severity) =>
      findings.where((AuditFinding f) => f.severity == severity).length;

  /// `true` si hay al menos un hallazgo con la gravedad indicada o superior.
  bool hasAtLeast(AuditSeverity threshold) =>
      findings.any((AuditFinding f) => f.severity.weight >= threshold.weight);

  /// Hallazgos ordenados por archivo y línea para su presentación.
  List<AuditFinding> get sortedFindings {
    final List<AuditFinding> copy = List<AuditFinding>.of(findings)
      ..sort((AuditFinding a, AuditFinding b) {
        final int byPath = a.path.compareTo(b.path);
        if (byPath != 0) {
          return byPath;
        }
        final int byLine = a.line.compareTo(b.line);
        if (byLine != 0) {
          return byLine;
        }
        return a.ruleId.compareTo(b.ruleId);
      });
    return copy;
  }

  /// `true` si no se detectó ningún hallazgo.
  bool get isClean => findings.isEmpty;
}
