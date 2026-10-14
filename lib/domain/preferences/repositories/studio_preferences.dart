/// Preferencias del estudio: historial de acordes, lecciones, jam y racha.
abstract interface class StudioPreferences {
  /// Acordes abiertos recientemente, del más reciente al más antiguo.
  List<String> get recentChordIds;

  /// Reemplaza el historial de acordes.
  Future<void> setRecentChordIds(List<String> ids);

  /// Lecciones de teoría marcadas como aprendidas.
  Set<String> get completedLessons;

  /// Reemplaza las lecciones aprendidas.
  Future<void> setCompletedLessons(Set<String> ids);

  /// Mejor puntuación de una pista de jam ([trackKey] = `song:bamba`).
  int jamBest(String trackKey);

  /// Guarda la puntuación si supera la anterior de [trackKey].
  Future<void> saveJamBest(String trackKey, int score);

  /// Días en que se practicó, como `aaaa-mm-dd`.
  Set<String> get practiceDays;

  /// Reemplaza los días practicados.
  Future<void> setPracticeDays(Set<String> days);
}
