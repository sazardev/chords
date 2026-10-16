import 'package:chords/domain/chords/entities/chord_family.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/level_filter_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Abre la hoja de filtros avanzados de la biblioteca.
Future<void> showChordFiltersSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext sheet) => const ChordFiltersSheet(),
    );

/// Filtros avanzados: nivel, tipo de acorde y dificultad máxima.
///
/// Sacarlos de la pantalla principal la deja limpia; aquí se ajustan con
/// calma y el botón inferior muestra al vuelo cuántos acordes quedan.
class ChordFiltersSheet extends StatelessWidget {
  /// Crea la hoja.
  const ChordFiltersSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordFilterController filters = context
        .watch<ChordFilterController>();
    final ChordsController chords = context.watch<ChordsController>();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AppText(
                    t.chords.filters,
                    variant: AppTextVariant.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: filters.clearFilters,
                  child: Text(t.chords.reset),
                ),
              ],
            ),
          ),
          Flexible(child: _Body(filters: filters)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '${t.chords.apply} · '
                '${t.chords.results(n: chords.visibleChords.length)}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contenido desplazable: nivel, tipo de acorde y dificultad máxima.
class _Body extends StatelessWidget {
  const _Body({required this.filters});

  final ChordFilterController filters;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final int? max = filters.filters.maxDifficulty;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Title(t.chords.filterLevel),
          LevelFilterRow(
            selected: filters.filters.level,
            onSelected: filters.selectLevel,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
          _Title(t.chords.filterQuality),
          for (final ChordFamily family in ChordFamily.values) ...<Widget>[
            _FamilyLabel(t.chordTheory.families[family.name] ?? family.name),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final ChordQuality quality in ChordQuality.values)
                  if (quality.family == family)
                    FilterChip(
                      label: Text(qualityLabel(t, quality)),
                      selected: filters.filters.quality == quality,
                      onSelected: (_) => filters.selectQuality(
                        filters.filters.quality == quality ? null : quality,
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 20),
          _Title(t.chords.maxDifficulty(level: max ?? 5)),
          Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: (max ?? 5).toDouble(),
            label: '${max ?? 5}',
            onChanged: (double value) =>
                filters.setMaxDifficulty(value == 5 ? null : value.round()),
          ),
        ],
      ),
    );
  }
}

class _FamilyLabel extends StatelessWidget {
  const _FamilyLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: AppText(
      text,
      variant: AppTextVariant.labelMedium,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: AppText(
      text,
      variant: AppTextVariant.titleMedium,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
