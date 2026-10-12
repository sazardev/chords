/// Lectura de tono detectada por el micrófono.
class PitchReading {
  /// Crea una lectura de tono.
  const PitchReading({
    required this.frequency,
    required this.note,
    required this.cents,
    required this.clarity,
    this.level = 0,
  });

  /// Frecuencia detectada en Hz.
  final double frequency;

  /// Nota más cercana (p. ej. `A#`).
  final String note;

  /// Desviación en cents respecto a la nota (-50..50).
  final double cents;

  /// Claridad de la detección (0-1): cuán periódica y limpia es la señal.
  final double clarity;

  /// Nivel de la señal de entrada (0-1).
  final double level;

  /// `true` si la lectura es suficientemente fiable.
  bool get isReliable => clarity >= 0.7;

  @override
  String toString() =>
      'PitchReading($note, ${frequency.toStringAsFixed(1)}Hz, '
      '${cents.toStringAsFixed(1)} cents, ${clarity.toStringAsFixed(2)})';
}
