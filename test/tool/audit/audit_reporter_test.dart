import 'package:test/test.dart';

import '../../../tool/src/audit/audit_finding.dart';
import '../../../tool/src/audit/audit_report.dart';
import '../../../tool/src/audit/audit_reporter.dart';
import '../../../tool/src/audit/audit_severity.dart';

/// Tests de los informes de auditoría.
void main() {
  const AuditReporter reporter = AuditReporter();

  AuditReport reportOf(List<AuditFinding> findings) =>
      AuditReport(filesAnalyzed: 3, findings: findings);

  const AuditFinding layer = AuditFinding(
    ruleId: 'layer-boundary',
    ruleTitle: 'Fronteras entre capas',
    path: 'lib/presentation/x.dart',
    line: 7,
    message: 'lib/presentation/ no puede importar data/',
    severity: AuditSeverity.error,
  );

  const AuditFinding size = AuditFinding(
    ruleId: 'file-length',
    ruleTitle: 'Longitud máxima de archivo',
    path: 'lib/gigante.dart',
    line: 400,
    message: 'El archivo tiene 512 líneas',
    severity: AuditSeverity.warning,
  );

  group('AuditReporter', () {
    test('resume un informe limpio', () {
      expect(
        reporter.renderText(reportOf(const <AuditFinding>[])),
        contains('sin hallazgos'),
      );
    });

    test('agrupa los hallazgos por archivo y conserva el orden', () {
      final String text = reporter.renderText(
        reportOf(const <AuditFinding>[size, layer]),
      );

      expect(
        text.indexOf('lib/gigante.dart'),
        lessThan(text.indexOf('lib/presentation/x.dart')),
      );
      expect(text, contains('1 errores'));
      expect(text, contains('1 avisos'));
    });

    test('escribe un informe Markdown con ubicaciones', () {
      final String markdown = reporter.renderMarkdown(
        reportOf(const <AuditFinding>[layer]),
      );

      expect(markdown, contains('# Informe de auditoría de código'));
      expect(markdown, contains('## `lib/presentation/x.dart`'));
      expect(markdown, contains('`lib/presentation/x.dart:7`'));
      expect(markdown, contains('**error**'));
    });

    test('ordenar por archivo y línea es estable', () {
      final List<AuditFinding> sorted = reportOf(const <AuditFinding>[
        layer,
        size,
      ]).sortedFindings;

      expect(sorted.first.path, 'lib/gigante.dart');
      expect(sorted.last.path, 'lib/presentation/x.dart');
    });
  });
}
