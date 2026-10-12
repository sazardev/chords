import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/mini_game_card.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Catálogo de juegos: oído, mástil y dedos, y tocar con el micrófono.
class MiniGamesHubPage extends StatelessWidget {
  /// Crea el catálogo.
  const MiniGamesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final MiniGameProgressController progress = context
        .watch<MiniGameProgressController>();
    return Scaffold(
      appBar: AppBar(title: Text(t.minigames.hubTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: <Widget>[
                Entrance(child: _ProgressCard(progress: progress)),
                const SizedBox(height: 12),
                const Entrance(index: 1, child: _ChordGameCard()),
                for (final MiniGameCategory category
                    in MiniGameCategory.values) ...<Widget>[
                  const SizedBox(height: 24),
                  _CategorySection(category: category, progress: progress),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});

  final MiniGameProgressController progress;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.minigames.hubSubtitle,
            variant: AppTextVariant.titleMedium,
            color: scheme.onPrimaryContainer,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Icon(Icons.star_rounded, color: scheme.onPrimaryContainer),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  t.minigames.starsTotal(
                    earned: progress.totalStars,
                    total: progress.maxStars,
                  ),
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.totalStars / progress.maxStars,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChordGameCard extends StatelessWidget {
  const _ChordGameCard();

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

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.progress});

  final MiniGameCategory category;
  final MiniGameProgressController progress;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<MiniGameKind> games = MiniGameKind.of(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(categoryTitle(t, category), variant: AppTextVariant.titleLarge),
        AppText(
          categorySubtitle(t, category),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _card(BuildContext context, MiniGameKind kind) => MiniGameCard(
    kind: kind,
    stars: progress.starsFor(kind),
    onTap: () => context.push('$kMiniGamePath?kind=${kind.id}'),
  );
}
