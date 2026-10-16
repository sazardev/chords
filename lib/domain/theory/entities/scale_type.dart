import 'package:chords/domain/theory/entities/scale_family.dart';

export 'package:chords/domain/theory/entities/scale_family.dart';

/// Tipo de escala con sus intervalos desde la tónica.
///
/// Las fórmulas (grados escritos como `1 b3 4 5 b7`) están en
/// [kScaleFormulas]; los textos (nombre, carácter, estilos) en los catálogos
/// de traducciones.
enum ScaleType {
  /// Mayor (jónica): brillante, la base de la armonía.
  major('major', '1 2 3 4 5 6 7', ScaleFamily.majorModes),

  /// Dórica: menor con sexta mayor; funk, jazz y Santana.
  dorian('dorian', '1 2 b3 4 5 6 b7', ScaleFamily.majorModes),

  /// Frigia: menor con segunda menor; flamenco y metal.
  phrygian('phrygian', '1 b2 b3 4 5 b6 b7', ScaleFamily.majorModes),

  /// Lidia: mayor con cuarta aumentada; soñadora.
  lydian('lydian', '1 2 3 #4 5 6 7', ScaleFamily.majorModes),

  /// Mixolidia: mayor con séptima menor; rock, blues y country.
  mixolydian('mixolydian', '1 2 3 4 5 6 b7', ScaleFamily.majorModes),

  /// Menor natural (eólica): triste y épica.
  naturalMinor('minor', '1 2 b3 4 5 b6 b7', ScaleFamily.minor),

  /// Locria: menor con segunda y quinta bemol; inestable, de metal y jazz.
  locrian('locrian', '1 b2 b3 4 b5 b6 b7', ScaleFamily.majorModes),

  /// Menor armónica: séptima elevada, sabor clásico y flamenco.
  harmonicMinor('harmonicMinor', '1 2 b3 4 5 b6 7', ScaleFamily.minor),

  /// Menor melódica (la de jazz): menor con sexta y séptima mayores.
  melodicMinor('melodicMinor', '1 2 b3 4 5 6 7', ScaleFamily.minor),

  /// Locria ♮6: segundo modo de la menor armónica.
  locrianNatural6(
    'locrianNatural6',
    '1 b2 b3 4 b5 6 b7',
    ScaleFamily.harmonicModes,
  ),

  /// Jónica #5: tercer modo de la menor armónica.
  ionianSharp5('ionianSharp5', '1 2 3 4 #5 6 7', ScaleFamily.harmonicModes),

  /// Dórica #4 (ucraniana): cuarto modo de la menor armónica.
  ukrainianDorian(
    'ukrainianDorian',
    '1 2 b3 #4 5 6 b7',
    ScaleFamily.harmonicModes,
  ),

  /// Frigia dominante: quinto modo de la menor armónica; flamenco y klezmer.
  phrygianDominant(
    'phrygianDominant',
    '1 b2 3 4 5 b6 b7',
    ScaleFamily.harmonicModes,
  ),

  /// Lidia #2: sexto modo de la menor armónica.
  lydianSharp2('lydianSharp2', '1 #2 3 #4 5 6 7', ScaleFamily.harmonicModes),

  /// Superlocria bb7: séptimo modo de la menor armónica.
  superLocrianBb7(
    'superLocrianBb7',
    '1 b2 b3 b4 b5 b6 bb7',
    ScaleFamily.harmonicModes,
  ),

  /// Dórica b2: segundo modo de la menor melódica.
  dorianFlat2('dorianFlat2', '1 b2 b3 4 5 6 b7', ScaleFamily.melodicModes),

  /// Lidia aumentada: tercer modo de la menor melódica.
  lydianAugmented(
    'lydianAugmented',
    '1 2 3 #4 #5 6 7',
    ScaleFamily.melodicModes,
  ),

  /// Lidia dominante: cuarto modo de la menor melódica; dominantes con #11.
  lydianDominant('lydianDominant', '1 2 3 #4 5 6 b7', ScaleFamily.melodicModes),

  /// Mixolidia b6 (hindú): quinto modo de la menor melódica.
  mixolydianFlat6(
    'mixolydianFlat6',
    '1 2 3 4 5 b6 b7',
    ScaleFamily.melodicModes,
  ),

  /// Locria #2 (semilocria): sexto modo de la menor melódica.
  locrianSharp2('locrianSharp2', '1 2 b3 4 b5 b6 b7', ScaleFamily.melodicModes),

  /// Alterada (superlocria): séptimo modo de la menor melódica.
  altered('altered', '1 b2 #2 3 b5 #5 b7', ScaleFamily.melodicModes),

  /// Pentatónica menor: la escala del rock y el blues.
  minorPentatonic('minorPentatonic', '1 b3 4 5 b7', ScaleFamily.pentatonic),

  /// Pentatónica mayor: country, pop y folk.
  majorPentatonic('majorPentatonic', '1 2 3 5 6', ScaleFamily.pentatonic),

  /// Blues: pentatónica menor con la quinta disminuida (blue note).
  blues('blues', '1 b3 4 b5 5 b7', ScaleFamily.pentatonic),

  /// Blues mayor: pentatónica mayor con la tercera menor como nota de paso.
  majorBlues('majorBlues', '1 2 b3 3 5 6', ScaleFamily.pentatonic),

  /// Pentatónica menor con novena (hexatónica): pentatónica menor + 2.
  minorHexatonic('minorHexatonic', '1 2 b3 4 5 b7', ScaleFamily.pentatonic),

  /// Pentatónica suspendida (egipcia): sin terceras, abierta y ambigua.
  suspendedPentatonic(
    'suspendedPentatonic',
    '1 2 4 5 b7',
    ScaleFamily.pentatonic,
  ),

  /// Tonos enteros: seis notas a distancia de un tono; flotante y onírica.
  wholeTone('wholeTone', '1 2 3 #4 #5 b7', ScaleFamily.symmetric),

  /// Disminuida tono-semitono: ocho notas simétricas sobre acordes dim.
  diminishedWholeHalf(
    'diminishedWholeHalf',
    '1 2 b3 4 b5 b6 6 7',
    ScaleFamily.symmetric,
  ),

  /// Disminuida semitono-tono: ocho notas simétricas sobre dominantes.
  diminishedHalfWhole(
    'diminishedHalfWhole',
    '1 b2 #2 3 #4 5 6 b7',
    ScaleFamily.symmetric,
  ),

  /// Aumentada: seis notas alternando tercera menor y semitono.
  augmentedScale('augmentedScale', '1 #2 3 5 #5 7', ScaleFamily.symmetric),

  /// Bebop dominante: mixolidia con la séptima mayor de paso.
  bebopDominant('bebopDominant', '1 2 3 4 5 6 b7 7', ScaleFamily.symmetric),

  /// Bebop mayor: mayor con la sexta menor de paso.
  bebopMajor('bebopMajor', '1 2 3 4 5 b6 6 7', ScaleFamily.symmetric),

  /// Húngara menor: menor armónica con cuarta aumentada.
  hungarianMinor('hungarianMinor', '1 2 b3 #4 5 b6 7', ScaleFamily.exotic),

  /// Doble armónica (arábiga, bizantina): dos segundas aumentadas.
  doubleHarmonic('doubleHarmonic', '1 b2 3 4 5 b6 7', ScaleFamily.exotic),

  /// Hirajoshi: pentatónica japonesa de cinco notas.
  hirajoshi('hirajoshi', '1 2 b3 5 b6', ScaleFamily.exotic),

  /// Napolitana menor: menor armónica con segunda bemol.
  neapolitanMinor('neapolitanMinor', '1 b2 b3 4 5 b6 7', ScaleFamily.exotic),

  /// Persa: siete notas con segunda y quinta bemol y tercera mayor.
  persian('persian', '1 b2 3 4 b5 b6 7', ScaleFamily.exotic);

  /// Crea el tipo de escala con su fórmula de grados (`1 2 b3 4 5 b6 7`).
  const ScaleType(this.id, this._formula, this.family);

  /// Identificador estable (rutas y traducciones).
  final String id;

  final String _formula;

  /// Semitonos de cada grado desde la tónica, en orden ascendente.
  ///
  /// Se deducen de la fórmula: es la única fuente de verdad de la escala.
  List<int> get intervals => _intervalsOf[this]!;

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
  List<String> get formula => _formulaOf[this]!;

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

  static final Map<ScaleType, List<String>> _formulaOf =
      <ScaleType, List<String>>{
        for (final ScaleType type in ScaleType.values)
          type: type._formula.split(' '),
      };

  static final Map<ScaleType, List<int>> _intervalsOf = <ScaleType, List<int>>{
    for (final ScaleType type in ScaleType.values)
      type: <int>[
        for (final String degree in type._formula.split(' '))
          semitonesOfDegree(degree),
      ],
  };

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

/// Semitonos que separan un grado escrito (`1`, `b3`, `#4`, `bb7`) de la
/// tónica.
int semitonesOfDegree(String degree) {
  const Map<String, int> natural = <String, int>{
    '1': 0,
    '2': 2,
    '3': 4,
    '4': 5,
    '5': 7,
    '6': 9,
    '7': 11,
  };
  final String number = degree.replaceAll(RegExp('[b#]'), '');
  final int shift = degree.split('#').length - degree.split('b').length;
  return (natural[number]! + shift) % 12;
}
