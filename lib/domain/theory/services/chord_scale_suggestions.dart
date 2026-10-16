import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';

/// Escalas que suenan bien para improvisar sobre cada tipo de acorde, la
/// mejor primero. Todas parten de la raíz del acorde.
const Map<ChordQuality, List<ScaleType>>
kChordScales = <ChordQuality, List<ScaleType>>{
  ChordQuality.major: <ScaleType>[
    ScaleType.majorPentatonic,
    ScaleType.major,
    ScaleType.lydian,
  ],
  ChordQuality.minor: <ScaleType>[
    ScaleType.minorPentatonic,
    ScaleType.naturalMinor,
    ScaleType.dorian,
  ],
  ChordQuality.seven: <ScaleType>[
    ScaleType.mixolydian,
    ScaleType.blues,
    ScaleType.majorPentatonic,
  ],
  ChordQuality.minorSeven: <ScaleType>[
    ScaleType.dorian,
    ScaleType.minorPentatonic,
    ScaleType.naturalMinor,
  ],
  ChordQuality.majorSeven: <ScaleType>[
    ScaleType.major,
    ScaleType.lydian,
    ScaleType.majorPentatonic,
  ],
  ChordQuality.suspendedFourth: <ScaleType>[
    ScaleType.mixolydian,
    ScaleType.majorPentatonic,
  ],
  ChordQuality.suspendedSecond: <ScaleType>[
    ScaleType.majorPentatonic,
    ScaleType.major,
  ],
  ChordQuality.power: <ScaleType>[
    ScaleType.minorPentatonic,
    ScaleType.majorPentatonic,
    ScaleType.blues,
  ],
  ChordQuality.sixth: <ScaleType>[ScaleType.majorPentatonic, ScaleType.major],
  ChordQuality.minorSixth: <ScaleType>[
    ScaleType.dorian,
    ScaleType.melodicMinor,
  ],
  ChordQuality.diminished: <ScaleType>[ScaleType.diminishedWholeHalf],
  ChordQuality.augmented: <ScaleType>[
    ScaleType.wholeTone,
    ScaleType.lydianAugmented,
  ],
  ChordQuality.ninth: <ScaleType>[ScaleType.mixolydian, ScaleType.blues],
  ChordQuality.add9: <ScaleType>[ScaleType.majorPentatonic, ScaleType.major],
  ChordQuality.minorAdd9: <ScaleType>[
    ScaleType.minorPentatonic,
    ScaleType.naturalMinor,
    ScaleType.dorian,
  ],
  ChordQuality.sixNine: <ScaleType>[
    ScaleType.majorPentatonic,
    ScaleType.major,
    ScaleType.lydian,
  ],
  ChordQuality.minorNinth: <ScaleType>[
    ScaleType.dorian,
    ScaleType.minorPentatonic,
  ],
  ChordQuality.majorNinth: <ScaleType>[ScaleType.lydian, ScaleType.major],
  ChordQuality.eleventh: <ScaleType>[ScaleType.mixolydian],
  ChordQuality.minorEleventh: <ScaleType>[
    ScaleType.dorian,
    ScaleType.minorPentatonic,
  ],
  ChordQuality.thirteenth: <ScaleType>[ScaleType.mixolydian, ScaleType.blues],
  ChordQuality.sevenSus4: <ScaleType>[
    ScaleType.mixolydian,
    ScaleType.minorPentatonic,
  ],
  ChordQuality.nineSus4: <ScaleType>[
    ScaleType.mixolydian,
    ScaleType.minorPentatonic,
  ],
  ChordQuality.minorMajorSeven: <ScaleType>[
    ScaleType.melodicMinor,
    ScaleType.harmonicMinor,
  ],
  ChordQuality.halfDiminished: <ScaleType>[
    ScaleType.locrianSharp2,
    ScaleType.locrian,
  ],
  ChordQuality.diminishedSeven: <ScaleType>[ScaleType.diminishedWholeHalf],
  ChordQuality.sevenFlatNine: <ScaleType>[
    ScaleType.phrygianDominant,
    ScaleType.diminishedHalfWhole,
  ],
  ChordQuality.sevenSharpNine: <ScaleType>[
    ScaleType.blues,
    ScaleType.altered,
    ScaleType.diminishedHalfWhole,
  ],
  ChordQuality.sevenSharpFive: <ScaleType>[
    ScaleType.wholeTone,
    ScaleType.altered,
  ],
  ChordQuality.sevenFlatFive: <ScaleType>[
    ScaleType.lydianDominant,
    ScaleType.altered,
    ScaleType.wholeTone,
  ],
  ChordQuality.sevenSharpEleven: <ScaleType>[ScaleType.lydianDominant],
  ChordQuality.majorSevenSharpEleven: <ScaleType>[ScaleType.lydian],
  ChordQuality.majorSevenSharpFive: <ScaleType>[ScaleType.lydianAugmented],
};

/// Escalas sugeridas para improvisar sobre un acorde de la calidad dada.
List<ScaleType> scalesForQuality(ChordQuality quality) =>
    kChordScales[quality] ?? const <ScaleType>[ScaleType.majorPentatonic];
