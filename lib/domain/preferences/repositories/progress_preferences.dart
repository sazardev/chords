/// Preferencias de progreso: acordes dominados y mejor puntuación.
abstract interface class ProgressPreferences {
  /// Identificadores de acordes marcados como dominados.
  Set<String> get masteredChordIds;

  /// Reemplaza el conjunto de acordes dominados.
  Future<void> setMasteredChordIds(Set<String> ids);

  /// Mejor puntuación registrada en el modo juego.
  int get bestScore;

  /// Guarda la puntuación si supera la anterior.
  Future<void> saveBestScore(int score);
}
