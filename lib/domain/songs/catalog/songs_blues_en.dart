/// Blues y baladas de raíces tradicionales.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Blues y baladas de raíces tradicionales.
const List<Song> kBluesSongsEn = <Song>[
  Song(
    id: 'johnHenry',
    title: 'John Henry',
    genre: 'blues',
    difficulty: 1,
    bpm: 96,
    strum: StrumPattern.shuffle,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'John Henry was a little baby,'),
        SongLine(<String>['C', 'G'], "sitting on his papa's knee;"),
        SongLine(<String>[
          'G',
          'G',
        ], 'he picked up a hammer and a little piece of steel,'),
        SongLine(<String>[
          'D7',
          'G',
        ], "said, \"Hammer's gonna be the death of me, Lord, Lord,"),
        SongLine(<String>['D7', 'G'], "hammer's gonna be the death of me.\""),
      ]),
    ],
  ),
  Song(
    id: 'carelessLove',
    title: 'Careless Love',
    genre: 'blues',
    difficulty: 1,
    bpm: 80,
    strum: StrumPattern.shuffle,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Love, oh love, oh careless love,'),
        SongLine(<String>['F', 'C'], 'you fly through my head like wine;'),
        SongLine(<String>[
          'C',
          'C',
        ], "you've wrecked the life of many a poor girl,"),
        SongLine(<String>['G7', 'C'], "and you're sure going to wreck mine."),
      ]),
    ],
  ),
  Song(
    id: 'frankieJohnny',
    title: 'Frankie and Johnny',
    genre: 'blues',
    difficulty: 2,
    bpm: 108,
    strum: StrumPattern.shuffle,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'Frankie and Johnny were lovers,'),
        SongLine(<String>['D7', 'D7'], 'oh Lord, how they could love;'),
        SongLine(<String>['G', 'G7'], 'swore to be true to each other,'),
        SongLine(<String>['C D7', 'G'], 'true as the stars above.'),
      ]),
      SongSection(SongPart.chorus, <SongLine>[
        SongLine(<String>['G', 'G'], 'He was her man,'),
        SongLine(<String>['D7', 'G'], 'but he done her wrong.'),
      ]),
    ],
  ),
];
