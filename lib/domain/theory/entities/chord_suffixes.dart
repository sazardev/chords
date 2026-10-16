import 'package:chords/domain/chords/entities/chord_quality.dart';

/// Otras formas de escribir el sufijo de una cifra, además del oficial de
/// cada calidad (`ChordQuality.suffix`).
const Map<String, ChordQuality> _alternativeSuffixes = <String, ChordQuality>{
  'M': ChordQuality.major,
  'maj': ChordQuality.major,
  'min': ChordQuality.minor,
  '-': ChordQuality.minor,
  'M7': ChordQuality.majorSeven,
  'Δ': ChordQuality.majorSeven,
  'Δ7': ChordQuality.majorSeven,
  'min7': ChordQuality.minorSeven,
  '-7': ChordQuality.minorSeven,
  '+': ChordQuality.augmented,
  'o': ChordQuality.diminished,
  '°': ChordQuality.diminished,
  'º': ChordQuality.diminished,
  'o7': ChordQuality.diminishedSeven,
  '°7': ChordQuality.diminishedSeven,
  'º7': ChordQuality.diminishedSeven,
  'ø': ChordQuality.halfDiminished,
  'ø7': ChordQuality.halfDiminished,
  'm7(b5)': ChordQuality.halfDiminished,
  'sus': ChordQuality.suspendedFourth,
  '7sus': ChordQuality.sevenSus4,
  '9sus': ChordQuality.nineSus4,
  'M9': ChordQuality.majorNinth,
  'mM7': ChordQuality.minorMajorSeven,
  'mmaj7': ChordQuality.minorMajorSeven,
  '7+5': ChordQuality.sevenSharpFive,
  '+7': ChordQuality.sevenSharpFive,
  'aug7': ChordQuality.sevenSharpFive,
  '7(b5)': ChordQuality.sevenFlatFive,
  '7(#11)': ChordQuality.sevenSharpEleven,
  'maj7(#11)': ChordQuality.majorSevenSharpEleven,
  'M7#5': ChordQuality.majorSevenSharpFive,
};

final Map<String, ChordQuality> _bySuffix = <String, ChordQuality>{
  ..._alternativeSuffixes,
  for (final ChordQuality quality in ChordQuality.values)
    quality.suffix: quality,
};

/// Calidad que corresponde al sufijo de una cifra (`m7`, `maj9`, `7#9`, `ø`).
///
/// Admite las variantes habituales (`M7`, `-7`, `°`, `+`). Devuelve `null` si
/// no se reconoce.
ChordQuality? qualityOfSuffix(String suffix) => _bySuffix[suffix];
