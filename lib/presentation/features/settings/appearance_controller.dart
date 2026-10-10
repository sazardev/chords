import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:chords/domain/preferences/repositories/appearance_preferences.dart';
import 'package:chords/presentation/theme/app_theme_options.dart';
import 'package:flutter/material.dart';

/// Controlador de la apariencia de la app: tema, acento, color dinámico y
/// tamaño de texto.
///
/// Responsabilidad única sobre la personalización visual; se apoya en el
/// contrato [AppearancePreferences] del dominio.
class AppearanceController extends ChangeNotifier {
  /// Crea el controlador con las preferencias de apariencia.
  AppearanceController(this._preferences);

  final AppearancePreferences _preferences;

  ThemeMode _themeMode = ThemeMode.system;
  AppAccentColor _accentColor = AppAccentColor.violeta;
  bool _dynamicColor = false;
  AppFontScale _fontScale = AppFontScale.normal;

  /// Modo de tema seleccionado.
  ThemeMode get themeMode => _themeMode;

  /// Color de acento seleccionado.
  AppAccentColor get accentColor => _accentColor;

  /// Si se usa el color dinámico del sistema cuando está disponible.
  bool get dynamicColor => _dynamicColor;

  /// Escala de tamaño de texto seleccionada.
  AppFontScale get fontScale => _fontScale;

  /// Opciones completas de personalización del tema.
  AppThemeOptions get themeOptions => AppThemeOptions(
    accent: _accentColor,
    dynamicColor: _dynamicColor,
    fontScale: _fontScale,
  );

  /// Cambia el modo de tema.
  Future<void> setThemeMode(ThemeMode value) async {
    if (value == _themeMode) {
      return;
    }
    _themeMode = value;
    await _preferences.setThemeMode(value);
    notifyListeners();
  }

  /// Cambia el color de acento de la interfaz.
  Future<void> setAccentColor(AppAccentColor value) async {
    if (value == _accentColor) {
      return;
    }
    _accentColor = value;
    await _preferences.setAccentColor(value);
    notifyListeners();
  }

  /// Activa o desactiva el color dinámico del sistema (Material You).
  Future<void> setDynamicColor({required bool value}) async {
    if (value == _dynamicColor) {
      return;
    }
    _dynamicColor = value;
    await _preferences.setDynamicColor(value: value);
    notifyListeners();
  }

  /// Cambia la escala de tamaño de texto.
  Future<void> setFontScale(AppFontScale value) async {
    if (value == _fontScale) {
      return;
    }
    _fontScale = value;
    await _preferences.setFontScale(value);
    notifyListeners();
  }

  /// Carga los valores persistidos.
  Future<void> load() async {
    _themeMode = _preferences.themeMode;
    _accentColor = _preferences.accentColor;
    _dynamicColor = _preferences.dynamicColor;
    _fontScale = _preferences.fontScale;
    notifyListeners();
  }
}
