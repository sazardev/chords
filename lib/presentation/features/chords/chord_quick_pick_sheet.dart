import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_family.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Abre el selector rápido de nota y tipo de acorde.
Future<void> showChordQuickPickSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext sheet) => const ChordQuickPickSheet(),
    );

/// Selector rápido: la nota (12 chips) y el tipo de acorde agrupado por
/// familias. Al elegir las dos cosas se puede abrir la ficha directamente.
class ChordQuickPickSheet extends StatelessWidget {
  /// Crea la hoja.
  const ChordQuickPickSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordFilterController filters = context
        .watch<ChordFilterController>();
    final ChordsController chords = context.watch<ChordsController>();
    final ChordRoot? root = filters.filters.root;
    final ChordQuality? quality = filters.filters.quality;
    final Chord? picked = root == null || quality == null
        ? null
        : _find(chords.allChords, root, quality);
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
                    t.chordTheory.pickChord,
                    variant: AppTextVariant.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    filters
                      ..selectRoot(null)
                      ..selectQuality(null);
                  },
                  child: Text(t.chordTheory.pickClear),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Heading(t.chordTheory.pickRoot),
                  _RootChips(filters: filters),
                  const SizedBox(height: 16),
                  _Heading(t.chordTheory.pickQuality),
                  _QualityChips(filters: filters),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      t.chordTheory.pickShow(n: chords.visibleChords.length),
                    ),
                  ),
                ),
                if (picked != null) ...<Widget>[
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).pop();
                      unawaited(context.push(chordDetailRoute(picked.id)));
                    },
                    child: Text(t.chordTheory.pickOpen(name: picked.name)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Chord? _find(List<Chord> all, ChordRoot root, ChordQuality quality) {
    for (final Chord chord in all) {
      if (chord.root == root && chord.quality == quality) {
        return chord;
      }
    }
    return null;
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

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

class _RootChips extends StatelessWidget {
  const _RootChips({required this.filters});

  final ChordFilterController filters;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        for (final ChordRoot root in ChordRoot.values)
          ChoiceChip(
            label: Text(noteLabel(t, root.pitchClass)),
            selected: filters.filters.root == root,
            onSelected: (_) =>
                filters.selectRoot(filters.filters.root == root ? null : root),
          ),
      ],
    );
  }
}

class _QualityChips extends StatelessWidget {
  const _QualityChips({required this.filters});

  final ChordFilterController filters;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final ChordFamily family in ChordFamily.values) ...<Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: AppText(
              t.chordTheory.families[family.name] ?? family.name,
              variant: AppTextVariant.labelMedium,
              color: scheme.onSurfaceVariant,
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (final ChordQuality quality in ChordQuality.values)
                if (quality.family == family)
                  ChoiceChip(
                    label: Text(
                      quality.suffix.isEmpty ? 'maj' : quality.suffix,
                    ),
                    tooltip: qualityLabel(t, quality),
                    selected: filters.filters.quality == quality,
                    onSelected: (_) => filters.selectQuality(
                      filters.filters.quality == quality ? null : quality,
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
