import '../audit_config.dart';
import '../audit_finding.dart';
import '../audit_rule.dart';
import '../audit_severity.dart';
import '../metrics/source_metrics.dart';
import '../metrics/type_summary.dart';

/// Prohíbe tipos demasiado largos o con demasiadas operaciones públicas.
///
/// Un tipo que lo hace todo se vuelve imposible de probar y de reutilizar:
/// divídelo por colaboradores o extrae subtipos.
const ClassSizeRule classSizeRule = ClassSizeRule();

/// Regla de tamaño máximo por tipo.
class ClassSizeRule implements AuditRule {
  /// Crea la regla.
  const ClassSizeRule();

  @override
  String get id => 'class-size';

  @override
  String get title => 'Tamaño máximo de clase';

  @override
  Set<String> get rootPrefixes => kSourceScopes;

  @override
  AuditSeverity get severity => AuditSeverity.warning;

  @override
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config) {
    final List<AuditFinding> findings = <AuditFinding>[];
    for (final TypeSummary type in metrics.types) {
      findings
        ..addAll(_lengthFinding(type, metrics.path, config))
        ..addAll(_widthFinding(type, metrics.path, config));
    }
    return findings;
  }

  /// Hallazgo por longitud del tipo.
  Iterable<AuditFinding> _lengthFinding(
    TypeSummary type,
    String path,
    AuditConfig config,
  ) {
    if (type.lineCount <= config.maxClassLines) {
      return const <AuditFinding>[];
    }
    return <AuditFinding>[
      AuditFinding(
        ruleId: id,
        ruleTitle: title,
        path: path,
        line: type.block.startLine,
        message:
            '${type.displayName} ocupa ${type.lineCount} líneas '
            '(máximo ${config.maxClassLines}). Divide el tipo.',
        severity: severity,
      ),
    ];
  }

  /// Hallazgo por número de operaciones públicas.
  Iterable<AuditFinding> _widthFinding(
    TypeSummary type,
    String path,
    AuditConfig config,
  ) {
    if (type.members.adaptsInterface ||
        type.members.publicMethods <= config.maxPublicMembers) {
      return const <AuditFinding>[];
    }
    return <AuditFinding>[
      AuditFinding(
        ruleId: id,
        ruleTitle: title,
        path: path,
        line: type.block.startLine,
        message:
            '${type.displayName} expone '
            '${type.members.publicMethods} operaciones públicas '
            '(máximo ${config.maxPublicMembers}). Agrupa responsabilidades '
            'en colaboradores.',
        severity: severity,
      ),
    ];
  }
}
