/// Canciones infantiles y de ronda tradicionales en español.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Canciones infantiles y de ronda tradicionales en español.
const List<Song> kChildrenSongsEs = <Song>[
  Song(
    id: 'naranjaDulce',
    title: 'Naranja dulce',
    genre: 'folk',
    difficulty: 1,
    bpm: 96,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Naranja dulce, limón partido,'),
        SongLine(<String>['G7', 'C'], 'dame un abrazo que yo te pido.'),
        SongLine(<String>['C', 'C'], 'Si fueran falsos mis juramentos,'),
        SongLine(<String>['G7', 'G7'], 'en poco tiempo se olvidarán.'),
        SongLine(<String>['C', 'C7'], 'Toca la marcha, mi pecho llora,'),
        SongLine(<String>['F', 'C'], 'adiós, amores, me voy de aquí.'),
      ]),
    ],
  ),
  Song(
    id: 'arrozConLeche',
    title: 'Arroz con leche',
    genre: 'folk',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Arroz con leche me quiero casar'),
        SongLine(<String>['G7', 'C'], 'con una señorita de San Nicolás.'),
        SongLine(<String>['C', 'C'], 'Que sepa coser, que sepa bordar,'),
        SongLine(<String>[
          'G7',
          'C',
        ], 'que sepa abrir la puerta para ir a jugar.'),
      ]),
    ],
  ),
  Song(
    id: 'mambru',
    title: 'Mambrú se fue a la guerra',
    genre: 'folk',
    difficulty: 1,
    bpm: 96,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Mambrú se fue a la guerra,'),
        SongLine(<String>['G7', 'G7'], '¡qué dolor, qué dolor, qué pena!'),
        SongLine(<String>['C', 'C'], 'Mambrú se fue a la guerra,'),
        SongLine(<String>['G7', 'C'], 'no sé cuándo vendrá.'),
      ]),
    ],
  ),
  Song(
    id: 'campana',
    title: 'Campana sobre campana',
    genre: 'folk',
    difficulty: 2,
    bpm: 100,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am'], 'Campana sobre campana,'),
        SongLine(<String>['E7', 'Am'], 'y sobre campana una,'),
        SongLine(<String>['Am', 'Am'], 'asómate a la ventana,'),
        SongLine(<String>['E7', 'Am'], 'verás al Niño en la cuna.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Am', 'Dm'], 'Belén, campanas de Belén,'),
        SongLine(<String>['E7', 'E7'], 'que los ángeles tocan,'),
        SongLine(<String>['Am', 'Dm'], '¿qué nueva me traéis?'),
        SongLine(<String>['E7', 'Am']),
      ]),
    ],
  ),
  Song(
    id: 'peces',
    title: 'Los peces en el río',
    genre: 'folk',
    difficulty: 1,
    bpm: 104,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'Pero mira cómo beben'),
        SongLine(<String>['D7', 'D7'], 'los peces en el río,'),
        SongLine(<String>['G', 'G'], 'pero mira cómo beben'),
        SongLine(<String>['D7', 'G'], 'por ver a Dios nacido.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'C'], 'Beben y beben y vuelven a beber,'),
        SongLine(<String>[
          'D7',
          'G',
        ], 'los peces en el río por ver a Dios nacer.'),
      ]),
    ],
  ),
  Song(
    id: 'alfonso',
    title: '¿Dónde vas, Alfonso XII?',
    genre: 'folk',
    difficulty: 2,
    bpm: 90,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am'], '¿Dónde vas, Alfonso XII?'),
        SongLine(<String>['E7', 'E7'], '¿Dónde vas, triste de ti?'),
        SongLine(<String>['Am', 'Am'], 'Voy en busca de Mercedes'),
        SongLine(<String>['E7', 'Am'], 'que ayer tarde no la vi.'),
      ]),
    ],
  ),
  Song(
    id: 'vibora',
    title: 'A la víbora de la mar',
    genre: 'folk',
    difficulty: 1,
    bpm: 108,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'A la víbora, víbora,'),
        SongLine(<String>['G7', 'G7'], 'de la mar, de la mar,'),
        SongLine(<String>['G7', 'C'], 'por aquí pueden pasar,'),
        SongLine(<String>['G7', 'C'], 'por aquí pueden pasar.'),
      ]),
    ],
  ),
  Song(
    id: 'queLlueva',
    title: 'Que llueva',
    genre: 'folk',
    difficulty: 1,
    bpm: 96,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Que llueva, que llueva,'),
        SongLine(<String>['G7', 'C'], 'la Virgen de la cueva;'),
        SongLine(<String>['C', 'C'], 'los pajaritos cantan,'),
        SongLine(<String>['G7', 'C'], 'las nubes se levantan.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['F', 'C'], 'Que sí, que no,'),
        SongLine(<String>['G7', 'C'], 'que caiga un chaparrón.'),
      ]),
    ],
  ),
  Song(
    id: 'tarara',
    title: 'La Tarara',
    genre: 'folk',
    difficulty: 2,
    bpm: 112,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am'], 'La Tarara, sí;'),
        SongLine(<String>['E7', 'E7'], 'la Tarara, no;'),
        SongLine(<String>['Am', 'Am'], 'la Tarara, madre,'),
        SongLine(<String>['E7', 'Am'], 'que la he visto yo.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Am', 'Dm'], 'Lleva la Tarara un vestido verde,'),
        SongLine(<String>['E7', 'Am'], 'lleno de volantes y de cascabeles.'),
      ]),
    ],
  ),
  Song(
    id: 'elefantes',
    title: 'Un elefante se balanceaba',
    genre: 'folk',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Un elefante se balanceaba'),
        SongLine(<String>['G7', 'C'], 'sobre la tela de una araña;'),
        SongLine(<String>['C', 'C'], 'como veía que resistía'),
        SongLine(<String>['G7', 'C'], 'fue a llamar a otro elefante.'),
      ]),
    ],
  ),
  Song(
    id: 'arrorro',
    title: 'Arrorró mi niño',
    genre: 'ballad',
    difficulty: 1,
    bpm: 72,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Arrorró mi niño,'),
        SongLine(<String>['G7', 'G7'], 'arrorró mi amor,'),
        SongLine(<String>['C', 'F'], 'arrorró pedazo'),
        SongLine(<String>['G7', 'C'], 'de mi corazón.'),
      ]),
    ],
  ),
];
