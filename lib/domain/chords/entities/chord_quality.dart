import 'package:chords/domain/chords/entities/chord_family.dart';
import 'package:chords/domain/chords/entities/chord_quality_info.dart';
import 'package:chords/domain/chords/entities/chord_quality_table.dart';

/// Calidad (tipo) de acorde: define los intervalos que lo construyen.
///
/// El orden de los valores es el pedagógico: de las triadas básicas a los
/// acordes de jazz. Los metadatos que no son la construcción (fórmula,
/// descripción, géneros, familia…) viven en [ChordQualityInfo] y se consultan
/// con [info] o con los atajos de esta clase.
enum ChordQuality {
  /// Mayor: estable y brillante.
  major('maj', '', 'Mayor', <int>[0, 4, 7]),

  /// Menor: melancólica.
  minor('min', 'm', 'Menor', <int>[0, 3, 7]),

  /// Séptima de dominante: tensión que resuelve.
  seven('7', '7', 'Séptima de dominante', <int>[0, 4, 7, 10]),

  /// Séptima menor: suave y versátil.
  minorSeven('m7', 'm7', 'Séptima menor', <int>[0, 3, 7, 10]),

  /// Séptima mayor: soñadora.
  majorSeven('maj7', 'maj7', 'Séptima mayor', <int>[0, 4, 7, 11]),

  /// Suspendida 4: suspensión abierta.
  suspendedFourth('sus4', 'sus4', 'Suspendida 4', <int>[0, 5, 7]),

  /// Suspendida 2: abierta y moderna.
  suspendedSecond('sus2', 'sus2', 'Suspendida 2', <int>[0, 2, 7]),

  /// Power chord: raíz y quinta (con la octava de la raíz).
  power('5', '5', 'Quinta', <int>[0, 7]),

  /// Mayor con sexta añadida.
  sixth('6', '6', 'Sexta', <int>[0, 4, 7, 9]),

  /// Menor con sexta añadida.
  minorSixth('m6', 'm6', 'Sexta menor', <int>[0, 3, 7, 9]),

  /// Triada disminuida: inestable.
  diminished('dim', 'dim', 'Disminuido', <int>[0, 3, 6]),

  /// Triada aumentada: simétrica.
  augmented('aug', 'aug', 'Aumentado', <int>[0, 4, 8]),

  /// Novena de dominante: rica y moderna.
  ninth('9', '9', 'Novena', <int>[0, 4, 7, 10, 14]),

  /// Mayor con novena añadida (sin séptima).
  add9('add9', 'add9', 'Novena añadida', <int>[0, 4, 7, 14]),

  /// Menor con novena añadida (sin séptima).
  minorAdd9('madd9', 'madd9', 'Menor con novena añadida', <int>[0, 3, 7, 14]),

  /// Sexta con novena: cierre típico de jazz y bossa.
  sixNine('69', '6/9', 'Sexta con novena', <int>[0, 4, 7, 9, 14]),

  /// Novena menor: séptima menor con novena.
  minorNinth('m9', 'm9', 'Novena menor', <int>[0, 3, 7, 10, 14]),

  /// Novena mayor: séptima mayor con novena.
  majorNinth('maj9', 'maj9', 'Novena mayor', <int>[0, 4, 7, 11, 14]),

  /// Oncena de dominante.
  eleventh('11', '11', 'Oncena', <int>[0, 4, 7, 10, 14, 17]),

  /// Oncena menor.
  minorEleventh('m11', 'm11', 'Oncena menor', <int>[0, 3, 7, 10, 14, 17]),

  /// Trecena de dominante: funk y jazz.
  thirteenth('13', '13', 'Trecena', <int>[0, 4, 7, 10, 14, 21]),

  /// Séptima suspendida 4.
  sevenSus4('7sus4', '7sus4', 'Séptima suspendida 4', <int>[0, 5, 7, 10]),

  /// Novena suspendida 4.
  nineSus4('9sus4', '9sus4', 'Novena suspendida 4', <int>[0, 5, 7, 10, 14]),

  /// Menor con séptima mayor: misterio y tensión.
  minorMajorSeven('mMaj7', 'mMaj7', 'Menor con séptima mayor', <int>[
    0,
    3,
    7,
    11,
  ]),

  /// Semidisminuido (menor séptima con quinta bemol).
  halfDiminished('m7b5', 'm7b5', 'Semidisminuido', <int>[0, 3, 6, 10]),

  /// Séptima disminuida: simétrica de cuatro notas.
  diminishedSeven('dim7', 'dim7', 'Séptima disminuida', <int>[0, 3, 6, 9]),

  /// Séptima con novena menor (b9): dominante tenso.
  sevenFlatNine('7b9', '7b9', 'Séptima con novena menor', <int>[
    0,
    4,
    7,
    10,
    13,
  ]),

  /// Séptima con novena aumentada (#9): el acorde de Hendrix.
  sevenSharpNine('7s9', '7#9', 'Séptima con novena aumentada', <int>[
    0,
    4,
    7,
    10,
    15,
  ]),

  /// Séptima con quinta aumentada (aug7).
  sevenSharpFive('7s5', '7#5', 'Séptima aumentada', <int>[0, 4, 8, 10]),

  /// Séptima con quinta bemol.
  sevenFlatFive('7b5', '7b5', 'Séptima con quinta bemol', <int>[0, 4, 6, 10]),

  /// Séptima con oncena aumentada (lidia dominante).
  sevenSharpEleven('7s11', '7#11', 'Séptima con oncena aumentada', <int>[
    0,
    4,
    7,
    10,
    18,
  ]),

  /// Séptima mayor con oncena aumentada (lidia).
  majorSevenSharpEleven(
    'maj7s11',
    'maj7#11',
    'Séptima mayor con oncena aumentada',
    <int>[0, 4, 7, 11, 18],
  ),

  /// Séptima mayor con quinta aumentada.
  majorSevenSharpFive('maj7s5', 'maj7#5', 'Séptima mayor aumentada', <int>[
    0,
    4,
    8,
    11,
  ]);

  /// Crea una calidad con su construcción.
  const ChordQuality(this.id, this.suffix, this.label, this.intervals);

  /// Identificador estable usado en el banco de datos (sin símbolos: `7s9`).
  final String id;

  /// Sufijo del nombre del acorde (p. ej. `m7`).
  final String suffix;

  /// Etiqueta legible en español.
  final String label;

  /// Intervalos en semitonos desde la raíz (la novena es 14, la trecena 21).
  final List<int> intervals;

  /// Metadatos de la calidad: fórmula, descripción, géneros, familia…
  ChordQualityInfo get info => kChordQualityTable[this]!;

  /// Descripción musical breve.
  String get description => info.description;

  /// Géneros asociados a la calidad.
  List<String> get genres => info.genres;

  /// Familia a la que pertenece (triadas, séptimas, extendidos…).
  ChordFamily get family => info.family;

  /// Cuánto se usa la calidad (1 raro … 5 imprescindible).
  int get popularity => info.popularity;

  /// Dificultad mínima (1-5) de cualquier posición del acorde.
  int get minDifficulty => info.minDifficulty;

  /// Grados que construyen el acorde (`1`, `b3`, `5`, `b7`…).
  List<String> get formula => info.formula;

  /// Intervalos (módulo 12) que definen el acorde y no se pueden omitir.
  Set<int> get requiredIntervals => <int>{
    for (final int interval in intervals)
      if (!info.optional.contains(interval % 12)) interval % 12,
  };

  /// Clases de tono (0-11) del acorde construido sobre [root].
  Set<int> pitchClassesOn(int root) => <int>{
    for (final int interval in intervals) (root + interval) % 12,
  };

  /// Resuelve una calidad a partir de su identificador.
  ///
  /// Devuelve `null` si el identificador no es válido.
  static ChordQuality? fromId(String id) => _byId[id];

  static final Map<String, ChordQuality> _byId = <String, ChordQuality>{
    for (final ChordQuality quality in ChordQuality.values) quality.id: quality,
  };
}

/// Lista de géneros disponibles, ordenada por popularidad.
const List<String> kChordGenres = <String>[
  'Pop',
  'Rock',
  'Blues',
  'Jazz',
  'Funk',
  'Balada',
  'R&B',
  'Soul',
  'Latino',
  'Metal',
  'Bossa',
  'Country',
  'Infantil',
  'Ambient',
  'Clásico',
  'Gospel',
  'Punk',
];
