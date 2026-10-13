import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:flutter/foundation.dart';

/// Controlador de ajustes de guitarra y sonido.
///
/// La apariencia (tema, acento, color dinámico y texto) vive en
/// [AppearanceController]; aquí queda el espejo de diagramas y el sonido.
class SettingsController extends ChangeNotifier {
  /// Crea el controlador con las preferencias locales.
  SettingsController(this._preferences);

  final PreferencesRepository _preferences;

  bool _mirrorChords = false;
  bool _soundEnabled = true;
  bool _guitarControl = true;
  bool _guitarBrowse = false;

  /// Si los diagramas se muestran en espejo (zurdos).
  bool get mirrorChords => _mirrorChords;

  /// Si el sonido de los acordes está activado.
  bool get soundEnabled => _soundEnabled;

  /// Si la app se puede manejar tocando cuerdas al aire con la guitarra.
  bool get guitarControl => _guitarControl;

  /// Si toda la app se maneja con la guitarra (panel fijo y menú de notas).
  bool get guitarBrowse => _guitarBrowse;

  /// Cambia el modo espejo para zurdos.
  Future<void> setMirrorChords({required bool value}) async {
    if (value == _mirrorChords) {
      return;
    }
    _mirrorChords = value;
    await _preferences.setMirrorChords(value: value);
    appLogger.debug('ajuste mirror_chords=$value');
    analytics.settingChanged(setting: 'mirror_chords', value: value);
    notifyListeners();
  }

  /// Activa o desactiva el sonido.
  Future<void> setSoundEnabled({required bool value}) async {
    if (value == _soundEnabled) {
      return;
    }
    _soundEnabled = value;
    await _preferences.setSoundEnabled(value: value);
    appLogger.debug('ajuste sound_enabled=$value');
    analytics.settingChanged(setting: 'sound_enabled', value: value);
    notifyListeners();
  }

  /// Activa o desactiva el control de la app con la guitarra.
  ///
  /// Sin control no hay modo guitarra global, así que apagarlo lo apaga.
  Future<void> setGuitarControl({required bool value}) async {
    if (!value && _guitarBrowse) {
      await setGuitarBrowse(value: false);
    }
    if (value == _guitarControl) {
      return;
    }
    _guitarControl = value;
    await _preferences.setGuitarControlEnabled(value: value);
    appLogger.debug('ajuste guitar_control=$value');
    analytics.settingChanged(setting: 'guitar_control', value: value);
    notifyListeners();
  }

  /// Activa o desactiva el modo guitarra global; al activarlo se enciende
  /// también el control con la guitarra.
  Future<void> setGuitarBrowse({required bool value}) async {
    if (value && !_guitarControl) {
      await setGuitarControl(value: true);
    }
    if (value == _guitarBrowse) {
      return;
    }
    _guitarBrowse = value;
    await _preferences.setGuitarBrowseEnabled(value: value);
    appLogger.debug('ajuste guitar_browse=$value');
    analytics.settingChanged(setting: 'guitar_browse', value: value);
    notifyListeners();
  }

  /// Carga los valores persistidos.
  Future<void> load() async {
    _mirrorChords = _preferences.mirrorChords;
    _soundEnabled = _preferences.soundEnabled;
    _guitarControl = _preferences.guitarControlEnabled;
    _guitarBrowse = _preferences.guitarBrowseEnabled;
    notifyListeners();
  }
}
