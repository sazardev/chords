/// Notas que suenan en una posición de acorde (afinación estándar).
library;

import 'package:chords/domain/chords/entities/pitch_classes.dart';

/// Altura MIDI de cada cuerda al aire, de la sexta a la primera (E A D G B e).
const List<int> kOpenStringMidi = <int>[40, 45, 50, 55, 59, 64];

/// Altura MIDI de la nota que suena en la cuerda [string] (0 = sexta) al
/// pulsar el traste [fret].
int midiOf(int string, int fret) => kOpenStringMidi[string] + fret;

/// Clase de tono (0-11) de la cuerda [string] en el traste [fret].
int pitchClassOfFret(int string, int fret) => midiOf(string, fret) % 12;

/// Cuerdas que suenan (traste >= 0), de la sexta a la primera.
List<int> soundingStrings(List<int> frets) => <int>[
  for (int s = 0; s < frets.length; s++)
    if (frets[s] >= 0) s,
];

/// Clases de tono distintas que suenan en [frets].
Set<int> pitchClassesOfFrets(List<int> frets) => <int>{
  for (final int s in soundingStrings(frets)) pitchClassOfFret(s, frets[s]),
};

/// Nombres (ordenados alfabéticamente) de las notas que suenan en [frets].
List<String> noteNamesOfFrets(List<int> frets) =>
    pitchClassesOfFrets(frets).map(noteNameOfPitchClass).toList()..sort();
