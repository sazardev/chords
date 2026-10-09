/// Resultado posible de una ronda del modo juego.
enum GameOutcome {
  /// Acorde completo reconocido.
  success,

  /// Algunas notas reconocidas.
  partial,

  /// No se reconoció el acorde.
  fail,

  /// Se agotó el tiempo.
  timeout,
}
