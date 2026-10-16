import 'package:chords/data/local/band_preferences_store.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// La configuración de la banda se guarda y se recupera entre sesiones.
void main() {
  Future<PreferencesService> open(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return PreferencesService.create();
  }

  test('sin nada guardado devuelve los valores de fábrica', () async {
    final PreferencesService prefs = await open(<String, Object>{});
    expect(prefs.bandConfig, const BandConfig());
  });

  test('lo guardado vuelve igual al abrir otra vez', () async {
    final PreferencesService prefs = await open(<String, Object>{});
    final BandConfig config = applyBandMode(const BandConfig(), BandMode.rhythm)
        .copyWith(
          style: (value: 'cumbia'),
          swing: (value: 0.25),
          countInBars: 2,
          loops: 3,
          transpose: 4,
          intensity: BandIntensity.soft,
          bass: (value: BassKind.upright),
        );
    await prefs.setBandConfig(config);
    final SharedPreferences raw = await SharedPreferences.getInstance();
    final PreferencesService again = PreferencesService(raw);
    expect(again.bandConfig, config);
    expect(again.bandConfig.isOn(BandChannel.guitar), isFalse);
    expect(again.bandConfig.style, 'cumbia');
  });

  test('un valor dañado no rompe la app: vuelve a los de fábrica', () async {
    final PreferencesService prefs = await open(<String, Object>{
      BandPreferencesStore.kBandConfigKey: '{esto no es json',
    });
    expect(prefs.bandConfig, const BandConfig());
    final PreferencesService partial = await open(<String, Object>{
      BandPreferencesStore.kBandConfigKey: '{"loops": 2, "style": "tango"}',
    });
    expect(partial.bandConfig.loops, 2);
    expect(partial.bandConfig.style, 'tango');
    expect(partial.bandConfig.countInBars, 1);
  });

  group('BandSettingsController', () {
    test('cada cambio se guarda y avisa', () async {
      final PreferencesService prefs = await open(<String, Object>{});
      final BandSettingsController settings = BandSettingsController(prefs);
      int notified = 0;
      settings
        ..addListener(() => notified++)
        ..toggleChannel(BandChannel.drums)
        ..setVolume(BandChannel.bass, 0.3)
        ..applyMode(BandMode.noGuitar);
      expect(notified, 3);
      settings.set(settings.config);
      expect(notified, 3, reason: 'sin cambios no avisa');

      final BandSettingsController reopened = BandSettingsController(
        PreferencesService(await SharedPreferences.getInstance()),
      );
      expect(reopened.config, settings.config);
      expect(
        reopened.config.mixOf(BandChannel.bass).volume,
        closeTo(0.3, 1e-9),
      );
      expect(reopened.config.isOn(BandChannel.guitar), isFalse);
      // noGuitar vuelve a encender lo que había silenciado antes.
      expect(reopened.config.isOn(BandChannel.drums), isTrue);
    });

    test('el volumen se limita entre 0 y 1 y reset vuelve a fábrica', () async {
      final PreferencesService prefs = await open(<String, Object>{});
      final BandSettingsController settings = BandSettingsController(prefs)
        ..setVolume(BandChannel.keys, 3);
      expect(settings.config.mixOf(BandChannel.keys).volume, 1);
      settings.setVolume(BandChannel.keys, -1);
      expect(settings.config.mixOf(BandChannel.keys).volume, 0);
      settings.reset();
      expect(settings.config, const BandConfig());
      expect(prefs.bandConfig, const BandConfig());
    });
  });
}
