/// Buscador de digitaciones: elige qué dedo pisa cada cuerda.
///
/// Prueba cómo repartir las cuerdas pisadas entre los cuatro dedos (con
/// cejillos cuando varias cuerdas comparten traste) y se queda con la
/// digitación válida más natural: el índice en el traste más bajo, un dedo por
/// traste en orden, el meñique solo si hace falta y el cejillo con el índice.
library;

import 'fingering_rules.dart';

/// Resultado: dedo por cuerda (0 = sin dedo).
typedef Fingering = List<int>;

/// Mejor digitación de [frets], o `null` si la mano no puede tocarla.
Fingering? solveFingering(List<int> frets) {
  final List<int> pressed = <int>[
    for (int s = 0; s < frets.length; s++)
      if (frets[s] > 0) s,
  ];
  if (pressed.isEmpty) {
    return List<int>.filled(frets.length, 0);
  }
  final int minFret = pressed.map((int s) => frets[s]).reduce(_min);
  Fingering? best;
  int bestCost = 1 << 30;
  for (final List<FingerBlock> blocks in _partitions(frets, pressed)) {
    if (blocks.length > 4) {
      continue;
    }
    for (final List<int> fingerOf in _permutations(blocks.length)) {
      final Fingering candidate = _fingersFor(frets, blocks, fingerOf);
      if (fingeringIssues(frets, candidate).isNotEmpty) {
        continue;
      }
      final int cost = _cost(blocks, fingerOf, minFret);
      if (cost < bestCost) {
        bestCost = cost;
        best = candidate;
      }
    }
  }
  return best;
}

/// Coste de una digitación: más bajo = más natural.
int _cost(List<FingerBlock> blocks, List<int> fingerOf, int minFret) {
  int cost = 0;
  for (int i = 0; i < blocks.length; i++) {
    final FingerBlock block = blocks[i];
    final int finger = fingerOf[i];
    final int natural = (block.fret - minFret + 1).clamp(1, 4);
    cost += 2 * (finger - natural).abs();
    if (finger == 4) {
      cost += 2;
    }
    if (block.strings.length > 1) {
      cost += finger == 1 ? 1 : 5;
    }
  }
  return cost;
}

Fingering _fingersFor(
  List<int> frets,
  List<FingerBlock> blocks,
  List<int> fingerOf,
) {
  final Fingering fingers = List<int>.filled(frets.length, 0);
  for (int i = 0; i < blocks.length; i++) {
    for (final int s in blocks[i].strings) {
      fingers[s] = fingerOf[i];
    }
  }
  return fingers;
}

/// Todas las formas de agrupar las cuerdas pisadas en dedos.
///
/// Cada traste se parte en bloques de cuerdas contiguas (entre sí) donde un
/// dedo plano cabe; los bloques de un mismo traste se ordenan de grave a agudo.
List<List<FingerBlock>> _partitions(List<int> frets, List<int> pressed) {
  final List<int> fretValues = <int>{
    for (final int s in pressed) frets[s],
  }.toList()..sort();
  List<List<FingerBlock>> result = <List<FingerBlock>>[<FingerBlock>[]];
  for (final int fret in fretValues) {
    final List<int> strings = <int>[
      for (final int s in pressed)
        if (frets[s] == fret) s,
    ];
    final List<List<FingerBlock>> options = <List<FingerBlock>>[
      for (final List<List<int>> split in _splits(strings))
        if (split.every(
          (List<int> group) =>
              canLayFinger(frets, fret, group.first, group.last),
        ))
          <FingerBlock>[
            for (final List<int> group in split) FingerBlock(fret, group),
          ],
    ];
    result = <List<FingerBlock>>[
      for (final List<FingerBlock> head in result)
        for (final List<FingerBlock> tail in options)
          if (head.length + tail.length <= 4) <FingerBlock>[...head, ...tail],
    ];
  }
  return result;
}

/// Particiones en grupos de cuerdas consecutivas (en el orden dado).
List<List<List<int>>> _splits(List<int> strings) {
  if (strings.isEmpty) {
    return <List<List<int>>>[<List<int>>[]];
  }
  final List<List<List<int>>> result = <List<List<int>>>[];
  for (int take = 1; take <= strings.length; take++) {
    for (final List<List<int>> rest in _splits(strings.sublist(take))) {
      result.add(<List<int>>[strings.sublist(0, take), ...rest]);
    }
  }
  return result;
}

/// Asignaciones de dedos distintos (1-4) a [count] bloques.
List<List<int>> _permutations(int count) {
  final List<List<int>> result = <List<int>>[];
  void build(List<int> current) {
    if (current.length == count) {
      result.add(List<int>.of(current));
      return;
    }
    for (int finger = 1; finger <= 4; finger++) {
      if (!current.contains(finger)) {
        build(<int>[...current, finger]);
      }
    }
  }

  build(<int>[]);
  return result;
}

int _min(int a, int b) => a < b ? a : b;
