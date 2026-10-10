import '../audit_config.dart';
import '../audit_finding.dart';
import '../audit_rule.dart';
import '../audit_severity.dart';
import '../metrics/function_block.dart';
import '../metrics/source_metrics.dart';

/// Prohíbe cuerpos con demasiados puntos de decisión.
///
/// La complejidad ciclomática alta indica caminos sin probar: sustituye las
/// ramas por tablas, estrategias o tipos sellados.
const ComplexityRule complexityRule = ComplexityRule();

/// Regla de complejidad máxima por cuerpo ejecutable.
class ComplexityRule implements AuditRule {
  /// Crea la regla.
  const ComplexityRule();

  @override
  String get id => 'complexity';

  @override
  String get title => 'Complejidad máxima por función';

  @override
  Set<String> get rootPrefixes => kSourceScopes;

  @override
  AuditSeverity get severity => AuditSeverity.error;

  @override
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config) {
    final List<AuditFinding> findings = <AuditFinding>[];
    for (final FunctionBlock function in metrics.functions) {
      if (function.branchCount <= config.maxBranches) {
        continue;
      }
      findings.add(
        AuditFinding(
          ruleId: id,
          ruleTitle: title,
          path: metrics.path,
          line: function.block.startLine,
          message:
              '${function.block.kind.label} ${function.qualifiedName} tiene '
              '${function.branchCount} puntos de decisión '
              '(máximo ${config.maxBranches}). Divide el cuerpo o usa '
              'despacho por datos.',
          severity: severity,
        ),
      );
    }
    return findings;
  }
}
