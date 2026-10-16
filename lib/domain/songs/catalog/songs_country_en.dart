/// Canciones country y de montaña tradicionales.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Canciones country y de montaña tradicionales.
const List<Song> kCountrySongsEn = <Song>[
  Song(
    id: 'sheComing',
    title: "She'll Be Coming Round the Mountain",
    genre: 'country',
    difficulty: 1,
    bpm: 108,
    strum: StrumPattern.boomChick,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'C',
          'C',
        ], "She'll be coming round the mountain when she comes,"),
        SongLine(<String>[
          'G7',
          'G7',
        ], "she'll be coming round the mountain when she comes,"),
        SongLine(<String>['C', 'C7'], "she'll be coming round the mountain,"),
        SongLine(<String>['F', 'C'], "she'll be coming round the mountain,"),
        SongLine(<String>[
          'G7',
          'C',
        ], "she'll be coming round the mountain when she comes."),
      ]),
    ],
  ),
  Song(
    id: 'clementine',
    title: 'Oh My Darling, Clementine',
    genre: 'country',
    difficulty: 1,
    bpm: 112,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'In a cavern, in a canyon,'),
        SongLine(<String>['G', 'D7'], 'excavating for a mine,'),
        SongLine(<String>['D7', 'D7'], 'dwelt a miner, forty-niner,'),
        SongLine(<String>['G', 'G'], 'and his daughter Clementine.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'G'], 'Oh my darling, oh my darling,'),
        SongLine(<String>['D7', 'D7'], 'oh my darling Clementine,'),
        SongLine(<String>['D7', 'D7'], 'you are lost and gone forever,'),
        SongLine(<String>['G', 'G'], 'dreadful sorry, Clementine.'),
      ]),
    ],
  ),
  Song(
    id: 'oldSmoky',
    title: 'On Top of Old Smoky',
    genre: 'country',
    difficulty: 1,
    bpm: 92,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'On top of old Smoky,'),
        SongLine(<String>['F', 'C'], 'all covered with snow,'),
        SongLine(<String>['C', 'C'], 'I lost my true lover,'),
        SongLine(<String>['G7', 'C'], 'from courting too slow.'),
      ]),
    ],
  ),
  Song(
    id: 'campTown',
    title: 'Camptown Races',
    author: 'Stephen Foster, 1850',
    genre: 'country',
    difficulty: 2,
    bpm: 124,
    strum: StrumPattern.boomChick,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'C',
          'C',
        ], 'De Camptown ladies sing this song, doo-dah, doo-dah;'),
        SongLine(<String>[
          'C',
          'G7',
        ], 'de Camptown racetrack five miles long, oh, de doo-dah day.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>[
          'F',
          'C',
        ], 'Gwine to run all night, gwine to run all day,'),
        SongLine(<String>[
          'C G7',
          'C',
        ], 'I bet my money on the bob-tail nag, somebody bet on the bay.'),
      ]),
    ],
  ),
  Song(
    id: 'circleUnbroken',
    title: 'Will the Circle Be Unbroken',
    author: 'Habershon y Gabriel, 1907',
    genre: 'country',
    difficulty: 2,
    bpm: 92,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'There are loved ones in the glory'),
        SongLine(<String>['F', 'C'], 'whose dear forms you often miss;'),
        SongLine(<String>['C', 'C'], 'when you close your earthly story,'),
        SongLine(<String>['G7', 'C'], 'will you join them in their bliss?'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['C', 'F'], 'Will the circle be unbroken,'),
        SongLine(<String>['C', 'G7'], 'by and by, Lord, by and by?'),
        SongLine(<String>['C', 'F'], "There's a better home awaiting"),
        SongLine(<String>['C G7', 'C'], 'in the sky, Lord, in the sky.'),
      ]),
    ],
  ),
];
