/// Preferencias de progreso: acordes dominados, récord y minijuegos.
abstract interface class ProgressPreferences {
  /// Identificadores de acordes marcados como dominados.
  Set<String> get masteredChordIds;

  /// Reemplaza el conjunto de acordes dominados.
  Future<void> setMasteredChordIds(Set<String> ids);

  /// Mejor puntuación registrada en el modo juego.
  int get bestScore;

  /// Guarda la puntuación si supera la anterior.
  Future<void> saveBestScore(int score);

  /// Mejor porcentaje de acierto (0-100) de un minijuego y nivel.
  ///
  /// [gameKey] identifica la pareja juego-nivel (p. ej. `guessNote_easy`).
  int miniGameBest(String gameKey);

  /// Guarda el porcentaje si supera el anterior de [gameKey].
  Future<void> saveMiniGameBest(String gameKey, int percent);
}
