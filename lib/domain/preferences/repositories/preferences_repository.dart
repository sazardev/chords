import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:flutter/material.dart' show ThemeMode;

/// Contrato de las preferencias locales que consume la presentación.
///
/// Expone solo lo que los controladores necesitan, de modo que la capa de
/// presentación dependa de esta abstracción del dominio y no de la
/// implementación concreta en `data`.
abstract interface class PreferencesRepository {
  /// Si el usuario ya completó el onboarding.
  bool get onboardingCompleted;

  /// Marca el onboarding como completado.
  Future<void> setOnboardingCompleted();

  /// Reinicia el onboarding.
  Future<void> resetOnboarding();

  /// Identificadores de acordes marcados como dominados.
  Set<String> get masteredChordIds;

  /// Reemplaza el conjunto de acordes dominados.
  Future<void> setMasteredChordIds(Set<String> ids);

  /// Mejor puntuación registrada en el modo juego.
  int get bestScore;

  /// Guarda la puntuación si supera la anterior.
  Future<void> saveBestScore(int score);

  /// Si el sonido de los acordes está activado.
  bool get soundEnabled;

  /// Activa o desactiva el sonido.
  Future<void> setSoundEnabled({required bool value});

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
