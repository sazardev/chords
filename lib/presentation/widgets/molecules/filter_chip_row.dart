import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:flutter/material.dart';

/// Fila desplazable de chips de filtro para las calidades de acorde.
class FilterChipRow extends StatelessWidget {
  /// Crea la fila de chips.
  const FilterChipRow({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Calidad seleccionada (o `null` = todas).
  final ChordQuality? selected;

  /// Callback de selección (recibe `null` para "todas").
  final ValueChanged<ChordQuality?> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          FilterChip(
            label: Text(t.chords.filterAllQualities),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final ChordQuality quality in ChordQuality.values) ...<Widget>[
            const SizedBox(width: 8),
            FilterChip(
              label: Text(qualityLabel(t, quality)),
              selected: selected == quality,
              onSelected: (_) =>
                  onSelected(selected == quality ? null : quality),
            ),
          ],
        ],
      ),
    );
  }
}
