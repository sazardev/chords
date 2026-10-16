import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/l10n/locale_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
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

import '../fakes/fake_audio_repository.dart';
import '../fakes/mini_game_kit.dart';

/// La aplicación completa montada sobre el banco real y un audio falso, para
/// probar pantallas con su navegación, tema, idioma y ajustes de verdad.
class AppHarness {
  AppHarness._({
    required this.chords,
    required this.audio,
    required this.settings,
    required this.appearance,
    required this.filters,
    required this.chordsController,
    required this.providers,
  });

  /// Prepara los controladores (español, sonido apagado) y carga el banco.
  static Future<AppHarness> create(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PreferencesService.kLanguageKey: 'spanish',
      PreferencesService.kSoundKey: false,
    });
    final PreferencesService preferences = await PreferencesService.create();
    final ChordRepository chords = ChordRepositoryImpl();
    final FakeAudioRepository audio = FakeAudioRepository();
    final SettingsController settings = SettingsController(preferences);
    final AppearanceController appearance = AppearanceController(preferences);
    final OnboardingController onboarding = OnboardingController(preferences);
    final ChordFilterController filters = ChordFilterController();
    final ChordsController chordsController = ChordsController(
      chords,
      const SearchChordsUseCase(),
      filters,
    );
    final LearnController learn = LearnController(chords, preferences);
    final GameScoreController gameScore = GameScoreController(preferences);
    final GameAudioController gameTuner = GameAudioController(audio);
    final MiniGameKit miniGames = MiniGameKit(
      chords: chords,
      audio: audio,
      preferences: preferences,
    );
    final LocaleController locale = LocaleController(
      LocaleRepositoryImpl(preferences),
    );
    await tester.runAsync(() async {
      await chordsController.load();
      await learn.load();
    });
    onboarding.completeSync();
    final List<SingleChildWidget> providers = <SingleChildWidget>[
      ChangeNotifierProvider<LocaleController>.value(value: locale),
      ChangeNotifierProvider<SettingsController>.value(value: settings),
      ChangeNotifierProvider<ProfileController>.value(
        value: ProfileController(preferences, settings),
      ),
      ChangeNotifierProvider<AppearanceController>.value(value: appearance),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
      ChangeNotifierProvider<ChordsController>.value(value: chordsController),
      ChangeNotifierProvider<ChordFilterController>.value(value: filters),
      ChangeNotifierProvider<ChordDetailController>.value(
        value: ChordDetailController(chords, audio, preferences),
      ),
      ChangeNotifierProvider<LearnController>.value(value: learn),
      ChangeNotifierProvider<GameController>.value(
        value: GameController(audio, chords, gameScore, gameTuner),
      ),
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
    return AppHarness._(
      chords: chords,
      audio: audio,
      settings: settings,
      appearance: appearance,
      filters: filters,
      chordsController: chordsController,
      providers: providers,
    );
  }

  /// Banco de acordes real ya cargado.
  final ChordRepository chords;

  /// Audio falso (no suena nada).
  final FakeAudioRepository audio;

  /// Ajustes (zurdos, guitarra…).
  final SettingsController settings;

  /// Apariencia (tema claro u oscuro).
  final AppearanceController appearance;

  /// Filtros de la biblioteca.
  final ChordFilterController filters;

  /// Lista visible de la biblioteca.
  final ChordsController chordsController;

  /// Proveedores de toda la aplicación.
  final List<SingleChildWidget> providers;

  /// Monta la aplicación en una pantalla de [size] píxeles lógicos.
  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
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
  }

  /// Navega a [location] y espera a que se asiente.
  Future<void> go(WidgetTester tester, String location) async {
    router(tester).go(location);
    await tester.pumpAndSettle();
  }

  /// Enrutador montado en la aplicación.
  GoRouter router(WidgetTester tester) =>
      tester.widget<MaterialApp>(find.byType(MaterialApp)).routerConfig!
          as GoRouter;
}
