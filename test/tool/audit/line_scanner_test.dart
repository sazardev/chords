import 'package:test/test.dart';

import '../../../tool/src/audit/metrics/line_scanner.dart';
import '../../../tool/src/audit/metrics/scanned_line.dart';

/// Tests del normalizador de líneas.
void main() {
  const LineScanner scanner = LineScanner();

  group('LineScanner', () {
    test('elimina comentarios de línea y de bloque', () {
      final List<ScannedLine> lines = scanner.scan(<String>[
        'final int a = 1; // suma',
        '/* bloque',
        '   todavía bloque */ final int b = 2;',
      ]);

      expect(lines[0].code.trimRight(), 'final int a = 1;');
      expect(lines[1].code.trim(), isEmpty);
      expect(lines[1].depthBefore, 0);
      expect(lines[2].code.contains('final int b = 2;'), isTrue);
    });

    test('vacía el interior de las cadenas conservando las comillas', () {
      final List<ScannedLine> lines = scanner.scan(<String>[
        "const String k = 'no {cuenta}';",
      ]);

      expect(lines[0].code.contains('{'), isFalse);
      expect(lines[0].code.startsWith("const String k = '"), isTrue);
    });

    test('cuenta la profundidad de llaves ignorando cadenas', () {
      final List<ScannedLine> lines = scanner.scan(<String>[
        'void main() {',
        "  print('{');",
        '  if (true) {',
        '  }',
        '}',
      ]);

      expect(lines.map((ScannedLine l) => l.depthAfter), <int>[1, 1, 2, 1, 0]);
    });

    test('arrastra los comentarios de bloque entre líneas', () {
      final List<ScannedLine> lines = scanner.scan(<String>[
        '/*',
        'sigue',
        '*/ final int c = 3;',
      ]);

      expect(lines[1].code.trim(), isEmpty);
      expect(lines[2].code.contains('final int c = 3;'), isTrue);
      expect(lines[2].depthAfter, 0);
    });
  });
}
