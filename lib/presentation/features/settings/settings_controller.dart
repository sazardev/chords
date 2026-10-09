import 'package:chords/data/local/preferences_service.dart';
import 'package:flutter/material.dart';

/// Controlador de ajustes de usuario.
///
/// Persiste el modo de tema, el espejo de diagramas y el sonido.
class SettingsController extends ChangeNotifier {
  /// Crea el controlador con las preferencias locales.
  SettingsController(this._preferences);

  final PreferencesService _preferences;

  ThemeMode _themeMode = ThemeMode.system;
  bool _mirrorChords = false;
  bool _soundEnabled = true;

  /// Modo de tema seleccionado.
  ThemeMode get themeMode => _themeMode;

  /// Si los diagramas se muestran en espejo (zurdos).
  bool get mirrorChords => _mirrorChords;

  /// Si el sonido de los acordes está activado.
  bool get soundEnabled => _soundEnabled;

  /// Cambia el modo de tema.
  Future<void> setThemeMode(ThemeMode value) async {
    if (value == _themeMode) {
      return;
    }
    _themeMode = value;
    await _preferences.setThemeMode(value);
    notifyListeners();
  }

  /// Cambia el modo espejo para zurdos.
  Future<void> setMirrorChords({required bool value}) async {
    if (value == _mirrorChords) {
      return;
    }
    _mirrorChords = value;
    await _preferences.setMirrorChords(value: value);
    notifyListeners();
  }

  /// Activa o desactiva el sonido.
  Future<void> setSoundEnabled({required bool value}) async {
    if (value == _soundEnabled) {
      return;
    }
    _soundEnabled = value;
    await _preferences.setSoundEnabled(value: value);
    notifyListeners();
  }

  /// Carga los valores persistidos.
  Future<void> load() async {
    _themeMode = _preferences.themeMode;
    _mirrorChords = _preferences.mirrorChords;
    _soundEnabled = _preferences.soundEnabled;
    notifyListeners();
  }
}
