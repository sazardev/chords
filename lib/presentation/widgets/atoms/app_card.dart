import 'package:flutter/material.dart';

/// Tarjeta plana del sistema de diseño.
///
/// Usa una superficie de color uniforme, sin elevaciones, sombras, degradados
/// ni bordes: la jerarquía se expresa solo con el rol de color.
class AppCard extends StatelessWidget {
  /// Crea la tarjeta.
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.color,
  });

  /// Contenido de la tarjeta.
  final Widget child;

  /// Acción al pulsar (si es nula, la tarjeta no es interactiva).
  final VoidCallback? onTap;

  /// Relleno interno.
  final EdgeInsetsGeometry padding;

  /// Radio de las esquinas.
  final double borderRadius;

  /// Color de fondo (por defecto `surfaceContainerLow` del tema).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget content = Padding(padding: padding, child: child);
    return Material(
      color: color ?? scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
