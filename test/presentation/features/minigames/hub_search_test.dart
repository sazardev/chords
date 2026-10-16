import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/hub_filter.dart';
import 'package:chords/presentation/features/minigames/mini_game_card.dart';
import 'package:chords/presentation/features/minigames/mini_games_hub_page.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/mini_game_harness.dart';

/// El catálogo con 39 juegos: familias, buscador, chips de filtro, novedades
/// y recorrido con la guitarra sobre lo que deja ver el filtro.
void main() {
  late MiniGameHarness h;

  setUp(() async => h = await MiniGameHarness.create());

  Translations t(WidgetTester tester) =>
      Translations.of(tester.element(find.byType(MiniGamesHubPage)));

  Future<void> search(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
  }

  Future<void> chip(WidgetTester tester, String label) async {
    final Finder finder = find.widgetWithText(ChoiceChip, label);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('muestra las seis familias con su resumen y sus chips', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    for (final MiniGameCategory category in kHubCategoryOrder) {
      expect(
        find.widgetWithText(ChoiceChip, categoryTitle(t(tester), category)),
        findsOne,
        reason: category.name,
      );
    }
    expect(find.text('Todos'), findsOne);
    expect(find.text('Nuevos'), findsOne);
    expect(find.text('Acordes y variantes'), findsWidgets);
    expect(find.text('Progresiones y armonía'), findsWidgets);
    expect(find.text('11 juegos'), findsOne);
    expect(tester.takeException(), isNull);
  });

  testWidgets('las tarjetas nuevas llevan la marca de novedad', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    final int badges = find.byIcon(Icons.fiber_new_rounded).evaluate().length;
    expect(badges, 17);
    expect(
      find.byType(MiniGameCard),
      findsNWidgets(MiniGameKind.values.length),
    );
  });

  testWidgets('buscar deja solo los juegos que coinciden', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    await search(tester, 'caged');
    expect(find.text('Formas CAGED'), findsOne);
    expect(find.text('Adivina la nota'), findsNothing);
    expect(find.text('Toca el acorde'), findsNothing);
    expect(find.byType(MiniGameCard), findsNWidgets(1));
    await search(tester, '');
    expect(
      find.byType(MiniGameCard),
      findsNWidgets(MiniGameKind.values.length),
    );
  });

  testWidgets('buscar sin acierto muestra que no hay juegos', (
    WidgetTester tester,
  ) async {
    await h.pump(tester);
    await search(tester, 'zzzzzz');
    expect(find.text('Ningún juego coincide'), findsOne);
    expect(find.byType(MiniGameCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el chip de novedades solo enseña los juegos nuevos', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    await chip(tester, 'Nuevos');
    expect(find.byType(MiniGameCard), findsNWidgets(17));
    expect(find.text('Adivina la nota'), findsNothing);
    expect(find.text('Cambios de acorde'), findsOne);
    expect(find.text('Toca el acorde'), findsNothing);
    await chip(tester, 'Todos');
    expect(
      find.byType(MiniGameCard),
      findsNWidgets(MiniGameKind.values.length),
    );
  });

  testWidgets('un chip de familia filtra y se quita pulsándolo otra vez', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    await chip(tester, 'Progresiones y armonía');
    expect(find.byType(MiniGameCard), findsNWidgets(5));
    expect(find.text('Duelo de estilos'), findsOne);
    expect(find.text('Adivina la nota'), findsNothing);
    await chip(tester, 'Progresiones y armonía');
    expect(
      find.byType(MiniGameCard),
      findsNWidgets(MiniGameKind.values.length),
    );
  });

  testWidgets('la búsqueda y la familia se combinan', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    await chip(tester, 'Acordes y variantes');
    await search(tester, 'racha');
    expect(find.byType(MiniGameCard), findsNWidgets(3));
    expect(find.text('Racha: cejillas'), findsOne);
  });

  testWidgets('abrir un juego nuevo desde el catálogo muestra su guía', (
    WidgetTester tester,
  ) async {
    await h.pump(tester, size: const Size(412, 9000));
    await tester.tap(find.text('Fórmula del acorde'));
    await tester.pumpAndSettle();
    expect(find.text('Cómo se juega'), findsOne);
    expect(find.textContaining('1-3-5 es mayor'), findsOne);
  });

  testWidgets('con la guitarra solo se recorre lo que deja ver el filtro', (
    WidgetTester tester,
  ) async {
    await h.settings.setGuitarBrowse(value: true);
    await h.pump(tester, size: const Size(412, 9000));
    final Translations tr = t(tester);
    final int all = MiniGameKind.values.length + 1;
    expect(find.textContaining('1 de $all'), findsOne);

    await search(tester, 'racha');
    final int visible =
        filterGames(tr, const HubFilter(query: 'racha')).length +
        (showsChordGame(tr, const HubFilter(query: 'racha')) ? 1 : 0);
    expect(visible, greaterThan(0));
    expect(find.textContaining('1 de $visible'), findsOne);
    await h.settings.setGuitarBrowse(value: false);
    await tester.pumpAndSettle();
  });

  testWidgets('sin juegos visibles el panel de la guitarra se oculta', (
    WidgetTester tester,
  ) async {
    await h.settings.setGuitarBrowse(value: true);
    await h.pump(tester);
    await search(tester, 'zzzzzz');
    expect(find.text('Abrir'), findsNothing);
    expect(tester.takeException(), isNull);
    await h.settings.setGuitarBrowse(value: false);
    await tester.pumpAndSettle();
  });

  for (final Size size in const <Size>[
    Size(320, 480),
    Size(360, 640),
    Size(412, 915),
    Size(800, 1280),
  ]) {
    testWidgets('el catálogo cabe a ${size.width}x${size.height}', (
      WidgetTester tester,
    ) async {
      await h.pump(tester, size: size);
      expect(tester.takeException(), isNull);
      await search(tester, 'acorde');
      expect(tester.takeException(), isNull);
      await chip(tester, 'Nuevos');
      expect(tester.takeException(), isNull);
    });
  }
}
