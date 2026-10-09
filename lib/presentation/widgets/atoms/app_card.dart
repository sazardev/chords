import 'package:flutter/material.dart';

/// Tarjeta base con esquinas amplias y respuesta táctil opcional.
class AppCard extends StatelessWidget {
  /// Crea la tarjeta.
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
  });

  /// Contenido de la tarjeta.
  final Widget child;

  /// Acción al pulsar (si es nula, la tarjeta no es interactiva).
  final VoidCallback? onTap;

  /// Relleno interno.
  final EdgeInsetsGeometry padding;

  /// Radio de las esquinas.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(padding: padding, child: child);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: onTap == null
          ? content
          : InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: onTap,
              child: content,
            ),
    );
  }
}
