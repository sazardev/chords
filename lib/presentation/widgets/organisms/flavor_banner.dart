import 'package:flutter/material.dart';

/// Bandeja superior que identifica el flavor fuera de producción.
class FlavorBanner extends StatelessWidget {
  /// Crea el banner.
  const FlavorBanner({
    required this.visible,
    required this.text,
    required this.child,
    super.key,
  });

  /// Si el banner se muestra.
  final bool visible;

  /// Texto mostrado (nombre del flavor).
  final String text;

  /// Contenido de la aplicación.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return child;
    }
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: scheme.tertiaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SafeArea(
            bottom: false,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onTertiaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
