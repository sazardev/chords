/// Espirituales, himnos y villancicos de dominio público.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Espirituales, himnos y villancicos de dominio público.
const List<Song> kGospelSongsEn = <Song>[
  Song(
    id: 'swingLow',
    title: 'Swing Low, Sweet Chariot',
    genre: 'gospel',
    difficulty: 1,
    bpm: 76,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G7'], 'Swing low, sweet chariot,'),
        SongLine(<String>['C', 'G'], 'coming for to carry me home;'),
        SongLine(<String>['G', 'G7'], 'swing low, sweet chariot,'),
        SongLine(<String>['C G', 'D7 G'], 'coming for to carry me home.'),
      ]),
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'G',
          'G',
        ], 'I looked over Jordan and what did I see,'),
        SongLine(<String>['C', 'G'], 'coming for to carry me home?'),
        SongLine(<String>['G', 'G'], 'A band of angels coming after me,'),
        SongLine(<String>['C G', 'D7 G'], 'coming for to carry me home.'),
      ]),
    ],
  ),
  Song(
    id: 'kumbaya',
    title: 'Kumbaya',
    genre: 'gospel',
    difficulty: 1,
    bpm: 84,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'F'], 'Kumbaya, my Lord, kumbaya;'),
        SongLine(<String>['C', 'G7'], 'kumbaya, my Lord, kumbaya;'),
        SongLine(<String>['C', 'F'], 'kumbaya, my Lord, kumbaya;'),
        SongLine(<String>['C G7', 'C'], 'oh Lord, kumbaya.'),
      ]),
    ],
  ),
  Song(
    id: 'michaelRow',
    title: 'Michael, Row the Boat Ashore',
    genre: 'gospel',
    difficulty: 1,
    bpm: 88,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'C',
          'F',
        ], 'Michael, row the boat ashore, hallelujah;'),
        SongLine(<String>[
          'C',
          'G7',
        ], 'Michael, row the boat ashore, hallelujah.'),
        SongLine(<String>[
          'C',
          'F',
        ], 'Sister, help to trim the sail, hallelujah;'),
        SongLine(<String>[
          'C G7',
          'C',
        ], 'sister, help to trim the sail, hallelujah.'),
      ]),
    ],
  ),
  Song(
    id: 'goDownMoses',
    title: 'Go Down, Moses',
    genre: 'gospel',
    difficulty: 2,
    bpm: 76,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am'], "When Israel was in Egypt's land,"),
        SongLine(<String>['E7', 'Am'], 'let my people go;'),
        SongLine(<String>[
          'Am',
          'Am',
        ], 'oppressed so hard they could not stand,'),
        SongLine(<String>['E7', 'Am'], 'let my people go.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>[
          'Am',
          'Dm',
        ], "Go down, Moses, way down in Egypt's land;"),
        SongLine(<String>[
          'Am E7',
          'Am',
        ], 'tell old Pharaoh, let my people go.'),
      ]),
    ],
  ),
  Song(
    id: 'wadeWater',
    title: 'Wade in the Water',
    genre: 'gospel',
    difficulty: 2,
    bpm: 84,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['Dm', 'Dm'], 'Wade in the water,'),
        SongLine(<String>['A7', 'Dm'], 'wade in the water, children,'),
        SongLine(<String>['Dm', 'Dm'], 'wade in the water;'),
        SongLine(<String>['A7', 'Dm'], "God's gonna trouble the water."),
      ]),
    ],
  ),
  Song(
    id: 'nobodyKnows',
    title: "Nobody Knows the Trouble I've Seen",
    genre: 'gospel',
    difficulty: 1,
    bpm: 68,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], "Nobody knows the trouble I've seen,"),
        SongLine(<String>['C', 'G'], 'nobody knows but Jesus;'),
        SongLine(<String>['G', 'G'], "nobody knows the trouble I've seen,"),
        SongLine(<String>['D7', 'G'], 'glory, hallelujah!'),
      ]),
    ],
  ),
  Song(
    id: 'goTell',
    title: 'Go Tell It on the Mountain',
    genre: 'gospel',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'C'], 'Go tell it on the mountain,'),
        SongLine(<String>['F', 'C'], 'over the hills and everywhere;'),
        SongLine(<String>['C', 'C'], 'go tell it on the mountain'),
        SongLine(<String>['G7', 'C'], 'that Jesus Christ is born.'),
      ]),
    ],
  ),
  Song(
    id: 'riverside',
    title: 'Down by the Riverside',
    genre: 'gospel',
    difficulty: 1,
    bpm: 112,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], "I'm gonna lay down my sword and shield,"),
        SongLine(<String>['C', 'G'], 'down by the riverside,'),
        SongLine(<String>['G', 'G'], 'down by the riverside,'),
        SongLine(<String>['D7', 'G'], 'down by the riverside.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'C'], "I ain't gonna study war no more,"),
        SongLine(<String>['G D7', 'G'], "I ain't gonna study war no more."),
      ]),
    ],
  ),
  Song(
    id: 'silentNight',
    title: 'Silent Night',
    author: 'Joseph Mohr y Franz Gruber, 1818',
    genre: 'ballad',
    difficulty: 1,
    bpm: 60,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Silent night, holy night,'),
        SongLine(<String>['G7', 'C'], 'all is calm, all is bright,'),
        SongLine(<String>['F', 'C'], 'round yon virgin mother and child,'),
        SongLine(<String>['F', 'C'], 'holy infant so tender and mild,'),
        SongLine(<String>['G7', 'C'], 'sleep in heavenly peace,'),
        SongLine(<String>['G7', 'C'], 'sleep in heavenly peace.'),
      ]),
    ],
  ),
  Song(
    id: 'joyWorld',
    title: 'Joy to the World',
    author: 'Isaac Watts, 1719',
    genre: 'gospel',
    difficulty: 1,
    bpm: 108,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'G7'], 'Joy to the world, the Lord is come;'),
        SongLine(<String>['C', 'F'], 'let earth receive her King;'),
        SongLine(<String>['C', 'G7'], 'let every heart prepare Him room,'),
        SongLine(<String>['C F', 'G7 C'], 'and heaven and nature sing.'),
      ]),
    ],
  ),
];
