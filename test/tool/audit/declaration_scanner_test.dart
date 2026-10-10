import 'package:test/test.dart';

import '../../../tool/src/audit/metrics/declaration_block.dart';
import '../../../tool/src/audit/metrics/declaration_kind.dart';
import '../../../tool/src/audit/metrics/declaration_scanner.dart';
import '../../../tool/src/audit/metrics/declaration_tree.dart';
import '../../../tool/src/audit/metrics/line_scanner.dart';
import '../../../tool/src/audit/metrics/scanned_line.dart';

/// Tests del escáner de declaraciones.
void main() {
  const DeclarationScanner scanner = DeclarationScanner();

  List<ScannedLine> scanOf(List<String> source) =>
      const LineScanner().scan(source);

  group('DeclarationScanner', () {
    test('detecta clases y sus métodos', () {
      final DeclarationTree tree = scanner.scan(
        scanOf(<String>[
          'class Service {',
          '  final int _value;',
          '',
          '  Service(this._value);',
          '',
          '  int compute() {',
          '    return _value;',
          '  }',
          '}',
        ]),
      );

      expect(tree.types, hasLength(1));
      expect(tree.types.single.name, 'Service');
      expect(tree.types.single.lineCount, 9);

      expect(tree.executables, hasLength(2));
      final DeclarationBlock constructor = tree.executables.first;
      expect(constructor.name, 'Service');
      expect(constructor.kind, DeclarationKind.constructor);

      final DeclarationBlock method = tree.executables.last;
      expect(method.name, 'compute');
      expect(method.kind, DeclarationKind.method);
      expect(method.enclosingType, 'Service');
      expect(method.lineCount, 3);
    });

    test('clasifica getters y funciones de nivel superior', () {
      final DeclarationTree tree = scanner.scan(
        scanOf(<String>[
          'int get answer => 42;',
          '',
          'String describe() {',
          "  return 'algo';",
          '}',
        ]),
      );

      expect(tree.types, isEmpty);
      expect(tree.executables, hasLength(2));
      expect(tree.executables.first.kind, DeclarationKind.accessor);
      expect(tree.executables.last.kind, DeclarationKind.function);
    });

    test('ignora las sentencias del cuerpo de un método', () {
      final DeclarationTree tree = scanner.scan(
        scanOf(<String>[
          'class Guard {',
          '  void run() {',
          '    if (ready) {',
          '      return;',
          '    }',
          '    for (final int i in items) {',
          '      print(i);',
          '    }',
          '  }',
          '}',
        ]),
      );

      expect(tree.types, hasLength(1));
      expect(tree.executables, hasLength(1));
      expect(tree.executables.single.name, 'run');
    });

    test('detecta enums, mixins y typedefs', () {
      final DeclarationTree tree = scanner.scan(
        scanOf(<String>[
          'enum Level {',
          '  low,',
          '  high,',
          '}',
          '',
          'mixin Loggable {',
          '  void log();',
          '}',
          '',
          'typedef Callback = void Function(int value);',
        ]),
      );

      expect(tree.types.map((DeclarationBlock b) => b.kind), <DeclarationKind>[
        DeclarationKind.enumType,
        DeclarationKind.mixinType,
        DeclarationKind.typedefType,
      ]);
    });

    test('no confunde una asignación con una firma', () {
      final DeclarationTree tree = scanner.scan(
        scanOf(<String>[
          'class Holder {',
          '  final int total = compute();',
          '  final String name = build().trim();',
          '}',
        ]),
      );

      expect(tree.executables, isEmpty);
      expect(tree.types.single.lineCount, 4);
    });
  });
}
