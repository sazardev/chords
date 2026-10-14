import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/home/home_page.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests del dashboard de inicio.
void main() {
  late ProfileController profile;
  late LearnController learn;

  Future<void> pumpHome(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    final SettingsController settings = SettingsController(preferences);
    profile = ProfileController(preferences, settings)..load();
    final ChordRepository repository = ChordRepositoryImpl();
    final ChordsController chords = ChordsController(
      repository,
      const SearchChordsUseCase(),
      ChordFilterController(),
    );
    learn = LearnController(repository, preferences);
    await tester.runAsync(() async {
      await chords.load();
      await learn.load();
    });
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<ChordsController>.value(value: chords),
            ChangeNotifierProvider<LearnController>.value(value: learn),
            ChangeNotifierProvider<ProfileController>.value(value: profile),
            ChangeNotifierProvider<SettingsController>.value(value: settings),
            ChangeNotifierProvider<GameScoreController>.value(
              value: GameScoreController(preferences),
            ),
            ChangeNotifierProvider<StudioProgressController>.value(
              value: StudioProgressController(preferences),
            ),
          ],
          child: MaterialApp(theme: buildLightTheme(), home: const HomePage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('muestra saludo, siguiente acorde, recomendaciones y accesos', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);

    expect(find.text('¿Qué tocas hoy?'), findsOneWidget);
    expect(find.text('Tu siguiente acorde'), findsOneWidget);
    expect(find.text('Practicar'), findsOneWidget);
    expect(find.text('Para ti'), findsOneWidget);
    expect(find.text('Herramientas'), findsOneWidget);
    expect(find.text('Afinar'), findsOneWidget);
    expect(find.text('Biblioteca de acordes'), findsOneWidget);
    expect(find.text('Dominados'), findsOneWidget);
  });

  testWidgets('sin perfil invita a completarlo', (WidgetTester tester) async {
    await pumpHome(tester);

    expect(find.text('Cuéntame cómo tocas y personalizo todo'), findsOneWidget);
  });

  testWidgets('la experiencia cambia por dónde empieza el itinerario', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester);
    final Chord beginnerNext = _chordById(learn, learn.nextChordId!);
    expect(LearningLevel.of(beginnerNext).level, 1);

    profile.setExperience(ExperienceLevel.advanced);
    await tester.pumpAndSettle();

    final String advancedId = learn.nextChordIdFrom(4)!;
    expect(LearningLevel.of(_chordById(learn, advancedId)).level, 4);
    expect(find.text(_chordById(learn, advancedId).name), findsWidgets);
  });
}

Chord _chordById(LearnController learn, String id) => learn
    .chordsOfLevel(1)
    .followedBy(learn.chordsOfLevel(2))
    .followedBy(learn.chordsOfLevel(3))
    .followedBy(learn.chordsOfLevel(4))
    .followedBy(learn.chordsOfLevel(5))
    .firstWhere((Chord c) => c.id == id);
