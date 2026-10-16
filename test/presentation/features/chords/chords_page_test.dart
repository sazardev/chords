import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/services/chord_sorter.dart';
import 'package:chords/presentation/widgets/molecules/chord_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

/// Biblioteca de acordes: búsqueda, orden, selector rápido y filtros.
void main() {
  /// Nombres de los acordes visibles, en orden.
  List<String> shown(WidgetTester tester) => <String>[
    for (final Element e in find.byType(ChordCard).evaluate())
      (e.widget as ChordCard).chord.name,
  ];

  Future<AppHarness> openLibrary(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    final AppHarness harness = await AppHarness.create(tester);
    await harness.pump(tester, size: size);
    await harness.go(tester, kChordsPath);
    return harness;
  }

  Future<void> search(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField).first, text);
    await tester.pumpAndSettle();
  }

  testWidgets('busca por cifrado, nombre en español y notas', (
    WidgetTester tester,
  ) async {
    final AppHarness harness = await openLibrary(tester);
    await search(tester, 'Re menor 7');
    expect(shown(tester).first, 'Dm7');
    expect(harness.chordsController.visibleChords.first.id, 'D-m7');

    await search(tester, 'Cmaj7');
    expect(shown(tester).first, 'Cmaj7');

    await search(tester, 'C E G');
    expect(shown(tester).first, 'C');

    await search(tester, 'F#m7b5');
    expect(shown(tester).first, 'F#m7b5');

    await search(tester, 'zzzz');
    expect(find.byType(ChordCard), findsNothing);
    expect(find.textContaining('Prueba con Cm7'), findsOneWidget);
    // Deja disparar el temporizador de analíticas de la búsqueda.
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('ordena por nota y agrupa con encabezados', (
    WidgetTester tester,
  ) async {
    final AppHarness harness = await openLibrary(tester);
    await tester.tap(find.byTooltip('Ordenar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Por nota (Do, Re, Mi…)'));
    await tester.pumpAndSettle();
    expect(harness.filters.sort, ChordSort.root);
    expect(find.text('Do'), findsOneWidget);
    expect(shown(tester).first, 'C');

    await tester.tap(find.byTooltip('Ordenar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Por tipo de acorde'));
    await tester.pumpAndSettle();
    expect(find.text('Mayor'), findsWidgets);
    expect(shown(tester).take(3), <String>['C', 'C#', 'D']);

    await tester.tap(find.byTooltip('Ordenar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Más fáciles primero'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    final List<Chord> visible = harness.chordsController.visibleChords;
    for (int i = 1; i < visible.length; i++) {
      expect(
        visible[i].difficulty.level,
        greaterThanOrEqualTo(visible[i - 1].difficulty.level),
      );
    }
  });

  testWidgets('el selector rápido elige nota y tipo y abre la ficha', (
    WidgetTester tester,
  ) async {
    final AppHarness harness = await openLibrary(tester);
    await tester.tap(find.byTooltip('Elegir nota y tipo'));
    await tester.pumpAndSettle();
    expect(find.text('Elegir nota y tipo'), findsWidgets);
    expect(find.text('Triadas'), findsOneWidget);
    expect(find.text('Extendidos'), findsOneWidget);
    expect(find.text('Alterados'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Mi'));
    await tester.pumpAndSettle();
    expect(harness.filters.filters.root, ChordRoot.e);
    expect(
      harness.chordsController.visibleChords.length,
      ChordQuality.values.length,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'm7'));
    await tester.pumpAndSettle();
    expect(harness.filters.filters.quality, ChordQuality.minorSeven);
    expect(harness.chordsController.visibleChords.single.id, 'E-m7');
    expect(find.text('Ver 1 acordes'), findsOneWidget);

    await tester.tap(find.text('Abrir ficha de Em7'));
    await tester.pumpAndSettle();
    expect(find.text('Em7'), findsWidgets);
    expect(find.text('Mi Séptima menor'), findsOneWidget);
  });

  testWidgets('la selección activa se ve con una cruz para quitarla', (
    WidgetTester tester,
  ) async {
    final AppHarness harness = await openLibrary(tester);
    harness.filters.selectRoot(ChordRoot.g);
    harness.filters.selectQuality(ChordQuality.sevenSharpNine);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(InputChip, 'Sol'), findsOneWidget);
    expect(
      find.widgetWithText(InputChip, 'Séptima con novena aumentada'),
      findsOneWidget,
    );
    expect(shown(tester), <String>['G7#9']);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(InputChip, 'Sol'),
        matching: find.byIcon(Icons.clear),
      ),
    );
    await tester.pumpAndSettle();
    expect(harness.filters.filters.root, isNull);
    expect(harness.chordsController.visibleChords.length, 12);
  });

  testWidgets('los filtros agrupan los tipos de acorde por familias', (
    WidgetTester tester,
  ) async {
    final AppHarness harness = await openLibrary(tester);
    await tester.tap(find.byTooltip('Filtros'));
    await tester.pumpAndSettle();
    for (final String family in <String>[
      'Triadas',
      'Quintas',
      'Sextas',
      'Séptimas',
      'Extendidos',
      'Suspendidos y añadidos',
      'Alterados',
    ]) {
      await tester.dragUntilVisible(
        find.text(family),
        find.byType(SingleChildScrollView).last,
        const Offset(0, -150),
      );
      expect(find.text(family), findsOneWidget);
    }
    await tester.dragUntilVisible(
      find.widgetWithText(FilterChip, 'Semidisminuido'),
      find.byType(SingleChildScrollView).last,
      const Offset(0, 150),
    );
    await tester.tap(find.widgetWithText(FilterChip, 'Semidisminuido'));
    await tester.pumpAndSettle();
    expect(harness.filters.filters.quality, ChordQuality.halfDiminished);
  });

  for (final Size size in <Size>[
    const Size(320, 480),
    const Size(412, 915),
    const Size(1024, 768),
  ]) {
    testWidgets('se ve entera en ${size.width.toInt()}x${size.height.toInt()}, '
        'en oscuro y para zurdos', (WidgetTester tester) async {
      final AppHarness harness = await AppHarness.create(tester);
      await harness.appearance.setThemeMode(ThemeMode.dark);
      await harness.settings.setMirrorChords(value: true);
      await harness.pump(tester, size: size);
      await harness.go(tester, kChordsPath);
      for (final ChordSort sort in ChordSort.values) {
        harness.filters.setSort(sort);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$sort $size');
        expect(find.byType(ChordCard), findsWidgets);
      }
      await tester.tap(find.byTooltip('Elegir nota y tipo'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'selector $size');
    });
  }
}
