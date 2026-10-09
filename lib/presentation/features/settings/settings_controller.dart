import 'package:flutter/material.dart';

/// Controlador de ajustes de usuario (tema, color dinámico, espejo).
class SettingsController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _mirrorChords = false;

  /// Modo de tema seleccionado.
  ThemeMode get themeMode => _themeMode;

  /// Si los diagramas se muestran en espejo (zurdos).
  bool get mirrorChords => _mirrorChords;

  /// Cambia el modo de tema.
  set themeMode(ThemeMode value) {
    if (value == _themeMode) {
      return;
    }
    _themeMode = value;
    notifyListeners();
  }

  /// Activa o desactiva el modo espejo para zurdos.
  set mirrorChords(bool value) {
    if (value == _mirrorChords) {
      return;
    }
    _mirrorChords = value;
    notifyListeners();
  }
}
