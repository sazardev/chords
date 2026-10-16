import 'package:chords/domain/theory/entities/scale_type.dart';

/// Sección del selector de escalas: un título y las escalas que agrupa.
class ScaleSection {
  /// Crea la sección.
  const ScaleSection(this.id, this.group, this.scales);

  /// Identificador estable (clave de la traducción del título).
  final String id;

  /// Bloque del selector al que pertenece.
  final ScaleGroup group;

  /// Escalas de la sección, en el orden en que se enseñan.
  final List<ScaleType> scales;
}

/// Secciones del selector, agrupadas por bloque.
///
/// Una escala puede estar en más de una (la menor natural es la eólica, el
/// sexto modo de la mayor).
const List<ScaleSection> kScaleSections = <ScaleSection>[
  ScaleSection('majorModes', ScaleGroup.major, <ScaleType>[
    ScaleType.major,
    ScaleType.dorian,
    ScaleType.phrygian,
    ScaleType.lydian,
    ScaleType.mixolydian,
    ScaleType.naturalMinor,
    ScaleType.locrian,
  ]),
  ScaleSection('minors', ScaleGroup.minor, <ScaleType>[
    ScaleType.naturalMinor,
    ScaleType.harmonicMinor,
    ScaleType.melodicMinor,
  ]),
  ScaleSection('harmonicModes', ScaleGroup.minor, <ScaleType>[
    ScaleType.locrianNatural6,
    ScaleType.ionianSharp5,
    ScaleType.ukrainianDorian,
    ScaleType.phrygianDominant,
    ScaleType.lydianSharp2,
    ScaleType.superLocrianBb7,
  ]),
  ScaleSection('melodicModes', ScaleGroup.minor, <ScaleType>[
    ScaleType.dorianFlat2,
    ScaleType.lydianAugmented,
    ScaleType.lydianDominant,
    ScaleType.mixolydianFlat6,
    ScaleType.locrianSharp2,
    ScaleType.altered,
  ]),
  ScaleSection('pentatonics', ScaleGroup.pentatonic, <ScaleType>[
    ScaleType.minorPentatonic,
    ScaleType.majorPentatonic,
    ScaleType.blues,
    ScaleType.majorBlues,
    ScaleType.minorHexatonic,
    ScaleType.suspendedPentatonic,
  ]),
  ScaleSection('symmetric', ScaleGroup.exotic, <ScaleType>[
    ScaleType.wholeTone,
    ScaleType.diminishedWholeHalf,
    ScaleType.diminishedHalfWhole,
    ScaleType.augmentedScale,
    ScaleType.bebopDominant,
    ScaleType.bebopMajor,
  ]),
  ScaleSection('exotic', ScaleGroup.exotic, <ScaleType>[
    ScaleType.hungarianMinor,
    ScaleType.doubleHarmonic,
    ScaleType.hirajoshi,
    ScaleType.neapolitanMinor,
    ScaleType.persian,
  ]),
];

/// Secciones de un bloque del selector.
List<ScaleSection> sectionsOf(ScaleGroup group) => <ScaleSection>[
  for (final ScaleSection section in kScaleSections)
    if (section.group == group) section,
];

/// Bloque en el que se muestra [scale] por primera vez.
ScaleGroup groupOf(ScaleType scale) {
  for (final ScaleSection section in kScaleSections) {
    if (section.scales.contains(scale)) {
      return section.group;
    }
  }
  return ScaleGroup.of(scale.family);
}
