import 'declaration_block.dart';
import 'scanned_line.dart';

/// Marcadores que neutralizan operadores con `?` o `=` para el conteo.
final List<RegExp> _neutralizers = <RegExp>[
  RegExp(r'\?[.=]'),
  RegExp(r'\?\?'),
  RegExp('=+'),
  RegExp('!='),
  RegExp('<='),
  RegExp('>='),
];

/// Patrones que suman un punto de decisión.
final List<RegExp> _branchPatterns = <RegExp>[
  RegExp(r'\bif\s*\('),
  RegExp(r'\belse\s+if\b'),
  RegExp(r'\bfor\s*\('),
  RegExp(r'\bwhile\s*\('),
  RegExp(r'\bcase\s'),
  RegExp(r'\bcatch\s*\('),
  RegExp('&&'),
  RegExp(r'\|\|'),
  RegExp(r'\?[^?]*:'),
];

/// Contador de puntos de decisión (base de la complejidad ciclomática).
class DecisionPointCounter {
  /// Crea el contador.
  const DecisionPointCounter();

  /// Cuenta los puntos de decisión dentro del bloque indicado.
  int count(List<ScannedLine> lines, DeclarationBlock block) {
    final int from = block.startLine - 1;
    final int to = block.endLine;
    int branches = 0;
    for (int index = from; index < to && index < lines.length; index++) {
      branches += _countLine(lines[index].code);
    }
    return branches;
  }

  /// Puntos de decisión de una línea de código ya normalizada.
  int _countLine(String code) {
    String normalized = code;
    for (final RegExp neutralizer in _neutralizers) {
      normalized = normalized.replaceAll(neutralizer, '@@');
    }
    int total = 0;
    for (final RegExp pattern in _branchPatterns) {
      total += pattern.allMatches(normalized).length;
    }
    return total;
  }
}
