import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/theory/genre_page.dart';
import 'package:chords/presentation/features/theory/genres_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guía de géneros: 27 estilos agrupados por familia, con búsqueda, y la
/// ficha con la descripción y la animación del rasgueo.
void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.es));

  Future<void> pump(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(900, 12000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(child: MaterialApp(home: page)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('la guía lista los 27 géneros en cuatro familias', (
    WidgetTester tester,
  ) async {
    await pump(tester, const GenresPage());

    expect(find.byIcon(Icons.chevron_right_rounded), findsNWidgets(27));
    for (final String family in <String>[
      'Raíces y ritmos latinos',
      'Rock y metal',
      'Blues, jazz y soul',
      'Pop y baile',
    ]) {
      expect(find.text(family), findsOneWidget, reason: family);
    }
    for (final String name in <String>[
      'Cumbia',
      'Salsa',
      'Ranchera',
      'Flamenco',
      'Disco',
      'Ska',
      'Indie',
      'Grunge',
      'Reggaetón',
      'Lo-fi',
      'Tango',
      'Bolero',
    ]) {
      expect(find.text(name), findsOneWidget, reason: name);
    }
  });

  testWidgets('la búsqueda filtra por nombre y oculta las familias vacías', (
    WidgetTester tester,
  ) async {
    await pump(tester, const GenresPage());

    await tester.enterText(find.byType(TextField), 'cumb');
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    expect(find.text('Cumbia'), findsOneWidget);
    expect(find.text('Raíces y ritmos latinos'), findsOneWidget);
    expect(find.text('Rock y metal'), findsNothing);

    await tester.enterText(find.byType(TextField), 'Am');
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.chevron_right_rounded), findsWidgets);

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('Ningún género coincide con tu búsqueda'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
  });

  testWidgets('cada ficha de género nuevo se construye con su rasgueo', (
    WidgetTester tester,
  ) async {
    for (final String id in <String>[
      'cumbia',
      'salsa',
      'ranchera',
      'flamenco',
      'disco',
      'ska',
      'indie',
      'grunge',
      'reggaeton',
      'lofi',
      'tango',
      'bolero',
    ]) {
      final GenreGuide guide = genreGuideById(id)!;
      await pump(tester, GenrePage(genreId: id));
      expect(find.textContaining(guide.emoji), findsWidgets, reason: id);
      expect(find.text('Ver el rasgueo en movimiento'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: id);
    }
  });

  testWidgets('el rasgueo se anima hueco a hueco y se puede detener', (
    WidgetTester tester,
  ) async {
    await pump(tester, const GenrePage(genreId: 'reggaeton'));

    expect(find.textContaining('Rasgueo: Reggaetón (dembow)'), findsOneWidget);
    await tester.tap(find.text('Ver el rasgueo en movimiento'));
    await tester.pump();
    expect(find.text('Detener'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Detener'), findsOneWidget);

    await tester.tap(find.text('Detener'));
    await tester.pump();
    expect(find.text('Ver el rasgueo en movimiento'), findsOneWidget);
  });

  testWidgets('el golpe apagado se dibuja con ✕ y se explica', (
    WidgetTester tester,
  ) async {
    await pump(tester, const GenrePage(genreId: 'flamenco'));

    expect(find.text('✕'), findsOneWidget);
    expect(find.text('✕ = golpe apagado (percusivo)'), findsOneWidget);
  });

  testWidgets('un género desconocido muestra el error de ruta', (
    WidgetTester tester,
  ) async {
    await pump(tester, const GenrePage(genreId: 'no-existe'));

    expect(find.textContaining('genre:no-existe'), findsOneWidget);
  });
}
