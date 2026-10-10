import 'audit_finding.dart';
import 'audit_report.dart';
import 'audit_severity.dart';

/// Escribe informes de auditoría en texto plano y Markdown.
class AuditReporter {
  /// Crea el reporter.
  const AuditReporter();

  /// Resumen legible para la consola.
  String renderText(AuditReport report) {
    if (report.isClean) {
      return 'Auditoría OK: ${report.filesAnalyzed} archivos sin hallazgos.';
    }
    final StringBuffer buffer = StringBuffer()
      ..writeln(
        'Auditoría: ${report.findings.length} hallazgos en '
        '${report.filesAnalyzed} archivos '
        '(${report.countOf(AuditSeverity.error)} errores, '
        '${report.countOf(AuditSeverity.warning)} avisos, '
        '${report.countOf(AuditSeverity.info)} notas)',
      );
    final Map<String, List<AuditFinding>> byPath = _groupByPath(report);
    for (final String path in byPath.keys) {
      buffer
        ..writeln()
        ..writeln(path);
      for (final AuditFinding finding in byPath[path]!) {
        buffer.writeln(
          '  ${finding.line > 0 ? finding.line : '-'} '
          '[${finding.severity.label}] ${finding.ruleId} '
          '${finding.message}',
        );
      }
    }
    return buffer.toString().trimRight();
  }

  /// Informe en Markdown para adjuntar a revisiones.
  String renderMarkdown(AuditReport report) {
    final StringBuffer buffer = StringBuffer()
      ..writeln('# Informe de auditoría de código')
      ..writeln()
      ..writeln('- Archivos analizados: ${report.filesAnalyzed}')
      ..writeln('- Hallazgos: ${report.findings.length}')
      ..writeln(
        '- Errores: ${report.countOf(AuditSeverity.error)} · '
        'Avisos: ${report.countOf(AuditSeverity.warning)} · '
        'Notas: ${report.countOf(AuditSeverity.info)}',
      );
    final Map<String, List<AuditFinding>> byPath = _groupByPath(report);
    for (final String path in byPath.keys) {
      buffer
        ..writeln()
        ..writeln('## `$path`');
      for (final AuditFinding finding in byPath[path]!) {
        final String location = finding.line > 0 ? ':${finding.line}' : '';
        buffer.writeln(
          '- **${finding.severity.label}** `${finding.ruleId}` '
          '`${finding.path}$location` — ${finding.message}',
        );
      }
    }
    return buffer.toString().trimRight();
  }

  /// Agrupa los hallazgos por archivo conservando el orden dado.
  Map<String, List<AuditFinding>> _groupByPath(AuditReport report) {
    final Map<String, List<AuditFinding>> grouped =
        <String, List<AuditFinding>>{};
    for (final AuditFinding finding in report.sortedFindings) {
      grouped.putIfAbsent(finding.path, () => <AuditFinding>[]).add(finding);
    }
    return grouped;
  }
}
