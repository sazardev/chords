import 'package:chords/config/app_config.dart';
import 'package:chords/config/route_paths.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/presentation/features/chords/chord_detail_page.dart';
import 'package:chords/presentation/features/chords/chords_page.dart';
import 'package:chords/presentation/features/game/game_page.dart';
import 'package:chords/presentation/features/home/home_page.dart';
import 'package:chords/presentation/features/learn/learn_page.dart';
import 'package:chords/presentation/features/live/live_page.dart';
import 'package:chords/presentation/features/logs/logs_page.dart';
import 'package:chords/presentation/features/settings/settings_page.dart';
import 'package:chords/presentation/router/logging_navigator_observer.dart';
import 'package:chords/presentation/router/router_error_screen.dart';
import 'package:chords/presentation/widgets/organisms/adaptive_navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Construye el enrutador de la aplicación.
///
/// Incluye deep links (`chords://` y `https://chords.app/`), rutas
/// jerárquicas y parámetros de consulta en `/chords` y `/chords/detail`.
class AppRouter {
  /// Crea el enrutador para la configuración indicada.
  AppRouter({required this._config});

  final AppConfig _config;

  /// Enrutador listo para `MaterialApp.router`.
  late final GoRouter router = GoRouter(
    initialLocation: kHomePath,
    debugLogDiagnostics: _config.enableRouteLogs,
    observers: <NavigatorObserver>[LoggingNavigatorObserver()],
    errorBuilder: (BuildContext context, GoRouterState state) {
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
    },
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell shell,
        ) => AdaptiveNavigationShell(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: kHomePath,
                name: kHomeRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: kLearnPath,
                name: kLearnRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const LearnPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: kChordsPath,
                name: kChordsRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const ChordsPage(),
              ),
              GoRoute(
                path: kChordDetailPath,
                name: kChordDetailRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const ChordDetailPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: kGamePath,
                name: kGameRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const GamePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: kLivePath,
                name: kLiveRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const LivePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: kSettingsPath,
                name: kSettingsRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsPage(),
              ),
              GoRoute(
                path: kLogsPath,
                name: kLogsRouteName,
                builder: (BuildContext context, GoRouterState state) =>
                    const LogsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
