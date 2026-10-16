/// Ejercicios básicos de blues, rock, pop, metal y funk: solo acordes.
library;

import 'package:chords/domain/songs/catalog/song_authors.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Ejercicios básicos de blues, rock, pop, metal y funk: solo acordes.
const List<Song> kCoreExercises = <Song>[
  Song(
    id: 'bluesInA',
    title: 'Blues en La · 12 compases',
    author: kChordsAuthor,
    genre: 'blues',
    difficulty: 1,
    bpm: 84,
    strum: StrumPattern.shuffle,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['A7', 'A7', 'A7', 'A7']),
        SongLine(<String>['D7', 'D7', 'A7', 'A7']),
        SongLine(<String>['E7', 'D7', 'A7', 'E7']),
      ]),
    ],
  ),
  Song(
    id: 'rockInE',
    title: 'Power chords en Mi',
    author: kChordsAuthor,
    genre: 'rock',
    difficulty: 2,
    bpm: 116,
    strum: StrumPattern.eighths,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['E5', 'E5', 'A5', 'A5']),
        SongLine(<String>['E5', 'E5', 'B5', 'A5']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G5', 'A5', 'E5', 'E5']),
        SongLine(<String>['G5', 'A5', 'B5', 'B5']),
      ]),
    ],
  ),
  Song(
    id: 'popFourChords',
    title: 'Los cuatro acordes del pop',
    author: kChordsAuthor,
    genre: 'pop',
    difficulty: 1,
    bpm: 90,
    strum: StrumPattern.pop,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'D', 'Em', 'C']),
        SongLine(<String>['G', 'D', 'Em', 'C']),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'G', 'D', 'Em']),
        SongLine(<String>['C', 'G', 'D', 'D']),
      ]),
    ],
  ),
  Song(
    id: 'metalGallop',
    title: 'Galope metalero en Mi menor',
    author: kChordsAuthor,
    genre: 'metal',
    difficulty: 2,
    bpm: 132,
    strum: StrumPattern.gallop,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['E5', 'E5', 'C5', 'D5']),
        SongLine(<String>['E5', 'E5', 'F5', 'E5']),
      ]),
    ],
  ),
  Song(
    id: 'funkVamp',
    title: 'Vamp funky en Mi',
    author: kChordsAuthor,
    genre: 'funk',
    difficulty: 3,
    bpm: 100,
    strum: StrumPattern.funkMuted,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Em7', 'Em7', 'A9', 'A9']),
        SongLine(<String>['Em7', 'Em7', 'A9', 'B7']),
      ]),
    ],
  ),
];
