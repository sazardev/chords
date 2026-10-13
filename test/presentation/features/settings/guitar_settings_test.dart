import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests de los ajustes del control con la guitarra.
void main() {
  Future<SettingsController> build() async {
    final PreferencesService preferences = await PreferencesService.create();
    final SettingsController settings = SettingsController(preferences);
    await settings.load();
    return settings;
  }

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  test('por defecto las órdenes están activas y el catálogo no', () async {
    final SettingsController settings = await build();
    expect(settings.guitarControl, isTrue);
    expect(settings.guitarBrowse, isFalse);
  });

  test('los dos ajustes se guardan y se recuperan', () async {
    final SettingsController settings = await build();
    await settings.setGuitarBrowse(value: true);
    expect(settings.guitarControl, isTrue);
    expect(settings.guitarBrowse, isTrue);

    final SettingsController reloaded = await build();
    expect(reloaded.guitarControl, isTrue);
    expect(reloaded.guitarBrowse, isTrue);
  });

  test('el modo guitarra global necesita el control con la guitarra', () async {
    final SettingsController settings = await build();
    await settings.setGuitarControl(value: false);
    await settings.setGuitarBrowse(value: true);
    expect(settings.guitarControl, isTrue, reason: 'activar lo enciende');

    await settings.setGuitarControl(value: false);
    expect(settings.guitarBrowse, isFalse, reason: 'apagarlo apaga el modo');
    final SettingsController reloaded = await build();
    expect(reloaded.guitarControl, isFalse);
    expect(reloaded.guitarBrowse, isFalse);
  });
}
