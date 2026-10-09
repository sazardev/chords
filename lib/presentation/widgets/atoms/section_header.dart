import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Encabezado de sección con acción opcional a la derecha.
class SectionHeader extends StatelessWidget {
  /// Crea el encabezado.
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  /// Título de la sección.
  final String title;

  /// Texto de la acción (p. ej. `Ver todo`).
  final String? actionLabel;

  /// Callback de la acción.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    child: Row(
      children: <Widget>[
        Expanded(child: AppText(title, variant: AppTextVariant.titleLarge)),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    ),
  );
}
