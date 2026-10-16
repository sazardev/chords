/// Baladas y canciones folk anglosajonas tradicionales.
library;

import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Baladas y canciones folk anglosajonas tradicionales.
const List<Song> kFolkSongsEn = <Song>[
  Song(
    id: 'scarborough',
    title: 'Scarborough Fair',
    genre: 'folk',
    difficulty: 2,
    bpm: 96,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'G'], 'Are you going to Scarborough Fair?'),
        SongLine(<String>['Am', 'C'], 'Parsley, sage, rosemary and thyme.'),
        SongLine(<String>['D', 'Am'], 'Remember me to one who lives there,'),
        SongLine(<String>['G', 'Am'], 'she once was a true love of mine.'),
      ]),
    ],
  ),
  Song(
    id: 'shenandoah',
    title: 'Shenandoah',
    genre: 'folk',
    difficulty: 1,
    bpm: 76,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'F'], 'Oh Shenandoah, I long to see you,'),
        SongLine(<String>['C', 'G7'], 'away, you rolling river.'),
        SongLine(<String>['C', 'F'], 'Oh Shenandoah, I long to see you,'),
        SongLine(<String>['C', 'G7'], "away, I'm bound away,"),
        SongLine(<String>['F', 'C'], "'cross the wide Missouri."),
      ]),
    ],
  ),
  Song(
    id: 'downValley',
    title: 'Down in the Valley',
    genre: 'folk',
    difficulty: 1,
    bpm: 84,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'G'], 'Down in the valley, valley so low,'),
        SongLine(<String>[
          'D7',
          'D7',
        ], 'hang your head over, hear the wind blow.'),
        SongLine(<String>[
          'D7',
          'D7',
        ], 'Hear the wind blow, dear, hear the wind blow,'),
        SongLine(<String>[
          'G',
          'G',
        ], 'hang your head over, hear the wind blow.'),
      ]),
    ],
  ),
  Song(
    id: 'waterIsWide',
    title: 'The Water Is Wide',
    genre: 'folk',
    difficulty: 2,
    bpm: 80,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['G', 'C'], "The water is wide, I can't cross o'er,"),
        SongLine(<String>['G', 'D'], 'and neither have I wings to fly.'),
        SongLine(<String>['G', 'C'], 'Give me a boat that will carry two,'),
        SongLine(<String>['G D', 'G'], 'and both shall row, my love and I.'),
      ]),
    ],
  ),
  Song(
    id: 'lochLomond',
    title: 'Loch Lomond',
    genre: 'folk',
    difficulty: 2,
    bpm: 84,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'G',
          'C',
        ], 'By yon bonnie banks and by yon bonnie braes,'),
        SongLine(<String>[
          'G',
          'D7',
        ], 'where the sun shines bright on Loch Lomond,'),
        SongLine(<String>[
          'G',
          'C',
        ], 'where me and my true love were ever wont to gae'),
        SongLine(<String>[
          'G D7',
          'G',
        ], 'on the bonnie, bonnie banks of Loch Lomond.'),
      ]),
    ],
  ),
  Song(
    id: 'wayfaring',
    title: 'Wayfaring Stranger',
    genre: 'folk',
    difficulty: 2,
    bpm: 76,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['Am', 'Am'], 'I am a poor wayfaring stranger,'),
        SongLine(<String>[
          'Dm',
          'Am',
        ], 'while traveling through this world of woe.'),
        SongLine(<String>[
          'Am',
          'Am',
        ], "Yet there's no sickness, toil, nor danger"),
        SongLine(<String>['E7', 'Am'], 'in that bright land to which I go.'),
      ]),
    ],
  ),
  Song(
    id: 'dannyBoy',
    title: 'Danny Boy',
    author: 'Frederic Weatherly, 1913',
    genre: 'ballad',
    difficulty: 2,
    bpm: 70,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>[
          'D',
          'D',
        ], 'Oh Danny boy, the pipes, the pipes are calling,'),
        SongLine(<String>[
          'G',
          'D',
        ], 'from glen to glen and down the mountain side.'),
        SongLine(<String>[
          'D',
          'D',
        ], "The summer's gone and all the roses falling,"),
        SongLine(<String>[
          'G A7',
          'D',
        ], "'tis you, 'tis you must go and I must bide."),
      ]),
    ],
  ),
  Song(
    id: 'twinkle',
    title: 'Twinkle, Twinkle, Little Star',
    genre: 'folk',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.quarters,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Twinkle, twinkle, little star,'),
        SongLine(<String>['F C', 'G7'], 'how I wonder what you are!'),
        SongLine(<String>['C', 'C'], 'Up above the world so high,'),
        SongLine(<String>['F C', 'G7 C'], 'like a diamond in the sky.'),
      ]),
    ],
  ),
  Song(
    id: 'rowBoat',
    title: 'Row, Row, Row Your Boat',
    genre: 'folk',
    difficulty: 1,
    bpm: 100,
    strum: StrumPattern.waltz,
    sections: <SongSection>[
      SongSection(SongPart.verse, <SongLine>[
        SongLine(<String>['C', 'C'], 'Row, row, row your boat,'),
        SongLine(<String>['C', 'G7'], 'gently down the stream.'),
        SongLine(<String>['C', 'F'], 'Merrily, merrily, merrily, merrily,'),
        SongLine(<String>['C G7', 'C'], 'life is but a dream.'),
      ]),
    ],
  ),
];
