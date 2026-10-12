/// Experiencia con la guitarra: decide la dificultad de lo recomendado.
enum ExperienceLevel {
  /// Empieza: acordes abiertos sin cejilla.
  beginner(maxDifficulty: 2, targetDifficulty: 1, startLevel: 1),

  /// Ya cambia de acorde con soltura y prueba cejillas.
  intermediate(maxDifficulty: 3, targetDifficulty: 3, startLevel: 3),

  /// Domina cejillas y busca color y voicings.
  advanced(maxDifficulty: 5, targetDifficulty: 4, startLevel: 4);

  /// Crea el nivel con sus parámetros de recomendación.
  const ExperienceLevel({
    required this.maxDifficulty,
    required this.targetDifficulty,
    required this.startLevel,
  });

  /// Dificultad máxima (1-5) que se recomienda.
  final int maxDifficulty;

  /// Dificultad ideal (1-5) para practicar.
  final int targetDifficulty;

  /// Nivel del itinerario por el que empezar (1-5).
  final int startLevel;
}
