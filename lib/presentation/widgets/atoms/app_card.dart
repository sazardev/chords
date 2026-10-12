import 'package:chords/presentation/widgets/atoms/press_scale.dart';
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
    this.borderRadius = 28,
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

  /// Color de fondo (por defecto `surfaceContainer` del tema).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget content = Padding(padding: padding, child: child);
    final Widget card = Material(
      color: color ?? scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
    return onTap == null ? card : PressScale(child: card);
  }
}
