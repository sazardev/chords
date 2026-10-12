/// Dificultad de una partida de minijuego.
enum MiniGameLevel {
  /// Pocas opciones y notas muy distintas.
  easy(replays: 9),

  /// Más opciones y notas más cercanas.
  medium(replays: 5),

  /// Todas las opciones, notas casi iguales y pocas repeticiones.
  hard(replays: 3);

  /// Crea un nivel con las veces que se puede repetir el sonido.
  const MiniGameLevel({required this.replays});

  /// Veces que se puede volver a escuchar la pregunta.
  final int replays;

  /// Identificador estable (preferencias y analítica).
  String get id => name;

  /// Resuelve un nivel por su identificador; `null` si no existe.
  static MiniGameLevel? fromId(String? id) {
    for (final MiniGameLevel level in MiniGameLevel.values) {
      if (level.id == id) {
        return level;
      }
    }
    return null;
  }
}
