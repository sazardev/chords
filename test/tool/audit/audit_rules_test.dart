import 'package:test/test.dart';

import '../../../tool/src/audit/audit_config.dart';
import '../../../tool/src/audit/audit_engine.dart';
import '../../../tool/src/audit/audit_finding.dart';
import '../../../tool/src/audit/audit_report.dart';
import '../../../tool/src/audit/audit_rule.dart';
import '../../../tool/src/audit/audit_severity.dart';
import '../../../tool/src/audit/metrics/source_metrics.dart';
import '../../../tool/src/audit/rules/class_size_rule.dart';
import '../../../tool/src/audit/rules/complexity_rule.dart';
import '../../../tool/src/audit/rules/default_rules.dart';
import '../../../tool/src/audit/rules/file_length_rule.dart';
import '../../../tool/src/audit/rules/function_length_rule.dart';
import '../../../tool/src/audit/rules/layer_boundary_rule.dart';
import '../../../tool/src/audit/rules/switch_size_rule.dart';
import '../../../tool/src/audit/source_file.dart';

/// Tests de las reglas y del motor de auditoría.
void main() {
  SourceMetrics metricsOf(String path, List<String> lines) =>
      SourceMetrics.compute(SourceFile(path: path, lines: lines));

  group('file length', () {
    test('avisa cuando el archivo supera el presupuesto', () {
      final Iterable<AuditFinding> findings = fileLengthRule.evaluate(
        metricsOf('lib/largo.dart', <String>[
          for (int i = 0; i < 30; i++) 'const int c$i = $i;',
        ]),
        const AuditConfig(maxFileLines: 20),
      );

      expect(findings, hasLength(1));
      expect(findings.single.severity, AuditSeverity.warning);
      expect(findings.single.line, 20);
    });

    test('acepta un archivo dentro del presupuesto', () {
      expect(
        fileLengthRule.evaluate(
          metricsOf('lib/corto.dart', <String>['const int a = 1;']),
          const AuditConfig(maxFileLines: 10),
        ),
        isEmpty,
      );
    });
  });

  group('class size', () {
    test('avisa por longitud y por número de operaciones', () {
      final Iterable<AuditFinding> findings = classSizeRule.evaluate(
        metricsOf('lib/gigante.dart', <String>[
          'class Giant {',
          '  int do1() => 1;',
          '  int do2() => 2;',
          '  int do3() => 3;',
          '}',
        ]),
        const AuditConfig(maxClassLines: 3, maxPublicMembers: 2),
      );

      expect(findings.map((AuditFinding f) => f.ruleId), <String>[
        'class-size',
        'class-size',
      ]);
    });

    test('mide solo comportamiento, no los campos de datos', () {
      final Iterable<AuditFinding> findings = classSizeRule.evaluate(
        metricsOf('lib/entidad.dart', <String>[
          'class Entity {',
          '  final String a;',
          '  final String b;',
          '  final String c;',
          '  const Entity(this.a, this.b, this.c);',
          '}',
        ]),
        const AuditConfig(maxPublicMembers: 2),
      );

      expect(findings, isEmpty);
    });

    test('no marca los adaptadores que implementan una interfaz', () {
      expect(
        classSizeRule.evaluate(
          metricsOf('lib/adaptador.dart', <String>[
            'class Adapter implements Repository {',
            '  int a() => 1;',
            '  int b() => 2;',
            '  int c() => 3;',
            '  int d() => 4;',
            '}',
          ]),
          const AuditConfig(maxPublicMembers: 2),
        ),
        isEmpty,
      );
    });
  });

  group('function length y complejidad', () {
    test('avisa de un método demasiado largo', () {
      final Iterable<AuditFinding> findings = functionLengthRule.evaluate(
        metricsOf('lib/largo.dart', <String>[
          'int long() {',
          for (int i = 0; i < 40; i++) '  int v$i = $i;',
          '  return 0;',
          '}',
        ]),
        const AuditConfig(maxFunctionLines: 10),
      );

      expect(findings, hasLength(1));
    });

    test('marca como error un cuerpo con demasiadas decisiones', () {
      final Iterable<AuditFinding> findings = complexityRule.evaluate(
        metricsOf('lib/complejo.dart', <String>[
          'int branchy(int a) {',
          '  if (a == 1) return 1;',
          '  if (a == 2) return 2;',
          '  if (a == 3) return 3;',
          '  if (a == 4) return 4;',
          '  if (a == 5) return 5;',
          '  if (a == 6) return 6;',
          '  return 0;',
          '}',
        ]),
        const AuditConfig(maxBranches: 3),
      );

      expect(findings, hasLength(1));
      expect(findings.single.severity, AuditSeverity.error);
    });
  });

  group('switch size', () {
    test('avisa cuando un switch acumula demasiados casos', () {
      final Iterable<AuditFinding> findings = switchSizeRule.evaluate(
        metricsOf('lib/clasificador.dart', <String>[
          'int classify(int v) {',
          '  switch (v) {',
          '    case 1:',
          '      return 1;',
          '    case 2:',
          '      return 2;',
          '    case 3:',
          '      return 3;',
          '  }',
          '  return 0;',
          '}',
        ]),
        const AuditConfig(maxSwitchCases: 2),
      );

      expect(findings, hasLength(1));
      expect(findings.single.line, 2);
    });
  });

  group('layer boundary', () {
    test('marca la presentación importando datos', () {
      final Iterable<AuditFinding> findings = layerBoundaryRule.evaluate(
        metricsOf('lib/presentation/x.dart', <String>[
          "import 'package:chords/data/local/preferences_service.dart';",
          'class X {}',
        ]),
        AuditConfig.defaults,
      );

      expect(findings, hasLength(1));
      expect(findings.single.severity, AuditSeverity.error);
      expect(findings.single.line, 1);
    });

    test('permite presentar importando dominio', () {
      expect(
        layerBoundaryRule.evaluate(
          metricsOf('lib/presentation/x.dart', <String>[
            "import 'package:chords/domain/chords/entities/chord.dart';",
            'class X {}',
          ]),
          AuditConfig.defaults,
        ),
        isEmpty,
      );
    });

    test('ignora los tests', () {
      expect(
        layerBoundaryRule.evaluate(
          metricsOf('test/x_test.dart', <String>[
            "import 'package:chords/data/local/preferences_service.dart';",
            'void main() {}',
          ]),
          AuditConfig.defaults,
        ),
        isEmpty,
      );
    });
  });

  group('AuditEngine', () {
    test('no informa nada cuando todas las reglas pasan', () {
      final AuditReport report = const AuditEngine().evaluate(<SourceFile>[
        const SourceFile(
          path: 'lib/limpio.dart',
          lines: <String>['class Clean {', '  int value() => 1;', '}'],
        ),
      ]);

      expect(report.isClean, isTrue);
      expect(report.filesAnalyzed, 1);
    });

    test('agrupa hallazgos de varias reglas', () {
      final AuditReport report =
          const AuditEngine(config: AuditConfig(maxBranches: 2))
              .evaluate(<SourceFile>[
                const SourceFile(
                  path: 'lib/sucio.dart',
                  lines: <String>[
                    'class Dirty {',
                    '  int branchy(int a) {',
                    '    if (a == 1) return 1;',
                    '    if (a == 2) return 2;',
                    '    if (a == 3) return 3;',
                    '    if (a == 4) return 4;',
                    '    return 0;',
                    '  }',
                    '}',
                  ],
                ),
              ]);

      expect(report.findings, isNotEmpty);
      expect(report.hasAtLeast(AuditSeverity.error), isTrue);
      expect(report.countOf(AuditSeverity.error), 1);
    });

    test('las reglas por defecto cubren las seis dimensiones', () {
      expect(defaultAuditRules.map((AuditRule r) => r.id), <String>[
        'layer-boundary',
        'file-length',
        'class-size',
        'function-length',
        'complexity',
        'switch-size',
      ]);
    });
  });
}
