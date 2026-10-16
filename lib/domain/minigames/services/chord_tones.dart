import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Clases de tono de las notas de [quality] sobre la raíz [root], en el orden
/// del acorde (raíz primero).
List<int> chordTones(int root, ChordQuality quality) => <int>[
  for (final int interval in quality.intervals) (root + interval) % 12,
];

/// Clases de tono de las notas de un acorde del banco.
Set<int> pitchClassesOfChord(Chord chord) =>
    chordTones(chord.root.pitchClass, chord.quality).toSet();

/// Índices de cuerda (0 = sexta) que suenan en [frets].
List<int> soundingStrings(List<int> frets) => <int>[
  for (int s = 0; s < frets.length; s++)
    if (frets[s] >= 0) s,
];

/// Clase de tono de la cuerda de índice [stringIndex] (0 = sexta) pisada en
/// [fret].
int pitchClassAtString(int stringIndex, int fret) =>
    FretPosition(6 - stringIndex, fret).pitchClass;

/// Clases de tono que suenan en [frets], de la sexta a la primera.
List<int> soundingPitchClasses(List<int> frets) => <int>[
  for (final int s in soundingStrings(frets)) pitchClassAtString(s, frets[s]),
];

/// Clase de tono del bajo de [variant] (la cuerda más grave que suena).
int? bassPitchClass(ChordVariant variant) {
  final List<int> strings = soundingStrings(variant.frets);
  return strings.isEmpty
      ? null
      : pitchClassAtString(strings.first, variant.frets[strings.first]);
}

/// Índice de la cuerda más grave de [variant] que suena la raíz de [chord];
/// `null` si la posición no lleva la raíz.
int? rootStringIndex(Chord chord, ChordVariant variant) {
  for (final int s in soundingStrings(variant.frets)) {
    if (pitchClassAtString(s, variant.frets[s]) == chord.root.pitchClass) {
      return s;
    }
  }
  return null;
}
