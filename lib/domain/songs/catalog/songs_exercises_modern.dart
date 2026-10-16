/// Ejercicios de rock, pop y baile: solo acordes, sin letra.
library;

import 'package:chords/domain/songs/catalog/song_authors.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Ejercicios de rock, pop y baile: solo acordes, sin letra.
const List<Song> kModernExercises = <Song>[
  Song(
    id: 'discoInAm',
    title: 'Disco en La menor',
    author: kChordsAuthor,
    genre: 'disco',
    difficulty: 2,
    bpm: 118,
    strum: StrumPattern.disco,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am7', 'Am7', 'Dm7', 'Dm7']),
        SongLine(<String>['G', 'G', 'C', 'Cmaj7']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'Cmaj7']),
        SongLine(<String>['Dm7', 'E7', 'Am7', 'Am7']),
      ]),
    ],
  ),
  Song(
    id: 'skaInG',
    title: 'Ska en Sol',
    author: kChordsAuthor,
    genre: 'ska',
    difficulty: 2,
    bpm: 150,
    strum: StrumPattern.ska,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G', 'C', 'C']),
        SongLine(<String>['G', 'G', 'D', 'D']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'C', 'G', 'D']),
        SongLine(<String>['G', 'C', 'D', 'G']),
      ]),
    ],
  ),
  Song(
    id: 'indieInD',
    title: 'Indie luminoso en Re',
    author: kChordsAuthor,
    genre: 'indie',
    difficulty: 2,
    bpm: 128,
    strum: StrumPattern.campfire,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['D', 'A', 'Bm', 'G']),
        SongLine(<String>['D', 'A', 'Bm', 'G']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Dsus2', 'Dsus4', 'Asus4', 'A']),
        SongLine(<String>['Bm', 'G', 'D', 'A']),
      ]),
    ],
  ),
  Song(
    id: 'grungeInE',
    title: 'Grunge en Mi',
    author: kChordsAuthor,
    genre: 'grunge',
    difficulty: 1,
    bpm: 104,
    strum: StrumPattern.downstrokes,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['E5', 'E5', 'C5', 'C5']),
        SongLine(<String>['G5', 'G5', 'D5', 'D5']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C5', 'D5', 'E5', 'E5']),
        SongLine(<String>['C5', 'D5', 'G5', 'E5']),
      ]),
    ],
  ),
  Song(
    id: 'lofiInC',
    title: 'Lo-fi en Do',
    author: kChordsAuthor,
    genre: 'lofi',
    difficulty: 2,
    bpm: 76,
    strum: StrumPattern.lofi,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Cmaj7', 'Em7', 'Fmaj7', 'Dm7']),
        SongLine(<String>['Cmaj7', 'Em7', 'Fmaj7', 'Dm7']),
      ]),
      SongSection(SongPart.bridge, <SongLine>[
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'Am7']),
        SongLine(<String>['Dm7', 'G7', 'Cmaj7', 'Cmaj7']),
      ]),
    ],
  ),
  Song(
    id: 'punkInE',
    title: 'Punk en Mi',
    author: kChordsAuthor,
    genre: 'punk',
    difficulty: 1,
    bpm: 170,
    strum: StrumPattern.downstrokes,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['E5', 'E5', 'A5', 'A5']),
        SongLine(<String>['E5', 'E5', 'B5', 'A5']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['A5', 'B5', 'E5', 'E5']),
        SongLine(<String>['A5', 'B5', 'E5', 'E5']),
      ]),
    ],
  ),
];
