/// Notas del mástil de la guitarra en afinación estándar.
library;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/services/pitch_math.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:meta/meta.dart';

/// Último traste que trabajan los juegos (la octava de la cuerda al aire).
const int kMaxFret = 12;

/// Posición en el mástil: una cuerda (1-6) y un traste (0 = al aire).
@immutable
class FretPosition {
  /// Crea la posición.
  const FretPosition(this.stringNumber, this.fret);

  /// Número de cuerda: 1 = primera (aguda) … 6 = sexta (grave).
  final int stringNumber;

  /// Traste pulsado; `0` es la cuerda al aire.
  final int fret;

  /// Cuerda de la afinación estándar.
  GuitarString get string => standardStringByNumber(stringNumber)!;

  /// Clase de tono (0 = Do … 11 = Si).
  int get pitchClass => (pitchClassOfNote(string.note) + fret) % 12;

  /// Nombre de la nota en notación inglesa (p. ej. `C#`).
  String get note => noteNameOfPitchClass(pitchClass);

  /// Frecuencia en Hz de la nota pulsada.
  double get frequency => shiftBySemitones(string.frequency, fret);

  @override
  bool operator ==(Object other) =>
      other is FretPosition &&
      other.stringNumber == stringNumber &&
      other.fret == fret;

  @override
  int get hashCode => Object.hash(stringNumber, fret);

  @override
  String toString() => 'FretPosition(cuerda $stringNumber, traste $fret)';
}

/// Trastes (0-11) de la cuerda [stringNumber] que suenan [pitchClass].
List<int> fretsOfPitchClass(int stringNumber, int pitchClass) => <int>[
  for (int fret = 0; fret < 12; fret++)
    if (FretPosition(stringNumber, fret).pitchClass == pitchClass) fret,
];

/// `true` si la clase de tono es una nota natural (sin sostenido).
bool isNaturalPitchClass(int pitchClass) =>
    !noteNameOfPitchClass(pitchClass).contains('#');

/// Clase de tono de una etiqueta como `A#` o `A#4`; `-1` si no es válida.
int pitchClassOfLabel(String label) =>
    pitchClassOfNote(label.replaceAll(RegExp('[0-9-]'), ''));
