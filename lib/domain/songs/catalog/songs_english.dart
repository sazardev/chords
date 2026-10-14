/// Canciones tradicionales y de dominio público en inglés.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Cancionero en inglés.
const List<Song> kEnglishSongs = <Song>[
  Song(
    id: 'amazingGrace',
    title: 'Amazing Grace',
    author: 'John Newton, 1779',
    genre: 'gospel',
    difficulty: 1,
    bpm: 80,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'G',
          'G',
          'C',
          'G',
        ], 'Amazing grace, how sweet the sound'),
        SongLine(<String>['G', 'G', 'D', 'D'], 'that saved a wretch like me.'),
        SongLine(<String>[
          'G',
          'G7',
          'C',
          'G',
        ], 'I once was lost, but now am found,'),
        SongLine(<String>['G', 'D', 'G', 'G'], 'was blind, but now I see.'),
      ]),
    ],
  ),
  Song(
    id: 'saints',
    title: 'When the Saints Go Marching In',
    genre: 'gospel',
    difficulty: 1,
    bpm: 120,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>[
          'C',
          'C',
          'C',
          'C',
        ], 'Oh, when the saints go marching in,'),
        SongLine(<String>[
          'C',
          'C',
          'G7',
          'G7',
        ], 'oh, when the saints go marching in,'),
        SongLine(<String>[
          'C',
          'C7',
          'F',
          'F',
        ], 'oh Lord, I want to be in that number'),
        SongLine(<String>[
          'C',
          'G7',
          'C',
          'C',
        ], 'when the saints go marching in.'),
      ]),
    ],
  ),
  Song(
    id: 'risingSun',
    title: 'The House of the Rising Sun',
    genre: 'blues',
    difficulty: 2,
    bpm: 76,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'Am',
          'C',
          'D',
          'F',
        ], 'There is a house in New Orleans'),
        SongLine(<String>['Am', 'C', 'E', 'E'], 'they call the Rising Sun,'),
        SongLine(<String>[
          'Am',
          'C',
          'D',
          'F',
        ], "and it's been the ruin of many a poor boy,"),
        SongLine(<String>['Am', 'E', 'Am', 'E'], "and God, I know I'm one."),
      ]),
    ],
  ),
  Song(
    id: 'susanna',
    title: 'Oh! Susanna',
    author: 'Stephen Foster, 1848',
    genre: 'country',
    difficulty: 1,
    bpm: 112,
    strum: StrumPattern.boomChick,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'C',
          'C',
          'C',
          'G7',
        ], 'I come from Alabama with a banjo on my knee,'),
        SongLine(<String>[
          'C',
          'C',
          'G7',
          'C',
        ], "I'm going to Louisiana, my true love for to see."),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>[
          'F',
          'F',
          'C',
          'G7',
        ], "Oh! Susanna, oh, don't you cry for me,"),
        SongLine(<String>[
          'C',
          'C',
          'G7',
          'C',
        ], 'for I come from Alabama with a banjo on my knee.'),
      ]),
    ],
  ),
  Song(
    id: 'redRiver',
    title: 'Red River Valley',
    genre: 'country',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.boomChick,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'G',
          'G',
          'G',
          'D7',
        ], 'From this valley they say you are going,'),
        SongLine(<String>[
          'D7',
          'D7',
          'D7',
          'G',
        ], 'we will miss your bright eyes and sweet smile,'),
        SongLine(<String>[
          'G',
          'G7',
          'C',
          'C',
        ], 'for they say you are taking the sunshine'),
        SongLine(<String>[
          'G',
          'D7',
          'G',
          'G',
        ], 'that has brightened our pathway a while.'),
      ]),
    ],
  ),
  Song(
    id: 'homeRange',
    title: 'Home on the Range',
    author: 'Brewster Higley, 1872',
    genre: 'country',
    difficulty: 2,
    bpm: 120,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'G',
          'G',
          'C',
          'C',
        ], 'Oh, give me a home where the buffalo roam,'),
        SongLine(<String>[
          'G',
          'G',
          'A7',
          'D7',
        ], 'where the deer and the antelope play,'),
        SongLine(<String>[
          'G',
          'G7',
          'C',
          'C',
        ], 'where seldom is heard a discouraging word'),
        SongLine(<String>[
          'G',
          'D7',
          'G',
          'G',
        ], 'and the skies are not cloudy all day.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['D7', 'D7', 'G', 'G'], 'Home, home on the range,'),
        SongLine(<String>[
          'G',
          'G',
          'A7',
          'D7',
        ], 'where the deer and the antelope play,'),
        SongLine(<String>[
          'G',
          'G7',
          'C',
          'C',
        ], 'where seldom is heard a discouraging word'),
        SongLine(<String>[
          'G',
          'D7',
          'G',
          'G',
        ], 'and the skies are not cloudy all day.'),
      ]),
    ],
  ),
  Song(
    id: 'greensleeves',
    title: 'Greensleeves',
    genre: 'folk',
    difficulty: 2,
    bpm: 96,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'Am',
          'G',
          'F',
          'E',
        ], 'Alas, my love, you do me wrong'),
        SongLine(<String>[
          'Am',
          'G',
          'F E',
          'E',
        ], 'to cast me off discourteously,'),
        SongLine(<String>[
          'Am',
          'G',
          'F',
          'E',
        ], 'for I have loved you well and long,'),
        SongLine(<String>[
          'Am',
          'G',
          'F E',
          'Am',
        ], 'delighting in your company.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'G', 'F', 'E'], 'Greensleeves was all my joy,'),
        SongLine(<String>[
          'C',
          'G',
          'F E',
          'E',
        ], 'Greensleeves was my delight,'),
        SongLine(<String>[
          'C',
          'G',
          'F',
          'E',
        ], 'Greensleeves was my heart of gold,'),
        SongLine(<String>[
          'Am',
          'G',
          'F E',
          'Am',
        ], 'and who but my lady Greensleeves.'),
      ]),
    ],
  ),
  Song(
    id: 'auldLangSyne',
    title: 'Auld Lang Syne',
    author: 'Robert Burns, 1788',
    genre: 'folk',
    difficulty: 2,
    bpm: 84,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'G',
          'D',
          'G',
          'C',
        ], 'Should auld acquaintance be forgot'),
        SongLine(<String>['G', 'D', 'Em C', 'D'], 'and never brought to mind?'),
        SongLine(<String>[
          'G',
          'D',
          'G',
          'C',
        ], 'Should auld acquaintance be forgot'),
        SongLine(<String>['G', 'Em C', 'D', 'G'], 'and auld lang syne?'),
      ]),
    ],
  ),
  Song(
    id: 'jingleBells',
    title: 'Jingle Bells',
    author: 'James Lord Pierpont, 1857',
    genre: 'folk',
    difficulty: 1,
    bpm: 120,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>[
          'G',
          'G',
          'G',
          'G',
        ], 'Jingle bells, jingle bells, jingle all the way!'),
        SongLine(<String>[
          'C',
          'G',
          'A7',
          'D7',
        ], 'Oh, what fun it is to ride in a one-horse open sleigh, hey!'),
        SongLine(<String>[
          'G',
          'G',
          'G',
          'G',
        ], 'Jingle bells, jingle bells, jingle all the way!'),
        SongLine(<String>[
          'C',
          'G',
          'D7',
          'G',
        ], 'Oh, what fun it is to ride in a one-horse open sleigh!'),
      ]),
    ],
  ),
];
