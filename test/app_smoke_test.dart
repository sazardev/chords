import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/config/route_paths.dart';
import 'package:chords/data/audio/audio_repository_impl.dart';
import 'package:chords/data/chords/datasources/chord_asset_datasource.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/l10n/locale_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/appearance_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/router/app_router.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:chords/presentation/widgets/molecules/chord_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Smoke test de la aplicación completa (arranque, assets y navegación).
void main() {
  testWidgets('la app arranca, carga el banco y navega', (
    WidgetTester tester,
  ) async {
    // El entorno de pruebas arranca en inglés: fijamos el español,
    // idioma base de la app, para que los textos sean deterministas.
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.kLanguageKey: 'spanish',
      PreferencesService.kSoundKey: false,
    });
    final PreferencesService preferences = await PreferencesService.create();
    final LocaleController localeController = LocaleController(
      LocaleRepositoryImpl(preferences),
    );
    final ChordRepository chords = ChordRepositoryImpl(
      dataSource: const ChordAssetDataSource(),
    );
    final AudioRepository audio = AudioRepositoryImpl();
    final SettingsController settings = SettingsController(preferences);
    final AppearanceController appearance = AppearanceController(preferences);
    final OnboardingController onboarding = OnboardingController(preferences);
    final ChordFilterController chordFilters = ChordFilterController();
    final ChordsController chordsController = ChordsController(
      chords,
      const SearchChordsUseCase(),
      chordFilters,
    );
    final ChordDetailController chordDetail = ChordDetailController(
      chords,
      audio,
      preferences,
    );
    final LearnController learn = LearnController(chords, preferences);
    final GameScoreController gameScore = GameScoreController(preferences);
    final GameAudioController gameTuner = GameAudioController(audio);
    final GameController game = GameController(
      audio,
      chords,
      gameScore,
      gameTuner,
    );
    final LiveController live = LiveController(audio, chords);

    await tester.runAsync(() async {
      await chords.load();
      await chordsController.load();
      await learn.load();
      onboarding.load();
      await localeController.load();
    });

    final List<SingleChildWidget> providers = <SingleChildWidget>[
      ChangeNotifierProvider<LocaleController>.value(value: localeController),
      ChangeNotifierProvider<SettingsController>.value(value: settings),
      ChangeNotifierProvider<AppearanceController>.value(value: appearance),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
      ChangeNotifierProvider<ChordsController>.value(value: chordsController),
      ChangeNotifierProvider<ChordFilterController>.value(value: chordFilters),
      ChangeNotifierProvider<ChordDetailController>.value(value: chordDetail),
      ChangeNotifierProvider<LearnController>.value(value: learn),
      ChangeNotifierProvider<GameController>.value(value: game),
      ChangeNotifierProvider<GameScoreController>.value(value: gameScore),
      ChangeNotifierProvider<GameAudioController>.value(value: gameTuner),
      ChangeNotifierProvider<LiveController>.value(value: live),
    ];

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: providers,
          child: ChordsApp(
            config: const AppConfig.dev(),
            router: AppRouter(config: const AppConfig.dev()).router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Onboarding pendiente en el primer arranque: se muestra sobre el home.
    expect(find.text('Omitir'), findsOneWidget);
    await tester.tap(find.text('Omitir'));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué tocas hoy?'), findsOneWidget);

    // Navegación al listado de acordes.
    await tester.tap(find.text('Acordes').last);
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);

    // Entrar al detalle de un acorde.
    final Chord chord = tester
        .widget<ChordCard>(find.byType(ChordCard).first)
        .chord;
    await tester.tap(find.byType(ChordCard).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(find.text('Arpegios'), findsOneWidget);
    // El listado de posiciones está más abajo: hay que desplazarse.
    await tester.drag(find.byType(ListView).last, const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Posiciones'), findsOneWidget);
    expect(find.text(chord.name), findsWidgets);

    // Volver del detalle regresa al listado (ruta raíz, no pestaña).
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);

    // Abrir otro acorde muestra el nuevo, no el anterior.
    final Chord second = tester
        .widget<ChordCard>(find.byType(ChordCard).at(1))
        .chord;
    await tester.tap(find.byType(ChordCard).at(1));
    await tester.pumpAndSettle();
    expect(find.text(second.name), findsWidgets);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Desde Aprender, la ficha se abre encima y volver regresa a Aprender.
    routerOf(tester).go(kLearnPath);
    await tester.pumpAndSettle();
    final Chord learnChord = tester
        .widget<ChordTile>(find.byType(ChordTile).first)
        .chord;
    await tester.tap(find.byType(ChordTile).first);
    await tester.pumpAndSettle();
    expect(find.text(learnChord.name), findsWidgets);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Aprender'), findsWidgets);

    // Página en vivo sin micrófono activo.
    routerOf(tester).go(kLivePath);
    await tester.pumpAndSettle();
    expect(find.text('En vivo'), findsWidgets);
    expect(find.text('Micrófono en espera'), findsOneWidget);

    // Modo juego: iniciar serie y ver el objetivo.
    routerOf(tester).go(kGamePath);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empezar serie'));
    await tester.pumpAndSettle();
    expect(find.text('Ronda 1'), findsOneWidget);
    expect(find.text('Estoy listo'), findsOneWidget);

    // Cambio de idioma en caliente: la interfaz pasa a inglés.
    routerOf(tester).go(kSettingsPath);
    await tester.pumpAndSettle();
    final Finder english = find.text('Inglés');
    await tester.scrollUntilVisible(
      english,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(english);
    await tester.pumpAndSettle();
    routerOf(tester).go(kHomePath);
    await tester.pumpAndSettle();
    expect(find.text('What are you playing today?'), findsOneWidget);

    // Deep link con parámetros de consulta: /chords?root=E&quality=min.
    routerOf(tester).go('$kChordsPath?root=E&quality=min');
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    await tester.pump(Duration.zero);
    expect(chordsController.visibleChords.isNotEmpty, isTrue);
    expect(
      chordsController.visibleChords.every(
        (Chord c) => c.root == ChordRoot.e && c.quality == ChordQuality.minor,
      ),
      isTrue,
    );
  });
}

/// Recupera el enrutador montado en la aplicación.
GoRouter routerOf(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp)).routerConfig!
        as GoRouter;
