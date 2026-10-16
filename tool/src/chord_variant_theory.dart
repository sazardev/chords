/// Comprobaciones musicales de una posición de acorde.
///
/// Las notas que salen de los trastes tienen que ser las del acorde: ninguna
/// ajena, todas las que lo definen (las opcionales de la calidad, como la
/// quinta, pueden faltar) y el bajo es la raíz (o la nota que anuncia el
/// identificador en las inversiones).
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

import 'chord_theory.dart';

/// Problemas musicales de [frets] como [quality] sobre [root].
List<String> theoryIssues(
  ChordRoot root,
  ChordQuality quality,
  List<int> frets, {
  int expectedBass = 0,
}) {
  final List<String> issues = <String>[];
  final Set<int> sounding = <int>{
    for (int s = 0; s < frets.length; s++)
      if (frets[s] >= 0) (kStringTuning[s] + frets[s]) % 12,
  };
  final Set<int> expected = quality.pitchClassesOn(root.pitchClass);
  final Set<int> required = <int>{
    for (final int interval in quality.requiredIntervals)
      (root.pitchClass + interval) % 12,
  };
  final Iterable<int> foreign = sounding.difference(expected);
  if (foreign.isNotEmpty) {
    issues.add(
      'suena ${foreign.map(noteNameOfPitchClass).join(', ')}, '
      'que no es del acorde',
    );
  }
  final Iterable<int> missing = required.difference(sounding);
  if (missing.isNotEmpty) {
    issues.add('falta ${missing.map(noteNameOfPitchClass).join(', ')}');
  }
  final int bass = frets.indexWhere((int f) => f >= 0);
  if (bass < 0) {
    issues.add('no suena ninguna cuerda');
  } else if ((kStringTuning[bass] + frets[bass]) % 12 !=
      (root.pitchClass + expectedBass) % 12) {
    issues.add(
      expectedBass == 0
          ? 'el bajo no es la raíz ${root.name}'
          : 'el bajo no es la nota anunciada (+$expectedBass semitonos)',
    );
  }
  return issues;
}
