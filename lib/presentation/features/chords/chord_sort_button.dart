import 'package:chords/domain/chords/services/chord_sorter.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter/material.dart';

/// Botón de la barra superior que elige el orden de la lista de acordes.
class ChordSortButton extends StatelessWidget {
  /// Crea el botón con el orden [selected].
  const ChordSortButton({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Orden activo.
  final ChordSort selected;

  /// Se llama al elegir otro orden.
  final ValueChanged<ChordSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return PopupMenuButton<ChordSort>(
      tooltip: t.chordTheory.sortTooltip,
      icon: Badge(
        isLabelVisible: selected != ChordSort.essentials,
        smallSize: 8,
        child: const Icon(Icons.sort_rounded),
      ),
      initialValue: selected,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ChordSort>>[
        for (final ChordSort sort in ChordSort.values)
          CheckedPopupMenuItem<ChordSort>(
            value: sort,
            checked: sort == selected,
            child: Text(_label(t, sort)),
          ),
      ],
    );
  }

  String _label(Translations t, ChordSort sort) => switch (sort) {
    ChordSort.essentials => t.chordTheory.sortEssentials,
    ChordSort.difficulty => t.chordTheory.sortDifficulty,
    ChordSort.root => t.chordTheory.sortRoot,
    ChordSort.quality => t.chordTheory.sortQuality,
  };
}
