/// Golpe de un hueco de corchea en un patrón de rasgueo.
enum StrumStroke {
  /// Silencio: la mano pasa sin tocar.
  rest,

  /// Rasgueo hacia abajo.
  down,

  /// Rasgueo hacia arriba.
  up,

  /// Bajo: solo la nota raíz en las cuerdas graves.
  bass,
}

/// Patrones de rasgueo, escritos en corcheas (dos huecos por pulso).
///
/// `D` abajo, `U` arriba, `B` bajo y `-` silencio. Un compás de 4/4 tiene
/// ocho huecos y uno de 3/4, seis.
enum StrumPattern {
  /// Un golpe por compás: para cambiar de acorde sin prisas.
  whole('D-------'),

  /// Pulso a pulso, todo hacia abajo.
  quarters('D-D-D-D-'),

  /// El rasgueo del pop: abajo, abajo-arriba, arriba-abajo-arriba.
  pop('D-DU-UDU'),

  /// Corcheas constantes del rock.
  eighths('DUDUDUDU'),

  /// Bajo y rasgueo alternados del country (boom-chick).
  boomChick('B-D-B-D-'),

  /// Reggae: solo en los contratiempos.
  skank('--D---D-'),

  /// Bossa nova: bajo en el pulso y acorde sincopado.
  bossa('B-DB-DB-'),

  /// Shuffle del blues: largo-corto en cada pulso.
  shuffle('D-UD-UD-'),

  /// Vals en 3/4: bajo y dos golpes.
  waltz('B-D-D-');

  /// Crea el patrón a partir de su notación.
  const StrumPattern(this.notation);

  /// Notación del patrón (`D-DU-UDU`).
  final String notation;

  /// Pulsos por compás (4 o 3).
  int get beatsPerBar => notation.length ~/ 2;

  /// Golpes del patrón, hueco a hueco.
  List<StrumStroke> get strokes => <StrumStroke>[
    for (final String char in notation.split(''))
      switch (char) {
        'D' => StrumStroke.down,
        'U' => StrumStroke.up,
        'B' => StrumStroke.bass,
        _ => StrumStroke.rest,
      },
  ];

  /// Resuelve un patrón por su nombre; `null` si no existe.
  static StrumPattern? fromName(String? name) {
    for (final StrumPattern pattern in StrumPattern.values) {
      if (pattern.name == name) {
        return pattern;
      }
    }
    return null;
  }
}
