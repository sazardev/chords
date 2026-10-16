import 'package:chords/config/route_paths.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_host.dart';
import 'package:chords/presentation/features/minigames/mini_game_page.dart';
import 'package:chords/presentation/features/minigames/mini_games_hub_page.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'mini_game_kit.dart';

/// Monta el catálogo y las pantallas de los minijuegos con un router de
/// pruebas, sobre los controladores reales de [kit].
Future<void> pumpMiniGameApp(
  WidgetTester tester, {
  required MiniGameKit kit,
  required SettingsController settings,
  String location = kGamePath,
  Size size = const Size(360, 640),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  addTearDown(kit.close);
  final GoRouter router = GoRouter(
    initialLocation: location,
    routes: <RouteBase>[
      GoRoute(
        path: kGamePath,
        builder: (BuildContext context, GoRouterState state) =>
            const MiniGamesHubPage(),
      ),
      GoRoute(
        path: kMiniGamePath,
        builder: (BuildContext context, GoRouterState state) =>
            MiniGamePage(gameId: state.uri.queryParameters['kind']),
      ),
      GoRoute(
        path: kChordGamePath,
        builder: (BuildContext context, GoRouterState state) =>
            const Text('serie de acordes'),
      ),
      GoRoute(
        path: kChordPracticePath,
        builder: (BuildContext context, GoRouterState state) =>
            Text('práctica ${state.uri.queryParameters['id']}'),
      ),
    ],
  );
  await tester.pumpWidget(
    TranslationProvider(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<SettingsController>.value(value: settings),
          ...kit.providers,
        ],
        child: MaterialApp.router(
          routerConfig: router,
          builder: (BuildContext context, Widget? child) =>
              GuitarNavHost(router: router, child: child!),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Lista principal de la pantalla: la primera que se desplaza (el catálogo
/// tiene además la fila horizontal de filtros y el campo de búsqueda).
Finder mainScrollable() => find.byType(Scrollable).first;

/// Pulsa el texto [text] desplazando la lista hasta verlo.
Future<void> tapText(WidgetTester tester, String text) async {
  final Finder finder = find.text(text);
  await tester.scrollUntilVisible(finder, 200, scrollable: mainScrollable());
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
