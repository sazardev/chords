import 'package:chords/config/app_config.dart';
import 'package:chords/config/route_paths.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/presentation/features/chords/chord_detail_page.dart';
import 'package:chords/presentation/features/chords/chords_page.dart';
import 'package:chords/presentation/features/game/game_page.dart';
import 'package:chords/presentation/features/home/home_page.dart';
import 'package:chords/presentation/features/jam/jam_page.dart';
import 'package:chords/presentation/features/learn/learn_page.dart';
import 'package:chords/presentation/features/live/live_page.dart';
import 'package:chords/presentation/features/logs/logs_page.dart';
import 'package:chords/presentation/features/minigames/mini_game_page.dart';
import 'package:chords/presentation/features/minigames/mini_games_hub_page.dart';
import 'package:chords/presentation/features/practice/chord_practice_page.dart';
import 'package:chords/presentation/features/profile/profile_page.dart';
import 'package:chords/presentation/features/settings/settings_page.dart';
import 'package:chords/presentation/features/songs/song_page.dart';
import 'package:chords/presentation/features/songs/songs_page.dart';
import 'package:chords/presentation/features/studio/history_page.dart';
import 'package:chords/presentation/features/theory/genre_page.dart';
import 'package:chords/presentation/features/theory/genres_page.dart';
import 'package:chords/presentation/features/theory/lesson_page.dart';
import 'package:chords/presentation/features/theory/scale_explorer_page.dart';
import 'package:chords/presentation/features/theory/theory_page.dart';
import 'package:chords/presentation/router/logging_navigator_observer.dart';
import 'package:chords/presentation/router/router_error_screen.dart';
import 'package:chords/presentation/widgets/organisms/adaptive_navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Construye el enrutador de la aplicación.
///
/// Incluye deep links (`chords://` y `https://chords.app/`), rutas
/// jerárquicas y parámetros de consulta en `/chords` y `/chords/detail`. El
/// detalle de acorde vive en la raíz (fuera de las pestañas) para que se abra
/// sobre cualquier pantalla y volver atrás regrese exactamente de donde se
/// vino.
class AppRouter {
  /// Crea el enrutador para la configuración indicada.
  AppRouter({required this._config});

  final AppConfig _config;
  final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

  /// Enrutador listo para `MaterialApp.router`.
  late final GoRouter router = _build();

  GoRouter _build() => GoRouter(
    initialLocation: kHomePath,
    navigatorKey: _rootKey,
    debugLogDiagnostics: _config.enableRouteLogs,
    observers: <NavigatorObserver>[LoggingNavigatorObserver()],
    errorBuilder: _errorBuilder,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell shell,
        ) => AdaptiveNavigationShell(shell: shell),
        branches: <StatefulShellBranch>[
          _homeBranch(),
          _learnBranch(),
          _chordsBranch(),
          _gameBranch(),
          _liveBranch(),
          _settingsBranch(),
        ],
      ),
      _chordDetailRoute(),
      _chordPracticeRoute(),
      _chordGameRoute(),
      _miniGameRoute(),
      _profileRoute(),
      ..._studioRoutes(),
    ],
  );

  /// Rutas del estudio: teoría, escalas, géneros, jam, canciones e historial.
  List<GoRoute> _studioRoutes() => <GoRoute>[
    _rootRoute(kTheoryPath, (_) => const TheoryPage()),
    _rootRoute(
      kLessonPath,
      (Map<String, String> q) => LessonPage(lessonId: q['id']),
    ),
    _rootRoute(kScalesPath, (_) => const ScaleExplorerPage()),
    _rootRoute(kGenresPath, (_) => const GenresPage()),
    _rootRoute(
      kGenrePath,
      (Map<String, String> q) => GenrePage(genreId: q['id']),
    ),
    _rootRoute(kJamPath, (_) => const JamPage()),
    _rootRoute(kSongsPath, (_) => const SongsPage()),
    _rootRoute(kSongPath, (Map<String, String> q) => SongPage(songId: q['id'])),
    _rootRoute(kHistoryPath, (_) => const HistoryPage()),
  ];

  GoRoute _rootRoute(
    String path,
    Widget Function(Map<String, String> query) page,
  ) => GoRoute(
    path: path,
    parentNavigatorKey: _rootKey,
    builder: (BuildContext context, GoRouterState state) =>
        page(state.uri.queryParameters),
  );

  StatefulShellBranch _homeBranch() => StatefulShellBranch(
    routes: <RouteBase>[_route(kHomePath, kHomeRouteName, const HomePage())],
  );

  StatefulShellBranch _learnBranch() => StatefulShellBranch(
    routes: <RouteBase>[_route(kLearnPath, kLearnRouteName, const LearnPage())],
  );

  StatefulShellBranch _chordsBranch() => StatefulShellBranch(
    routes: <RouteBase>[
      _route(kChordsPath, kChordsRouteName, const ChordsPage()),
    ],
  );

  StatefulShellBranch _gameBranch() => StatefulShellBranch(
    routes: <RouteBase>[
      _route(kGamePath, kGameRouteName, const MiniGamesHubPage()),
    ],
  );

  StatefulShellBranch _liveBranch() => StatefulShellBranch(
    routes: <RouteBase>[_route(kLivePath, kLiveRouteName, const LivePage())],
  );

  StatefulShellBranch _settingsBranch() => StatefulShellBranch(
    routes: <RouteBase>[
      _route(kSettingsPath, kSettingsRouteName, const SettingsPage()),
      _route(kLogsPath, kLogsRouteName, const LogsPage()),
    ],
  );

  GoRoute _chordDetailRoute() => GoRoute(
    path: kChordDetailPath,
    name: kChordDetailRouteName,
    parentNavigatorKey: _rootKey,
    builder: (BuildContext context, GoRouterState state) =>
        const ChordDetailPage(),
  );

  GoRoute _chordPracticeRoute() => GoRoute(
    path: kChordPracticePath,
    name: kChordPracticeRouteName,
    parentNavigatorKey: _rootKey,
    builder: (BuildContext context, GoRouterState state) =>
        const ChordPracticePage(),
  );

  GoRoute _chordGameRoute() => GoRoute(
    path: kChordGamePath,
    name: kChordGameRouteName,
    parentNavigatorKey: _rootKey,
    builder: (BuildContext context, GoRouterState state) => const GamePage(),
  );

  GoRoute _miniGameRoute() => GoRoute(
    path: kMiniGamePath,
    name: kMiniGameRouteName,
    parentNavigatorKey: _rootKey,
    builder: (BuildContext context, GoRouterState state) =>
        MiniGamePage(gameId: state.uri.queryParameters['kind']),
  );

  GoRoute _profileRoute() => GoRoute(
    path: kProfilePath,
    name: kProfileRouteName,
    parentNavigatorKey: _rootKey,
    builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
  );

  GoRoute _route(String path, String name, Widget page) => GoRoute(
    path: path,
    name: name,
    builder: (BuildContext context, GoRouterState state) => page,
  );

  Widget _errorBuilder(BuildContext context, GoRouterState state) {
    final GoException? exception = state.error;
    if (exception != null) {
      appLogger.error(
        'excepción de navegación',
        channel: LogChannel.router,
        error: exception,
        context: <String, Object?>{'location': state.uri.toString()},
      );
    } else {
      appLogger.warning(
        'ruta no encontrada',
        channel: LogChannel.router,
        context: <String, Object?>{'location': state.uri.toString()},
      );
    }
    return RouterErrorScreen(location: state.uri.toString());
  }
}
