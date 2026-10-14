/// Familia de una escala: decide cómo se agrupa en el catálogo.
enum ScaleFamily {
  /// Escalas de siete notas de la tonalidad mayor y menor.
  diatonic,

  /// Pentatónicas y blues: las escalas del solista.
  pentatonic,

  /// Modos griegos: colores de la escala mayor.
  modal,
}

/// Tipo de escala con sus intervalos desde la tónica.
enum ScaleType {
  /// Mayor (jónica): brillante, la base de la armonía.
  major('major', <int>[0, 2, 4, 5, 7, 9, 11], ScaleFamily.diatonic),

  /// Menor natural (eólica): triste y épica.
  naturalMinor('minor', <int>[0, 2, 3, 5, 7, 8, 10], ScaleFamily.diatonic),

  /// Menor armónica: séptima elevada, sabor clásico y flamenco.
  harmonicMinor('harmonicMinor', <int>[
    0,
    2,
    3,
    5,
    7,
    8,
    11,
  ], ScaleFamily.diatonic),

  /// Pentatónica menor: la escala del rock y el blues.
  minorPentatonic('minorPentatonic', <int>[
    0,
    3,
    5,
    7,
    10,
  ], ScaleFamily.pentatonic),

  /// Pentatónica mayor: country, pop y folk.
  majorPentatonic('majorPentatonic', <int>[
    0,
    2,
    4,
    7,
    9,
  ], ScaleFamily.pentatonic),

  /// Blues: pentatónica menor con la quinta disminuida (blue note).
  blues('blues', <int>[0, 3, 5, 6, 7, 10], ScaleFamily.pentatonic),

  /// Dórica: menor con sexta mayor; funk, jazz y Santana.
  dorian('dorian', <int>[0, 2, 3, 5, 7, 9, 10], ScaleFamily.modal),

  /// Frigia: menor con segunda menor; flamenco y metal.
  phrygian('phrygian', <int>[0, 1, 3, 5, 7, 8, 10], ScaleFamily.modal),

  /// Lidia: mayor con cuarta aumentada; soñadora.
  lydian('lydian', <int>[0, 2, 4, 6, 7, 9, 11], ScaleFamily.modal),

  /// Mixolidia: mayor con séptima menor; rock, blues y country.
  mixolydian('mixolydian', <int>[0, 2, 4, 5, 7, 9, 10], ScaleFamily.modal);

  /// Crea el tipo de escala.
  const ScaleType(this.id, this.intervals, this.family);

  /// Identificador estable (rutas y traducciones).
  final String id;

  /// Semitonos de cada grado desde la tónica, en orden ascendente.
  final List<int> intervals;

  /// Familia de la escala.
  final ScaleFamily family;

  /// Número de notas de la escala.
  int get length => intervals.length;

  /// `true` si su tercera es menor (suena "triste").
  bool get isMinor => intervals.contains(3) && !intervals.contains(4);

  /// Clases de tono de la escala con tónica [tonic] (0 = Do).
  List<int> pitchClasses(int tonic) => <int>[
    for (final int interval in intervals) (tonic + interval) % 12,
  ];

  /// `true` si la clase de tono [pitchClass] está en la escala de [tonic].
  bool contains(int tonic, int pitchClass) =>
      intervals.contains((pitchClass - tonic) % 12);

  /// Resuelve un tipo por su identificador; `null` si no existe.
  static ScaleType? fromId(String? id) {
    for (final ScaleType type in ScaleType.values) {
      if (type.id == id) {
        return type;
      }
    }
    return null;
  }
}

/// Nombre del intervalo de cada semitono como grado: `1`, `b3`, `#4`…
const List<String> kDegreeSymbols = <String>[
  '1',
  'b2',
  '2',
  'b3',
  '3',
  '4',
  'b5',
  '5',
  'b6',
  '6',
  'b7',
  '7',
];

/// Símbolo de grado de [pitchClass] respecto de la tónica [tonic].
///
/// En las escalas lidias el tritono es una cuarta aumentada (`#4`).
String degreeSymbol(int tonic, int pitchClass, {ScaleType? scale}) {
  final int interval = (pitchClass - tonic) % 12;
  if (interval == 6 && scale == ScaleType.lydian) {
    return '#4';
  }
  return kDegreeSymbols[interval];
}
