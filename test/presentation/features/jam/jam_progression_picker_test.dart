import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_progression_picker.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests del selector de progresiones del jam (género primero).
void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.es));

  Future<void> pump(
    WidgetTester tester,
    JamSelection selection,
    ValueChanged<JamSelection> onChanged,
  ) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: JamProgressionPicker(
                selection: selection,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hay un chip por género y el del género actual está elegido', (
    WidgetTester tester,
  ) async {
    await pump(tester, const JamSelection(), (_) {});

    for (final GenreGuide guide in kGenreGuides) {
      expect(
        find.textContaining(guide.emoji, skipOffstage: false),
        findsWidgets,
        reason: guide.id,
      );
    }
    final ChoiceChip selected = tester
        .widgetList<ChoiceChip>(find.byType(ChoiceChip, skipOffstage: false))
        .firstWhere(
          (ChoiceChip chip) =>
              chip.selected && (chip.label as Text).data!.contains('Pop'),
        );
    expect(selected.selected, isTrue);
  });

  testWidgets('elegir un género salta a su primera progresión', (
    WidgetTester tester,
  ) async {
    JamSelection? changed;
    await pump(tester, const JamSelection(), (JamSelection s) => changed = s);

    final Finder blues = find.textContaining('Blues', skipOffstage: false);
    await tester.ensureVisible(blues.first);
    await tester.pumpAndSettle();
    await tester.tap(blues.first);
    await tester.pumpAndSettle();

    expect(changed, isNotNull);
    expect(changed!.progression.genre, 'blues');
    expect(changed!.progressionId, progressionsOf('blues').first.id);
  });

  testWidgets('la lista solo ofrece las progresiones del género', (
    WidgetTester tester,
  ) async {
    await pump(tester, const JamSelection(), (_) {});

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    final int items = find
        .byType(DropdownMenuItem<String>, skipOffstage: false)
        .evaluate()
        .length;
    // Cada elemento aparece en el botón y en el menú desplegado.
    expect(items, greaterThanOrEqualTo(progressionsOf('pop').length));
    expect(items, lessThan(kProgressions.length));
    expect(kGenreGuides.length, 27);
  });
}
