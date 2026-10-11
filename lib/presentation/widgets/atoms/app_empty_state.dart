import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Estado vacío genérico con icono, título y mensaje.
class AppEmptyState extends StatelessWidget {
  /// Crea el estado vacío.
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  /// Icono representativo.
  final IconData icon;

  /// Título principal.
  final String title;

  /// Mensaje de ayuda.
  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56, color: scheme.outline),
            const SizedBox(height: 12),
            AppText(title, variant: AppTextVariant.titleLarge, maxLines: 2),
            const SizedBox(height: 6),
            AppText(
              message,
              color: scheme.onSurfaceVariant,
              align: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
