import 'scanned_line.dart';

/// Bloque `switch` con su número de casos.
class SwitchBlock {
  /// Crea el bloque.
  const SwitchBlock({
    required this.startLine,
    required this.endLine,
    required this.caseCount,
  });

  /// Primera línea del `switch` (1-indexada).
  final int startLine;

  /// Última línea del `switch` (1-indexada).
  final int endLine;

  /// Número de `case` que contiene.
  final int caseCount;

  /// Número de líneas que ocupa.
  int get lineCount => endLine - startLine + 1;
}

/// Escáner de sentencias `switch` con llaves.
///
/// Ignora las expresiones `switch` de una sola línea (con `=>`), que son
/// idiomáticas y no acumulan casos. Los switches anidados se miden por
/// separado para que cada uno reciba su propio recuento de casos.
class SwitchScanner {
  /// Crea el escáner.
  const SwitchScanner();

  /// Detecta los bloques `switch` del archivo.
  List<SwitchBlock> scan(List<ScannedLine> lines) {
    final List<SwitchBlock> blocks = <SwitchBlock>[];
    int index = 0;
    while (index < lines.length) {
      if (!_isSwitchHead(lines[index])) {
        index++;
        continue;
      }
      blocks.add(_readSwitch(lines, index, blocks));
      index = blocks.last.endLine;
    }
    return blocks;
  }

  /// Lee el switch que empieza en [start] y lo añade a [sink].
  ///
  /// Los switches anidados encontrados por el camino se registran aparte.
  SwitchBlock _readSwitch(
    List<ScannedLine> lines,
    int start,
    List<SwitchBlock> sink,
  ) {
    final int startDepth = lines[start].depthBefore;
    final int bodyDepth = startDepth + 1;
    int cases = 0;
    int endLine = lines[start].number;
    int cursor = start + 1;
    while (cursor < lines.length && lines[cursor].depthAfter != startDepth) {
      final ScannedLine line = lines[cursor];
      if (_isSwitchHead(line)) {
        sink.add(_readSwitch(lines, cursor, sink));
        cursor = sink.last.endLine;
        continue;
      }
      if (line.depthBefore == bodyDepth && line.trimmed.startsWith('case ')) {
        cases++;
      }
      endLine = line.number;
      cursor++;
    }
    return SwitchBlock(
      startLine: lines[start].number,
      endLine: endLine,
      caseCount: cases,
    );
  }

  /// `true` si la línea abre una sentencia `switch` multilínea.
  bool _isSwitchHead(ScannedLine line) =>
      line.trimmed.startsWith('switch') &&
      line.trimmed.contains('(') &&
      line.opensBlock;
}
