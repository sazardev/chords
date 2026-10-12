import 'dart:async' show unawaited;

import 'package:chords/app/app.dart';
import 'package:chords/config/app_config.dart';
import 'package:chords/config/flavor.dart';
import 'package:chords/core/analytics/analytics.dart';
import 'package:chords/core/analytics/analytics_log_sink.dart';
import 'package:chords/core/logging/app_log_level.dart';
import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/core/logging/log_sink.dart';
import 'package:chords/core/logging/runtime/app_error_zone.dart';
import 'package:chords/core/logging/runtime/logging_bootstrap.dart';
import 'package:chords/data/analytics/analytics_bootstrap.dart';
import 'package:chords/data/audio/audio_repository_impl.dart';
import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/l10n/locale_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/domain/l10n/repositories/locale_repository.dart';
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Punto de entrada de arranque de la aplicación.
///
/// Activa el logging global, cronometra la composición de dependencias, monta
/// la app bajo una zona protegida de errores y deja rastro de todo el proceso.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  final AnalyticsBootstrapResult analyticsResult = await bootstrapAnalytics(
    config: config,
  );
  configureAnalytics(analyticsResult.service);
  final AppLogger logger = bootstrapLogging(
    minLevel: _minLevelFor(config.flavor),
    appName: config.appName,
    inAppDiagnostics: config.enableRouteLogs,
    extraSinks: <LogSink>[AnalyticsLogSink(analyticsResult.service)],
  );
  _reportAnalytics(logger, config, analyticsResult);
  final AppDependencies dependencies = await logger.track(
    AppDependencies.create,
    name: 'composición de dependencias',
    channel: LogChannel.boot,
    slowThreshold: const Duration(milliseconds: 800),
    context: <String, Object?>{'flavor': config.flavor.name},
  );
  final Widget app = TranslationProvider(
    child: MultiProvider(
      providers: _appProviders(dependencies),
      child: ChordsApp(
        config: config,
        router: AppRouter(config: config).router,
      ),
    ),
  );
  runAppGuarded(logger, app);
}

/// Providers de la aplicación a partir de las dependencias compuestas.
List<SingleChildWidget> _appProviders(AppDependencies dependencies) =>
    <SingleChildWidget>[
      ChangeNotifierProvider<LocaleController>(
        create: (_) => dependencies.localeController,
      ),
      ChangeNotifierProvider<AppearanceController>(
        create: (_) => dependencies.appearanceController,
      ),
      ChangeNotifierProvider<SettingsController>(
        create: (_) => dependencies.settingsController,
      ),
      ChangeNotifierProvider<OnboardingController>(
        create: (_) => dependencies.onboardingController,
      ),
      ChangeNotifierProvider<ChordsController>(
        create: (_) => dependencies.chordsController,
      ),
      ChangeNotifierProvider<ChordFilterController>(
        create: (_) => dependencies.chordFilterController,
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
      ChangeNotifierProvider<GameScoreController>(
        create: (_) => dependencies.gameScoreController,
      ),
      ChangeNotifierProvider<GameAudioController>(
        create: (_) => dependencies.gameAudioController,
      ),
      ChangeNotifierProvider<LiveController>(
        create: (_) => dependencies.liveController,
      ),
    ];

/// Severidad mínima de log según el flavor activo.
AppLogLevel _minLevelFor(Flavor flavor) => switch (flavor) {
  Flavor.dev => AppLogLevel.debug,
  Flavor.staging => AppLogLevel.info,
  Flavor.prod => AppLogLevel.warning,
};

/// Deja rastro del arranque de analíticas y avisa si no están disponibles.
void _reportAnalytics(
  AppLogger logger,
  AppConfig config,
  AnalyticsBootstrapResult result,
) {
  result.service.appOpened(flavor: config.flavor.name);
  if (result.problem != null) {
    logger.warning(
      'analíticas no disponibles: se usa backend silencioso',
      channel: LogChannel.boot,
      error: result.problem,
      stackTrace: result.stackTrace,
      context: <String, Object?>{'flavor': config.flavor.name},
    );
    return;
  }
  logger.info(
    result.active
        ? 'analíticas Firebase activas'
        : 'analíticas desactivadas en este flavor',
    channel: LogChannel.boot,
    context: <String, Object?>{'flavor': config.flavor.name},
  );
}

/// Composición de dependencias de la aplicación.
///
/// Centraliza la creación de repositorios, casos de uso y controladores para
/// que el arranque sea el único lugar con lógica de construcción.
class AppDependencies {
  AppDependencies._({
    required this.localeController,
    required this.appearanceController,
    required this.settingsController,
    required this.onboardingController,
    required this.chordsController,
    required this.chordFilterController,
    required this.chordDetailController,
    required this.learnController,
    required this.gameController,
    required this.gameScoreController,
    required this.gameAudioController,
    required this.liveController,
  });

  /// Crea el grafo de dependencias por defecto.
  static Future<AppDependencies> create() async {
    final PreferencesService preferences = await PreferencesService.create();
    final LocaleRepository localeRepository = LocaleRepositoryImpl(preferences);
    final ChordRepository chordRepository = ChordRepositoryImpl();
    final AudioRepository audioRepository = AudioRepositoryImpl();
    final LocaleController locale = LocaleController(localeRepository);
    final AppearanceController appearance = AppearanceController(preferences);
    final SettingsController settings = SettingsController(preferences);
    final OnboardingController onboarding = OnboardingController(preferences);
    final ChordFilterController chordFilters = ChordFilterController();
    final ChordsController chords = ChordsController(
      chordRepository,
      const SearchChordsUseCase(),
      chordFilters,
    );
    final ChordDetailController chordDetail = ChordDetailController(
      chordRepository,
      audioRepository,
      preferences,
    );
    final LearnController learn = LearnController(chordRepository, preferences);
    final GameScoreController gameScore = GameScoreController(preferences);
    final GameAudioController gameTuner = GameAudioController(audioRepository);
    final GameController game = GameController(
      audioRepository,
      chordRepository,
      gameScore,
      gameTuner,
    );
    final LiveController live = LiveController(
      audioRepository,
      chordRepository,
    );
    unawaited(locale.load());
    unawaited(appearance.load());
    unawaited(settings.load());
    onboarding.load();
    unawaited(chords.load());
    unawaited(learn.load());
    gameScore.loadBestScore();
    return AppDependencies._(
      localeController: locale,
      appearanceController: appearance,
      settingsController: settings,
      onboardingController: onboarding,
      chordsController: chords,
      chordFilterController: chordFilters,
      chordDetailController: chordDetail,
      learnController: learn,
      gameController: game,
      gameScoreController: gameScore,
      gameAudioController: gameTuner,
      liveController: live,
    );
  }

  /// Controlador del idioma de la interfaz.
  final LocaleController localeController;

  /// Controlador de la apariencia (tema, acento, texto y color dinámico).
  final AppearanceController appearanceController;

  /// Controlador de ajustes.
  final SettingsController settingsController;

  /// Controlador del onboarding.
  final OnboardingController onboardingController;

  /// Controlador del listado de acordes.
  final ChordsController chordsController;

  /// Controlador de los filtros de la biblioteca de acordes.
  final ChordFilterController chordFilterController;

  /// Controlador del detalle de acorde.
  final ChordDetailController chordDetailController;

  /// Controlador del aprendizaje.
  final LearnController learnController;

  /// Controlador del modo juego.
  final GameController gameController;

  /// Controlador de la puntuación y el récord del juego.
  final GameScoreController gameScoreController;

  /// Controlador de la escucha y afinación del juego.
  final GameAudioController gameAudioController;

  /// Controlador de la afinación en vivo.
  final LiveController liveController;
}
