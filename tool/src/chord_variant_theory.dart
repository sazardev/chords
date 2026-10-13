/// Comprobaciones musicales de una posición de acorde.
///
/// Las notas que salen de los trastes tienen que ser las del acorde: ninguna
/// ajena, todas las que lo definen (la quinta puede faltar) y, salvo en
/// inversiones, la raíz en el bajo.
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

import 'chord_theory.dart';

/// Problemas musicales de [frets] como [quality] sobre [root].
List<String> theoryIssues(
  ChordRoot root,
  ChordQuality quality,
  List<int> frets, {
  required List<String> declaredNotes,
  required bool isInversion,
}) {
  final List<String> issues = <String>[];
  final Set<int> sounding = <int>{
    for (int s = 0; s < frets.length; s++)
      if (frets[s] >= 0) (kStringTuning[s] + frets[s]) % 12,
  };
  final Set<int> expected = pitchClassesForIntervals(
    root.pitchClass,
    quality.intervals,
  );
  final Set<int> required = <int>{
    for (final int interval in quality.intervals)
      if (interval % 12 != 7 || quality.intervals.length == 2)
        (root.pitchClass + interval) % 12,
  };
  final List<String> actual = notesForFrets(frets);
  if (actual.join(',') != (List<String>.of(declaredNotes)..sort()).join(',')) {
    issues.add('las notas declaradas no coinciden con los trastes: $actual');
  }
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
  if (bass >= 0 &&
      !isInversion &&
      (kStringTuning[bass] + frets[bass]) % 12 != root.pitchClass) {
    issues.add('el bajo no es la raíz ${root.name}');
  }
  return issues;
}
