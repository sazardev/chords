import 'dart:async' show unawaited;

import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/data/audio/audio_repository_impl.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Punto de entrada de arranque de la aplicación.
///
/// Compone las dependencias, registra los controladores y monta la app.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppDependencies dependencies = await AppDependencies.create();
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<SettingsController>(
          create: (_) => dependencies.settingsController,
        ),
        ChangeNotifierProvider<OnboardingController>(
          create: (_) => dependencies.onboardingController,
        ),
        ChangeNotifierProvider<ChordsController>(
          create: (_) => dependencies.chordsController,
        ),
        ChangeNotifierProvider<ChordDetailController>(
          create: (_) => dependencies.chordDetailController,
        ),
        ChangeNotifierProvider<LearnController>(
          create: (_) => dependencies.learnController,
        ),
        ChangeNotifierProvider<GameController>(
          create: (_) => dependencies.gameController,
        ),
        ChangeNotifierProvider<LiveController>(
          create: (_) => dependencies.liveController,
        ),
      ],
      child: ChordsApp(
        config: config,
        router: AppRouter(config: config).router,
      ),
    ),
  );
}

/// Composición de dependencias de la aplicación.
///
/// Centraliza la creación de repositorios, casos de uso y controladores para
/// que el arranque sea el único lugar con lógica de construcción.
class AppDependencies {
  AppDependencies._({
    required this.settingsController,
    required this.onboardingController,
    required this.chordsController,
    required this.chordDetailController,
    required this.learnController,
    required this.gameController,
    required this.liveController,
  });

  /// Crea el grafo de dependencias por defecto.
  static Future<AppDependencies> create() async {
    final PreferencesService preferences = await PreferencesService.create();
    final ChordRepository chordRepository = ChordRepositoryImpl();
    final AudioRepository audioRepository = AudioRepositoryImpl();
    final SettingsController settings = SettingsController(preferences);
    final OnboardingController onboarding = OnboardingController(preferences);
    final ChordsController chords = ChordsController(
      chordRepository,
      const SearchChordsUseCase(),
      preferences,
    );
    final ChordDetailController chordDetail = ChordDetailController(
      chordRepository,
      audioRepository,
      preferences,
    );
    final LearnController learn = LearnController(chordRepository, preferences);
    final GameController game = GameController(
      audioRepository,
      chordRepository,
      preferences,
    );
    final LiveController live = LiveController(
      audioRepository,
      chordRepository,
    );
    unawaited(settings.load());
    onboarding.load();
    unawaited(chords.load());
    unawaited(learn.load());
    game.loadBestScore();
    return AppDependencies._(
      settingsController: settings,
      onboardingController: onboarding,
      chordsController: chords,
      chordDetailController: chordDetail,
      learnController: learn,
      gameController: game,
      liveController: live,
    );
  }

  /// Controlador de ajustes.
  final SettingsController settingsController;

  /// Controlador del onboarding.
  final OnboardingController onboardingController;

  /// Controlador del listado de acordes.
  final ChordsController chordsController;

  /// Controlador del detalle de acorde.
  final ChordDetailController chordDetailController;

  /// Controlador del aprendizaje.
  final LearnController learnController;

  /// Controlador del modo juego.
  final GameController gameController;

  /// Controlador de la afinación en vivo.
  final LiveController liveController;
}
