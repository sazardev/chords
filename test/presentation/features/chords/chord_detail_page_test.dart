import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../support/app_harness.dart';

/// Ficha de acorde: notas, fórmula, variantes, parientes, uso y escala.
void main() {
  /// Desplaza la ficha hasta que [finder] se vea.
  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.dragUntilVisible(
      finder,
      find.byType(ListView).last,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
  }

  Future<AppHarness> openDetail(
    WidgetTester tester,
    String id, {
    Size size = const Size(390, 844),
  }) async {
    final AppHarness harness = await AppHarness.create(tester);
    await harness.pump(tester, size: size);
    await harness.go(tester, '$kChordDetailPath?id=${Uri.encodeComponent(id)}');
    return harness;
  }

  testWidgets('muestra las notas con su grado y la fórmula del acorde', (
    WidgetTester tester,
  ) async {
    await openDetail(tester, 'C-7');
    await reveal(tester, find.text('Notas y fórmula'));
    expect(find.text('Notas y fórmula'), findsOneWidget);
    // Las cuatro notas del Do7 con su grado.
    for (final String degree in <String>['1', '3', '5', 'b7']) {
      expect(find.text(degree), findsWidgets, reason: degree);
    }
    expect(find.text('Do'), findsWidgets);
    expect(find.text('Mi'), findsWidgets);
    expect(find.text('Sol'), findsWidgets);
    expect(find.text('La♯'), findsWidgets);
    expect(find.text('Fórmula: 1  3  5  b7'), findsOneWidget);
    // Descripción de la calidad y tonalidades en las que está.
    expect(find.textContaining('Blues y funk'), findsOneWidget);
    expect(find.text('En qué tonalidades está'), findsOneWidget);
    expect(find.text('V7 en Fa mayor'), findsOneWidget);
  });

  testWidgets('filtra las posiciones por tipo', (WidgetTester tester) async {
    final AppHarness harness = await openDetail(tester, 'C-maj');
    await reveal(tester, find.text('Variantes de este acorde'));
    final ChordDetailController controller = tester
        .element(find.text('Variantes de este acorde'))
        .read<ChordDetailController>();
    final int total = controller.chord!.variantCount;
    expect(find.text('Posiciones ($total)'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Abierta'));
    await tester.pumpAndSettle();
    final int open = controller.extras!.visibleIndices.length;
    expect(open, lessThan(total));
    expect(open, greaterThan(0));
    expect(find.text('Forma de Do'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pumpAndSettle();
    expect(controller.extras!.visibleIndices.length, total);
    expect(harness.chords.isLoaded, isTrue);
  });

  testWidgets('los parientes saltan a la ficha de otro acorde', (
    WidgetTester tester,
  ) async {
    final AppHarness harness = await AppHarness.create(tester);
    await harness.pump(tester);
    await harness.go(tester, kChordsPath);
    unawaited(harness.router(tester).push('$kChordDetailPath?id=C-maj'));
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Acordes parientes'));
    expect(find.text('Acordes parientes'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Relativo: Am'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Cm7'), findsOneWidget);

    await tester.tap(find.widgetWithText(ActionChip, 'Cm7'));
    await tester.pumpAndSettle();
    expect(find.text('Do Séptima menor'), findsOneWidget);

    // Atrás vuelve a la biblioteca, no a la ficha anterior.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('cuenta dónde se usa y qué escala tocar encima', (
    WidgetTester tester,
  ) async {
    await openDetail(tester, 'A-m7');
    await reveal(tester, find.text('Dónde se usa'));
    expect(find.text('Dónde se usa'), findsOneWidget);
    expect(find.text('Géneros'), findsOneWidget);
    expect(find.text('Jazz'), findsWidgets);
    expect(find.text('Escala para improvisar'), findsOneWidget);
    expect(
      find.textContaining('Sobre Am7 suena bien: La dórica'),
      findsOneWidget,
    );
    expect(find.textContaining('También: pentatónica menor'), findsOneWidget);
  });

  testWidgets('un acorde de jazz sin progresión lo dice', (
    WidgetTester tester,
  ) async {
    await openDetail(tester, 'C-7s11');
    await reveal(tester, find.text('Dónde se usa'));
    expect(
      find.text('Todavía no está en ninguna progresión del catálogo.'),
      findsOneWidget,
    );
    expect(find.textContaining('lidia dominante'), findsWidgets);
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
      for (final String id in <String>['C-maj', 'F#-m7b5', 'A#-13', 'E-sus2']) {
        await harness.go(
          tester,
          '$kChordDetailPath?id=${Uri.encodeComponent(id)}',
        );
        for (final String section in <String>[
          'Notas y fórmula',
          'Arpegios',
          'Variantes de este acorde',
          'Acordes parientes',
          'Dónde se usa',
        ]) {
          await reveal(tester, find.text(section));
          expect(find.text(section), findsOneWidget, reason: '$id $size');
        }
        expect(tester.takeException(), isNull, reason: '$id $size');
      }
    });
  }
}
