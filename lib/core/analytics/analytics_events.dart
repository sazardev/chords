/// Catálogo de eventos y parámetros de analítica de Chords.
///
/// Se centralizan aquí para que cada llamada use la misma nomenclatura —
/// minúsculas, `snake_case`, sin prefijos reservados y de 40 caracteres o
/// menos, como exige Firebase— y el catálogo completo sea auditable en un
/// único lugar.
library;

/// Nombres de los eventos enviados al proveedor de analíticas.
abstract final class AnalyticsEventName {
  /// La aplicación se ha abierto (con el flavor como parámetro).
  static const String appOpen = 'app_open';

  /// Un error ha sido registrado.
  static const String appError = 'app_error';

  /// Un aviso ha sido registrado.
  static const String appWarning = 'app_warning';

  /// Se ha abierto la ficha de un acorde.
  static const String chordViewed = 'chord_viewed';

  /// Se ha reproducido un acorde (rasgueo o arpegio).
  static const String chordPlayed = 'chord_played';

  /// Se ha ejecutado una búsqueda en la biblioteca.
  static const String searchPerformed = 'search_performed';

  /// Ha cambiado un filtro de la biblioteca.
  static const String filterChanged = 'filter_changed';

  /// Ha cambiado el dominio de un acorde.
  static const String chordMasteryChanged = 'chord_mastery_changed';

  /// Ha comenzado una partida del modo juego.
  static const String gameStarted = 'game_started';

  /// Se ha resuelto una ronda del modo juego.
  static const String gameRoundPlayed = 'game_round_played';

  /// Ha terminado la serie de rondas del modo juego.
  static const String gameFinished = 'game_finished';

  /// Ha comenzado una partida de un minijuego.
  static const String miniGameStarted = 'minigame_started';

  /// Ha terminado una partida de un minijuego.
  static const String miniGameFinished = 'minigame_finished';

  /// Ha comenzado una sesión de afinación en vivo.
  static const String liveSessionStarted = 'live_session_started';

  /// Ha terminado una sesión de afinación en vivo.
  static const String liveSessionEnded = 'live_session_ended';

  /// Ha terminado una sesión del afinador por cuerdas.
  static const String tunerSessionEnded = 'tuner_session_ended';

  /// Ha terminado una sesión de práctica de un acorde cuerda a cuerda.
  static const String practiceSessionEnded = 'practice_session_ended';

  /// Resultado de la solicitud de permiso de micrófono.
  static const String micPermission = 'mic_permission';

  /// La persona ha elegido o cambiado su perfil de guitarrista.
  static const String profileUpdated = 'profile_updated';

  /// Ha cambiado un ajuste de la aplicación.
  static const String settingChanged = 'setting_changed';

  /// El usuario ha avanzado en el onboarding.
  static const String onboardingStep = 'onboarding_step';

  /// El onboarding se ha completado.
  static const String onboardingCompleted = 'onboarding_completed';

  /// El onboarding se ha reiniciado desde ajustes.
  static const String onboardingReset = 'onboarding_reset';

  /// Se ha abierto el visor de diagnóstico.
  static const String diagnosticsOpened = 'diagnostics_opened';
}

/// Todos los nombres de evento del catálogo, para auditoría y pruebas.
const List<String> kAllAnalyticsEventNames = <String>[
  AnalyticsEventName.appOpen,
  AnalyticsEventName.appError,
  AnalyticsEventName.appWarning,
  AnalyticsEventName.chordViewed,
  AnalyticsEventName.chordPlayed,
  AnalyticsEventName.searchPerformed,
  AnalyticsEventName.filterChanged,
  AnalyticsEventName.chordMasteryChanged,
  AnalyticsEventName.gameStarted,
  AnalyticsEventName.gameRoundPlayed,
  AnalyticsEventName.gameFinished,
  AnalyticsEventName.miniGameStarted,
  AnalyticsEventName.miniGameFinished,
  AnalyticsEventName.liveSessionStarted,
  AnalyticsEventName.liveSessionEnded,
  AnalyticsEventName.tunerSessionEnded,
  AnalyticsEventName.practiceSessionEnded,
  AnalyticsEventName.micPermission,
  AnalyticsEventName.profileUpdated,
  AnalyticsEventName.settingChanged,
  AnalyticsEventName.onboardingStep,
  AnalyticsEventName.onboardingCompleted,
  AnalyticsEventName.onboardingReset,
  AnalyticsEventName.diagnosticsOpened,
];

/// Nombres de los parámetros que acompañan a los eventos.
abstract final class AnalyticsParam {
  /// Flavor de compilación activo.
  static const String flavor = 'flavor';

  /// Nombre de la pantalla visitada.
  static const String screen = 'screen';

  /// Pantalla anterior a la visitada.
  static const String previousScreen = 'previous_screen';

  /// Canal de registro de origen.
  static const String channel = 'channel';

  /// Mensaje legible del evento de registro.
  static const String message = 'message';

  /// Origen del error capturado.
  static const String origin = 'origin';

  /// Identificador del acorde.
  static const String chordId = 'chord_id';

  /// Nombre estándar del acorde (p. ej. `Cm7`).
  static const String chordName = 'chord_name';

  /// Calidad del acorde (p. ej. `min7`).
  static const String quality = 'quality';

  /// Nivel de dificultad (1-5).
  static const String difficulty = 'difficulty';

  /// Identificador de la posición del acorde.
  static const String variantId = 'variant_id';

  /// Si la reproducción fue un arpegio.
  static const String arpeggio = 'arpeggio';

  /// Identificador del patrón de arpegio.
  static const String patternId = 'pattern_id';

  /// Texto buscado.
  static const String query = 'query';

  /// Longitud del texto buscado.
  static const String queryLength = 'query_length';

  /// Número de resultados obtenidos.
  static const String results = 'results';

  /// Filtro modificado.
  static const String filter = 'filter';

  /// Valor del filtro modificado.
  static const String filterValue = 'filter_value';

  /// Si el acorde quedó dominado.
  static const String mastered = 'mastered';

  /// Total de acordes dominados tras el cambio.
  static const String totalMastered = 'total_mastered';

  /// Nivel de aprendizaje o del juego.
  static const String level = 'level';

  /// Número de rondas de la serie.
  static const String rounds = 'rounds';

  /// Posición de la ronda dentro de la serie.
  static const String roundIndex = 'round_index';

  /// Notas que pedía la ronda.
  static const String expectedNotes = 'expected_notes';

  /// Notas que el micrófono llegó a escuchar.
  static const String heardNotes = 'heard_notes';

  /// Proporción de acierto (0-1).
  static const String matchRatio = 'match_ratio';

  /// Resultado de la ronda (success, partial, fail, timeout).
  static const String outcome = 'outcome';

  /// Tiempo límite de la ronda en milisegundos.
  static const String timeLimitMs = 'time_limit_ms';

  /// Puntuación de la partida.
  static const String score = 'score';

  /// Mejor puntuación histórica.
  static const String bestScore = 'best_score';

  /// Rondas superadas.
  static const String won = 'won';

  /// Rondas parcialmente acertadas.
  static const String partial = 'partial';

  /// Rondas falladas o agotadas.
  static const String failed = 'failed';

  /// Duración de la sesión en milisegundos.
  static const String durationMs = 'duration_ms';

  /// Lecturas de tono totales.
  static const String readings = 'readings';

  /// Lecturas de tono fiables.
  static const String reliableReadings = 'reliable_readings';

  /// Notas escuchadas durante la sesión.
  static const String notesHeard = 'notes_heard';

  /// Número de acordes sugeridos al terminar.
  static const String suggestions = 'suggestions';

  /// Cuerdas que quedaron afinadas en la sesión del afinador.
  static const String tunedStrings = 'tuned_strings';

  /// Cuerdas del acorde reconocidas en la práctica.
  static const String matchedStrings = 'matched_strings';

  /// Cuerdas que usa el acorde practicado.
  static const String totalStrings = 'total_strings';

  /// Si la práctica llegó a completar el acorde.
  static const String completed = 'completed';

  /// Si el permiso se concedió.
  static const String granted = 'granted';

  /// Tipo de guitarra del perfil.
  static const String guitar = 'guitar';

  /// Mano con la que toca.
  static const String hand = 'hand';

  /// Estilo de ataque.
  static const String playStyle = 'play_style';

  /// Experiencia declarada.
  static const String experience = 'experience';

  /// Número de géneros favoritos.
  static const String genreCount = 'genre_count';

  /// Ajuste modificado.
  static const String setting = 'setting';

  /// Valor del ajuste modificado.
  static const String settingValue = 'setting_value';

  /// Paso del onboarding.
  static const String step = 'step';

  /// Identificador del minijuego.
  static const String gameId = 'game_id';

  /// Dificultad elegida en el minijuego (easy, medium, hard).
  static const String gameLevel = 'game_level';

  /// Porcentaje de acierto de la partida (0-100).
  static const String percent = 'percent';

  /// Estrellas ganadas en la partida (0-3).
  static const String stars = 'stars';

  /// Respuestas acertadas de la partida.
  static const String correct = 'correct';

  /// Preguntas respondidas en la partida.
  static const String total = 'total';

  /// Mejor racha de aciertos de la partida.
  static const String bestStreak = 'best_streak';
}
