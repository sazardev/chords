import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/mini_game_catalog.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Tarjeta de un minijuego en el catálogo: icono, nombre, estrellas y la
/// marca de novedad.
class MiniGameCard extends StatelessWidget {
  /// Crea la tarjeta de [kind] con las [stars] ganadas (0-3).
  const MiniGameCard({
    required this.kind,
    required this.stars,
    required this.onTap,
    super.key,
  });

  /// Juego que representa.
  final MiniGameKind kind;

  /// Mejores estrellas ganadas.
  final int stars;

  /// Abre el juego.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    miniGameIcon(kind),
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              const Spacer(),
              if (kind.isNew) const _NewBadge(),
              if (kind.usesMic)
                Tooltip(
                  message: t.minigames.needsMic,
                  child: Icon(
                    Icons.mic_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          AppText(
            gameTitle(t, kind),
            variant: AppTextVariant.titleMedium,
            maxLines: 2,
          ),
          const SizedBox(height: 2),
          AppText(
            gameDescription(t, kind),
            variant: AppTextVariant.labelMedium,
            color: scheme.onSurfaceVariant,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Semantics(
            label: '$stars/3',
            child: Row(
              children: <Widget>[
                for (int i = 0; i < 3; i++)
                  Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 20,
                    color: i < stars ? scheme.primary : scheme.outlineVariant,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Marca de los juegos recién añadidos (solo un icono: la tarjeta es
/// estrecha en el móvil).
class _NewBadge extends StatelessWidget {
  const _NewBadge();

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String label = context.t.chordGames.newBadge;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Tooltip(
        message: label,
        child: Icon(
          Icons.fiber_new_rounded,
          size: 26,
          semanticLabel: label,
          color: scheme.tertiary,
        ),
      ),
    );
  }
}
