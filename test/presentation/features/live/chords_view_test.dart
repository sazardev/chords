import 'package:chords/config/route_paths.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/live/chords_view.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';

ChordCandidate _candidate(
  ChordRoot root,
  ChordQuality quality, {
  double confidence = 0.9,
}) => ChordCandidate(
  root: root,
  quality: quality,
  score: 1,
  confidence: confidence,
);

/// Tests de la interfaz del modo acordes en vivo.
void main() {
  late FakeAudioRepository audio;
  late LiveController controller;
  late SettingsController settings;
  late GoRouter router;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    audio = FakeAudioRepository();
    controller = LiveController(audio, loadChordBank());
    router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const Scaffold(body: SingleChildScrollView(child: ChordsView())),
        ),
        GoRoute(
          path: kChordDetailPath,
          builder: (BuildContext context, GoRouterState state) => Scaffold(
            appBar: AppBar(),
            body: Text('ficha ${state.uri.queryParameters['id']}'),
          ),
        ),
      ],
    );
  });

  tearDown(() {
    controller.dispose();
    LocaleSettings.setLocaleSync(AppLocale.es);
  });

  /// Crea los ajustes (la lectura de preferencias necesita tiempo real).
  Future<void> initSettings(WidgetTester tester) async {
    settings = (await tester.runAsync(
      () async => SettingsController(await PreferencesService.create()),
    ))!;
  }

  Future<void> pumpView(
    WidgetTester tester, {
    ThemeData? theme,
    Size size = const Size(420, 2000),
  }) async {
    await initSettings(tester);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<LiveController>.value(value: controller),
            ChangeNotifierProvider<SettingsController>.value(value: settings),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            theme: theme ?? buildLightTheme(),
          ),
        ),
      ),
    );
  }

  /// Empieza a escuchar como lo haría la pantalla al hacerse visible.
  Future<void> listen(WidgetTester tester) async {
    await tester.runAsync(controller.start);
    await tester.pump();
  }

  /// Deja que terminen las esperas del controlador y las transiciones.
  Future<void> settle(WidgetTester tester) async {
    for (int i = 0; i < 3; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
    }
  }

  /// Emite [chord] y deja que la interfaz se actualice.
  Future<void> hear(WidgetTester tester, ChordCandidate chord) async {
    audio.emitChord(chord);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 600));
  }

  testWidgets('en reposo invita a activar el micrófono', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);

    expect(find.text('Activar micrófono'), findsOne);
    expect(find.text('Toca un acorde'), findsOne);
    expect(
      find.text('Aquí aparecerán los acordes que vayas tocando.'),
      findsOne,
    );
    expect(find.byType(ChordDiagram), findsNothing);
  });

  testWidgets('sin permiso explica el problema y deja reintentar', (
    WidgetTester tester,
  ) async {
    audio.accessResult = MicStatus.permissionDenied;
    await pumpView(tester);
    await listen(tester);

    expect(find.byType(MicProblemCard), findsOne);
    expect(find.text('Necesito tu micrófono'), findsOne);
    expect(find.text('Activar micrófono'), findsNothing);

    audio.accessResult = MicStatus.listening;
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();

    expect(controller.status, MicStatus.listening);
  });

  testWidgets('en silencio pide tocar un acorde y muestra el nivel', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);
    await listen(tester);

    expect(find.text('Toca un acorde'), findsOne);
    expect(find.byType(MicLevelBar), findsOne);
    expect(find.text('Activar micrófono'), findsNothing);
  });

  testWidgets('con sonido pero sin acorde fiable dice que está escuchando', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);
    await listen(tester);

    audio.emitChordReading(
      ChordReading(
        chroma: List<double>.filled(12, 0.2),
        candidates: const <ChordCandidate>[],
        level: 0.5,
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Escuchando…'), findsOne);
  });

  testWidgets('un acorde sale con nombre, confianza, notas y diagrama', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);
    await listen(tester);

    await hear(tester, _candidate(ChordRoot.a, ChordQuality.minor));

    expect(find.text('Am'), findsWidgets);
    expect(find.text('La Menor'), findsOne);
    expect(find.textContaining('90 % de confianza'), findsOneWidget);
    expect(find.text('Muy seguro · 90 % de confianza'), findsOne);
    // Las 12 notas, con solfeo.
    for (final String note in <String>[
      'Do',
      'Do#',
      'Re',
      'Re#',
      'Mi',
      'Fa',
      'Fa#',
      'Sol',
      'Sol#',
      'La',
      'La#',
      'Si',
    ]) {
      expect(find.text(note), findsOneWidget, reason: note);
    }
    expect(find.byType(ChordDiagram), findsOneWidget);
    expect(find.text('Posición más cercana'), findsOne);
    expect(find.text('Notas que suenan'), findsOne);
  });

  testWidgets('muestra las alternativas probables con su confianza', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);
    await listen(tester);
    final ChordCandidate am = _candidate(ChordRoot.a, ChordQuality.minor);
    final ChordCandidate c = _candidate(
      ChordRoot.c,
      ChordQuality.sixth,
      confidence: 0.55,
    );

    audio.emitChordReading(
      ChordReading(
        chroma: List<double>.filled(12, 0.3),
        candidates: <ChordCandidate>[am, c],
        chord: am,
        bass: 9,
        level: 0.6,
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('También podría ser'), findsOne);
    expect(find.text('C6 · 55 %'), findsOne);
  });

  testWidgets('el historial recuerda los acordes y se puede tocar', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);
    await listen(tester);

    await hear(tester, _candidate(ChordRoot.c, ChordQuality.major));
    await hear(tester, _candidate(ChordRoot.g, ChordQuality.major));

    expect(find.text('Últimos acordes'), findsOne);
    expect(find.widgetWithText(ActionChip, 'G'), findsOne);
    expect(find.widgetWithText(ActionChip, 'C'), findsOne);

    await tester.tap(find.widgetWithText(ActionChip, 'C'));
    await settle(tester);

    // Se abre la ficha y el micrófono se suelta mientras tanto.
    expect(find.text('ficha C-maj'), findsOne);
    expect(audio.stops, 1);

    // Al volver retoma la escucha y conserva el historial.
    final int requests = audio.requests;
    router.pop();
    await settle(tester);

    expect(audio.requests, greaterThan(requests));
    expect(find.widgetWithText(ActionChip, 'G'), findsOne);
  });

  testWidgets('tocar el diagrama abre la ficha del acorde', (
    WidgetTester tester,
  ) async {
    await pumpView(tester);
    await listen(tester);
    await hear(tester, _candidate(ChordRoot.e, ChordQuality.minor));

    await tester.tap(find.text('Posición más cercana'));
    await settle(tester);

    expect(find.text('ficha E-min'), findsOne);
  });

  testWidgets('el modo zurdo espeja el diagrama', (WidgetTester tester) async {
    await pumpView(tester);
    await tester.runAsync(() => settings.setMirrorChords(value: true));
    await tester.pump();
    await listen(tester);

    await hear(tester, _candidate(ChordRoot.d, ChordQuality.major));

    final ChordDiagram diagram = tester.widget<ChordDiagram>(
      find.byType(ChordDiagram),
    );
    expect(diagram.mirror, isTrue);
  });

  testWidgets('se ve bien en tema claro y oscuro, en móvil pequeño', (
    WidgetTester tester,
  ) async {
    for (final ThemeData theme in <ThemeData>[
      buildLightTheme(),
      buildDarkTheme(),
    ]) {
      await pumpView(tester, theme: theme, size: const Size(320, 700));
      await listen(tester);
      await hear(tester, _candidate(ChordRoot.g, ChordQuality.minorSeven));

      expect(find.text('Gm7'), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.runAsync(controller.stop);
    }
  });

  testWidgets('en inglés las notas van con letras', (
    WidgetTester tester,
  ) async {
    LocaleSettings.setLocaleSync(AppLocale.en);
    await pumpView(tester);
    await listen(tester);

    await hear(tester, _candidate(ChordRoot.cSharp, ChordQuality.major));

    expect(find.text('C#'), findsWidgets);
    expect(find.text('Notes sounding'), findsOne);
    expect(find.text('Do#'), findsNothing);
  });
}
