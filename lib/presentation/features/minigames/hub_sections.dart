import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/hub_guitar_nav.dart';
import 'package:chords/presentation/features/minigames/mini_game_card.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tarjeta de la serie "toca el acorde", la primera del catálogo.
class HubChordGameCard extends StatelessWidget {
  /// Crea la tarjeta.
  const HubChordGameCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.tertiaryContainer,
      onTap: () => context.push(kChordGamePath),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.sports_esports_rounded,
            size: 32,
            color: scheme.onTertiaryContainer,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.minigames.chordGameTitle,
                  variant: AppTextVariant.titleMedium,
                  color: scheme.onTertiaryContainer,
                ),
                AppText(
                  t.minigames.chordGameSubtitle,
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onTertiaryContainer.withValues(alpha: 0.8),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: scheme.onTertiaryContainer),
        ],
      ),
    );
  }
}

/// Una familia de juegos del catálogo: título, resumen y sus tarjetas.
class HubCategorySection extends StatelessWidget {
  /// Crea la sección de [category] con los [games] que se ven.
  const HubCategorySection({
    required this.category,
    required this.games,
    required this.progress,
    required this.focused,
    required this.keyOf,
    super.key,
  });

  /// Familia que representa.
  final MiniGameCategory category;

  /// Juegos de la familia que pasan el filtro.
  final List<MiniGameKind> games;

  /// Progreso (estrellas) de cada juego.
  final MiniGameProgressController progress;

  /// Juego seleccionado con la guitarra; `null` si ninguno.
  final MiniGameKind? focused;

  /// Llave de cada juego, para llevar la lista hasta el seleccionado.
  final GlobalKey Function(MiniGameKind kind) keyOf;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Expanded(
              child: AppText(
                categoryTitle(t, category),
                variant: AppTextVariant.titleLarge,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 8),
            AppText(
              t.chordGames.gamesCount(n: games.length),
              variant: AppTextVariant.labelMedium,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
        AppText(
          categorySubtitle(t, category),
          color: scheme.onSurfaceVariant,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < games.length; i += 2) ...<Widget>[
          if (i > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: _card(context, games[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < games.length
                      ? _card(context, games[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _card(BuildContext context, MiniGameKind kind) => HubFocus(
    key: keyOf(kind),
    focused: focused == kind,
    child: MiniGameCard(
      kind: kind,
      stars: progress.starsFor(kind),
      onTap: () => context.push('$kMiniGamePath?kind=${kind.id}'),
    ),
  );
}
