import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/presentation/features/theory/scale_explorer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../support/app_harness.dart';

/// Explorador de escalas: selector por familias, fórmula, posiciones y
/// acordes de la escala.
void main() {
  Future<AppHarness> openScale(
    WidgetTester tester,
    String query, {
    Size size = const Size(390, 844),
  }) async {
    final AppHarness harness = await AppHarness.create(tester);
    await harness.pump(tester, size: size);
    await harness.go(tester, '$kScalesPath?$query');
    return harness;
  }

  ScaleExplorerController controllerOf(WidgetTester tester) => tester
      .element(find.text('Explorador de escalas'))
      .read<ScaleExplorerController>();

  /// Baja la pantalla hasta que [finder] se vea.
  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.dragUntilVisible(
      finder,
      find.byType(ListView).last,
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('enseña la escala, su fórmula, carácter y estilos', (
    WidgetTester tester,
  ) async {
    await openScale(tester, 'scale=phrygianDominant&key=4&pos=2');
    expect(find.text('Mi frigia dominante'), findsWidgets);
    expect(find.text('Fórmula: 1 b2 3 4 5 b6 b7'), findsOneWidget);
    expect(find.textContaining('flamenco'), findsWidgets);
    expect(find.text('Nota característica: 3'), findsOneWidget);
    expect(find.text('Dónde se usa'), findsOneWidget);
    expect(
      find.textContaining('7 posiciones de tres notas por cuerda'),
      findsOneWidget,
    );
    expect(controllerOf(tester).position, 2);
  });

  testWidgets('agrupa las escalas en cuatro familias', (
    WidgetTester tester,
  ) async {
    await openScale(tester, 'scale=major&key=0');
    expect(find.widgetWithText(ChoiceChip, 'Dórica'), findsNothing);
    await tester.tap(find.byIcon(Icons.unfold_more_rounded));
    await tester.pumpAndSettle();
    for (final String group in <String>[
      'Mayor y modos',
      'Menores',
      'Pentatónicas y blues',
      'Exóticas y simétricas',
    ]) {
      expect(find.widgetWithText(ChoiceChip, group), findsOneWidget);
    }
    // El bloque de la mayor muestra sus siete modos y no las demás.
    expect(find.widgetWithText(ChoiceChip, 'Dórica'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Locria'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Menor armónica'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Menores'));
    await tester.pumpAndSettle();
    expect(find.text('Modos de la menor armónica'), findsOneWidget);
    expect(find.text('Modos de la menor melódica'), findsOneWidget);
    expect(
      find.widgetWithText(ChoiceChip, 'Alterada (superlocria)'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(ChoiceChip, 'Menor melódica'));
    await tester.pumpAndSettle();
    expect(controllerOf(tester).scale, ScaleType.melodicMinor);

    await tester.tap(find.byIcon(Icons.unfold_more_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Exóticas y simétricas'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Tonos enteros'));
    await tester.pumpAndSettle();
    expect(controllerOf(tester).scale, ScaleType.wholeTone);
    expect(
      find.text('6 ventanas de trastes (escala simétrica)'),
      findsOneWidget,
    );
  });

  testWidgets('muestra los acordes diatónicos: tríadas y séptimas', (
    WidgetTester tester,
  ) async {
    await openScale(tester, 'scale=harmonicMinor&key=9');
    await reveal(tester, find.text('Acordes de la escala'));
    expect(find.text('Tríadas'), findsOneWidget);
    expect(find.text('Séptimas'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Am'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Caug'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'AmMaj7'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'E7'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'G#dim7'), findsOneWidget);

    await tester.tap(find.widgetWithText(ActionChip, 'E7'));
    await tester.pumpAndSettle();
    expect(find.text('Mi Séptima de dominante'), findsOneWidget);
  });

  testWidgets('las escalas que no son de siete notas lo explican', (
    WidgetTester tester,
  ) async {
    await openScale(tester, 'scale=hirajoshi&key=2');
    await reveal(tester, find.text('Acordes de la escala'));
    expect(find.textContaining('Con 5 notas no forma acordes'), findsOneWidget);
    expect(find.text('Séptimas'), findsNothing);
  });

  testWidgets('elige posición y suena de subida y bajada', (
    WidgetTester tester,
  ) async {
    await openScale(tester, 'scale=diminishedWholeHalf&key=0');
    expect(controllerOf(tester).positionCount, 8);
    await reveal(tester, find.widgetWithText(ChoiceChip, '5'));
    await tester.tap(find.widgetWithText(ChoiceChip, '5'));
    await tester.pumpAndSettle();
    expect(controllerOf(tester).position, 5);

    await tester.tap(find.text('Escuchar'));
    await tester.pump();
    expect(find.text('Parar'), findsOneWidget);
    await tester.tap(find.text('Parar'));
    await tester.pumpAndSettle();
    expect(find.text('Escuchar'), findsOneWidget);
  });

  for (final Size size in <Size>[
    const Size(320, 480),
    const Size(412, 915),
    const Size(1024, 768),
  ]) {
    testWidgets('todas las escalas caben en ${size.width.toInt()}x'
        '${size.height.toInt()}, en oscuro y para zurdos', (
      WidgetTester tester,
    ) async {
      final AppHarness harness = await AppHarness.create(tester);
      await harness.appearance.setThemeMode(ThemeMode.dark);
      await harness.settings.setMirrorChords(value: true);
      await harness.pump(tester, size: size);
      for (final ScaleType scale in ScaleType.values) {
        await harness.go(
          tester,
          '$kScalesPath?scale=${scale.id}&key=${scale.index % 12}&pos=1',
        );
        expect(tester.takeException(), isNull, reason: '${scale.id} $size');
      }
    });
  }
}
