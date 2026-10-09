import 'package:flutter/material.dart';

/// Botón circular para reproducir el sonido de un acorde.
class ChordPlayButton extends StatelessWidget {
  /// Crea el botón.
  const ChordPlayButton({
    required this.onPressed,
    super.key,
    this.loading = false,
    this.size = 44,
    this.tooltip = 'Escuchar acorde',
  });

  /// Acción al pulsar.
  final VoidCallback onPressed;

  /// Si está reproduciendo.
  final bool loading;

  /// Diámetro del botón.
  final double size;

  /// Texto de ayuda.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: size,
          height: size,
          child: loading
              ? Center(
                  child: SizedBox(
                    width: size / 2.5,
                    height: size / 2.5,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Material(
                  color: scheme.secondaryContainer,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onPressed,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: scheme.onSecondaryContainer,
                      size: size / 2,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
