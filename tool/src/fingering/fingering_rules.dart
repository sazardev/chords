/// Reglas físicas de una digitación de guitarra.
///
/// Dado el traste de cada cuerda y el dedo que la pisa, decide si la mano
/// puede hacerlo: un dedo no está en dos trastes a la vez, los dedos van
/// ordenados como los trastes, el cejillo no pasa por encima de una cuerda al
/// aire y la mano no se estira más de lo razonable. Las usan por igual el
/// validador del banco y el generador de digitaciones.
library;

/// Separación máxima de trastes entre el dedo más bajo y el más alto.
const int kMaxFretSpan = 3;

/// Un dedo puede estirarse un traste más de lo que le toca por su posición.
const int kExtraStretch = 1;

/// Grupo de cuerdas pisadas por un mismo dedo en un mismo traste.
class FingerBlock {
  /// Crea el grupo.
  const FingerBlock(this.fret, this.strings);

  /// Traste donde está el dedo.
  final int fret;

  /// Cuerdas (0 = sexta) que cubre, de grave a aguda.
  final List<int> strings;

  /// Primera y última cuerda que toca.
  int get first => strings.first;

  /// Última cuerda que toca.
  int get last => strings.last;

  /// Cuerdas que abarca de la primera a la última.
  int get width => last - first + 1;
}

/// Si [frets] entre [first] y [last] permite tender un dedo plano en [fret].
///
/// Ninguna cuerda intermedia puede estar al aire ni más abajo que [fret]:
/// el dedo la pisaría o la dejaría sonar distinto.
bool canLayFinger(List<int> frets, int fret, int first, int last) {
  for (int s = first; s <= last; s++) {
    if (frets[s] == 0 || (frets[s] > 0 && frets[s] < fret)) {
      return false;
    }
  }
  return true;
}

/// Problemas físicos de la digitación; vacío si se puede tocar.
List<String> fingeringIssues(List<int> frets, List<int> fingers) {
  final List<String> issues = <String>[];
  _checkAssignment(frets, fingers, issues);
  if (issues.isNotEmpty) {
    return issues;
  }
  final Map<int, FingerBlock> blocks = fingerBlocks(frets, fingers);
  _checkBlocks(frets, blocks, issues);
  _checkOrderAndReach(blocks, issues);
  return issues;
}

/// Grupos de cuerdas por dedo (solo cuerdas pisadas con dedo asignado).
Map<int, FingerBlock> fingerBlocks(List<int> frets, List<int> fingers) {
  final Map<int, List<int>> byFinger = <int, List<int>>{};
  for (int s = 0; s < frets.length; s++) {
    if (frets[s] > 0 && fingers[s] > 0) {
      byFinger.putIfAbsent(fingers[s], () => <int>[]).add(s);
    }
  }
  return <int, FingerBlock>{
    for (final MapEntry<int, List<int>> entry in byFinger.entries)
      entry.key: FingerBlock(frets[entry.value.first], entry.value),
  };
}

void _checkAssignment(List<int> frets, List<int> fingers, List<String> out) {
  for (int s = 0; s < frets.length; s++) {
    final bool pressed = frets[s] > 0;
    if (pressed && (fingers[s] < 1 || fingers[s] > 4)) {
      out.add('cuerda ${6 - s}: traste ${frets[s]} sin dedo válido');
    }
    if (!pressed && fingers[s] != 0) {
      out.add('cuerda ${6 - s}: no se pisa pero tiene dedo ${fingers[s]}');
    }
  }
}

void _checkBlocks(
  List<int> frets,
  Map<int, FingerBlock> blocks,
  List<String> out,
) {
  for (final MapEntry<int, FingerBlock> entry in blocks.entries) {
    final FingerBlock block = entry.value;
    final bool sameFret = block.strings.every(
      (int s) => frets[s] == block.fret,
    );
    if (!sameFret) {
      out.add('el dedo ${entry.key} está en trastes distintos');
    } else if (!canLayFinger(frets, block.fret, block.first, block.last)) {
      out.add('el dedo ${entry.key} tapa una cuerda al aire o más grave');
    }
  }
}

void _checkOrderAndReach(Map<int, FingerBlock> blocks, List<String> out) {
  final List<int> used = blocks.keys.toList()..sort();
  for (int i = 0; i < used.length; i++) {
    for (int j = i + 1; j < used.length; j++) {
      final int low = blocks[used[i]]!.fret;
      final int high = blocks[used[j]]!.fret;
      if (low > high) {
        out.add('el dedo ${used[i]} está más alto que el ${used[j]}');
      } else if (high - low > used[j] - used[i] + kExtraStretch) {
        out.add('los dedos ${used[i]} y ${used[j]} no llegan: $low→$high');
      }
    }
  }
  if (used.isNotEmpty) {
    final List<int> pressed = <int>[
      for (final FingerBlock b in blocks.values) b.fret,
    ]..sort();
    if (pressed.last - pressed.first > kMaxFretSpan) {
      out.add('abre ${pressed.last - pressed.first + 1} trastes (máx. 4)');
    }
  }
}

/// Cejillo que implica la digitación: el dedo que abarca más cuerdas de punta
/// a punta (a igual anchura, el del traste más bajo). `null` si ningún dedo
/// cubre dos cuerdas.
({int fret, int from, int to})? barreOf(List<int> frets, List<int> fingers) {
  FingerBlock? widest;
  for (final FingerBlock block in fingerBlocks(frets, fingers).values) {
    if (block.strings.length < 2) {
      continue;
    }
    final FingerBlock? current = widest;
    if (current == null ||
        block.width > current.width ||
        (block.width == current.width && block.fret < current.fret)) {
      widest = block;
    }
  }
  return widest == null
      ? null
      : (fret: widest.fret, from: widest.first, to: widest.last);
}
