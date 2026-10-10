import '../audit_config.dart';
import '../audit_finding.dart';
import '../audit_rule.dart';
import '../audit_severity.dart';
import '../metrics/source_metrics.dart';

/// Prohíbe archivos más largos que el presupuesto acordado.
///
/// Un archivo largo suele esconder varias responsabilidades: divídelo por
/// capas o por funcionalidad.
const FileLengthRule fileLengthRule = FileLengthRule();

/// Regla de longitud máxima de archivo.
class FileLengthRule implements AuditRule {
  /// Crea la regla.
  const FileLengthRule();

  @override
  String get id => 'file-length';

  @override
  String get title => 'Longitud máxima de archivo';

  @override
  Set<String> get rootPrefixes => const <String>{};

  @override
  AuditSeverity get severity => AuditSeverity.warning;

  @override
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config) {
    if (metrics.lineCount <= config.maxFileLines) {
      return const <AuditFinding>[];
    }
    return <AuditFinding>[
      AuditFinding(
        ruleId: id,
        ruleTitle: title,
        path: metrics.path,
        line: config.maxFileLines,
        message:
            'El archivo tiene ${metrics.lineCount} líneas '
            '(máximo ${config.maxFileLines}). Extrae responsabilidades '
            'a archivos más pequeños.',
        severity: severity,
      ),
    ];
  }
}
