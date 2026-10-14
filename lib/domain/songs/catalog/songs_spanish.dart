/// Canciones tradicionales y de dominio público en español.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Cancionero en español.
const List<Song> kSpanishSongs = <Song>[
  Song(
    id: 'cumpleanos',
    title: 'Cumpleaños feliz',
    author: 'Mildred y Patty Hill',
    genre: 'folk',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'D'], 'Cumpleaños feliz,'),
        SongLine(<String>['D', 'G'], 'te deseamos a ti,'),
        SongLine(<String>['G7', 'C'], 'cumpleaños querido,'),
        SongLine(<String>['G D', 'G'], 'cumpleaños feliz.'),
      ]),
    ],
  ),
  Song(
    id: 'estrellita',
    title: 'Estrellita, ¿dónde estás?',
    genre: 'folk',
    difficulty: 1,
    bpm: 92,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'F C'], 'Estrellita, ¿dónde estás?'),
        SongLine(<String>['F C', 'G7 C'], 'Me pregunto qué serás.'),
        SongLine(<String>['C F', 'C G7'], 'En el cielo y en el mar,'),
        SongLine(<String>['C F', 'C G7'], 'un diamante de verdad.'),
        SongLine(<String>['C', 'F C'], 'Estrellita, ¿dónde estás?'),
        SongLine(<String>['F C', 'G7 C'], 'Me pregunto qué serás.'),
      ]),
    ],
  ),
  Song(
    id: 'mananitas',
    title: 'Las mañanitas',
    genre: 'latin',
    difficulty: 1,
    bpm: 104,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'Estas son las mañanitas'),
        SongLine(<String>['D7', 'D7'], 'que cantaba el rey David;'),
        SongLine(<String>['D7', 'D7'], 'hoy por ser día de tu santo'),
        SongLine(<String>['G', 'G'], 'te las cantamos aquí.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'G'], 'Despierta, mi bien, despierta,'),
        SongLine(<String>['D7', 'D7'], 'mira que ya amaneció;'),
        SongLine(<String>['D7', 'D7'], 'ya los pajarillos cantan,'),
        SongLine(<String>['G', 'G'], 'la luna ya se metió.'),
      ]),
    ],
  ),
  Song(
    id: 'bamba',
    title: 'La bamba',
    genre: 'latin',
    difficulty: 1,
    bpm: 132,
    strum: StrumPattern.pop,
    sections: <SongSection>[
      SongSection(SongPart.intro, <SongLine>[
        SongLine(<String>['C F', 'G', 'C F', 'G']),
      ]),
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C F', 'G'], 'Para bailar la bamba,'),
        SongLine(<String>['C F', 'G'], 'para bailar la bamba se necesita'),
        SongLine(<String>['C F', 'G'], 'una poca de gracia,'),
        SongLine(<String>['C F', 'G'], 'una poca de gracia pa mí, pa ti,'),
        SongLine(<String>['C F', 'G'], 'ay, arriba y arriba.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C F', 'G'], 'Bamba, bamba,'),
        SongLine(<String>['C F', 'G'], 'bamba, bamba.'),
      ]),
    ],
  ),
  Song(
    id: 'cucaracha',
    title: 'La cucaracha',
    genre: 'latin',
    difficulty: 1,
    bpm: 128,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C'], 'La cucaracha, la cucaracha,'),
        SongLine(<String>['G7', 'G7'], 'ya no puede caminar,'),
        SongLine(<String>['G7', 'G7'], 'porque no tiene, porque le faltan'),
        SongLine(<String>['C', 'C'], 'las dos patitas de atrás.'),
      ]),
    ],
  ),
  Song(
    id: 'cielito',
    title: 'Cielito lindo',
    author: 'Quirino Mendoza y Cortés, 1882',
    genre: 'latin',
    difficulty: 2,
    bpm: 120,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'De la Sierra Morena,'),
        SongLine(<String>['G7', 'G7'], 'cielito lindo, vienen bajando'),
        SongLine(<String>['G7', 'G7'], 'un par de ojitos negros,'),
        SongLine(<String>['C', 'C'], 'cielito lindo, de contrabando.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C7'], '¡Ay, ay, ay, ay!'),
        SongLine(<String>['F', 'F'], 'Canta y no llores,'),
        SongLine(<String>['C', 'G7'], 'porque cantando se alegran,'),
        SongLine(<String>['G7', 'C'], 'cielito lindo, los corazones.'),
      ]),
    ],
  ),
  Song(
    id: 'colores',
    title: 'De colores',
    genre: 'folk',
    difficulty: 1,
    bpm: 108,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'De colores,'),
        SongLine(<String>['G', 'G'], 'de colores se visten los campos'),
        SongLine(<String>['D7', 'D7'], 'en la primavera.'),
        SongLine(<String>['D7', 'D7'], 'De colores,'),
        SongLine(<String>['D7', 'D7'], 'de colores son los pajaritos'),
        SongLine(<String>['G', 'G'], 'que vienen de afuera.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'G7'], 'Y por eso los grandes amores'),
        SongLine(<String>['C', 'C'], 'de muchos colores'),
        SongLine(<String>['D7', 'G'], 'me gustan a mí.'),
      ]),
    ],
  ),
  Song(
    id: 'llorona',
    title: 'La Llorona',
    genre: 'latin',
    difficulty: 2,
    bpm: 84,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am'], 'Todos me dicen el negro, Llorona,'),
        SongLine(<String>['E7', 'E7'], 'negro, pero cariñoso.'),
        SongLine(<String>['E7', 'E7'], 'Todos me dicen el negro, Llorona,'),
        SongLine(<String>['Am', 'Am'], 'negro, pero cariñoso.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Dm', 'Am'], 'Yo soy como el chile verde, Llorona,'),
        SongLine(<String>['E7', 'Am'], 'picante, pero sabroso.'),
        SongLine(<String>['Dm', 'Am'], 'Yo soy como el chile verde, Llorona,'),
        SongLine(<String>['E7', 'Am'], 'picante, pero sabroso.'),
      ]),
    ],
  ),
];
