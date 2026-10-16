import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/hub_filter.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/molecules/search_field.dart';
import 'package:flutter/material.dart';

/// Buscador del catálogo y chips para elegir una familia o las novedades.
class HubSearchBar extends StatelessWidget {
  /// Crea el buscador con el [filter] actual; [onChanged] recibe el nuevo.
  const HubSearchBar({
    required this.filter,
    required this.onChanged,
    super.key,
  });

  /// Filtro en uso.
  final HubFilter filter;

  /// Se llama con el filtro nuevo cuando cambia el texto o un chip.
  final ValueChanged<HubFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SearchField(
          hintText: t.chordGames.searchHint,
          initialValue: filter.query,
          onChanged: (String value) => onChanged(filter.withQuery(value)),
        ),
        const SizedBox(height: 10),
        Semantics(
          label: t.chordGames.filterLabel,
          container: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _chip(
                  label: t.chordGames.filterAll,
                  selected: _onlyQuery,
                  onSelected: () => onChanged(HubFilter(query: filter.query)),
                ),
                _chip(
                  label: t.chordGames.filterNew,
                  selected: filter.onlyNew,
                  onSelected: () =>
                      onChanged(filter.withOnlyNew(value: !filter.onlyNew)),
                  icon: Icons.auto_awesome_rounded,
                ),
                for (final MiniGameCategory category in kHubCategoryOrder)
                  _chip(
                    label: categoryTitle(t, category),
                    selected: filter.category == category,
                    onSelected: () => onChanged(
                      filter.withCategory(
                        filter.category == category ? null : category,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Solo hay texto buscado: sigue contando como "todos".
  bool get _onlyQuery => filter.category == null && !filter.onlyNew;

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    IconData? icon,
  }) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      avatar: icon == null ? null : Icon(icon, size: 18),
      selected: selected,
      onSelected: (bool _) => onSelected(),
    ),
  );
}
