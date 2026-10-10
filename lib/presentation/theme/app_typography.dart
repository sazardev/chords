import 'package:flutter/material.dart';

/// Tipografía base de la aplicación (escala Material 3).
///
/// [fontScale] multiplica todos los tamaños para que la selección de tamaño de
/// texto de los ajustes crezca de forma uniforme en toda la interfaz.
TextTheme buildAppTextTheme({double fontScale = 1}) {
  final TextTheme base = Typography.material2021().englishLike;
  return base.copyWith(
    displayLarge: TextStyle(
      fontSize: 52 * fontScale,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: base.displayLarge?.height,
    ),
    headlineMedium: TextStyle(
      fontSize: 28 * fontScale,
      fontWeight: FontWeight.w600,
      height: base.headlineMedium?.height,
    ),
    titleLarge: TextStyle(
      fontSize: 22 * fontScale,
      fontWeight: FontWeight.w600,
      height: base.titleLarge?.height,
    ),
    titleMedium: TextStyle(
      fontSize: 16 * fontScale,
      fontWeight: FontWeight.w600,
      height: base.titleMedium?.height,
    ),
    bodyLarge: TextStyle(
      fontSize: 15 * fontScale,
      height: base.bodyLarge?.height,
    ),
    bodyMedium: TextStyle(
      fontSize: 14 * fontScale,
      height: base.bodyMedium?.height,
    ),
    labelLarge: TextStyle(
      fontSize: 14 * fontScale,
      fontWeight: FontWeight.w600,
      height: base.labelLarge?.height,
    ),
    labelMedium: TextStyle(
      fontSize: 12 * fontScale,
      height: base.labelMedium?.height,
    ),
  );
}
