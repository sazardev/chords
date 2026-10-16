import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/features/theory/lesson_page.dart';
import 'package:chords/presentation/features/theory/theory_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// La escuela de guitarra ampliada: índice por bloques y lecciones nuevas.
void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.es));

  late StudioProgressController progress;
  late SettingsController settings;

  Future<void> pump(WidgetTester tester, Widget page) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    progress = StudioProgressController(preferences);
    settings = SettingsController(preferences);
    tester.view.physicalSize = const Size(900, 9000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<StudioProgressController>.value(
              value: progress,
            ),
            ChangeNotifierProvider<SettingsController>.value(value: settings),
          ],
          child: MaterialApp(home: page),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('el índice agrupa las lecciones en cuatro bloques', (
    WidgetTester tester,
  ) async {
    await pump(tester, const TheoryPage());

    final Translations t = AppLocale.es.buildSync();
    for (final String unit in <String>[
      t.theory.unitBasics,
      t.theory.unitScales,
      t.theory.unitHarmony,
      t.theory.unitTechnique,
    ]) {
      expect(find.text(unit), findsOneWidget, reason: unit);
    }
    expect(
      find.text('0 de ${kTheoryLessons.length} lecciones aprendidas'),
      findsOneWidget,
    );
    expect(find.text('Cómo se construye un acorde'), findsOneWidget);
    expect(find.text('Afinaciones alternativas'), findsOneWidget);
  });

  testWidgets('cada lección nueva se abre con ideas clave y práctica', (
    WidgetTester tester,
  ) async {
    final Translations t = AppLocale.es.buildSync();
    for (final String id in <String>[
      'intervalSongs',
      'subdivision',
      'modesPractical',
      'triads',
      'extensions',
      'inversions',
      'circleFifths',
      'cadences',
      'relativeParallel',
      'transposeCapo',
      'styleComping',
      'tunings',
    ]) {
      await pump(tester, LessonPage(lessonId: id));
      expect(find.text(t.theory.lessonTitles[id]!), findsWidgets, reason: id);
      expect(find.text('Ideas clave'), findsOneWidget, reason: id);
      expect(find.byType(FilledButton), findsAtLeastNWidgets(2), reason: id);
      expect(tester.takeException(), isNull, reason: id);
    }
  });

  testWidgets('se puede marcar una lección nueva como aprendida', (
    WidgetTester tester,
  ) async {
    await pump(tester, const LessonPage(lessonId: 'cadences'));

    await tester.ensureVisible(find.text('Marcar como aprendida'));
    await tester.tap(find.text('Marcar como aprendida'));
    await tester.pumpAndSettle();

    expect(progress.completedLessons, contains('cadences'));
    expect(find.text('Aprendida'), findsOneWidget);
  });
}
