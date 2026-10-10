import '../audit_config.dart';
import '../audit_finding.dart';
import '../audit_rule.dart';
import '../audit_severity.dart';
import '../metrics/function_block.dart';
import '../metrics/source_metrics.dart';

/// Prohíbe funciones y métodos más largos que el presupuesto.
///
/// Los cuerpos largos mezclan pasos: extrae funciones con nombre, una por
/// paso, y compónlas.
const FunctionLengthRule functionLengthRule = FunctionLengthRule();

/// Regla de longitud máxima de cuerpo ejecutable.
class FunctionLengthRule implements AuditRule {
  /// Crea la regla.
  const FunctionLengthRule();

  @override
  String get id => 'function-length';

  @override
  String get title => 'Longitud máxima de función';

  @override
  Set<String> get rootPrefixes => kSourceScopes;

  @override
  AuditSeverity get severity => AuditSeverity.warning;

  @override
  Iterable<AuditFinding> evaluate(SourceMetrics metrics, AuditConfig config) {
    final List<AuditFinding> findings = <AuditFinding>[];
    for (final FunctionBlock function in metrics.functions) {
      if (function.block.lineCount <= config.maxFunctionLines) {
        continue;
      }
      findings.add(
        AuditFinding(
          ruleId: id,
          ruleTitle: title,
          path: metrics.path,
          line: function.block.startLine,
          message:
              '${function.block.kind.label} ${function.qualifiedName} ocupa '
              '${function.block.lineCount} líneas '
              '(máximo ${config.maxFunctionLines}). Extrae los pasos a '
              'funciones con nombre.',
          severity: severity,
        ),
      );
    }
    return findings;
  }
}
