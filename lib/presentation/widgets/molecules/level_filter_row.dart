import 'package:chords/l10n/translations.g.dart';
import 'package:flutter/material.dart';

/// Fila de chips para filtrar por nivel de aprendizaje.
class LevelFilterRow extends StatelessWidget {
  /// Crea la fila de niveles.
  const LevelFilterRow({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Nivel seleccionado (o `null` = todos).
  final int? selected;

  /// Callback de selección (recibe `null` para "todos").
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          for (int level = 0; level <= 5; level++) ...<Widget>[
            if (level > 0) const SizedBox(width: 8),
            ChoiceChip(
              label: Text(
                level == 0
                    ? t.chords.filterAll
                    : t.chords.levelShort(level: level),
              ),
              selected: (level == 0 && selected == null) || level == selected,
              onSelected: (_) => onSelected(level == 0 ? null : level),
              selectedColor: scheme.primaryContainer,
            ),
          ],
        ],
      ),
    );
  }
}
