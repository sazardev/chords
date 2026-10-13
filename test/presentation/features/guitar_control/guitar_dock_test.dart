import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_kit.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_host.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/widgets/organisms/adaptive_navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';

/// Tests del panel fijo del modo guitarra sobre el armazón real de la app.
void main() {
  late FakeAudioRepository audio;
  late SettingsController settings;
  late GuitarKit kit;
  late GoRouter router;
  final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

  StatefulShellBranch branch(String path) => StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: path,
        builder: (BuildContext context, GoRouterState state) =>
            Scaffold(body: Center(child: Text('página $path'))),
      ),
    ],
  );

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router = GoRouter(
      navigatorKey: rootKey,
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (
            BuildContext c,
            GoRouterState s,
            StatefulNavigationShell n,
          ) => AdaptiveNavigationShell(shell: n),
          branches: <StatefulShellBranch>[
            for (final String path in <String>[
              kHomePath,
              kLearnPath,
              kChordsPath,
              kGamePath,
              kLivePath,
              kSettingsPath,
            ])
              branch(path),
          ],
        ),
        GoRoute(
          path: kMiniGamePath,
          parentNavigatorKey: rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('un juego'))),
        ),
        GoRoute(
          path: kProfilePath,
          parentNavigatorKey: rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: Center(child: Text('perfil'))),
        ),
      ],
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<SettingsController>.value(value: settings),
            ...kit.providers,
            ChangeNotifierProvider<LiveController>.value(
              value: LiveController(audio, loadChordBank()),
            ),
            ChangeNotifierProvider<TunerController>.value(
              value: TunerController(audio),
            ),
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

  Future<void> choose(WidgetTester tester, String label) async {
    await tester.tap(find.text('Menú'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(Material), matching: find.text(label)),
    );
    await tester.pumpAndSettle();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    settings = SettingsController(await PreferencesService.create());
    audio = FakeAudioRepository();
    kit = GuitarKit(audio, settings);
  });

  Future<void> close() async {
    await kit.keeper.close();
    kit.nav.dispose();
    kit.listener.dispose();
  }

  testWidgets('apagado hay barra de navegación y no hay panel', (
    WidgetTester tester,
  ) async {
    await pump(tester);
    expect(find.byType(NavigationBar), findsOne);
    expect(find.text('Menú'), findsNothing);
    await close();
  });

  testWidgets('encendido, el panel sustituye a la barra en toda la app', (
    WidgetTester tester,
  ) async {
    await settings.setGuitarBrowse(value: true);
    await pump(tester);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Menú'), findsOne);
    expect(find.text('página /'), findsOne);

    await choose(tester, 'Acordes');
    expect(find.text('página $kChordsPath'), findsOne);
    expect(find.text('Menú de la guitarra'), findsNothing, reason: 'se cierra');

    // También sobre una pantalla que se abre encima de la barra.
    unawaited(router.push(kMiniGamePath));
    await tester.pumpAndSettle();
    expect(find.text('un juego'), findsOne);
    expect(find.text('Menú'), findsOne);

    await choose(tester, 'Atrás');
    expect(find.text('un juego'), findsNothing);
    expect(find.text('página $kChordsPath'), findsOne);

    await choose(tester, 'Perfil');
    expect(find.text('perfil'), findsOne);
    expect(find.text('Menú'), findsOne);
    await close();
  });

  testWidgets('apagar el modo conserva la pantalla y devuelve la barra', (
    WidgetTester tester,
  ) async {
    await settings.setGuitarBrowse(value: true);
    await pump(tester);
    await choose(tester, 'Ajustes');
    expect(find.text('página $kSettingsPath'), findsOne);

    await choose(tester, 'Apagar');
    expect(settings.guitarBrowse, isFalse);
    expect(find.byType(NavigationBar), findsOne);
    expect(find.text('Menú'), findsNothing);
    expect(find.text('página $kSettingsPath'), findsOne);
    await close();
  });
}
