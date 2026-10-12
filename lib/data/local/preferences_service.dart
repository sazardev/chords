import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de preferencias locales de la app.
///
/// Centraliza todas las claves para evitar duplicados.
class PreferencesService implements PreferencesRepository {
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

  /// Prefijo de las claves del mejor resultado de cada minijuego.
  static const String kMiniGameBestPrefix = 'minigame_best_v1_';

  /// Clave del sonido activado.
  static const String kSoundKey = 'sound_enabled_v1';

  /// Clave del modo de tema.
  static const String kThemeModeKey = 'theme_mode_v1';

  /// Clave del modo espejo.
  static const String kMirrorKey = 'mirror_chords_v1';

  /// Clave del idioma de la interfaz.
  static const String kLanguageKey = 'app_language_v1';

  /// Clave del color de acento.
  static const String kAccentColorKey = 'accent_color_v1';

  /// Clave del color dinámico del sistema.
  static const String kDynamicColorKey = 'dynamic_color_v1';

  /// Clave de la escala de tamaño de texto.
  static const String kFontScaleKey = 'font_scale_v1';

  /// Clave del tipo de guitarra.
  static const String kGuitarKey = 'profile_guitar_v1';

  /// Clave de la mano con la que se toca.
  static const String kHandKey = 'profile_hand_v1';

  /// Clave del estilo de ataque.
  static const String kStyleKey = 'profile_style_v1';

  /// Clave de los géneros favoritos.
  static const String kGenresKey = 'profile_genres_v1';

  /// Clave de la experiencia.
  static const String kExperienceKey = 'profile_experience_v1';

  /// Clave que marca el perfil como elegido por la persona.
  static const String kPersonalizedKey = 'profile_personalized_v1';

  /// `true` si el usuario ya vio el onboarding.
  @override
  bool get onboardingCompleted => _prefs.getBool(kOnboardingKey) ?? false;

  /// Marca el onboarding como completado.
  @override
  Future<void> setOnboardingCompleted() => _prefs.setBool(kOnboardingKey, true);

  /// Reinicia el onboarding.
  @override
  Future<void> resetOnboarding() => _prefs.setBool(kOnboardingKey, false);

  /// Identificadores de acordes dominados.
  @override
  Set<String> get masteredChordIds =>
      _prefs.getStringList(kMasteredKey)?.toSet() ?? <String>{};

  /// Reemplaza el conjunto de acordes dominados.
  @override
  Future<void> setMasteredChordIds(Set<String> ids) =>
      _prefs.setStringList(kMasteredKey, ids.toList());

  /// Mejor puntuación del modo juego.
  @override
  int get bestScore => _prefs.getInt(kBestScoreKey) ?? 0;

  /// Guarda la puntuación si supera la anterior.
  @override
  Future<void> saveBestScore(int score) async {
    if (score > bestScore) {
      await _prefs.setInt(kBestScoreKey, score);
    }
  }

  /// Mejor porcentaje de acierto de un minijuego y nivel.
  @override
  int miniGameBest(String gameKey) =>
      _prefs.getInt('$kMiniGameBestPrefix$gameKey') ?? 0;

  /// Guarda el porcentaje si supera el anterior.
  @override
  Future<void> saveMiniGameBest(String gameKey, int percent) async {
    if (percent > miniGameBest(gameKey)) {
      await _prefs.setInt('$kMiniGameBestPrefix$gameKey', percent);
    }
  }

  /// Si el sonido de los acordes está activado.
  @override
  bool get soundEnabled => _prefs.getBool(kSoundKey) ?? true;

  /// Activa o desactiva el sonido.
  @override
  Future<void> setSoundEnabled({required bool value}) =>
      _prefs.setBool(kSoundKey, value);

  /// Modo de tema persistido.
  @override
  ThemeMode get themeMode => switch (_prefs.getString(kThemeModeKey)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  /// Guarda el modo de tema.
  @override
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(kThemeModeKey, mode.name);

  /// Si los diagramas se muestran en espejo.
  @override
  bool get mirrorChords => _prefs.getBool(kMirrorKey) ?? false;

  /// Guarda el modo espejo.
  @override
  Future<void> setMirrorChords({required bool value}) =>
      _prefs.setBool(kMirrorKey, value);

  /// Color de acento persistido.
  @override
  AppAccentColor get accentColor => switch (_prefs.getString(kAccentColorKey)) {
    'azul' => AppAccentColor.azul,
    'anil' => AppAccentColor.anil,
    'cian' => AppAccentColor.cian,
    'verde' => AppAccentColor.verde,
    'lima' => AppAccentColor.lima,
    'ambar' => AppAccentColor.ambar,
    'naranja' => AppAccentColor.naranja,
    'rojo' => AppAccentColor.rojo,
    'rosa' => AppAccentColor.rosa,
    _ => AppAccentColor.violeta,
  };

  /// Guarda el color de acento.
  @override
  Future<void> setAccentColor(AppAccentColor accent) =>
      _prefs.setString(kAccentColorKey, accent.name);

  /// Si se usa el color dinámico del sistema cuando está disponible.
  @override
  bool get dynamicColor => _prefs.getBool(kDynamicColorKey) ?? false;

  /// Guarda la preferencia de color dinámico.
  @override
  Future<void> setDynamicColor({required bool value}) =>
      _prefs.setBool(kDynamicColorKey, value);

  /// Escala de tamaño de texto persistida.
  @override
  AppFontScale get fontScale => switch (_prefs.getString(kFontScaleKey)) {
    'pequena' => AppFontScale.pequena,
    'grande' => AppFontScale.grande,
    'extraGrande' => AppFontScale.extraGrande,
    _ => AppFontScale.normal,
  };

  /// Guarda la escala de tamaño de texto.
  @override
  Future<void> setFontScale(AppFontScale scale) =>
      _prefs.setString(kFontScaleKey, scale.name);

  /// Nombre del idioma guardado o `null` si sigue al sistema.
  String? get languageName => _prefs.getString(kLanguageKey);

  /// Guarda el idioma de la interfaz por nombre de valor.
  Future<void> setLanguageName(String name) =>
      _prefs.setString(kLanguageKey, name);

  /// Perfil de la persona (el inicial si nunca se guardó).
  @override
  PlayerProfile get playerProfile => PlayerProfile(
    guitar: _enumByName(
      GuitarType.values,
      _prefs.getString(kGuitarKey),
      GuitarType.acoustic,
    ),
    hand: _enumByName(
      PlayingHand.values,
      _prefs.getString(kHandKey),
      PlayingHand.right,
    ),
    style: _enumByName(
      PlayingStyle.values,
      _prefs.getString(kStyleKey),
      PlayingStyle.both,
    ),
    genres: _prefs.getStringList(kGenresKey)?.toSet() ?? <String>{},
    experience: _enumByName(
      ExperienceLevel.values,
      _prefs.getString(kExperienceKey),
      ExperienceLevel.beginner,
    ),
    personalized: _prefs.getBool(kPersonalizedKey) ?? false,
  );

  /// Guarda el perfil completo.
  @override
  Future<void> setPlayerProfile(PlayerProfile profile) async {
    await _prefs.setString(kGuitarKey, profile.guitar.name);
    await _prefs.setString(kHandKey, profile.hand.name);
    await _prefs.setString(kStyleKey, profile.style.name);
    await _prefs.setStringList(kGenresKey, profile.genres.toList()..sort());
    await _prefs.setString(kExperienceKey, profile.experience.name);
    await _prefs.setBool(kPersonalizedKey, profile.personalized);
  }

  T _enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
    for (final T value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return fallback;
  }
}
