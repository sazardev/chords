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
class ScaleHarmonyCard extends StatefulWidget {
  /// Crea la tarjeta de [scale] en la tónica [tonic].
  const ScaleHarmonyCard({required this.scale, required this.tonic, super.key});

  /// Escala.
  final ScaleType scale;

  /// Tónica (0 = Do).
  final int tonic;

  @override
  State<ScaleHarmonyCard> createState() => _ScaleHarmonyCardState();
}

class _ScaleHarmonyCardState extends State<ScaleHarmonyCard> {
  bool _sevenths = true;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ScaleHarmony harmony = ScaleHarmony(widget.scale, widget.tonic);
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
            SegmentedButton<bool>(
              segments: <ButtonSegment<bool>>[
                ButtonSegment<bool>(
                  value: false,
                  label: Text(t.scalesPlus.triads),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text(t.scalesPlus.sevenths),
                ),
              ],
              selected: <bool>{_sevenths},
              onSelectionChanged: (Set<bool> value) =>
                  setState(() => _sevenths = value.first),
            ),
            const SizedBox(height: 10),
            _ChordChips(chords: harmony.chords(sevenths: _sevenths)),
          ] else
            AppText(
              t.scalesPlus.noHarmony(n: widget.scale.length),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              maxLines: 3,
            ),
        ],
      ),
    );
  }
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
