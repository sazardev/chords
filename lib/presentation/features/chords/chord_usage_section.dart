import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/chord_progression_usage.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Dónde se usa el acorde: los géneros donde aparece, las progresiones del
/// catálogo que lo incluyen y la escala para improvisar encima.
class ChordUsageSection extends StatelessWidget {
  /// Crea la sección del [chord] con su información [insights].
  const ChordUsageSection({
    required this.chord,
    required this.insights,
    super.key,
  });

  /// Acorde mostrado.
  final Chord chord;

  /// Progresiones y escalas ya calculadas.
  final ChordInsights insights;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(title: t.chordTheory.whereTitle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Label(t.chordTheory.genresLabel),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    for (final String genre in chord.quality.genres)
                      ActionChip(
                        label: Text(genreLabel(t, genre)),
                        onPressed: () => context.go(
                          '$kChordsPath?genre=${Uri.encodeComponent(genre)}',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                _Label(t.chordTheory.progressionsLabel),
                const SizedBox(height: 4),
                if (insights.progressions.isEmpty)
                  AppText(
                    t.chordTheory.noProgressions,
                    color: scheme.onSurfaceVariant,
                    maxLines: 2,
                  ),
                for (final ProgressionUse use in insights.progressions)
                  _ProgressionRow(use: use),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _ScaleCard(chord: chord, scales: insights.scales),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      AppText(text, variant: AppTextVariant.titleMedium);
}

/// Una progresión con su grado y sus acordes en la tonalidad que lo contiene.
class _ProgressionRow extends StatelessWidget {
  const _ProgressionRow({required this.use});

  final ProgressionUse use;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final String key = noteLabel(t, use.tonic);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(progressionName(t, use.progression)),
      subtitle: Text(
        '${t.chordTheory.progressionRow(degree: use.degree, key: key)}: '
        '${use.chords.map((ChordSymbol c) => c.name).join(' – ')}',
      ),
      trailing: const Icon(Icons.play_circle_outline_rounded),
      onTap: () => unawaited(
        context.push('$kJamPath?prog=${use.progression.id}&key=${use.tonic}'),
      ),
    );
  }
}

/// Escalas para improvisar sobre el acorde, con un salto al explorador.
class _ScaleCard extends StatelessWidget {
  const _ScaleCard({required this.chord, required this.scales});

  final Chord chord;
  final List<ScaleType> scales;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ScaleType best = scales.first;
    final int tonic = chord.root.pitchClass;
    return AppCard(
      color: Theme.of(context).colorScheme.secondaryContainer,
      onTap: () => unawaited(
        context.push('$kScalesPath?scale=${best.id}&key=$tonic&pos=1'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.scalesPlus.chordScalesTitle,
            variant: AppTextVariant.titleMedium,
          ),
          const SizedBox(height: 4),
          AppText(
            t.scalesPlus.chordScaleHint(
              chord: chord.name,
              scale: scaleInKey(t, best, tonic),
            ),
            maxLines: 3,
          ),
          if (scales.length > 1) ...<Widget>[
            const SizedBox(height: 2),
            AppText(
              t.scalesPlus.chordScaleAlso(
                scales: scales
                    .skip(1)
                    .map((ScaleType s) => scaleName(t, s))
                    .join(' · '),
              ),
              variant: AppTextVariant.labelMedium,
              maxLines: 3,
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const Icon(Icons.stairs_rounded, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  t.scalesPlus.openInExplorer,
                  variant: AppTextVariant.labelLarge,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
