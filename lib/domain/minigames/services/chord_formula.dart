/// Fórmula de intervalos de un acorde (`1 – ♭3 – 5 – ♭7`).
library;

/// Grado de cada intervalo simple (semitonos 0-11) con su alteración.
const List<String> _simpleDegrees = <String>[
  '1',
  '♭2',
  '2',
  '♭3',
  '3',
  '4',
  '♭5',
  '5',
  '♯5',
  '6',
  '♭7',
  '7',
];

/// Grado de cada intervalo compuesto (semitonos 12-23, ya menos 12).
const Map<int, String> _compoundDegrees = <int, String>{
  1: '♭9',
  2: '9',
  3: '♯9',
  5: '11',
  6: '♯11',
  8: '♭13',
  9: '13',
};

/// Nombres de los grados de [intervals] (semitonos desde la raíz).
///
/// Distingue la séptima disminuida (`♭♭7`) de la sexta, que comparten
/// semitonos, mirando si el acorde tiene tercera y quinta disminuidas.
List<String> formulaDegrees(List<int> intervals) {
  final Set<int> simple = <int>{for (final int i in intervals) i % 12};
  final bool diminishedSeventh =
      simple.containsAll(<int>{3, 6, 9}) &&
      !simple.contains(10) &&
      !simple.contains(11);
  return <String>[
    for (final int interval in intervals)
      if (interval == 9 && diminishedSeventh)
        '♭♭7'
      else if (interval >= 12)
        _compoundDegrees[interval % 12] ?? _simpleDegrees[interval % 12]
      else
        _simpleDegrees[interval],
  ];
}

/// Fórmula lista para mostrar: `1 – ♭3 – 5`.
String formulaText(List<int> intervals) =>
    formulaDegrees(intervals).join(' – ');
