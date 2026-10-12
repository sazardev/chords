import 'package:chords/data/chords/repositories/chord_repository_impl.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chord_filters_sheet.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Tests de la hoja de filtros avanzados de la biblioteca.
void main() {
  testWidgets('filtra por tipo y muestra el recuento al vuelo', (
    WidgetTester tester,
  ) async {
    final ChordRepository repository = ChordRepositoryImpl();
    final ChordFilterController filters = ChordFilterController();
    final ChordsController chords = ChordsController(
      repository,
      const SearchChordsUseCase(),
      filters,
    );
    await tester.runAsync(chords.load);
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<ChordFilterController>.value(value: filters),
            ChangeNotifierProvider<ChordsController>.value(value: chords),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Builder(
              builder: (BuildContext context) => Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () => showChordFiltersSheet(context),
                    child: const Text('abrir'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Filtros'), findsOneWidget);
    final int total = chords.visibleChords.length;
    expect(find.textContaining('$total acordes'), findsOneWidget);

    await tester.tap(find.text('Menor').first);
    await tester.pumpAndSettle();
    expect(filters.filters.quality, ChordQuality.minor);
    expect(chords.visibleChords.length, lessThan(total));
    expect(
      find.textContaining('${chords.visibleChords.length} acordes'),
      findsOneWidget,
    );

    await tester.tap(find.text('Restablecer'));
    await tester.pumpAndSettle();
    expect(filters.filters.isEmpty, isTrue);

    await tester.tap(find.textContaining('Ver resultados'));
    await tester.pumpAndSettle();
    expect(find.text('Filtros'), findsNothing);
  });
}
