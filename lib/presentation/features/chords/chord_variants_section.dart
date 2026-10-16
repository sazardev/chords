import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_detail_controller.dart';
import 'package:chords/presentation/l10n/variant_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';

/// Las posiciones del acorde: las mismas notas en otros trastes, con filtros
/// por tipo (abiertas, cejilla, inversiones, drop 2…).
class ChordVariantsSection extends StatelessWidget {
  /// Crea la sección con el estado de [controller].
  const ChordVariantsSection({required this.controller, super.key});

  /// Controlador del detalle.
  final ChordDetailController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final Chord chord = controller.chord!;
    final List<int> visible = controller.visibleVariantIndices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(title: t.chordTheory.variantsTitle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppText(
            t.chordTheory.positionsCount(n: chord.variantCount),
            variant: AppTextVariant.labelLarge,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _FilterRow(controller: controller),
        const SizedBox(height: 4),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: AppText(t.chordTheory.variantsEmpty),
          ),
        for (final int index in visible)
          _VariantTile(controller: controller, index: index),
      ],
    );
  }
}

/// Chips para quedarse solo con un tipo de posición.
class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.controller});

  final ChordDetailController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<String> tags = controller.filterTags;
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          ChoiceChip(
            label: Text(t.chordTheory.filterAll),
            selected: controller.variantFilter == null,
            onSelected: (_) => controller.setVariantFilter(null),
          ),
          for (final String tag in tags) ...<Widget>[
            const SizedBox(width: 6),
            ChoiceChip(
              label: Text(t.chordTheory.tags[tag] ?? tag),
              selected: controller.variantFilter == tag,
              onSelected: (_) => controller.setVariantFilter(
                controller.variantFilter == tag ? null : tag,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VariantTile extends StatelessWidget {
  const _VariantTile({required this.controller, required this.index});

  final ChordDetailController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ThemeData theme = Theme.of(context);
    final Chord chord = controller.chord!;
    final ChordVariant variant = chord.variants[index];
    final bool selected = index == controller.selectedIndex;
    final String notes = t.chordDetail.notes(notes: variant.notes.join(' · '));
    return ListTile(
      selected: selected,
      leading: ChordDiagram(
        variant: variant,
        showFingers: false,
        width: 44,
        height: 56,
      ),
      title: Text(variantTitle(t, chord, variant)),
      subtitle: Text(
        index == 0 ? '${t.chordDetail.recommended} · $notes' : notes,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DifficultyBadge(difficulty: variant.difficulty, compact: true),
          const SizedBox(width: 8),
          ChordPlayButton(
            size: 36,
            tooltip: t.chordDetail.listenPosition(
              position: variantTitle(t, chord, variant),
            ),
            onPressed: () {
              controller.selectVariant(index);
              unawaited(controller.playSelected());
            },
          ),
        ],
      ),
      onTap: () => controller.selectVariant(index),
      tileColor: selected ? theme.colorScheme.surfaceContainerHigh : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
