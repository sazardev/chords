import 'package:test/test.dart';

import '../../../tool/src/audit/metrics/decision_point_counter.dart';
import '../../../tool/src/audit/metrics/declaration_block.dart';
import '../../../tool/src/audit/metrics/declaration_kind.dart';
import '../../../tool/src/audit/metrics/line_scanner.dart';
import '../../../tool/src/audit/metrics/scanned_line.dart';
import '../../../tool/src/audit/metrics/switch_scanner.dart';

/// Tests de métricas de flujo: switches y puntos de decisión.
void main() {
  const SwitchScanner switchScanner = SwitchScanner();
  const DecisionPointCounter counter = DecisionPointCounter();

  group('SwitchScanner', () {
    test('cuenta los casos de un switch con llaves', () {
      final List<ScannedLine> lines = const LineScanner().scan(<String>[
        'String label(int level) {',
        '  switch (level) {',
        '    case 1:',
        "      return 'uno';",
        '    case 2:',
        "      return 'dos';",
        '    default:',
        "      return 'muchos';",
        '  }',
        '}',
      ]);

      final List<SwitchBlock> blocks = switchScanner.scan(lines);

      expect(blocks, hasLength(1));
      expect(blocks.single.caseCount, 2);
      expect(blocks.single.startLine, 2);
      expect(blocks.single.endLine, 8);
    });

    test('ignora las expresiones switch de una línea', () {
      final List<ScannedLine> lines = const LineScanner().scan(<String>[
        'final String label = switch (mode) { 1 => "a", _ => "b" };',
      ]);

      expect(switchScanner.scan(lines), isEmpty);
    });

    test('no cuenta los casos de un switch anidado', () {
      final List<ScannedLine> lines = const LineScanner().scan(<String>[
        'int f(int a) {',
        '  switch (a) {',
        '    case 1:',
        '      switch (a) {',
        '        case 2:',
        '          return 3;',
        '      }',
        '      return 0;',
        '  }',
        '  return 1;',
        '}',
      ]);

      final List<SwitchBlock> blocks = switchScanner.scan(lines);

      expect(blocks, hasLength(2));
      expect(blocks.first.caseCount, 1);
      expect(blocks.last.caseCount, 1);
    });
  });

  group('DecisionPointCounter', () {
    test('suma condiciones, casos y operadores lógicos', () {
      final List<ScannedLine> lines = const LineScanner().scan(<String>[
        'bool check(int a, int b) {',
        '  if (a > 0 && b > 0) {',
        '    return true;',
        '  }',
        '  return a < b || a == b || a != b;',
        '}',
      ]);
      const DeclarationBlock block = DeclarationBlock(
        kind: DeclarationKind.method,
        name: 'check',
        startLine: 1,
        endLine: 6,
      );

      expect(counter.count(lines, block), 4);
    });

    test('no cuenta los textos ni los comentarios', () {
      final List<ScannedLine> lines = const LineScanner().scan(<String>[
        'String note() {',
        "  return 'si esto fuera código: if (x) { }';",
        '}',
      ]);
      const DeclarationBlock block = DeclarationBlock(
        kind: DeclarationKind.method,
        name: 'note',
        startLine: 1,
        endLine: 3,
      );

      expect(counter.count(lines, block), 0);
    });

    test('no cuenta los operadores null-aware como ternarios', () {
      final List<ScannedLine> lines = const LineScanner().scan(<String>[
        'int value(int? a) {',
        '  return a ?? 0;',
        '}',
      ]);
      const DeclarationBlock block = DeclarationBlock(
        kind: DeclarationKind.method,
        name: 'value',
        startLine: 1,
        endLine: 3,
      );

      expect(counter.count(lines, block), 0);
    });
  });
}
