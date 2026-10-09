import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de preferencias locales de la app.
///
/// Centraliza todas las claves para evitar duplicados.
class PreferencesService {
  /// Crea el servicio.
  const PreferencesService(this._prefs);

  /// Crea el servicio leyendo las preferencias del sistema.
  static Future<PreferencesService> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  final SharedPreferences _prefs;

  /// Clave del onboarding.
  static const String kOnboardingKey = 'onboarding_completed_v1';

  /// Clave de los acordes dominados.
  static const String kMasteredKey = 'mastered_chords_v1';

  /// Clave de la mejor puntuación del juego.
  static const String kBestScoreKey = 'best_score_v1';

  /// Clave del sonido activado.
  static const String kSoundKey = 'sound_enabled_v1';

  /// Clave del modo de tema.
  static const String kThemeModeKey = 'theme_mode_v1';

  /// Clave del modo espejo.
  static const String kMirrorKey = 'mirror_chords_v1';

  /// `true` si el usuario ya vio el onboarding.
  bool get onboardingCompleted => _prefs.getBool(kOnboardingKey) ?? false;

  /// Marca el onboarding como completado.
  Future<void> setOnboardingCompleted() => _prefs.setBool(kOnboardingKey, true);

  /// Reinicia el onboarding.
  Future<void> resetOnboarding() => _prefs.setBool(kOnboardingKey, false);

  /// Identificadores de acordes dominados.
  Set<String> get masteredChordIds =>
      _prefs.getStringList(kMasteredKey)?.toSet() ?? <String>{};

  /// Reemplaza el conjunto de acordes dominados.
  Future<void> setMasteredChordIds(Set<String> ids) =>
      _prefs.setStringList(kMasteredKey, ids.toList());

  /// Mejor puntuación del modo juego.
  int get bestScore => _prefs.getInt(kBestScoreKey) ?? 0;

  /// Guarda la puntuación si supera la anterior.
  Future<void> saveBestScore(int score) async {
    if (score > bestScore) {
      await _prefs.setInt(kBestScoreKey, score);
    }
  }

  /// Si el sonido de los acordes está activado.
  bool get soundEnabled => _prefs.getBool(kSoundKey) ?? true;

  /// Activa o desactiva el sonido.
  Future<void> setSoundEnabled({required bool value}) =>
      _prefs.setBool(kSoundKey, value);

  /// Modo de tema persistido.
  ThemeMode get themeMode => switch (_prefs.getString(kThemeModeKey)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  /// Guarda el modo de tema.
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(kThemeModeKey, mode.name);

  /// Si los diagramas se muestran en espejo.
  bool get mirrorChords => _prefs.getBool(kMirrorKey) ?? false;

  /// Guarda el modo espejo.
  Future<void> setMirrorChords({required bool value}) =>
      _prefs.setBool(kMirrorKey, value);
}
