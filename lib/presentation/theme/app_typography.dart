import 'package:flutter/material.dart';

/// Tipografía base de la aplicación (escala Material 3).
TextTheme buildAppTextTheme() => Typography.material2021().englishLike.copyWith(
  displayLarge: const TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  ),
  headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
  titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
  titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  bodyLarge: const TextStyle(fontSize: 15),
  bodyMedium: const TextStyle(fontSize: 14),
  labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
);
