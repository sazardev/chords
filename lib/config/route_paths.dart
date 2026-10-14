/// Rutas de navegación profundas de la aplicación.
///
/// Se usan también como rutas de deep link (`chords://` y
/// `https://chords.app/`) y admiten parámetros de consulta.
library;

/// Ruta de inicio.
const String kHomePath = '/';

/// Itinerario de aprendizaje por niveles.
const String kLearnPath = '/learn';

/// Listado de acordes (biblioteca).
const String kChordsPath = '/chords';

/// Detalle de un acorde (query `?id=C-maj`).
const String kChordDetailPath = '/chords/detail';

/// Práctica de un acorde cuerda a cuerda (query `?id=C-maj&v=0`).
const String kChordPracticePath = '/chords/practice';

/// Perfil de la persona (guitarra, mano, géneros y experiencia).
const String kProfilePath = '/profile';

/// Catálogo de juegos (minijuegos y modo "toca el acorde").
const String kGamePath = '/game';

/// Serie "toca el acorde" con el micrófono.
const String kChordGamePath = '/game/chords';

/// Un minijuego (query `?kind=guessNote`; ver `MiniGameKind`).
const String kMiniGamePath = '/game/play';

/// Afinación en vivo con micrófono.
const String kLivePath = '/live';

/// Ajustes de la aplicación.
const String kSettingsPath = '/settings';

/// Visor de diagnóstico de logs dentro de ajustes.
const String kLogsPath = '/settings/logs';

/// Escuela de teoría: lecciones por bloques.
const String kTheoryPath = '/learn/theory';

/// Una lección de teoría (query `?id=pentatonic`).
const String kLessonPath = '/learn/lesson';

/// Explorador de escalas (query `?scale=blues&key=9&pos=1`).
const String kScalesPath = '/learn/scales';

/// Guía de géneros.
const String kGenresPath = '/learn/genres';

/// Un género de la guía (query `?id=country`).
const String kGenrePath = '/learn/genre';

/// Jam guiado (query `?prog=blues12&key=9` o `?song=bamba&transpose=2`).
const String kJamPath = '/jam';

/// Cancionero.
const String kSongsPath = '/songs';

/// Una canción (query `?id=bamba`).
const String kSongPath = '/songs/detail';

/// Historial de acordes.
const String kHistoryPath = '/chords/history';

/// Nombre interno de la ruta de inicio.
const String kHomeRouteName = 'home';

/// Nombre interno de la ruta de aprendizaje.
const String kLearnRouteName = 'learn';

/// Nombre interno de la ruta de listado de acordes.
const String kChordsRouteName = 'chords';

/// Nombre interno de la ruta de detalle.
const String kChordDetailRouteName = 'chord-detail';

/// Nombre interno de la ruta de práctica de acorde.
const String kChordPracticeRouteName = 'chord-practice';

/// Nombre interno de la ruta del perfil.
const String kProfileRouteName = 'profile';

/// Nombre interno de la ruta del catálogo de juegos.
const String kGameRouteName = 'game';

/// Nombre interno de la ruta de la serie "toca el acorde".
const String kChordGameRouteName = 'chord-game';

/// Nombre interno de la ruta de un minijuego.
const String kMiniGameRouteName = 'minigame';

/// Nombre interno de la ruta en vivo.
const String kLiveRouteName = 'live';

/// Nombre interno de la ruta de ajustes.
const String kSettingsRouteName = 'settings';

/// Nombre interno de la ruta del visor de diagnóstico.
const String kLogsRouteName = 'logs';

/// Destinos de navegación en orden de pestaña.
const List<String> kNavigationDestinations = <String>[
  kHomePath,
  kLearnPath,
  kChordsPath,
  kGamePath,
  kLivePath,
  kSettingsPath,
];

/// Nombres internos de las rutas de cada pestaña, en el mismo orden.
const List<String> kNavigationRouteNames = <String>[
  kHomeRouteName,
  kLearnRouteName,
  kChordsRouteName,
  kGameRouteName,
  kLiveRouteName,
  kSettingsRouteName,
];
