import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_page.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del onboarding con las preguntas de perfil.
void main() {
  late PreferencesService preferences;
  late OnboardingController onboarding;
  late ProfileController profile;
  late SettingsController settings;

  Future<void> pumpOnboarding(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    onboarding = OnboardingController(preferences)..load();
    settings = SettingsController(preferences);
    profile = ProfileController(preferences, settings)..load();
    final ChordRepository repository = ChordRepositoryImpl();
    final ChordsController chords = ChordsController(
      repository,
      const SearchChordsUseCase(),
      ChordFilterController(),
    );
    await tester.runAsync(chords.load);
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<OnboardingController>.value(
              value: onboarding,
            ),
            ChangeNotifierProvider<ProfileController>.value(value: profile),
            ChangeNotifierProvider<SettingsController>.value(value: settings),
            ChangeNotifierProvider<ChordsController>.value(value: chords),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const OnboardingPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> next(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('recorre las preguntas y guarda el perfil elegido', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);
    expect(find.text('Tu guitarra, a tu medida'), findsOneWidget);

    await next(tester, 'Empezar');
    expect(find.text('¿Qué guitarra tocas?'), findsOneWidget);
    await tester.tap(find.text('Eléctrica'));
    await tester.pumpAndSettle();
    await next(tester, 'Continuar');

    expect(find.text('¿Cómo la tocas?'), findsOneWidget);
    await tester.tap(find.text('Zurdo'));
    await tester.pumpAndSettle();
    await next(tester, 'Continuar');

    expect(find.text('¿Qué música te gusta?'), findsOneWidget);
    await tester.tap(find.text('Rock'));
    await tester.pumpAndSettle();
    await next(tester, 'Continuar');

    expect(find.text('¿Cuánta experiencia tienes?'), findsOneWidget);
    await tester.tap(find.text('Toco con soltura'));
    await tester.pumpAndSettle();
    await next(tester, 'Continuar');

    expect(find.text('Tu guitarra también es el mando'), findsOneWidget);
    expect(settings.guitarBrowse, isFalse);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(settings.guitarBrowse, isTrue);
    await next(tester, 'Continuar');

    expect(find.text('Tu plan está listo'), findsOneWidget);
    expect(find.text('Empezar a tocar'), findsOneWidget);

    expect(profile.profile.guitar, GuitarType.electric);
    expect(profile.profile.hand, PlayingHand.left);
    expect(profile.profile.genres, <String>{'Rock'});
    expect(profile.profile.experience, ExperienceLevel.advanced);
    expect(settings.mirrorChords, isTrue);

    await next(tester, 'Empezar a tocar');
    expect(onboarding.isPending, isFalse);
    expect(profile.profile.personalized, isTrue);
  });

  testWidgets('Omitir cierra el onboarding sin personalizar', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);

    await tester.tap(find.text('Omitir'));
    await tester.pumpAndSettle();

    expect(onboarding.isPending, isFalse);
    expect(profile.profile.personalized, isFalse);
  });

  testWidgets('se puede volver atrás entre los pasos', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);
    await next(tester, 'Empezar');
    expect(find.text('¿Qué guitarra tocas?'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Atrás'));
    await tester.pumpAndSettle();

    expect(find.text('Tu guitarra, a tu medida'), findsOneWidget);
  });

  testWidgets('el paso de la guitarra enseña qué nota elige cada opción', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);
    await next(tester, 'Empezar');
    for (int i = 0; i < 4; i++) {
      await next(tester, 'Continuar');
    }
    expect(find.text('Tu guitarra también es el mando'), findsOneWidget);
    expect(find.textContaining('traste 14 o más'), findsOneWidget);
    expect(find.textContaining('Mi · al aire → Inicio'), findsOneWidget);

    await tester.tap(find.text('Acordes'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Fa♯ · traste 2 → Acordes'), findsOneWidget);
    expect(settings.guitarBrowse, isFalse, reason: 'ver no enciende nada');
  });

  testWidgets('el paso de la guitarra cabe en un móvil pequeño', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);
    tester.view.physicalSize = const Size(640, 1136);
    await tester.pumpAndSettle();
    await next(tester, 'Empezar');
    for (int i = 0; i < 4; i++) {
      expect(tester.takeException(), isNull, reason: 'paso $i');
      await next(tester, 'Continuar');
    }
    expect(find.text('Tu guitarra también es el mando'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'paso de la guitarra');
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
