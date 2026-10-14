import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/config/route_paths.dart';
import 'package:chords/data/audio/audio_repository_impl.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/l10n/locale_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/appearance_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes/mini_game_kit.dart';

/// Audit responsive: recorre todas las pantallas en tamaños de móvil
/// comprobando que no haya desbordes ni errores de layout.
void main() {
  testWidgets('las pantallas se renderizan sin desbordes en móvil', (
    WidgetTester tester,
  ) async {
    // El entorno de pruebas arranca en inglés: fijamos el español,
    // idioma base de la app, para que los textos sean deterministas.
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.kLanguageKey: 'spanish',
    });
    final PreferencesService preferences = await PreferencesService.create();
    final ChordRepository chords = ChordRepositoryImpl();
    final AudioRepository audio = AudioRepositoryImpl();
    final ChordFilterController chordFilters = ChordFilterController();
    final ChordsController chordsController = ChordsController(
      chords,
      const SearchChordsUseCase(),
      chordFilters,
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
    final OnboardingController onboarding = OnboardingController(preferences);
    final MiniGameKit miniGames = MiniGameKit(
      chords: chords,
      audio: audio,
      preferences: preferences,
    );

    await tester.runAsync(() async {
      await chordsController.load();
      await learn.load();
    });
    onboarding.completeSync();

    final LocaleController locale = LocaleController(
      LocaleRepositoryImpl(preferences),
    );

    final SettingsController settings = SettingsController(preferences);
    final List<SingleChildWidget> providers = <SingleChildWidget>[
      ChangeNotifierProvider<LocaleController>.value(value: locale),
      ChangeNotifierProvider<SettingsController>.value(value: settings),
      ChangeNotifierProvider<ProfileController>.value(
        value: ProfileController(preferences, settings),
      ),
      ChangeNotifierProvider<AppearanceController>.value(
        value: AppearanceController(preferences),
      ),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
      ChangeNotifierProvider<ChordsController>.value(value: chordsController),
      ChangeNotifierProvider<ChordFilterController>.value(value: chordFilters),
      ChangeNotifierProvider<ChordDetailController>.value(
        value: ChordDetailController(chords, audio, preferences),
      ),
      ChangeNotifierProvider<LearnController>.value(value: learn),
      ChangeNotifierProvider<GameController>.value(value: game),
      ChangeNotifierProvider<GameScoreController>.value(value: gameScore),
      ChangeNotifierProvider<GameAudioController>.value(value: gameTuner),
      ...miniGames.providers,
      ChangeNotifierProvider<LiveController>.value(
        value: LiveController(audio, chords),
      ),
      ChangeNotifierProvider<TunerController>.value(
        value: TunerController(audio),
      ),
      ChangeNotifierProvider<ChordPracticeController>.value(
        value: ChordPracticeController(audio, chords),
      ),
    ];

    // Tamaños representativos de móvil (del más pequeño al grande).
    // El último es estrecho pero muy alto: construye las listas largas del
    // estudio enteras para comprobar también su parte baja.
    const List<Size> phoneSizes = <Size>[
      Size(320, 480),
      Size(360, 640),
      Size(412, 915),
      Size(320, 5000),
    ];

    for (final Size size in phoneSizes) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

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
      expect(tester.takeException(), isNull, reason: 'home $size');

      await _visit(
        tester,
        kHomePath,
        expectText: '¿Qué tocas hoy?',
        size: size,
      );
      await _visit(tester, kLearnPath, expectText: 'Aprender', size: size);
      await _visit(tester, kChordsPath, expectText: 'Acordes', size: size);
      await _visit(tester, kGamePath, expectText: 'Jugar', size: size);
      await _visit(
        tester,
        kChordGamePath,
        expectText: 'Empezar serie',
        size: size,
      );
      for (final MiniGameKind kind in MiniGameKind.values) {
        await _visit(
          tester,
          '$kMiniGamePath?kind=${kind.id}',
          expectText: 'Cómo se juega',
          size: size,
        );
      }
      await _visit(tester, kLivePath, expectText: 'Afinador', size: size);
      await _visit(
        tester,
        '$kChordPracticePath?id=C-maj&v=0',
        expectText: 'Empezar a practicar',
        size: size,
      );
      await _visit(tester, kSettingsPath, expectText: 'Ajustes', size: size);
      await _visitStudio(tester, size);
    }
  });
}

/// Recorre las pantallas del estudio: teoría, cada lección, escalas, cada
/// género, jam, cancionero, cada canción e historial.
Future<void> _visitStudio(WidgetTester tester, Size size) async {
  final Translations es = AppLocale.es.buildSync();
  await _visit(
    tester,
    kTheoryPath,
    expectText: 'Escuela de guitarra',
    size: size,
  );
  for (final TheoryLesson lesson in kTheoryLessons) {
    await _visit(
      tester,
      '$kLessonPath?id=${lesson.id}',
      expectText: es.theory.lessonTitles[lesson.id]!,
      size: size,
    );
  }
  await _visit(
    tester,
    '$kScalesPath?scale=blues&key=9&pos=2',
    expectText: 'Explorador de escalas',
    size: size,
  );
  await _visit(tester, kGenresPath, expectText: 'Géneros', size: size);
  for (final GenreGuide guide in kGenreGuides) {
    await _visit(
      tester,
      '$kGenrePath?id=${guide.id}',
      expectText: '${guide.emoji}  ${es.theory.genreNames[guide.id]}',
      size: size,
    );
  }
  await _visit(tester, kJamPath, expectText: 'Progresiones', size: size);
  await _visit(
    tester,
    '$kJamPath?prog=blues12&key=4',
    expectText: 'Blues de 12 compases',
    size: size,
  );
  await _visit(
    tester,
    '$kJamPath?song=cielito&transpose=2',
    expectText: 'Cielito lindo',
    size: size,
  );
  await _visit(tester, kSongsPath, expectText: 'Cancionero', size: size);
  for (final Song song in kSongs) {
    await _visit(
      tester,
      '$kSongPath?id=${song.id}',
      expectText: 'Tocar en el jam',
      size: size,
    );
  }
  await _visit(
    tester,
    kHistoryPath,
    expectText: 'Historial de acordes',
    size: size,
  );
}

/// Navega a una ruta y comprueba que la pantalla se renderiza sin excepciones.
Future<void> _visit(
  WidgetTester tester,
  String location, {
  required String expectText,
  required Size size,
}) async {
  routerOf(tester).go(location);
  await tester.pumpAndSettle();
  expect(
    tester.takeException(),
    isNull,
    reason: 'excepción en $location a ${size.width}x${size.height}',
  );
  expect(
    find.text(expectText).evaluate().isNotEmpty,
    isTrue,
    reason: 'no se encontró "$expectText" en $location',
  );
}

/// Recupera el enrutador montado en la aplicación.
GoRouter routerOf(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp)).routerConfig!
        as GoRouter;
