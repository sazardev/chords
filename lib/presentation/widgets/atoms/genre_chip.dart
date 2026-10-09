import 'package:flutter/material.dart';

/// Chip de filtro por género musical.
class GenreChip extends StatelessWidget {
  /// Crea el chip.
  const GenreChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Nombre del género.
  final String label;

  /// Si está seleccionado.
  final bool selected;

  /// Callback al pulsar.
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => FilterChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
    showCheckmark: false,
    selectedColor: Theme.of(context).colorScheme.secondaryContainer,
  );
}
