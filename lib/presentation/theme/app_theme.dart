import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/theme/app_theme_options.dart';
import 'package:chords/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Construye el tema claro a partir de las opciones de personalización.
///
/// [dynamicScheme] permite inyectar el color dinámico del sistema
/// (Material You); si es nulo se usa el acento de [options].
ThemeData buildLightTheme({
  ColorScheme? dynamicScheme,
  AppThemeOptions options = const AppThemeOptions(),
}) => _baseTheme(
  options.lightScheme(dynamicScheme: dynamicScheme),
  options: options,
  isDynamic: dynamicScheme != null,
);

/// Construye el tema oscuro a partir de las opciones de personalización.
///
/// [dynamicScheme] permite inyectar el color dinámico del sistema
/// (Material You); si es nulo se usa el acento de [options].
ThemeData buildDarkTheme({
  ColorScheme? dynamicScheme,
  AppThemeOptions options = const AppThemeOptions(),
}) => _baseTheme(
  options.darkScheme(dynamicScheme: dynamicScheme),
  options: options,
  isDynamic: dynamicScheme != null,
);

/// Construye el tema plano de Material 3.
///
/// La jerarquía se comunica solo con color: superficies planas, sin
/// elevaciones, sombras, degradados ni bordes visibles.
ThemeData _baseTheme(
  ColorScheme scheme, {
  required AppThemeOptions options,
  required bool isDynamic,
}) {
  final AppChordColors chordColors = _chordColors(scheme, isDynamic);
  final TextTheme textTheme = buildAppTextTheme(
    fontScale: options.fontScale.scale,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: textTheme,
    extensions: <ThemeExtension<dynamic>>[chordColors],
    visualDensity: VisualDensity.standard,
    scaffoldBackgroundColor: scheme.surface,
    canvasColor: scheme.surface,
    shadowColor: Colors.transparent,
    splashFactory: InkSparkle.splashFactory,
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      color: scheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    chipTheme: ChipThemeData(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.secondaryContainer,
      secondarySelectedColor: scheme.primaryContainer,
      disabledColor: scheme.surfaceContainerHighest,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      showCheckmark: false,
      labelStyle: textTheme.labelLarge?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      secondaryLabelStyle: textTheme.labelLarge?.copyWith(
        color: scheme.onSecondaryContainer,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.surfaceContainerHighest,
        disabledForegroundColor: scheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(64, 48),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: const StadiumBorder(),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        foregroundColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: BorderSide.none,
        backgroundColor: scheme.surfaceContainerHigh,
        foregroundColor: scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        minimumSize: const Size(64, 48),
        shape: const StadiumBorder(),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        elevation: 0,
        foregroundColor: scheme.onSurfaceVariant,
        shape: const StadiumBorder(),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.surfaceContainerHigh,
        selectedBackgroundColor: scheme.secondaryContainer,
        selectedForegroundColor: scheme.onSecondaryContainer,
        foregroundColor: scheme.onSurfaceVariant,
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
      splashColor: Colors.transparent,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: const StadiumBorder(),
      shadowColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0,
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: const StadiumBorder(),
      selectedLabelTextStyle: TextStyle(color: scheme.onSurface),
      unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      suffixIconColor: scheme.onSurfaceVariant,
      prefixIconColor: scheme.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      textColor: scheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      selectedColor: scheme.onSecondaryContainer,
      selectedTileColor: scheme.secondaryContainer,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.fixed,
      elevation: 0,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      shape: const RoundedRectangleBorder(),
    ),
    dialogTheme: DialogThemeData(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: scheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: TextStyle(color: scheme.onSurfaceVariant),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      strokeCap: StrokeCap.round,
      strokeWidth: 4,
      linearMinHeight: 10,
      circularTrackColor: scheme.surfaceContainerHighest,
      linearTrackColor: scheme.surfaceContainerHighest,
      color: scheme.primary,
      refreshBackgroundColor: Colors.transparent,
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      indicatorColor: scheme.primary,
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorSize: TabBarIndicatorSize.label,
    ),
  );
}

/// Colores de dominio, armonizados con el esquema cuando el color es dinámico.
AppChordColors _chordColors(ColorScheme scheme, bool isDynamic) {
  final AppChordColors base = scheme.brightness == Brightness.dark
      ? AppChordColors.dark
      : AppChordColors.light;
  if (!isDynamic) {
    return base;
  }
  return base.harmonizedWith(scheme.primary);
}
