import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Acordes parientes: la misma raíz con otro color (mayor, menor, 7, maj7,
/// sus, add9…) y la relativa. Un toque salta a su ficha.
class ChordRelativesSection extends StatelessWidget {
  /// Crea la sección del [chord] con su información [insights].
  const ChordRelativesSection({
    required this.chord,
    required this.insights,
    super.key,
  });

  /// Acorde mostrado.
  final Chord chord;

  /// Parientes ya calculados.
  final ChordInsights insights;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final Chord? relative = insights.relative;
    if (insights.relatives.isEmpty && relative == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(title: t.chordTheory.relativesTitle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppText(
            t.chordTheory.relativesHint,
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (relative != null)
                _RelativeChip(
                  chord: relative,
                  label: t.chordTheory.relativeOf(name: relative.name),
                  highlighted: true,
                ),
              for (final Chord other in insights.relatives)
                _RelativeChip(chord: other, label: other.name),
            ],
          ),
        ),
      ],
    );
  }
}

class _RelativeChip extends StatelessWidget {
  const _RelativeChip({
    required this.chord,
    required this.label,
    this.highlighted = false,
  });

  final Chord chord;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Tooltip(
      message: '${chord.displayName} · ${qualityLabel(t, chord.quality)}',
      child: ActionChip(
        avatar: highlighted
            ? const Icon(Icons.swap_horiz_rounded, size: 18)
            : null,
        label: Text(label),
        onPressed: () => context.pushReplacement(chordDetailRoute(chord.id)),
      ),
    );
  }
}
