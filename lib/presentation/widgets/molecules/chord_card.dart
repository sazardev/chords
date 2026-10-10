import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';

/// Tarjeta de acorde para listados y sugerencias en vivo.
class ChordCard extends StatelessWidget {
  /// Crea la tarjeta.
  const ChordCard({
    required this.chord,
    required this.onTap,
    required this.onPlay,
    super.key,
    this.playing = false,
    this.mirror = false,
  });

  /// Acorde mostrado.
  final Chord chord;

  /// Acción al pulsar la tarjeta.
  final VoidCallback onTap;

  /// Acción al reproducir el acorde.
  final VoidCallback onPlay;

  /// Si este acorde está sonando.
  final bool playing;

  /// Si el diagrama se muestra en espejo.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Center(
              child: ChordDiagram(
                variant: chord.easiestVariant,
                mirror: mirror,
                width: 96,
                height: 120,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AppText(chord.name, variant: AppTextVariant.titleLarge),
          AppText(
            t.chords.positionCount(n: chord.variantCount),
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              DifficultyBadge(difficulty: chord.difficulty, compact: true),
              const Spacer(),
              ChordPlayButton(
                onPressed: onPlay,
                loading: playing,
                size: 36,
                tooltip: t.chordDetail.listenPosition(position: chord.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
