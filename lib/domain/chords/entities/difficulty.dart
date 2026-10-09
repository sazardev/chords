/// Nivel de dificultad de una posición de acorde.
enum Difficulty {
  /// Nivel 1: acordes abiertos básicos.
  beginner(1, 'Principiante', 'Abierto, sin cejillo'),

  /// Nivel 2: formas ligeras o tríadas cerradas.
  easy(2, 'Fácil', 'Tríadas o forms cortas'),

  /// Nivel 3: cejillo completo.
  medium(3, 'Intermedio', 'Cejillo completo'),

  /// Nivel 4: cejillo lejos o estirado.
  hard(4, 'Difícil', 'Gran estiramiento o cejillo alto'),

  /// Nivel 5: voicings de jazz o posiciones extremas.
  expert(5, 'Experto', 'Voicing avanzado o jazz');

  /// Crea un nivel con su etiqueta y descripción.
  const Difficulty(this.level, this.label, this.hint);

  /// Nivel numérico (1-5).
  final int level;

  /// Etiqueta legible.
  final String label;

  /// Ayuda textual corta.
  final String hint;

  /// Resuelve un nivel a partir de su valor numérico.
  ///
  /// Devuelve `null` si el nivel está fuera del rango 1-5.
  static Difficulty? fromLevel(int level) => switch (level) {
    1 => Difficulty.beginner,
    2 => Difficulty.easy,
    3 => Difficulty.medium,
    4 => Difficulty.hard,
    5 => Difficulty.expert,
    _ => null,
  };
}
