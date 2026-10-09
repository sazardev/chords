import 'package:chords/presentation/widgets/atoms/genre_chip.dart';
import 'package:flutter/material.dart';

/// Fila desplazable de chips de género musical.
class GenreFilterRow extends StatelessWidget {
  /// Crea la fila de géneros.
  const GenreFilterRow({
    required this.selected,
    required this.onSelected,
    super.key,
    this.genres = kDefaultGenreFilters,
  });

  /// Género seleccionado (o `null` = todos).
  final String? selected;

  /// Callback de selección (recibe `null` para "todos").
  final ValueChanged<String?> onSelected;

  /// Géneros mostrados.
  final List<String> genres;

  /// Géneros por defecto de la biblioteca.
  static const List<String> kDefaultGenreFilters = <String>[
    'Pop',
    'Rock',
    'Blues',
    'Funk',
    'Jazz',
    'Balada',
    'Latino',
    'Metal',
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: <Widget>[
        GenreChip(
          label: 'Todos',
          selected: selected == null,
          onSelected: () => onSelected(null),
        ),
        for (final String genre in genres) ...<Widget>[
          const SizedBox(width: 8),
          GenreChip(
            label: genre,
            selected: selected == genre,
            onSelected: () => onSelected(selected == genre ? null : genre),
          ),
        ],
      ],
    ),
  );
}
