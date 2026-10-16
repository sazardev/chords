/// Ejercicios de folk, country, jazz, soul, gospel y blues: solo acordes.
library;

import 'package:chords/domain/songs/catalog/song_authors.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Ejercicios de folk, country, jazz, soul, gospel y blues: solo acordes.
const List<Song> kClassicExercises = <Song>[
  Song(
    id: 'folkInG',
    title: 'Folk de fogata en Sol',
    author: kChordsAuthor,
    genre: 'folk',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.campfire,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'C', 'G', 'D']),
        SongLine(<String>['G', 'C', 'D', 'G']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Em', 'C', 'G', 'D']),
        SongLine(<String>['Em', 'C', 'D', 'G']),
      ]),
    ],
  ),
  Song(
    id: 'countryInG',
    title: 'Country boom-chick en Sol',
    author: kChordsAuthor,
    genre: 'country',
    difficulty: 1,
    bpm: 112,
    strum: StrumPattern.boomChick,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G', 'C', 'G']),
        SongLine(<String>['G', 'D7', 'G', 'G']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C', 'G', 'G']),
        SongLine(<String>['A7', 'D7', 'G', 'D7']),
      ]),
    ],
  ),
  Song(
    id: 'countryTrainInE',
    title: 'Tren de carga en Mi',
    author: kChordsAuthor,
    genre: 'country',
    difficulty: 2,
    bpm: 126,
    strum: StrumPattern.trainBeat,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['E', 'E', 'E', 'E']),
        SongLine(<String>['A', 'A', 'E', 'E']),
        SongLine(<String>['B7', 'A', 'E', 'B7']),
      ]),
    ],
  ),
  Song(
    id: 'reggaeInC',
    title: 'Reggae en Do',
    author: kChordsAuthor,
    genre: 'reggae',
    difficulty: 1,
    bpm: 76,
    strum: StrumPattern.skank,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'F', 'G', 'F']),
        SongLine(<String>['C', 'F', 'G', 'F']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Am', 'F', 'G', 'C']),
        SongLine(<String>['Am', 'F', 'G', 'C']),
      ]),
    ],
  ),
  Song(
    id: 'bossaInC',
    title: 'Bossa en Do',
    author: kChordsAuthor,
    genre: 'bossa',
    difficulty: 3,
    bpm: 120,
    strum: StrumPattern.bossa,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Cmaj7', 'A7', 'Dm7', 'G7']),
        SongLine(<String>['Cmaj7', 'A7', 'Dm7', 'G7']),
      ]),
      SongSection(SongPart.bridge, <SongLine>[
        SongLine(<String>['Em7', 'A7', 'Dm7', 'G7']),
        SongLine(<String>['Cmaj7', 'Am7', 'Dm7', 'G7']),
      ]),
    ],
  ),
  Song(
    id: 'jazz251InC',
    title: 'ii–V–I en Do',
    author: kChordsAuthor,
    genre: 'jazz',
    difficulty: 3,
    bpm: 100,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'Cmaj7']),
        SongLine(<String>['Em7', 'A7', 'Dm7', 'G7']),
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'A7']),
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'Cmaj7']),
      ]),
    ],
  ),
  Song(
    id: 'soulInC',
    title: 'Soul con séptimas mayores',
    author: kChordsAuthor,
    genre: 'soul',
    difficulty: 2,
    bpm: 80,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Fmaj7', 'Em7', 'Dm7', 'Cmaj7']),
        SongLine(<String>['Fmaj7', 'Em7', 'Dm7', 'Cmaj7']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Fmaj7', 'G7', 'Em7', 'Am7']),
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'Cmaj7']),
      ]),
    ],
  ),
  Song(
    id: 'gospelInC',
    title: 'Gospel con el IV menor',
    author: kChordsAuthor,
    genre: 'gospel',
    difficulty: 2,
    bpm: 76,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C7', 'F', 'Fm']),
        SongLine(<String>['C', 'G7', 'C', 'G7']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C7', 'F', 'Fm']),
        SongLine(<String>['C', 'G7', 'C', 'C']),
      ]),
    ],
  ),
  Song(
    id: 'balladInC',
    title: 'Balada arpegiada en Do',
    author: kChordsAuthor,
    genre: 'ballad',
    difficulty: 1,
    bpm: 68,
    strum: StrumPattern.arpeggio,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'G', 'Am', 'F']),
        SongLine(<String>['C', 'G', 'Am', 'F']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['F', 'C', 'G', 'G']),
        SongLine(<String>['F', 'G', 'C', 'C']),
      ]),
    ],
  ),
  Song(
    id: 'andaluzaInAm',
    title: 'Cadencia andaluza en La menor',
    author: kChordsAuthor,
    genre: 'latin',
    difficulty: 1,
    bpm: 96,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'G', 'F', 'E']),
        SongLine(<String>['Am', 'G', 'F', 'E']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Am', 'G', 'F', 'E7']),
        SongLine(<String>['Am', 'G', 'F', 'E']),
      ]),
    ],
  ),
  Song(
    id: 'bluesMinorInE',
    title: 'Blues menor en Mi',
    author: kChordsAuthor,
    genre: 'blues',
    difficulty: 2,
    bpm: 72,
    strum: StrumPattern.shuffle,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Em7', 'Em7', 'Em7', 'Em7']),
        SongLine(<String>['Am7', 'Am7', 'Em7', 'Em7']),
        SongLine(<String>['C7', 'B7', 'Em7', 'B7']),
      ]),
    ],
  ),
];
