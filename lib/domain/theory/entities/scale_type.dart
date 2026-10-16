import 'package:chords/domain/theory/entities/scale_family.dart';
import 'package:chords/domain/theory/entities/scale_formulas.dart';

export 'package:chords/domain/theory/entities/scale_family.dart';

/// Tipo de escala con sus intervalos desde la tónica.
///
/// Las fórmulas (grados escritos como `1 b3 4 5 b7`) están en
/// [kScaleFormulas]; los textos (nombre, carácter, estilos) en los catálogos
/// de traducciones.
enum ScaleType {
  /// Mayor (jónica): brillante, la base de la armonía.
  major('major', <int>[0, 2, 4, 5, 7, 9, 11], ScaleFamily.majorModes),

  /// Dórica: menor con sexta mayor; funk, jazz y Santana.
  dorian('dorian', <int>[0, 2, 3, 5, 7, 9, 10], ScaleFamily.majorModes),

  /// Frigia: menor con segunda menor; flamenco y metal.
  phrygian('phrygian', <int>[0, 1, 3, 5, 7, 8, 10], ScaleFamily.majorModes),

  /// Lidia: mayor con cuarta aumentada; soñadora.
  lydian('lydian', <int>[0, 2, 4, 6, 7, 9, 11], ScaleFamily.majorModes),

  /// Mixolidia: mayor con séptima menor; rock, blues y country.
  mixolydian('mixolydian', <int>[0, 2, 4, 5, 7, 9, 10], ScaleFamily.majorModes),

  /// Menor natural (eólica): triste y épica.
  naturalMinor('minor', <int>[0, 2, 3, 5, 7, 8, 10], ScaleFamily.minor),

  /// Locria: menor con segunda y quinta bemol; inestable, de metal y jazz.
  locrian('locrian', <int>[0, 1, 3, 5, 6, 8, 10], ScaleFamily.majorModes),

  /// Menor armónica: séptima elevada, sabor clásico y flamenco.
  harmonicMinor('harmonicMinor', <int>[
    0,
    2,
    3,
    5,
    7,
    8,
    11,
  ], ScaleFamily.minor),

  /// Menor melódica (la de jazz): menor con sexta y séptima mayores.
  melodicMinor('melodicMinor', <int>[0, 2, 3, 5, 7, 9, 11], ScaleFamily.minor),

  /// Locria ♮6: segundo modo de la menor armónica.
  locrianNatural6('locrianNatural6', <int>[
    0,
    1,
    3,
    5,
    6,
    9,
    10,
  ], ScaleFamily.harmonicModes),

  /// Jónica #5: tercer modo de la menor armónica.
  ionianSharp5('ionianSharp5', <int>[
    0,
    2,
    4,
    5,
    8,
    9,
    11,
  ], ScaleFamily.harmonicModes),

  /// Dórica #4 (ucraniana): cuarto modo de la menor armónica.
  ukrainianDorian('ukrainianDorian', <int>[
    0,
    2,
    3,
    6,
    7,
    9,
    10,
  ], ScaleFamily.harmonicModes),

  /// Frigia dominante: quinto modo de la menor armónica; flamenco y klezmer.
  phrygianDominant('phrygianDominant', <int>[
    0,
    1,
    4,
    5,
    7,
    8,
    10,
  ], ScaleFamily.harmonicModes),

  /// Lidia #2: sexto modo de la menor armónica.
  lydianSharp2('lydianSharp2', <int>[
    0,
    3,
    4,
    6,
    7,
    9,
    11,
  ], ScaleFamily.harmonicModes),

  /// Superlocria bb7: séptimo modo de la menor armónica.
  superLocrianBb7('superLocrianBb7', <int>[
    0,
    1,
    3,
    4,
    6,
    8,
    9,
  ], ScaleFamily.harmonicModes),

  /// Dórica b2: segundo modo de la menor melódica.
  dorianFlat2('dorianFlat2', <int>[
    0,
    1,
    3,
    5,
    7,
    9,
    10,
  ], ScaleFamily.melodicModes),

  /// Lidia aumentada: tercer modo de la menor melódica.
  lydianAugmented('lydianAugmented', <int>[
    0,
    2,
    4,
    6,
    8,
    9,
    11,
  ], ScaleFamily.melodicModes),

  /// Lidia dominante: cuarto modo de la menor melódica; dominantes con #11.
  lydianDominant('lydianDominant', <int>[
    0,
    2,
    4,
    6,
    7,
    9,
    10,
  ], ScaleFamily.melodicModes),

  /// Mixolidia b6 (hindú): quinto modo de la menor melódica.
  mixolydianFlat6('mixolydianFlat6', <int>[
    0,
    2,
    4,
    5,
    7,
    8,
    10,
  ], ScaleFamily.melodicModes),

  /// Locria #2 (semilocria): sexto modo de la menor melódica.
  locrianSharp2('locrianSharp2', <int>[
    0,
    2,
    3,
    5,
    6,
    8,
    10,
  ], ScaleFamily.melodicModes),

  /// Alterada (superlocria): séptimo modo de la menor melódica.
  altered('altered', <int>[0, 1, 3, 4, 6, 8, 10], ScaleFamily.melodicModes),

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

  /// Blues mayor: pentatónica mayor con la tercera menor como nota de paso.
  majorBlues('majorBlues', <int>[0, 2, 3, 4, 7, 9], ScaleFamily.pentatonic),

  /// Pentatónica menor con novena (hexatónica): pentatónica menor + 2.
  minorHexatonic('minorHexatonic', <int>[
    0,
    2,
    3,
    5,
    7,
    10,
  ], ScaleFamily.pentatonic),

  /// Pentatónica suspendida (egipcia): sin terceras, abierta y ambigua.
  suspendedPentatonic('suspendedPentatonic', <int>[
    0,
    2,
    5,
    7,
    10,
  ], ScaleFamily.pentatonic),

  /// Tonos enteros: seis notas a distancia de un tono; flotante y onírica.
  wholeTone('wholeTone', <int>[0, 2, 4, 6, 8, 10], ScaleFamily.symmetric),

  /// Disminuida tono-semitono: ocho notas simétricas sobre acordes dim.
  diminishedWholeHalf('diminishedWholeHalf', <int>[
    0,
    2,
    3,
    5,
    6,
    8,
    9,
    11,
  ], ScaleFamily.symmetric),

  /// Disminuida semitono-tono: ocho notas simétricas sobre dominantes.
  diminishedHalfWhole('diminishedHalfWhole', <int>[
    0,
    1,
    3,
    4,
    6,
    7,
    9,
    10,
  ], ScaleFamily.symmetric),

  /// Aumentada: seis notas alternando tercera menor y semitono.
  augmentedScale('augmentedScale', <int>[
    0,
    3,
    4,
    7,
    8,
    11,
  ], ScaleFamily.symmetric),

  /// Bebop dominante: mixolidia con la séptima mayor de paso.
  bebopDominant('bebopDominant', <int>[
    0,
    2,
    4,
    5,
    7,
    9,
    10,
    11,
  ], ScaleFamily.symmetric),

  /// Bebop mayor: mayor con la sexta menor de paso.
  bebopMajor('bebopMajor', <int>[
    0,
    2,
    4,
    5,
    7,
    8,
    9,
    11,
  ], ScaleFamily.symmetric),

  /// Húngara menor: menor armónica con cuarta aumentada.
  hungarianMinor('hungarianMinor', <int>[
    0,
    2,
    3,
    6,
    7,
    8,
    11,
  ], ScaleFamily.exotic),

  /// Doble armónica (arábiga, bizantina): dos segundas aumentadas.
  doubleHarmonic('doubleHarmonic', <int>[
    0,
    1,
    4,
    5,
    7,
    8,
    11,
  ], ScaleFamily.exotic),

  /// Hirajoshi: pentatónica japonesa de cinco notas.
  hirajoshi('hirajoshi', <int>[0, 2, 3, 7, 8], ScaleFamily.exotic),

  /// Napolitana menor: menor armónica con segunda bemol.
  neapolitanMinor('neapolitanMinor', <int>[
    0,
    1,
    3,
    5,
    7,
    8,
    11,
  ], ScaleFamily.exotic),

  /// Persa: siete notas con segunda y quinta bemol y tercera mayor.
  persian('persian', <int>[0, 1, 4, 5, 6, 8, 11], ScaleFamily.exotic);

  /// Crea el tipo de escala.
  const ScaleType(this.id, this.intervals, this.family);

  /// Identificador estable (rutas y traducciones).
  final String id;

  /// Semitonos de cada grado desde la tónica, en orden ascendente.
  final List<int> intervals;

  /// Familia de la escala.
  final ScaleFamily family;

  /// Las diez escalas de siempre: las que preguntan los juegos y las que
  /// enseña la guía de géneros.
  static const List<ScaleType> classics = <ScaleType>[
    major,
    naturalMinor,
    harmonicMinor,
    minorPentatonic,
    majorPentatonic,
    blues,
    dorian,
    phrygian,
    lydian,
    mixolydian,
  ];

  /// Número de notas de la escala.
  int get length => intervals.length;

  /// Grados de la escala como se escriben (`1`, `b3`, `#4`…), uno por nota.
  List<String> get formula => kScaleFormulas[this]!;

  /// Distancia en semitonos entre notas consecutivas, incluido el salto de
  /// la última a la octava (`2 2 1 2 2 2 1` en la mayor).
  List<int> get steps => <int>[
    for (int i = 0; i < intervals.length; i++)
      (i + 1 < intervals.length ? intervals[i + 1] : 12) - intervals[i],
  ];

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
/// Con [scale] se usa su propia escritura: el tritono es `#4` en las lidias
/// y `b5` en las locrias y en el blues.
String degreeSymbol(int tonic, int pitchClass, {ScaleType? scale}) {
  final int interval = (pitchClass - tonic) % 12;
  final int index = scale?.intervals.indexOf(interval) ?? -1;
  return index < 0 ? kDegreeSymbols[interval] : scale!.formula[index];
}
