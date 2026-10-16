import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_band_panel.dart';
import 'package:chords/presentation/features/jam/memory_band_preferences.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// El panel "Banda" de la preparación del jam.
void main() {
  late BandSettingsController settings;

  Future<void> pumpPanel(
    WidgetTester tester, {
    bool scoreMode = false,
    Size size = const Size(320, 3000),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settings = BandSettingsController(MemoryBandPreferences());
    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider<BandSettingsController>.value(
          value: settings,
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: JamBandPanel(scoreMode: scoreMode),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> expandAll(WidgetTester tester, List<String> titles) async {
    for (final String title in titles) {
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
    }
  }

  tearDown(() => LocaleSettings.setLocaleSync(AppLocale.es));

  for (final AppLocale locale in AppLocale.values) {
    testWidgets('cabe en 320 px con todo desplegado (${locale.languageCode})', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocaleSync(locale);
      await pumpPanel(tester);
      final Translations t = locale.buildSync();
      await expandAll(tester, <String>[
        t.jamBand.instruments,
        t.jamBand.feel,
        t.jamBand.structure,
      ]);
      settings.set(settings.config.copyWith(swing: (value: 0.5)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(t.jamBand.title), findsOneWidget);
      expect(find.text(t.jamBand.mixer), findsOneWidget);
      for (final BandMode mode in BandMode.values) {
        expect(find.text(t.jamBand.modes[mode.name]!), findsOneWidget);
      }
      for (final BandChannel channel in BandChannel.values) {
        expect(find.text(t.jamBand.channels[channel.name]!), findsWidgets);
      }
    });
  }

  testWidgets('los atajos de modo encienden y apagan canales', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester);
    await tester.tap(find.text('Solo ritmo'));
    await tester.pump();
    expect(bandModeOf(settings.config), BandMode.rhythm);
    expect(settings.config.isOn(BandChannel.guitar), isFalse);
    expect(settings.config.isOn(BandChannel.bass), isTrue);
    expect(find.textContaining('toques tú encima'), findsOneWidget);
    await tester.tap(find.text('Solo clic'));
    await tester.pump();
    expect(settings.config.isOn(BandChannel.click), isTrue);
    expect(settings.config.isOn(BandChannel.drums), isFalse);
    await tester.tap(find.text('Sin guitarra'));
    await tester.pump();
    expect(bandModeOf(settings.config), BandMode.noGuitar);
    await tester.tap(find.text('Banda completa'));
    await tester.pump();
    expect(bandModeOf(settings.config), BandMode.fullBand);
    expect(settings.config.isOn(BandChannel.click), isFalse);
  });

  testWidgets('el mezclador silencia y regula cada instrumento', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester);
    final Finder mute = find.byKey(const ValueKey<String>('mute-drums'));
    await tester.tap(mute);
    await tester.pump();
    expect(settings.config.isOn(BandChannel.drums), isFalse);
    final Slider silenced = tester.widget<Slider>(
      find.byKey(const ValueKey<String>('volume-drums')),
    );
    expect(silenced.onChanged, isNull, reason: 'un canal mudo no se regula');
    await tester.tap(mute);
    await tester.pump();
    expect(settings.config.isOn(BandChannel.drums), isTrue);

    final double before = settings.config.mixOf(BandChannel.bass).volume;
    await tester.drag(
      find.byKey(const ValueKey<String>('volume-bass')),
      const Offset(-80, 0),
    );
    await tester.pump();
    expect(settings.config.mixOf(BandChannel.bass).volume, lessThan(before));
    final Slider bass = tester.widget<Slider>(
      find.byKey(const ValueKey<String>('volume-bass')),
    );
    expect(bass.semanticFormatterCallback!(0.5), 'Volumen de Bajo 50%');
  });

  testWidgets('estilo e instrumentos se eligen y vuelven a automático', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester);
    await expandAll(tester, <String>['Instrumentos']);

    await tester.tap(find.text('Según la pista'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salsa').last);
    await tester.pumpAndSettle();
    expect(settings.config.style, 'salsa');

    await tester.tap(find.text('Salsa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Según la pista').last);
    await tester.pumpAndSettle();
    expect(settings.config.style, isNull);

    await tester.tap(find.text('Según el estilo').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jazz (kit pequeño)').last);
    await tester.pumpAndSettle();
    expect(settings.config.kit, DrumKit.jazz);
    expect(find.text('Jazz (kit pequeño)'), findsOneWidget);
  });

  testWidgets('swing, humanización, intensidad y rellenos', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester);
    await expandAll(tester, <String>['Sensación']);
    expect(find.byKey(const ValueKey<String>('swing')), findsNothing);
    await tester.tap(find.text('Swing del estilo'));
    await tester.pumpAndSettle();
    expect(settings.config.swing, closeTo(0.5, 1e-9));
    expect(find.byKey(const ValueKey<String>('swing')), findsOneWidget);
    await tester.drag(
      find.byKey(const ValueKey<String>('swing')),
      const Offset(60, 0),
    );
    await tester.pump();
    expect(settings.config.swing, greaterThan(0.5));
    await tester.tap(find.text('Swing del estilo'));
    await tester.pumpAndSettle();
    expect(settings.config.swing, isNull);

    final double humanize = settings.config.humanize;
    await tester.drag(
      find.byKey(const ValueKey<String>('humanize')),
      const Offset(120, 0),
    );
    await tester.pump();
    expect(settings.config.humanize, greaterThan(humanize));

    await tester.tap(find.text('Fuerte'));
    await tester.pump();
    expect(settings.config.intensity, BandIntensity.strong);
    await tester.tap(find.text('Rellenos de batería'));
    await tester.pump();
    expect(settings.config.fills, isFalse);
  });

  testWidgets('cuenta atrás, vueltas y transposición con sus límites', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester);
    await expandAll(tester, <String>['Estructura']);
    await tester.tap(find.text('2 compases'));
    await tester.pump();
    expect(settings.config.countInBars, 2);
    await tester.tap(find.text('Sin'));
    await tester.pump();
    expect(settings.config.countInBars, 0);

    Finder tip(String text) => find.ancestor(
      of: find.byTooltip(text),
      matching: find.byType(IconButton),
    );
    await tester.tap(tip('Una vuelta más'));
    await tester.pump();
    expect(settings.config.loops, 5);
    for (int i = 0; i < 6; i++) {
      await tester.tap(tip('Una vuelta menos'));
      await tester.pump();
    }
    expect(settings.config.loops, 1);
    expect(
      tester.widget<IconButton>(tip('Una vuelta menos')).onPressed,
      isNull,
    );

    await tester.tap(tip('Subir un semitono'));
    await tester.pump();
    await tester.tap(tip('Subir un semitono'));
    await tester.pump();
    expect(settings.config.transpose, 2);
    expect(find.text('Transposición / capo: +2'), findsOneWidget);
    for (int i = 0; i < 9; i++) {
      await tester.tap(tip('Bajar un semitono'));
      await tester.pump();
    }
    expect(settings.config.transpose, -6);
    expect(
      tester.widget<IconButton>(tip('Bajar un semitono')).onPressed,
      isNull,
    );
  });

  testWidgets('los valores de fábrica se recuperan con un toque', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester);
    settings.set(settings.config.copyWith(loops: 7, transpose: 3, humanize: 1));
    await tester.pump();
    await tester.tap(find.byTooltip('Valores de fábrica'));
    await tester.pump();
    expect(settings.config, const BandConfig());
  });

  testWidgets('en modo puntuar avisa de que la banda calla', (
    WidgetTester tester,
  ) async {
    await pumpPanel(tester, scoreMode: true);
    expect(find.textContaining('la banda calla'), findsOneWidget);
    await pumpPanel(tester);
    expect(find.textContaining('la banda calla'), findsNothing);
  });
}
