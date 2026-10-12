import 'package:meta/meta.dart';

/// Una cuerda de la guitarra con su nota y frecuencia de afinación.
@immutable
class GuitarString {
  /// Crea una cuerda.
  const GuitarString({
    required this.number,
    required this.note,
    required this.octave,
    required this.frequency,
  });

  /// Número de cuerda: 1 = primera (la más aguda) … 6 = sexta (la más grave).
  final int number;

  /// Nombre de la nota en notación inglesa (p. ej. `E`).
  final String note;

  /// Octava científica de la nota (p. ej. 2 para el Mi grave).
  final int octave;

  /// Frecuencia objetivo en Hz.
  final double frequency;

  /// Nota con su octava (p. ej. `E2`).
  String get label => '$note$octave';

  @override
  bool operator ==(Object other) =>
      other is GuitarString &&
      other.number == number &&
      other.note == note &&
      other.octave == octave;

  @override
  int get hashCode => Object.hash(number, note, octave);

  @override
  String toString() => 'GuitarString($number, $label)';
}

/// Afinación estándar, de la sexta a la primera: E2 A2 D3 G3 B3 E4.
const List<GuitarString> kStandardTuning = <GuitarString>[
  GuitarString(number: 6, note: 'E', octave: 2, frequency: 82.407),
  GuitarString(number: 5, note: 'A', octave: 2, frequency: 110),
  GuitarString(number: 4, note: 'D', octave: 3, frequency: 146.832),
  GuitarString(number: 3, note: 'G', octave: 3, frequency: 195.998),
  GuitarString(number: 2, note: 'B', octave: 3, frequency: 246.942),
  GuitarString(number: 1, note: 'E', octave: 4, frequency: 329.628),
];

/// Cuerda de la afinación estándar por su número (1-6); `null` si no existe.
GuitarString? standardStringByNumber(int number) {
  for (final GuitarString string in kStandardTuning) {
    if (string.number == number) {
      return string;
    }
  }
  return null;
}
