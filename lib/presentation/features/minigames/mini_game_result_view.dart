import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:flutter/material.dart';

/// Resultado de una partida: estrellas, aciertos y racha.
class MiniGameResultView extends StatelessWidget {
  /// Crea el resultado de una partida con [score] en [level].
  const MiniGameResultView({
    required this.score,
    required this.level,
    required this.isNewBest,
    required this.onPlayAgain,
    required this.onMoreGames,
    super.key,
  });

  /// Marcador final.
  final MiniGameScore score;

  /// Dificultad jugada.
  final MiniGameLevel level;

  /// Si el resultado es un récord.
  final bool isNewBest;

  /// Repite la partida en la misma dificultad.
  final ValueChanged<MiniGameLevel> onPlayAgain;

  /// Vuelve al catálogo.
  final VoidCallback onMoreGames;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        const SizedBox(height: 16),
        Entrance(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < 3; i++)
                Icon(
                  i < score.stars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 64,
                  color: i < score.stars
                      ? scheme.primary
                      : scheme.outlineVariant,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppText(
          resultTitle(t, score.stars),
          variant: AppTextVariant.headlineMedium,
          weight: FontWeight.w800,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        AppText(
          t.minigames.resultCorrect(correct: score.correct, total: score.total),
          variant: AppTextVariant.titleLarge,
          align: TextAlign.center,
        ),
        const SizedBox(height: 4),
        AppText(
          '${score.percent}% · ${t.minigames.resultStreak(n: score.bestStreak)}'
          ' · ${t.minigames.resultPoints(n: score.points)}',
          color: scheme.onSurfaceVariant,
          align: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        if (isNewBest) ...<Widget>[
          const SizedBox(height: 12),
          Center(
            child: Chip(
              avatar: const Icon(Icons.emoji_events_rounded),
              label: Text(t.minigames.newBest),
            ),
          ),
        ],
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: () => onPlayAgain(level),
          icon: const Icon(Icons.replay_rounded),
          label: Text(t.minigames.playAgain),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onMoreGames,
          icon: const Icon(Icons.apps_rounded),
          label: Text(t.minigames.moreGames),
        ),
      ],
    );
  }
}
