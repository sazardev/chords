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
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final ChordsController chordsController = ChordsController(
      chords,
      const SearchChordsUseCase(),
    );
    final LearnController learn = LearnController(chords, preferences);
    final GameController game = GameController(audio, chords, preferences);
    final OnboardingController onboarding = OnboardingController(preferences);

    await tester.runAsync(() async {
      await chordsController.load();
      await learn.load();
    });
    onboarding.completeSync();

    final LocaleController locale = LocaleController(
      LocaleRepositoryImpl(preferences),
    );

    final List<SingleChildWidget> providers = <SingleChildWidget>[
      ChangeNotifierProvider<LocaleController>.value(value: locale),
      ChangeNotifierProvider<SettingsController>.value(
        value: SettingsController(preferences),
      ),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
      ChangeNotifierProvider<ChordsController>.value(value: chordsController),
      ChangeNotifierProvider<ChordDetailController>.value(
        value: ChordDetailController(chords, audio, preferences),
      ),
      ChangeNotifierProvider<LearnController>.value(value: learn),
      ChangeNotifierProvider<GameController>.value(value: game),
      ChangeNotifierProvider<LiveController>.value(
        value: LiveController(audio, chords),
      ),
    ];

    // Tamaños representativos de móvil (del más pequeño al grande).
    const List<Size> phoneSizes = <Size>[
      Size(320, 480),
      Size(360, 640),
      Size(412, 915),
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
      await _visit(tester, kLivePath, expectText: 'En vivo', size: size);
      await _visit(tester, kSettingsPath, expectText: 'Ajustes', size: size);
    }
  });
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
