/// Corridos, rancheras y habaneras tradicionales de dominio público.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Corridos, rancheras y habaneras tradicionales de dominio público.
const List<Song> kRancheraSongs = <Song>[
  Song(
    id: 'adelita',
    title: 'La Adelita',
    genre: 'ranchera',
    difficulty: 2,
    bpm: 108,
    strum: StrumPattern.valsRanchero,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'En lo alto de la abrupta serranía,'),
        SongLine(<String>['D7', 'D7'], 'acampado se encontraba un regimiento'),
        SongLine(<String>['D7', 'D7'], 'y una moza que valiente lo seguía,'),
        SongLine(<String>['G', 'G'], 'locamente enamorada del sargento.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'G'], 'Y si Adelita se fuera con otro,'),
        SongLine(<String>['D7', 'D7'], 'la seguiría por tierra y por mar;'),
        SongLine(<String>['D7', 'D7'], 'si por mar en un buque de guerra,'),
        SongLine(<String>['G', 'G'], 'si por tierra en un tren militar.'),
      ]),
    ],
  ),
  Song(
    id: 'valentina',
    title: 'La Valentina',
    genre: 'ranchera',
    difficulty: 2,
    bpm: 112,
    strum: StrumPattern.valsRanchero,
    sections: <SongSection>[
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C'], 'Valentina, Valentina,'),
        SongLine(<String>['G7', 'G7'], 'rendido estoy a tus pies;'),
        SongLine(<String>['G7', 'G7'], 'si me han de matar mañana,'),
        SongLine(<String>['C', 'C'], 'que me maten de una vez.'),
      ]),
    ],
  ),
  Song(
    id: 'golondrina',
    title: 'La golondrina',
    author: 'Serradell y Zamacois, 1862',
    genre: 'ranchera',
    difficulty: 2,
    bpm: 84,
    strum: StrumPattern.valsRanchero,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], '¿A dónde irá veloz y fatigada'),
        SongLine(<String>['G7', 'G7'], 'la golondrina que de aquí se va?'),
        SongLine(<String>[
          'G7',
          'G7',
        ], 'Por si en el viento se hallara extraviada'),
        SongLine(<String>['C', 'C'], 'buscando abrigo y no lo encontrará.'),
      ]),
      SongSection(SongPart.outro, <SongLine>[
        SongLine(<String>['C', 'F C', 'G7', 'C']),
      ]),
    ],
  ),
  Song(
    id: 'paloma',
    title: 'La paloma',
    author: 'Sebastián Iradier, c. 1860',
    genre: 'bolero',
    difficulty: 2,
    bpm: 90,
    strum: StrumPattern.tresillo,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'G7'], 'Cuando salí de La Habana,'),
        SongLine(<String>['G7', 'C'], '¡válgame Dios!,'),
        SongLine(<String>['C', 'G7'], 'nadie me ha visto salir'),
        SongLine(<String>['G7', 'C'], 'si no fui yo.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C'], 'Si a tu ventana llega una paloma,'),
        SongLine(<String>['G7', 'G7'], 'trátala con cariño que es mi persona;'),
        SongLine(<String>['G7', 'G7'], 'cuéntale tus amores, bien de mi vida,'),
        SongLine(<String>['C', 'C'], 'corónala de flores que es cosa mía.'),
      ]),
    ],
  ),
];
