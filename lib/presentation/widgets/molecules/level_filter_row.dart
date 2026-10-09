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

  static const List<String> _labels = <String>[
    'Todos',
    'Nv 1',
    'Nv 2',
    'Nv 3',
    'Nv 4',
    'Nv 5',
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _labels.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 8),
            ChoiceChip(
              label: Text(_labels[i]),
              selected: (i == 0 && selected == null) || i == selected,
              onSelected: (_) => onSelected(i == 0 ? null : i),
              selectedColor: scheme.primaryContainer,
            ),
          ],
        ],
      ),
    );
  }
}
