import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:flutter/material.dart' show ThemeMode;

/// Preferencias de apariencia: tema, acento, color dinámico, texto y espejo.
abstract interface class AppearancePreferences {
  /// Modo de tema persistido.
  ThemeMode get themeMode;

  /// Guarda el modo de tema.
  Future<void> setThemeMode(ThemeMode mode);

  /// Si los diagramas se muestran en espejo.
  bool get mirrorChords;

  /// Guarda el modo espejo.
  Future<void> setMirrorChords({required bool value});

  /// Color de acento persistido.
  AppAccentColor get accentColor;

  /// Guarda el color de acento.
  Future<void> setAccentColor(AppAccentColor accent);

  /// Si se usa el color dinámico del sistema.
  bool get dynamicColor;

  /// Guarda la preferencia de color dinámico.
  Future<void> setDynamicColor({required bool value});

  /// Escala de tamaño de texto persistida.
  AppFontScale get fontScale;

  /// Guarda la escala de tamaño de texto.
  Future<void> setFontScale(AppFontScale scale);
}
