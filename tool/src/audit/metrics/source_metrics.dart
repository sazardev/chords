import '../source_file.dart';
import 'class_members_scanner.dart';
import 'decision_point_counter.dart';
import 'declaration_block.dart';
import 'declaration_scanner.dart';
import 'declaration_tree.dart';
import 'function_block.dart';
import 'import_scanner.dart';
import 'line_scanner.dart';
import 'scanned_line.dart';
import 'switch_scanner.dart';
import 'type_summary.dart';

/// Métricas de forma y arquitectura de un archivo.
class SourceMetrics {
  /// Crea las métricas.
  const SourceMetrics({
    required this.path,
    required this.lineCount,
    required this.types,
    required this.functions,
    required this.switches,
    required this.imports,
  });

  /// Calcula las métricas de un archivo.
  factory SourceMetrics.compute(SourceFile file) {
    final List<ScannedLine> lines = const LineScanner().scan(file.lines);
    final DeclarationTree tree = const DeclarationScanner().scan(lines);
    final List<SwitchBlock> switches = const SwitchScanner().scan(lines);
    final List<ImportDirective> imports = const ImportScanner().scan(
      file.lines,
    );
    final List<FunctionBlock> functions = tree.executables
        .map(
          (DeclarationBlock block) => FunctionBlock(
            block,
            branchCount: const DecisionPointCounter().count(lines, block),
          ),
        )
        .toList();
    final List<TypeSummary> types = tree.types
        .map(
          (DeclarationBlock block) => TypeSummary(
            block,
            const ClassMembersScanner().count(lines, block),
          ),
        )
        .toList();
    return SourceMetrics(
      path: file.path,
      lineCount: file.lineCount,
      types: types,
      functions: functions,
      switches: switches,
      imports: imports,
    );
  }

  /// Ruta del archivo.
  final String path;

  /// Número de líneas del archivo.
  final int lineCount;

  /// Tipos declarados.
  final List<TypeSummary> types;

  /// Cuerpos ejecutables.
  final List<FunctionBlock> functions;

  /// Bloques `switch`.
  final List<SwitchBlock> switches;

  /// Directivas `import`.
  final List<ImportDirective> imports;

  /// Cuerpo ejecutable más grande del archivo; `null` si no hay ninguno.
  FunctionBlock? get largestFunction {
    FunctionBlock? largest;
    for (final FunctionBlock function in functions) {
      if (largest == null ||
          function.block.lineCount > largest.block.lineCount) {
        largest = function;
      }
    }
    return largest;
  }
}
