/// Canal (subsistema) origen de un evento de log.
///
/// Permite filtrar el registro por área: arranque, audio, acordes, juego,
/// navegación, UI, rendimiento, etc.
enum LogChannel {
  /// Arranque de la app y composición de dependencias.
  boot,

  /// Navegación, rutas y deep links.
  router,

  /// Carga y consulta del banco de acordes.
  chords,

  /// Motor de audio, síntesis y reproducción.
  audio,

  /// Captura de micrófono y permisos.
  microphone,

  /// Aprendizaje y progreso.
  learn,

  /// Modo juego.
  game,

  /// Ajustes e interfaz.
  ui,

  /// Rendimiento, fluidez y tiempos de frame.
  performance,

  /// Errores capturados por el framework.
  framework;

  /// Nombre corto del canal.
  String get label => name;

  /// Descripción legible del canal.
  String get description => switch (this) {
    LogChannel.boot => 'Arranque',
    LogChannel.router => 'Navegación',
    LogChannel.chords => 'Acordes',
    LogChannel.audio => 'Audio',
    LogChannel.microphone => 'Micrófono',
    LogChannel.learn => 'Aprendizaje',
    LogChannel.game => 'Juego',
    LogChannel.ui => 'Interfaz',
    LogChannel.performance => 'Rendimiento',
    LogChannel.framework => 'Framework',
  };
}

/// Todos los canales disponibles, en orden de presentación.
const List<LogChannel> kAllLogChannels = LogChannel.values;
