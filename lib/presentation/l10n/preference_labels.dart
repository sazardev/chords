/// Etiquetas traducidas de las preferencias de interfaz.
///
/// Los valores de los ajustes (idioma, tema, acento, tamaño de texto) viven
/// en el dominio con su nombre canónico; estas funciones los presentan en el
/// idioma activo. Para dar soporte a un idioma nuevo solo hay que añadir las
/// claves a `lib/l10n`.
library;

import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/theme/app_accent_color.dart';
import 'package:chords/presentation/theme/app_font_scale.dart';
import 'package:flutter/material.dart' show ThemeMode;

/// Nombre del idioma en su propio idioma.
String languageLabel(Translations translations, AppLanguage language) =>
    switch (language) {
      AppLanguage.system => translations.data.language.system,
      AppLanguage.spanish => translations.data.language.es,
      AppLanguage.english => translations.data.language.en,
    };

/// Etiqueta corta del modo de tema.
String themeModeLabel(Translations translations, ThemeMode mode) =>
    switch (mode) {
      ThemeMode.system => translations.settings.theme.system,
      ThemeMode.light => translations.settings.theme.light,
      ThemeMode.dark => translations.settings.theme.dark,
    };

/// Descripción del comportamiento del modo de tema.
String themeModeSummary(Translations translations, ThemeMode mode) =>
    switch (mode) {
      ThemeMode.system => translations.settings.theme.summarySystem,
      ThemeMode.light => translations.settings.theme.summaryLight,
      ThemeMode.dark => translations.settings.theme.summaryDark,
    };

/// Valor actual del modo de tema, en una sola línea.
String themeModeValue(Translations translations, ThemeMode mode) =>
    switch (mode) {
      ThemeMode.system => translations.settings.theme.valueSystem,
      ThemeMode.light => translations.settings.theme.valueLight,
      ThemeMode.dark => translations.settings.theme.valueDark,
    };

/// Nombre del color de acento.
String accentColorLabel(Translations translations, AppAccentColor accent) =>
    switch (accent) {
      AppAccentColor.violeta => translations.settings.accent.violeta,
      AppAccentColor.azul => translations.settings.accent.azul,
      AppAccentColor.anil => translations.settings.accent.anil,
      AppAccentColor.cian => translations.settings.accent.cian,
      AppAccentColor.verde => translations.settings.accent.verde,
      AppAccentColor.lima => translations.settings.accent.lima,
      AppAccentColor.ambar => translations.settings.accent.ambar,
      AppAccentColor.naranja => translations.settings.accent.naranja,
      AppAccentColor.rojo => translations.settings.accent.rojo,
      AppAccentColor.rosa => translations.settings.accent.rosa,
    };

/// Nombre de la escala de tamaño de texto.
String fontScaleLabel(Translations translations, AppFontScale scale) =>
    switch (scale) {
      AppFontScale.pequena => translations.settings.fontScale.pequena,
      AppFontScale.normal => translations.settings.fontScale.normal,
      AppFontScale.grande => translations.settings.fontScale.grande,
      AppFontScale.extraGrande => translations.settings.fontScale.extraGrande,
    };
