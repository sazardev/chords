import 'package:flutter/material.dart';

/// Variantes tipográficas disponibles para [AppText].
enum AppTextVariant {
  /// Título muy grande (pantalla de inicio).
  displayLarge,

  /// Título de sección.
  headlineMedium,

  /// Título de tarjeta o diálogo.
  titleLarge,

  /// Título medio.
  titleMedium,

  /// Texto de cuerpo principal.
  bodyLarge,

  /// Texto de cuerpo secundario.
  bodyMedium,

  /// Etiqueta de botón.
  labelLarge,

  /// Etiqueta pequeña.
  labelMedium,
}

/// Texto con la escala tipográfica del tema aplicada.
class AppText extends StatelessWidget {
  /// Crea un texto estilizado.
  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.maxLines,
    this.align,
    this.overflow,
    this.weight,
  });

  /// Contenido del texto.
  final String text;

  /// Variante tipográfica.
  final AppTextVariant variant;

  /// Color opcional (por defecto el del tema).
  final Color? color;

  /// Máximo de líneas.
  final int? maxLines;

  /// Alineación del texto.
  final TextAlign? align;

  /// Comportamiento ante desbordes.
  final TextOverflow? overflow;

  /// Peso tipográfico opcional.
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    final TextStyle? base = _styleFor(context);
    return Text(
      text,
      style: base?.copyWith(color: color, fontWeight: weight),
      maxLines: maxLines,
      textAlign: align,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }

  TextStyle? _styleFor(BuildContext context) => switch (variant) {
    AppTextVariant.displayLarge => Theme.of(context).textTheme.displayLarge,
    AppTextVariant.headlineMedium => Theme.of(context).textTheme.headlineMedium,
    AppTextVariant.titleLarge => Theme.of(context).textTheme.titleLarge,
    AppTextVariant.titleMedium => Theme.of(context).textTheme.titleMedium,
    AppTextVariant.bodyLarge => Theme.of(context).textTheme.bodyLarge,
    AppTextVariant.bodyMedium => Theme.of(context).textTheme.bodyMedium,
    AppTextVariant.labelLarge => Theme.of(context).textTheme.labelLarge,
    AppTextVariant.labelMedium => Theme.of(context).textTheme.labelMedium,
  };
}
