import 'dart:io';

import 'audit_config.dart';
import 'audit_finding.dart';
import 'audit_report.dart';
import 'audit_rule.dart';
import 'metrics/source_metrics.dart';
import 'rules/default_rules.dart';
import 'source_discovery.dart';
import 'source_file.dart';

/// Motor de auditoría: descubre archivos, calcula métricas y aplica reglas.
class AuditEngine {
  /// Crea el motor.
  const AuditEngine({
    this.config = AuditConfig.defaults,
    this.rules = defaultAuditRules,
  });

  /// Presupuestos que aplica el motor.
  final AuditConfig config;

  /// Reglas activas.
  final List<AuditRule> rules;

  /// Audita el árbol de directorios indicado.
  AuditReport run(String root) {
    final List<File> files = const SourceDiscovery().discover(
      root,
      config.excludedDirectories,
    );
    final List<SourceFile> sources = files
        .map(
          (File file) => SourceFile.fromFile(
            file,
            relativePath: _relative(file.path, root),
          ),
        )
        .toList();
    return evaluate(sources);
  }

  /// Audita una lista de archivos ya leídos (útil para pruebas).
  AuditReport evaluate(List<SourceFile> sources) {
    final List<AuditFinding> findings = <AuditFinding>[];
    for (final SourceFile source in sources) {
      final SourceMetrics metrics = SourceMetrics.compute(source);
      for (final AuditRule rule in rules) {
        if (!rule.appliesTo(metrics.path)) {
          continue;
        }
        findings.addAll(rule.evaluate(metrics, config));
      }
    }
    return AuditReport(filesAnalyzed: sources.length, findings: findings);
  }

  /// Ruta del archivo relativa a la raíz auditada.
  String _relative(String path, String root) =>
      path.startsWith(root) && path.length > root.length
      ? path.substring(root.length).replaceFirst(Platform.pathSeparator, '')
      : path;
}
