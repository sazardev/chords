import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:flutter/material.dart';

/// Opciones de personalización del sistema de diseño.
///
/// Agrupa el acento, el color dinámico del sistema y la escala de texto para
/// que el tema se resuelva a partir de un único objeto inmutable.
@immutable
class AppThemeOptions {
  /// Crea las opciones de tema.
  const AppThemeOptions({
    this.accent = AppAccentColor.violeta,
    this.dynamicColor = false,
    this.fontScale = AppFontScale.normal,
  });

  /// Acento seleccionado por la persona usuaria.
  final AppAccentColor accent;

  /// Si se usa el color dinámico del sistema (Material You) cuando está
  /// disponible.
  final bool dynamicColor;

  /// Escala de tamaño de texto seleccionada.
  final AppFontScale fontScale;

  /// Reemplaza valores de las opciones actuales.
  AppThemeOptions copyWith({
    AppAccentColor? accent,
    bool? dynamicColor,
    AppFontScale? fontScale,
  }) => AppThemeOptions(
    accent: accent ?? this.accent,
    dynamicColor: dynamicColor ?? this.dynamicColor,
    fontScale: fontScale ?? this.fontScale,
  );

  /// Esquema de color claro.
  ///
  /// Usa [dynamicScheme] si se proporciona (color del sistema) y, si no, lo
  /// genera a partir del acento elegido.
  ColorScheme lightScheme({ColorScheme? dynamicScheme}) =>
      _resolve(dynamicScheme, dark: false);

  /// Esquema de color oscuro.
  ///
  /// Usa [dynamicScheme] si se proporciona (color del sistema) y, si no, lo
  /// genera a partir del acento elegido.
  ColorScheme darkScheme({ColorScheme? dynamicScheme}) =>
      _resolve(dynamicScheme, dark: true);

  ColorScheme _resolve(ColorScheme? dynamicScheme, {required bool dark}) {
    if (dynamicScheme != null) {
      return dynamicScheme;
    }
    return ColorScheme.fromSeed(
      seedColor: accent.seed,
      brightness: dark ? Brightness.dark : Brightness.light,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    );
  }
}
