import 'package:chords/config/app_config.dart';
import 'package:chords/presentation/features/chords/chord_detail_page.dart';
import 'package:chords/presentation/features/chords/chords_page.dart';
import 'package:chords/presentation/features/home/home_page.dart';
import 'package:chords/presentation/features/live/live_page.dart';
import 'package:chords/presentation/features/settings/settings_page.dart';
import 'package:chords/presentation/router/route_paths.dart';
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
            ],
          ),
        ],
      ),
    ],
  );
}
