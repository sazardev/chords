import 'package:flutter/material.dart';

/// Indicador circular de progreso con etiqueta central.
class ProgressRing extends StatelessWidget {
  /// Crea el anillo de progreso.
  const ProgressRing({
    required this.progress,
    super.key,
    this.size = 96,
    this.label,
  });

  /// Progreso entre 0 y 1.
  final double progress;

  /// Diámetro del anillo.
  final double size;

  /// Texto grande central.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double value = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 9,
              backgroundColor: scheme.surfaceContainerHighest,
              strokeCap: StrokeCap.round,
            ),
          ),
          if (label != null)
            Text(
              label!,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
        ],
      ),
    );
  }
}
