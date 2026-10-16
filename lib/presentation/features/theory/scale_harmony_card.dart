import 'dart:async' show unawaited;

import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/scale_harmony.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Acordes que nacen de la escala (tríadas o séptimas) con su grado; al
/// tocarlos abre la ficha del acorde. Las escalas que no tienen siete notas
/// no forman acordes por terceras y lo explican.
class ScaleHarmonyCard extends StatelessWidget {
  /// Crea la tarjeta de [scale] en la tónica [tonic].
  const ScaleHarmonyCard({required this.scale, required this.tonic, super.key});

  /// Escala.
  final ScaleType scale;

  /// Tónica (0 = Do).
  final int tonic;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ScaleHarmony harmony = ScaleHarmony(scale, tonic);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.scalesPlus.harmonyTitle,
            variant: AppTextVariant.titleMedium,
          ),
          const SizedBox(height: 10),
          if (harmony.hasHarmony) ...<Widget>[
            _Row(label: t.scalesPlus.triads, chords: harmony.chords()),
            const SizedBox(height: 12),
            _Row(
              label: t.scalesPlus.sevenths,
              chords: harmony.chords(sevenths: true),
            ),
          ] else
            AppText(
              t.scalesPlus.noHarmony(n: scale.length),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              maxLines: 3,
            ),
        ],
      ),
    );
  }
}

/// Un grupo de acordes (tríadas o séptimas) con su título.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.chords});

  final String label;
  final List<DiatonicChord> chords;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AppText(
        label,
        variant: AppTextVariant.labelLarge,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      const SizedBox(height: 6),
      _ChordChips(chords: chords),
    ],
  );
}

class _ChordChips extends StatelessWidget {
  const _ChordChips({required this.chords});

  final List<DiatonicChord> chords;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final DiatonicChord chord in chords)
          ActionChip(
            avatar: CircleAvatar(
              backgroundColor: chord.degree == 1
                  ? scheme.primary
                  : scheme.secondaryContainer,
              child: Text(
                chord.roman,
                style: TextStyle(
                  fontSize: 9,
                  color: chord.degree == 1
                      ? scheme.onPrimary
                      : scheme.onSecondaryContainer,
                ),
              ),
            ),
            label: Text(chord.symbol.name),
            onPressed: () =>
                unawaited(context.push(chordDetailRoute(chord.symbol.chordId))),
          ),
      ],
    );
  }
}
