import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';

/// Diagrama de la posición del acorde que más se parece a lo que suena.
///
/// Al tocarla se abre la ficha del acorde. Respeta el modo zurdo con
/// [mirror], igual que el resto de diagramas.
class ClosestPositionCard extends StatelessWidget {
  /// Crea la tarjeta.
  const ClosestPositionCard({
    required this.chord,
    required this.variant,
    required this.onTap,
    super.key,
    this.mirror = false,
  });

  /// Acorde del banco.
  final Chord chord;

  /// Posición mostrada.
  final ChordVariant variant;

  /// Acción al pulsar la tarjeta.
  final VoidCallback onTap;

  /// Si el diagrama se invierte para zurdos.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          ChordDiagram(
            variant: variant,
            mirror: mirror,
            width: 108,
            height: 138,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.liveChords.positionTitle,
                  variant: AppTextVariant.labelLarge,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                AppText(
                  chord.name,
                  variant: AppTextVariant.headlineMedium,
                  weight: FontWeight.w800,
                ),
                AppText(
                  variant.positionLabel,
                  color: scheme.onSurfaceVariant,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                AppText(
                  t.liveChords.positionHint(name: chord.name),
                  variant: AppTextVariant.labelMedium,
                  color: scheme.primary,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
