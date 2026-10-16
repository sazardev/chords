import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:meta/meta.dart';

/// Una nota del acorde con el grado que ocupa (`E` es la `3` de Do mayor).
@immutable
class ChordTone {
  /// Crea la nota.
  const ChordTone({
    required this.pitchClass,
    required this.degree,
    required this.isOptional,
  });

  /// Clase de tono (0 = Do … 11 = Si).
  final int pitchClass;

  /// Grado dentro del acorde: `1`, `b3`, `5`, `b7`, `9`…
  final String degree;

  /// `true` si se puede omitir en una posición (casi siempre la quinta).
  final bool isOptional;

  /// Nombre de la nota con sostenidos (`C#`).
  String get note => noteNameOfPitchClass(pitchClass);

  @override
  bool operator ==(Object other) =>
      other is ChordTone &&
      other.pitchClass == pitchClass &&
      other.degree == degree;

  @override
  int get hashCode => Object.hash(pitchClass, degree);

  @override
  String toString() => 'ChordTone($note $degree)';
}

/// Las notas del acorde de [root] y [quality], de la raíz hacia arriba.
List<ChordTone> chordTones(ChordRoot root, ChordQuality quality) {
  final Set<int> required = quality.requiredIntervals;
  return <ChordTone>[
    for (int i = 0; i < quality.intervals.length; i++)
      ChordTone(
        pitchClass: (root.pitchClass + quality.intervals[i]) % 12,
        degree: quality.formula[i],
        isOptional: !required.contains(quality.intervals[i] % 12),
      ),
  ];
}
