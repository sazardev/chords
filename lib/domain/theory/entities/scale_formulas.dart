import 'package:chords/domain/theory/entities/scale_type.dart';

/// Fórmula de cada escala: los grados que la forman, escritos como se dicen
/// (`1 2 b3 4 5 b6 7`), uno por nota y en el mismo orden que sus intervalos.
///
/// Un test comprueba que cada fórmula suma exactamente los semitonos de
/// `ScaleType.intervals`.
final Map<ScaleType, List<String>> kScaleFormulas = <ScaleType, List<String>>{
  for (final MapEntry<ScaleType, String> entry in _formulaText.entries)
    entry.key: entry.value.split(' '),
};

const Map<ScaleType, String> _formulaText = <ScaleType, String>{
  ScaleType.major: '1 2 3 4 5 6 7',
  ScaleType.dorian: '1 2 b3 4 5 6 b7',
  ScaleType.phrygian: '1 b2 b3 4 5 b6 b7',
  ScaleType.lydian: '1 2 3 #4 5 6 7',
  ScaleType.mixolydian: '1 2 3 4 5 6 b7',
  ScaleType.naturalMinor: '1 2 b3 4 5 b6 b7',
  ScaleType.locrian: '1 b2 b3 4 b5 b6 b7',
  ScaleType.harmonicMinor: '1 2 b3 4 5 b6 7',
  ScaleType.melodicMinor: '1 2 b3 4 5 6 7',
  ScaleType.locrianNatural6: '1 b2 b3 4 b5 6 b7',
  ScaleType.ionianSharp5: '1 2 3 4 #5 6 7',
  ScaleType.ukrainianDorian: '1 2 b3 #4 5 6 b7',
  ScaleType.phrygianDominant: '1 b2 3 4 5 b6 b7',
  ScaleType.lydianSharp2: '1 #2 3 #4 5 6 7',
  ScaleType.superLocrianBb7: '1 b2 b3 b4 b5 b6 bb7',
  ScaleType.dorianFlat2: '1 b2 b3 4 5 6 b7',
  ScaleType.lydianAugmented: '1 2 3 #4 #5 6 7',
  ScaleType.lydianDominant: '1 2 3 #4 5 6 b7',
  ScaleType.mixolydianFlat6: '1 2 3 4 5 b6 b7',
  ScaleType.locrianSharp2: '1 2 b3 4 b5 b6 b7',
  ScaleType.altered: '1 b2 #2 3 b5 #5 b7',
  ScaleType.minorPentatonic: '1 b3 4 5 b7',
  ScaleType.majorPentatonic: '1 2 3 5 6',
  ScaleType.blues: '1 b3 4 b5 5 b7',
  ScaleType.majorBlues: '1 2 b3 3 5 6',
  ScaleType.minorHexatonic: '1 2 b3 4 5 b7',
  ScaleType.suspendedPentatonic: '1 2 4 5 b7',
  ScaleType.wholeTone: '1 2 3 #4 #5 b7',
  ScaleType.diminishedWholeHalf: '1 2 b3 4 b5 b6 6 7',
  ScaleType.diminishedHalfWhole: '1 b2 #2 3 #4 5 6 b7',
  ScaleType.augmentedScale: '1 #2 3 5 #5 7',
  ScaleType.bebopDominant: '1 2 3 4 5 6 b7 7',
  ScaleType.bebopMajor: '1 2 3 4 5 b6 6 7',
  ScaleType.hungarianMinor: '1 2 b3 #4 5 b6 7',
  ScaleType.doubleHarmonic: '1 b2 3 4 5 b6 7',
  ScaleType.hirajoshi: '1 2 b3 5 b6',
  ScaleType.neapolitanMinor: '1 b2 b3 4 5 b6 7',
  ScaleType.persian: '1 b2 3 4 b5 b6 7',
};
