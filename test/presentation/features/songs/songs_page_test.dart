import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/songs/song_page.dart';
import 'package:chords/presentation/features/songs/songs_page.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';

/// El cancionero ampliado: búsqueda, filtros por género y ficha de canción.
void main() {
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.es));

  Future<void> pump(WidgetTester tester, Widget page) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    final StudioProgressController progress = StudioProgressController(
      preferences,
    );
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<StudioProgressController>.value(
              value: progress,
            ),
            ChangeNotifierProvider<JamController>.value(
              value: JamController(
                FakeAudioRepository(),
                loadChordBank(),
                progress,
                settings: BandSettingsController(preferences),
              ),
            ),
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(preferences),
            ),
          ],
          child: MaterialApp(home: page),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('la búsqueda encuentra canciones nuevas por título', (
    WidgetTester tester,
  ) async {
    await pump(tester, const SongsPage());

    await tester.enterText(find.byType(TextField), 'Adelita');
    await tester.pumpAndSettle();
    expect(find.text('La Adelita'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Scarborough');
    await tester.pumpAndSettle();
    expect(find.text('Scarborough Fair'), findsOneWidget);
    expect(find.text('La Adelita'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.text('Ninguna canción coincide'), findsOneWidget);
  });

  testWidgets('los chips de género incluyen los estilos nuevos y filtran', (
    WidgetTester tester,
  ) async {
    await pump(tester, const SongsPage());

    final Finder cumbia = find.text('🥁 Cumbia');
    await tester.ensureVisible(cumbia);
    await tester.tap(cumbia);
    await tester.pumpAndSettle();

    expect(find.text('Cumbia en La menor'), findsOneWidget);
    expect(find.text('La Adelita'), findsNothing);
  });

  testWidgets('la ficha de una canción nueva muestra letra y acordes', (
    WidgetTester tester,
  ) async {
    expect(songById('golondrina'), isNotNull);
    await pump(tester, const SongPage(songId: 'golondrina'));

    expect(find.text('La golondrina'), findsWidgets);
    expect(find.text('Tocar en el jam'), findsOneWidget);
    expect(find.textContaining('A dónde irá'), findsWidgets);
  });

  testWidgets('la ficha de un ejercicio muestra su rasgueo nuevo', (
    WidgetTester tester,
  ) async {
    await pump(tester, const SongPage(songId: 'discoInAm'));

    expect(find.text('Disco en La menor'), findsWidgets);
    expect(find.text('✕'), findsWidgets);
  });
}
