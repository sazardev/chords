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
/// `D` abajo, `U` arriba, `B` bajo, `X` golpe muteado (percusivo: la mano
/// apaga las cuerdas y suena un "chasquido" sin nota) y `-` silencio. Un
/// compás de 4/4 tiene ocho huecos y uno de 3/4, seis.
///
/// El golpe muteado se resuelve como [StrumStroke.rest] en [strokes]: una
/// banda que solo conoce las cuatro flechas lo oye como un silencio, y quien
/// quiera dibujarlo o sonarlo aparte lo distingue con [isMuted].
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
  waltz('B-D-D-'),

  /// Cumbia: bajo en el 1 y el 3 y el "chiqui" en el contratiempo.
  cumbia('B-DUB-DU'),

  /// Salsa: acordes sincopados que dialogan con la clave.
  salsa('D-UD-DU-'),

  /// Reggaetón: el "dembow", golpes en el 1, el "y" del 2, el 3 y el 4.
  reggaeton('D--DD-D-'),

  /// Rumba flamenca: abajo, abajo-arriba, golpe y rasgueo de abanico.
  rumba('D-DUXUDU'),

  /// Ska: arriba y rapidísimo en todos los contratiempos.
  ska('-U-U-U-U'),

  /// Disco: cuatro por el piso con el contratiempo apagado.
  disco('DXDUDXDU'),

  /// Bolero: bajo grave y acordes con la síncopa suave del género.
  bolero('B-D-DUD-'),

  /// Tango marcato: golpes firmes y secos en cada pulso.
  tango('D-DXD-DU'),

  /// Vals ranchero (3/4): bajo y acorde con rebote final.
  valsRanchero('B-D-DU'),

  /// Vals criollo (3/4): bajo, y el acorde arrastrado hacia el tercer pulso.
  valsCriollo('B-DUD-'),

  /// Merengue: pulso constante con la mano pendiente del contratiempo.
  merengue('D-DUDUDU'),

  /// Bachata: bajo y golpes enlazados con acento en el 2 y el 4.
  bachata('B-DU-DU-'),

  /// Folk de fogata: abajo-abajo y un final sincopado.
  campfire('D-D-DUDU'),

  /// Funk muteado: golpes secos y arrastres entre acordes.
  funkMuted('DXXUDXXU'),

  /// Balada arpegiada: bajo y notas sueltas hacia arriba.
  arpeggio('B-U-D-U-'),

  /// Corcheas siempre hacia abajo: punk, grunge y rock pesado.
  downstrokes('DDDDDDDD'),

  /// Galope metalero: una corchea y dos semicorcheas, todo abajo.
  gallop('D-DDD-DD'),

  /// Lo-fi: acordes perezosos que se arrastran un poco.
  lofi('D--UD-U-'),

  /// Charleston del jazz: acorde en el 1 y el "y" del 2.
  charleston('D--D----'),

  /// Tren del country: bajo y dos golpes rápidos, "chu-chu".
  trainBeat('B-DDB-DD'),

  /// Tresillo (3+3+2): el motor de la habanera y la milonga.
  tresillo('D--D--D-'),

  /// Balada de rock: abajo-abajo y un golpe de impulso hacia el compás.
  rockBallad('D-D-DUD-');

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

  /// `true` si el hueco [slot] es un golpe muteado (`X`).
  bool isMuted(int slot) => notation[slot] == 'X';

  /// `true` si algún hueco es un golpe muteado.
  bool get hasMutedStrokes => notation.contains('X');

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
