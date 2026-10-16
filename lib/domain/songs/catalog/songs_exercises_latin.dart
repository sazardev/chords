/// Ejercicios de ritmos latinos: solo acordes, sin letra.
library;

import 'package:chords/domain/songs/catalog/song_authors.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Ejercicios de ritmos latinos: solo acordes, sin letra.
const List<Song> kLatinExercises = <Song>[
  Song(
    id: 'cumbiaInAm',
    title: 'Cumbia en La menor',
    author: kChordsAuthor,
    genre: 'cumbia',
    difficulty: 1,
    bpm: 92,
    strum: StrumPattern.cumbia,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am', 'Dm', 'Dm']),
        SongLine(<String>['Am', 'Am', 'E7', 'E7']),
        SongLine(<String>['Am', 'Dm', 'E7', 'Am']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'G', 'Am', 'Am']),
        SongLine(<String>['Dm', 'Dm', 'E7', 'E7']),
      ]),
    ],
  ),
  Song(
    id: 'salsaMontuno',
    title: 'Montuno de salsa en Do',
    author: kChordsAuthor,
    genre: 'salsa',
    difficulty: 2,
    bpm: 140,
    strum: StrumPattern.salsa,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'F', 'G7', 'F']),
        SongLine(<String>['C', 'F', 'G7', 'F']),
      ]),
      SongSection(SongPart.bridge, <SongLine>[
        SongLine(<String>['Dm7', 'G7', 'C6', 'A7']),
        SongLine(<String>['Dm7', 'G7', 'C6', 'C6']),
      ]),
    ],
  ),
  Song(
    id: 'rancheraInG',
    title: 'Ranchera en vals en Sol',
    author: kChordsAuthor,
    genre: 'ranchera',
    difficulty: 1,
    bpm: 112,
    strum: StrumPattern.valsRanchero,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G', 'D7', 'D7']),
        SongLine(<String>['D7', 'D7', 'G', 'G']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'C', 'G', 'D7']),
        SongLine(<String>['G', 'C', 'D7', 'G']),
      ]),
    ],
  ),
  Song(
    id: 'polkaNortena',
    title: 'Polka norteña en Sol',
    author: kChordsAuthor,
    genre: 'ranchera',
    difficulty: 2,
    bpm: 120,
    strum: StrumPattern.boomChick,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G', 'C', 'G']),
        SongLine(<String>['D7', 'D7', 'G', 'G']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'G', 'D7', 'G']),
        SongLine(<String>['C', 'G', 'D7', 'G']),
      ]),
    ],
  ),
  Song(
    id: 'flamencoRumba',
    title: 'Rumba flamenca en La menor',
    author: kChordsAuthor,
    genre: 'flamenco',
    difficulty: 2,
    bpm: 112,
    strum: StrumPattern.rumba,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'G', 'F', 'E']),
        SongLine(<String>['Am', 'G', 'F', 'E']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Am', 'Dm', 'E', 'Am']),
        SongLine(<String>['Am', 'G', 'F', 'E']),
      ]),
    ],
  ),
  Song(
    id: 'tangoInDm',
    title: 'Tango en Re menor',
    author: kChordsAuthor,
    genre: 'tango',
    difficulty: 3,
    bpm: 118,
    strum: StrumPattern.tango,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Dm', 'Dm', 'Gm', 'Gm']),
        SongLine(<String>['A7', 'A7', 'Dm', 'Dm']),
      ]),
      SongSection(SongPart.bridge, <SongLine>[
        SongLine(<String>['F', 'F', 'Bb', 'Bb']),
        SongLine(<String>['Gm', 'A7', 'Dm', 'Dm']),
      ]),
    ],
  ),
  Song(
    id: 'boleroInC',
    title: 'Bolero en Do',
    author: kChordsAuthor,
    genre: 'bolero',
    difficulty: 2,
    bpm: 80,
    strum: StrumPattern.bolero,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'Am', 'Dm', 'G7']),
        SongLine(<String>['C', 'A7', 'Dm', 'G7']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C7', 'F', 'Fm']),
        SongLine(<String>['C', 'G7', 'C', 'C']),
      ]),
    ],
  ),
  Song(
    id: 'reggaetonInAm',
    title: 'Dembow en La menor',
    author: kChordsAuthor,
    genre: 'reggaeton',
    difficulty: 1,
    bpm: 94,
    strum: StrumPattern.reggaeton,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'F', 'C', 'G']),
        SongLine(<String>['Am', 'F', 'C', 'G']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['F', 'G', 'Am', 'Am']),
        SongLine(<String>['F', 'G', 'Am', 'G']),
      ]),
    ],
  ),
  Song(
    id: 'merengueInG',
    title: 'Merengue en Sol',
    author: kChordsAuthor,
    genre: 'latin',
    difficulty: 2,
    bpm: 132,
    strum: StrumPattern.merengue,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G', 'C', 'D7']),
        SongLine(<String>['G', 'G', 'C', 'D7']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'G', 'D7', 'G']),
        SongLine(<String>['C', 'G', 'D7', 'G']),
      ]),
    ],
  ),
  Song(
    id: 'bachataInAm',
    title: 'Bachata en La menor',
    author: kChordsAuthor,
    genre: 'latin',
    difficulty: 2,
    bpm: 118,
    strum: StrumPattern.bachata,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Dm', 'G', 'C']),
        SongLine(<String>['F', 'E7', 'Am', 'Am']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Am', 'Dm', 'G', 'C']),
        SongLine(<String>['Am', 'Dm', 'E7', 'Am']),
      ]),
    ],
  ),
  Song(
    id: 'valsCriolloInAm',
    title: 'Vals criollo en La menor',
    author: kChordsAuthor,
    genre: 'latin',
    difficulty: 2,
    bpm: 140,
    strum: StrumPattern.valsCriollo,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am', 'E7', 'Am']),
        SongLine(<String>['Dm', 'Am', 'E7', 'Am']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'G', 'Am', 'E7']),
        SongLine(<String>['Am', 'Dm', 'E7', 'Am']),
      ]),
    ],
  ),
];
