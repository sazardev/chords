/// Fase del reconocimiento de acordes que la interfaz sabe mostrar.
enum LiveChordPhase {
  /// El micrófono no está escuchando (sin permiso, en error o apagado).
  off,

  /// Escuchando, pero no suena nada: hay que tocar un acorde.
  silent,

  /// Suena algo, pero todavía no hay un acorde fiable.
  listening,

  /// Hay un acorde reconocido.
  detected,
}
