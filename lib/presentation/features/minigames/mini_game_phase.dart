/// Fase de una partida de minijuego.
enum MiniGamePhase {
  /// Pantalla de bienvenida: se elige la dificultad.
  intro,

  /// Hay una pregunta o reto esperando respuesta.
  asking,

  /// El micrófono escucha lo que se toca.
  listening,

  /// Se acaba de responder: se muestra el acierto o el fallo.
  feedback,

  /// La partida terminó y se enseña el resultado.
  finished,
}
