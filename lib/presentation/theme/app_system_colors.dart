import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Esquemas de color ofrecidos por el sistema operativo.
///
/// En Android proviene del fondo de pantalla (Material You); en macOS,
/// Windows y escritorios GTK, del color de acento del sistema.
@immutable
class AppSystemColors {
  /// Crea el par de esquemas del sistema.
  const AppSystemColors({required this.light, required this.dark});

  /// Esquema claro del sistema.
  final ColorScheme light;

  /// Esquema oscuro del sistema.
  final ColorScheme dark;
}

/// Lee el color del sistema y lo convierte en esquemas Material 3.
///
/// Devuelve `null` cuando la plataforma no expone ningún color, de modo que la
/// aplicación puede seguir con sus propios acentos.
Future<AppSystemColors?> loadSystemColors() async {
  // El plugin de plataforma sigue devolviendo la paleta legacy de Android.
  // ignore: deprecated_member_use
  final CorePalette? palette = await DynamicColorPlugin.getCorePalette();
  if (palette != null) {
    return AppSystemColors(
      light: _schemeOf(
        primary: palette.primary,
        secondary: palette.secondary,
        tertiary: palette.tertiary,
        neutral: palette.neutral,
        neutralVariant: palette.neutralVariant,
        brightness: Brightness.light,
      ),
      dark: _schemeOf(
        primary: palette.primary,
        secondary: palette.secondary,
        tertiary: palette.tertiary,
        neutral: palette.neutral,
        neutralVariant: palette.neutralVariant,
        brightness: Brightness.dark,
      ),
    );
  }
  final Color? accent = await _accentColor();
  if (accent == null) {
    return null;
  }
  return AppSystemColors(
    light: ColorScheme.fromSeed(seedColor: accent),
    dark: ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.dark),
  );
}

Future<Color?> _accentColor() async {
  try {
    return await DynamicColorPlugin.getAccentColor();
  } on PlatformException {
    return null;
  }
}

/// Convierte las paletas tonales del sistema en un esquema Material 3.
///
/// Los roles de superficie se derivan del esquema dinámico del sistema, que ya
/// aplica la variante tonal de Material You.
ColorScheme _schemeOf({
  required TonalPalette primary,
  required TonalPalette secondary,
  required TonalPalette tertiary,
  required TonalPalette neutral,
  required TonalPalette neutralVariant,
  required Brightness brightness,
}) {
  final DynamicScheme scheme = DynamicScheme(
    sourceColorHct: Hct.fromInt(primary.get(40)),
    variant: Variant.expressive,
    isDark: brightness == Brightness.dark,
    primaryPalette: primary,
    secondaryPalette: secondary,
    tertiaryPalette: tertiary,
    neutralPalette: neutral,
    neutralVariantPalette: neutralVariant,
  );
  final ColorScheme seeded = ColorScheme.fromSeed(
    seedColor: Color(scheme.primary),
    brightness: brightness,
  );
  return seeded.copyWith(
    primary: Color(scheme.primary),
    onPrimary: Color(scheme.onPrimary),
    primaryContainer: Color(scheme.primaryContainer),
    onPrimaryContainer: Color(scheme.onPrimaryContainer),
    secondary: Color(scheme.secondary),
    onSecondary: Color(scheme.onSecondary),
    secondaryContainer: Color(scheme.secondaryContainer),
    onSecondaryContainer: Color(scheme.onSecondaryContainer),
    tertiary: Color(scheme.tertiary),
    onTertiary: Color(scheme.onTertiary),
    tertiaryContainer: Color(scheme.tertiaryContainer),
    onTertiaryContainer: Color(scheme.onTertiaryContainer),
    error: Color(scheme.error),
    onError: Color(scheme.onError),
    errorContainer: Color(scheme.errorContainer),
    onErrorContainer: Color(scheme.onErrorContainer),
    surface: Color(scheme.surface),
    onSurface: Color(scheme.onSurface),
    surfaceDim: Color(scheme.surfaceDim),
    surfaceBright: Color(scheme.surfaceBright),
    surfaceContainerLowest: Color(scheme.surfaceContainerLowest),
    surfaceContainerLow: Color(scheme.surfaceContainerLow),
    surfaceContainer: Color(scheme.surfaceContainer),
    surfaceContainerHigh: Color(scheme.surfaceContainerHigh),
    surfaceContainerHighest: Color(scheme.surfaceContainerHighest),
    onSurfaceVariant: Color(scheme.onSurfaceVariant),
    outline: Color(scheme.outline),
    outlineVariant: Color(scheme.outlineVariant),
    inverseSurface: Color(scheme.inverseSurface),
    onInverseSurface: Color(scheme.inverseOnSurface),
    inversePrimary: Color(scheme.inversePrimary),
    shadow: Color(scheme.shadow),
    scrim: Color(scheme.scrim),
  );
}
