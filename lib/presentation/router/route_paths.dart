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

/// Modo juego.
const String kGamePath = '/game';

/// Afinación en vivo con micrófono.
const String kLivePath = '/live';

/// Ajustes de la aplicación.
const String kSettingsPath = '/settings';

/// Visor de diagnóstico de logs dentro de ajustes.
const String kLogsPath = '/settings/logs';

/// Nombre interno de la ruta de inicio.
const String kHomeRouteName = 'home';

/// Nombre interno de la ruta de aprendizaje.
const String kLearnRouteName = 'learn';

/// Nombre interno de la ruta de listado de acordes.
const String kChordsRouteName = 'chords';

/// Nombre interno de la ruta de detalle.
const String kChordDetailRouteName = 'chord-detail';

/// Nombre interno de la ruta del juego.
const String kGameRouteName = 'game';

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
