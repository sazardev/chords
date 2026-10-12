import 'package:flutter/material.dart';

/// Chip de filtro por género musical.
class GenreChip extends StatelessWidget {
  /// Crea el chip.
  const GenreChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
    this.starred = false,
  });

  /// Nombre del género.
  final String label;

  /// Si está seleccionado.
  final bool selected;

  /// Callback al pulsar.
  final VoidCallback onSelected;

  /// Si se marca con una estrella (género favorito).
  final bool starred;

  @override
  Widget build(BuildContext context) => FilterChip(
    avatar: starred ? const Icon(Icons.star_rounded, size: 16) : null,
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
    showCheckmark: false,
    selectedColor: Theme.of(context).colorScheme.secondaryContainer,
  );
}
