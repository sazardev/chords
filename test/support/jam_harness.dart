import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fakes/chord_bank.dart';
import '../fakes/fake_audio_repository.dart';
import '../fakes/fake_band_audio_repository.dart';
import 'widget_test_clock.dart';

/// Lo necesario para probar el jam: preferencias reales en memoria,
/// audio falso, banda falsa y un controlador con el reloj de `testWidgets`.
class JamHarness {
  JamHarness._(
    this.preferences,
    this.audio,
    this.band,
    this.progress,
    this.settings,
    this.jam,
  );

  /// Monta el arnés con la [config] de banda inicial.
  static Future<JamHarness> create(
    WidgetTester tester, {
    BandConfig config = const BandConfig(humanize: 0),
    DateTime? today,
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    await preferences.setBandConfig(config);
    final FakeAudioRepository audio = FakeAudioRepository();
    final FakeBandAudioRepository band = FakeBandAudioRepository();
    final StudioProgressController progress = StudioProgressController(
      preferences,
      clock: () => today ?? DateTime(2026, 10, 13, 18),
    );
    final BandSettingsController settings = BandSettingsController(preferences);
    final JamController jam = JamController(
      audio,
      loadChordBank(),
      progress,
      settings: settings,
      band: band,
      clock: WidgetTestClock(tester.binding),
    );
    await jam.load(track());
    return JamHarness._(preferences, audio, band, progress, settings, jam);
  }

  /// Preferencias reales sobre `SharedPreferences` de prueba.
  final PreferencesService preferences;

  /// Audio (micrófono) falso.
  final FakeAudioRepository audio;

  /// Banda falsa.
  final FakeBandAudioRepository band;

  /// Progreso del estudio.
  final StudioProgressController progress;

  /// Ajustes de la banda.
  final BandSettingsController settings;

  /// Controlador del jam.
  final JamController jam;

  /// Pista de prueba: Do y Sol a 120 BPM, una vuelta.
  static JamTrack track() => JamTrack.custom(
    <ChordSymbol>[ChordSymbol.parse('C'), ChordSymbol.parse('G')],
    title: 'prueba',
    bpm: 120,
    loops: 1,
  );

  /// Envuelve [body] con los proveedores y el tema de la app.
  Widget host(Widget body) => TranslationProvider(
    child: MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<JamController>.value(value: jam),
        ChangeNotifierProvider<BandSettingsController>.value(value: settings),
        ChangeNotifierProvider<StudioProgressController>.value(value: progress),
        ChangeNotifierProvider<SettingsController>.value(
          value: SettingsController(preferences),
        ),
      ],
      child: MaterialApp(
        theme: buildLightTheme(),
        home: Scaffold(body: body),
      ),
    ),
  );
}
