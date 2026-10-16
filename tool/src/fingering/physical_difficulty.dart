/// Dificultad física de una digitación (1-5).
///
/// Mide lo que exige a la mano: dedos usados, cejillos, apertura, meñique y
/// cuerdas mudas en medio. El generador nunca etiqueta una posición más fácil
/// de lo que sale aquí y el validador comprueba que se respete.
///
/// Calibrada con las referencias de siempre: un acorde abierto de tres dedos
/// (Do, Sol, La, Mi menor) es 1, uno de cuatro dedos (Si7) es 2, el cejillo
/// completo (Fa, Si menor) es 3.
library;

import 'dart:math' as math;

import 'fingering_rules.dart';

/// Dificultad (1-5) que exige tocar [frets] con los dedos [fingers].
int physicalDifficulty(List<int> frets, List<int> fingers) {
  final List<FingerBlock> blocks = fingerBlocks(frets, fingers).values.toList();
  final FingerBlock? barre = _widestBarre(blocks);
  final int others = blocks.length - (barre == null ? 0 : 1);
  double score = 1;
  score += (others - 3).clamp(0, 2).toDouble();
  score += barre == null ? 0 : _barreCost(barre.width);
  score += _spanCost(frets);
  score += _fingerBarreCost(fingers, blocks);
  if (blocks.any((FingerBlock b) => fingers[b.first] == 4)) {
    score += 0.25;
  }
  score += _hasMutedInside(frets) ? 0.5 : 0;
  return (score - 0.5).ceil().clamp(1, 5);
}

/// El dedo que cubre más cuerdas seguidas, si cubre al menos dos.
FingerBlock? _widestBarre(List<FingerBlock> blocks) {
  FingerBlock? widest;
  for (final FingerBlock block in blocks) {
    if (block.strings.length > 1 &&
        (widest == null || block.width > widest.width)) {
      widest = block;
    }
  }
  return widest;
}

/// Cejillo con un dedo que no es el índice: el meñique es el más duro.
double _fingerBarreCost(List<int> fingers, List<FingerBlock> blocks) {
  double cost = 0;
  for (final FingerBlock block in blocks) {
    if (block.strings.length > 1 && fingers[block.first] != 1) {
      cost = fingers[block.first] == 4 ? 1.5 : math.max(cost, 0.5);
    }
  }
  return cost;
}

/// Coste del cejillo: más cuerdas, más cuesta.
double _barreCost(int width) {
  if (width >= 5) {
    return 2;
  }
  return width >= 3 ? 1.25 : 0.75;
}

/// Coste de la apertura entre el traste más bajo y el más alto.
double _spanCost(List<int> frets) {
  final List<int> pressed = <int>[
    for (final int fret in frets)
      if (fret > 0) fret,
  ]..sort();
  if (pressed.length < 2) {
    return 0;
  }
  return pressed.last - pressed.first >= 3 ? 0.5 : 0;
}

/// Hay cuerdas mudas entre la primera y la última que suenan (hay que
/// taparlas).
bool _hasMutedInside(List<int> frets) {
  final int first = frets.indexWhere((int f) => f >= 0);
  final int last = frets.lastIndexWhere((int f) => f >= 0);
  return first >= 0 && frets.sublist(first, last + 1).any((int f) => f < 0);
}
