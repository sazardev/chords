import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
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
    this.leading = const <Widget>[],
    this.highlighted = const <String>{},
  });

  /// Género seleccionado (o `null` = todos).
  final String? selected;

  /// Callback de selección (recibe `null` para "todos").
  final ValueChanged<String?> onSelected;

  /// Géneros mostrados.
  final List<String> genres;

  /// Chips previos a "todos" (p. ej. un atajo "para mi nivel").
  final List<Widget> leading;

  /// Géneros a destacar con una estrella (los favoritos de la persona).
  final Set<String> highlighted;

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
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          for (final Widget chip in leading) ...<Widget>[
            chip,
            const SizedBox(width: 8),
          ],
          GenreChip(
            label: t.chords.filterAll,
            selected: selected == null,
            onSelected: () => onSelected(null),
          ),
          for (final String genre in genres) ...<Widget>[
            const SizedBox(width: 8),
            GenreChip(
              label: genreLabel(t, genre),
              starred: highlighted.contains(genre),
              selected: selected == genre,
              onSelected: () => onSelected(selected == genre ? null : genre),
            ),
          ],
        ],
      ),
    );
  }
}
