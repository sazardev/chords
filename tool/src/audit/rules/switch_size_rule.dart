import '../audit_config.dart';
import '../audit_finding.dart';
import '../audit_rule.dart';
import '../audit_severity.dart';
import '../metrics/source_metrics.dart';
import '../metrics/switch_scanner.dart';

/// Prohíbe sentencias `switch` con demasiados casos.
///
/// Un `switch` largo es un clasificador en código duro: reparte cada caso en
/// su propio colaborador o usa un mapa de estrategias.
const SwitchSizeRule switchSizeRule = SwitchSizeRule();

/// Regla de número máximo de casos por `switch`.
class SwitchSizeRule implements AuditRule {
  /// Crea la regla.
  const SwitchSizeRule();

  @override
  String get id => 'switch-size';

  @override
  String get title => 'Máximo de casos por switch';

  @override
  Set<String> get rootPrefixes => kSourceScopes;

  @override
  AuditSeverity get severity => AuditSeverity.warning;

  @override
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config) {
    final List<AuditFinding> findings = <AuditFinding>[];
    for (final SwitchBlock block in metrics.switches) {
      if (block.caseCount <= config.maxSwitchCases) {
        continue;
      }
      findings.add(
        AuditFinding(
          ruleId: id,
          ruleTitle: title,
          path: metrics.path,
          line: block.startLine,
          message:
              'El switch de la línea ${block.startLine} tiene '
              '${block.caseCount} casos '
              '(máximo ${config.maxSwitchCases}). Sustitúyelo por una tabla '
              'de estrategias o tipos sellados.',
          severity: severity,
        ),
      );
    }
    return findings;
  }
}
