import 'package:chords/domain/theory/entities/scale_type.dart';

/// Intervalo (en semitonos desde la tónica) de la nota que da carácter a la
/// escala: el bemol de la frigia, la cuarta de la lidia, la blue note…
///
/// El explorador la resalta. Las escalas simétricas y las pentatónicas sin
/// nota distintiva no tienen entrada.
const Map<ScaleType, int> kScaleAccents = <ScaleType, int>{
  ScaleType.dorian: 9,
  ScaleType.phrygian: 1,
  ScaleType.lydian: 6,
  ScaleType.mixolydian: 10,
  ScaleType.locrian: 6,
  ScaleType.harmonicMinor: 11,
  ScaleType.melodicMinor: 11,
  ScaleType.locrianNatural6: 9,
  ScaleType.ionianSharp5: 8,
  ScaleType.ukrainianDorian: 6,
  ScaleType.phrygianDominant: 4,
  ScaleType.lydianSharp2: 3,
  ScaleType.superLocrianBb7: 9,
  ScaleType.dorianFlat2: 1,
  ScaleType.lydianAugmented: 8,
  ScaleType.lydianDominant: 6,
  ScaleType.mixolydianFlat6: 8,
  ScaleType.locrianSharp2: 2,
  ScaleType.altered: 1,
  ScaleType.blues: 6,
  ScaleType.majorBlues: 3,
  ScaleType.minorHexatonic: 2,
  ScaleType.bebopDominant: 11,
  ScaleType.bebopMajor: 8,
  ScaleType.hungarianMinor: 6,
  ScaleType.doubleHarmonic: 1,
  ScaleType.neapolitanMinor: 1,
  ScaleType.persian: 1,
};
