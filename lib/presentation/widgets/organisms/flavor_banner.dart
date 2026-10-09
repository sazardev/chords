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
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SafeArea(
            bottom: false,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
