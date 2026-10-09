import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/theme/app_colors.dart';
import 'package:chords/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Construye el tema claro de la aplicación.
///
/// [colorScheme] permite inyectar un esquema dinámico (Android 12+).
ThemeData buildLightTheme({ColorScheme? colorScheme}) {
  final ColorScheme scheme =
      colorScheme ?? ColorScheme.fromSeed(seedColor: kSeedColor);
  return _baseTheme(scheme).copyWith(
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
    ),
  );
}

/// Construye el tema oscuro de la aplicación.
///
/// [colorScheme] permite inyectar un esquema dinámico (Android 12+).
ThemeData buildDarkTheme({ColorScheme? colorScheme}) {
  final ColorScheme scheme =
      colorScheme ??
      ColorScheme.fromSeed(seedColor: kSeedColor, brightness: Brightness.dark);
  return _baseTheme(scheme).copyWith(
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
    ),
  );
}

/// Aplica los componentes comunes a ambos temas.
ThemeData _baseTheme(ColorScheme scheme) {
  final AppChordColors chordColors = scheme.brightness == Brightness.dark
      ? AppChordColors.dark
      : AppChordColors.light;
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: buildAppTextTheme(),
    extensions: <ThemeExtension<dynamic>>[chordColors],
    cardTheme: const CardThemeData(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: scheme.outlineVariant),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 2,
      backgroundColor: scheme.surfaceContainer,
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}
