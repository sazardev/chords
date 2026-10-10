import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

/// Colores de dominio no cubiertos por `ColorScheme`.
///
/// Incluye los colores de diagramas de acordes, los niveles de dificultad y
/// el medidor de afinación en vivo.
@immutable
class AppChordColors extends ThemeExtension<AppChordColors> {
  /// Crea la extensión de colores.
  const AppChordColors({
    required this.openString,
    required this.mutedString,
    required this.fretPressed,
    required this.difficulty1,
    required this.difficulty2,
    required this.difficulty3,
    required this.difficulty4,
    required this.difficulty5,
    required this.inTune,
    required this.outOfTune,
  });

  /// Colores para el tema claro.
  static const AppChordColors light = AppChordColors(
    openString: Color(0xFF1DB954),
    mutedString: Color(0xFF9E9E9E),
    fretPressed: Color(0xFF4A4458),
    difficulty1: Color(0xFF1DB954),
    difficulty2: Color(0xFF43A047),
    difficulty3: Color(0xFFF9A825),
    difficulty4: Color(0xFFEF6C00),
    difficulty5: Color(0xFFE53935),
    inTune: Color(0xFF1DB954),
    outOfTune: Color(0xFFE53935),
  );

  /// Colores para el tema oscuro.
  static const AppChordColors dark = AppChordColors(
    openString: Color(0xFF4ADE80),
    mutedString: Color(0xFF6B7280),
    fretPressed: Color(0xFFCFC9DA),
    difficulty1: Color(0xFF4ADE80),
    difficulty2: Color(0xFF86EFAC),
    difficulty3: Color(0xFFFACC15),
    difficulty4: Color(0xFFFB923C),
    difficulty5: Color(0xFFF87171),
    inTune: Color(0xFF4ADE80),
    outOfTune: Color(0xFFF87171),
  );

  /// Color de cuerda al aire.
  final Color openString;

  /// Color de cuerda muda.
  final Color mutedString;

  /// Color de traste pulsado.
  final Color fretPressed;

  /// Color del nivel de dificultad 1.
  final Color difficulty1;

  /// Color del nivel de dificultad 2.
  final Color difficulty2;

  /// Color del nivel de dificultad 3.
  final Color difficulty3;

  /// Color del nivel de dificultad 4.
  final Color difficulty4;

  /// Color del nivel de dificultad 5.
  final Color difficulty5;

  /// Color de afinación correcta.
  final Color inTune;

  /// Color de desafinación.
  final Color outOfTune;

  /// Color asociado a un nivel de dificultad (1-5).
  Color forDifficulty(int level) => switch (level) {
    1 => difficulty1,
    2 => difficulty2,
    3 => difficulty3,
    4 => difficulty4,
    _ => difficulty5,
  };

  /// Ajusta los colores de dominio hacia [towards] para que convivan con el
  /// color dinámico del sistema sin perder su significado semántico.
  AppChordColors harmonizedWith(Color towards) => AppChordColors(
    openString: openString.harmonizeWith(towards),
    mutedString: mutedString.harmonizeWith(towards),
    fretPressed: fretPressed.harmonizeWith(towards),
    difficulty1: difficulty1.harmonizeWith(towards),
    difficulty2: difficulty2.harmonizeWith(towards),
    difficulty3: difficulty3.harmonizeWith(towards),
    difficulty4: difficulty4.harmonizeWith(towards),
    difficulty5: difficulty5.harmonizeWith(towards),
    inTune: inTune.harmonizeWith(towards),
    outOfTune: outOfTune.harmonizeWith(towards),
  );

  @override
  AppChordColors copyWith({
    Color? openString,
    Color? mutedString,
    Color? fretPressed,
    Color? difficulty1,
    Color? difficulty2,
    Color? difficulty3,
    Color? difficulty4,
    Color? difficulty5,
    Color? inTune,
    Color? outOfTune,
  }) => AppChordColors(
    openString: openString ?? this.openString,
    mutedString: mutedString ?? this.mutedString,
    fretPressed: fretPressed ?? this.fretPressed,
    difficulty1: difficulty1 ?? this.difficulty1,
    difficulty2: difficulty2 ?? this.difficulty2,
    difficulty3: difficulty3 ?? this.difficulty3,
    difficulty4: difficulty4 ?? this.difficulty4,
    difficulty5: difficulty5 ?? this.difficulty5,
    inTune: inTune ?? this.inTune,
    outOfTune: outOfTune ?? this.outOfTune,
  );

  @override
  AppChordColors lerp(ThemeExtension<AppChordColors>? other, double t) {
    if (other is! AppChordColors) {
      return this;
    }
    return AppChordColors(
      openString: Color.lerp(openString, other.openString, t)!,
      mutedString: Color.lerp(mutedString, other.mutedString, t)!,
      fretPressed: Color.lerp(fretPressed, other.fretPressed, t)!,
      difficulty1: Color.lerp(difficulty1, other.difficulty1, t)!,
      difficulty2: Color.lerp(difficulty2, other.difficulty2, t)!,
      difficulty3: Color.lerp(difficulty3, other.difficulty3, t)!,
      difficulty4: Color.lerp(difficulty4, other.difficulty4, t)!,
      difficulty5: Color.lerp(difficulty5, other.difficulty5, t)!,
      inTune: Color.lerp(inTune, other.inTune, t)!,
      outOfTune: Color.lerp(outOfTune, other.outOfTune, t)!,
    );
  }
}

/// Atajo para recuperar la extensión desde el contexto.
AppChordColors chordColorsOf(BuildContext context) {
  final AppChordColors? colors = Theme.of(context).extension<AppChordColors>();
  return colors ?? AppChordColors.light;
}

/// Atajo para recuperar la extensión desde un tema.
AppChordColors chordColorsOfTheme(ThemeData theme) {
  final AppChordColors? colors = theme.extension<AppChordColors>();
  return colors ?? AppChordColors.light;
}
