/// Calidad (tipo) de acorde: define los intervalos que lo construyen.
enum ChordQuality {
  /// Triada mayor: estable y brillante.
  major('maj', '', 'Mayor', <int>[0, 4, 7], 'Triada mayor; base de casi todo.'),

  /// Triada menor: melancólica.
  minor('min', 'm', 'Menor', <int>[
    0,
    3,
    7,
  ], 'Triada menor; color triste o íntimo.'),

  /// Séptima de dominante: tensión que resuelve a la tónica.
  seven('7', '7', 'Séptima de dominante', <int>[
    0,
    4,
    7,
    10,
  ], 'Blues y funk; tensión con resolución fuerte.'),

  /// Séptima menor: suave, muy usada en jazz y pop.
  minorSeven('m7', 'm7', 'Séptima menor', <int>[
    0,
    3,
    7,
    10,
  ], 'Suave y versátil; columna vertebral del ii-V-I.'),

  /// Séptima mayor: soñadora.
  majorSeven('maj7', 'maj7', 'Séptima mayor', <int>[
    0,
    4,
    7,
    11,
  ], 'Color soñador de pop y jazz.'),

  /// Cuarta suspendida: suspensión abierta.
  suspendedFourth('sus4', 'sus4', 'Suspendida 4', <int>[
    0,
    5,
    7,
  ], 'Suspensión abierta; suele resolver a mayor.'),

  /// Segunda suspendida: abierta y moderna.
  suspendedSecond('sus2', 'sus2', 'Suspendida 2', <int>[
    0,
    2,
    7,
  ], 'Abierta y etérea; habitual en pop y rock.'),

  /// Power chord de dos notas.
  power('5', '5', 'Quinta', <int>[
    0,
    7,
  ], 'Dos notas; rock, metal y distorsión.'),

  /// Mayor con sexta añadida.
  sixth('6', '6', 'Sexta', <int>[
    0,
    4,
    7,
    9,
  ], 'Aire vintage; frecuente en funk y folk.'),

  /// Menor con sexta añadida.
  minorSixth('m6', 'm6', 'Sexta menor', <int>[
    0,
    3,
    7,
    9,
  ], 'Color latino y jazz; muy expresiva.'),

  /// Triada disminuida: inestable.
  diminished('dim', 'dim', 'Disminuido', <int>[
    0,
    3,
    6,
  ], 'Tensión inestable; acorde de paso.'),

  /// Triada aumentada: simétrica.
  augmented('aug', 'aug', 'Aumentado', <int>[
    0,
    4,
    8,
  ], 'Simétrico y luminoso; enlaces cromáticos.'),

  /// Novena de dominante: color jazz.
  ninth('9', '9', 'Novena', <int>[
    0,
    4,
    7,
    10,
    14,
  ], 'Rica y moderna; funk y r&b.');

  /// Crea una calidad con sus metadatos.
  const ChordQuality(
    this.id,
    this.suffix,
    this.label,
    this.intervals,
    this.description,
  );

  /// Identificador estable usado en el banco de datos.
  final String id;

  /// Sufijo del nombre del acorde (p. ej. `m7`).
  final String suffix;

  /// Etiqueta legible en español.
  final String label;

  /// Intervalos en semitonos desde la raíz.
  final List<int> intervals;

  /// Descripción musical breve.
  final String description;

  /// Resuelve una calidad a partir de su identificador.
  ///
  /// Devuelve `null` si el identificador no es válido.
  static ChordQuality? fromId(String id) => switch (id) {
    'maj' => ChordQuality.major,
    'min' => ChordQuality.minor,
    '7' => ChordQuality.seven,
    'm7' => ChordQuality.minorSeven,
    'maj7' => ChordQuality.majorSeven,
    'sus4' => ChordQuality.suspendedFourth,
    'sus2' => ChordQuality.suspendedSecond,
    '5' => ChordQuality.power,
    '6' => ChordQuality.sixth,
    'm6' => ChordQuality.minorSixth,
    'dim' => ChordQuality.diminished,
    'aug' => ChordQuality.augmented,
    '9' => ChordQuality.ninth,
    _ => null,
  };
}
