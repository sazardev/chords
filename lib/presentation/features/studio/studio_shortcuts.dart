import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Un acceso del estudio: icono, título, descripción y destino.
typedef _Shortcut = ({IconData icon, String title, String body, String path});

/// Rejilla con las secciones para aprender la guitarra y su mundo: teoría,
/// escalas, géneros, jam, cancionero e historial.
class StudioShortcuts extends StatelessWidget {
  /// Crea la rejilla.
  const StudioShortcuts({super.key});

  List<_Shortcut> _items(Translations t) => <_Shortcut>[
    (
      icon: Icons.school_rounded,
      title: t.studio.theoryCard,
      body: t.studio.theoryCardBody,
      path: kTheoryPath,
    ),
    (
      icon: Icons.stairs_rounded,
      title: t.studio.scalesCard,
      body: t.studio.scalesCardBody,
      path: kScalesPath,
    ),
    (
      icon: Icons.album_rounded,
      title: t.studio.jamCard,
      body: t.studio.jamCardBody,
      path: kJamPath,
    ),
    (
      icon: Icons.lyrics_rounded,
      title: t.studio.songsCard,
      body: t.studio.songsCardBody,
      path: kSongsPath,
    ),
    (
      icon: Icons.library_music_rounded,
      title: t.studio.genresCard,
      body: t.studio.genresCardBody,
      path: kGenresPath,
    ),
    (
      icon: Icons.history_rounded,
      title: t.studio.historyCard,
      body: t.studio.historyCardBody,
      path: kHistoryPath,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<_Shortcut> items = _items(context.t);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const StreakBanner(),
        const SizedBox(height: 12),
        for (int i = 0; i < items.length; i += 2) ...<Widget>[
          if (i > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _ShortcutCard(item: items[i], index: i),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ShortcutCard(item: items[i + 1], index: i),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({required this.item, required this.index});

  final _Shortcut item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final (Color fill, Color ink) = switch (index ~/ 2) {
      0 => (scheme.primaryContainer, scheme.onPrimaryContainer),
      1 => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      _ => (scheme.secondaryContainer, scheme.onSecondaryContainer),
    };
    return AppCard(
      color: fill,
      borderRadius: 24,
      onTap: () => unawaited(context.push(item.path)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(item.icon, color: ink, size: 28),
          const SizedBox(height: 10),
          AppText(item.title, variant: AppTextVariant.titleMedium, color: ink),
          const SizedBox(height: 2),
          AppText(
            item.body,
            variant: AppTextVariant.labelMedium,
            color: ink.withValues(alpha: 0.8),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

/// Racha de días practicando, con una llama si hoy ya se tocó.
class StreakBanner extends StatelessWidget {
  /// Crea el aviso de racha.
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final StudioProgressController progress = context
        .watch<StudioProgressController>();
    final (:int days, :bool today) = progress.streak;
    return AppCard(
      borderRadius: 24,
      color: scheme.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.local_fire_department_rounded,
            color: today ? scheme.tertiary : scheme.outline,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  days == 0
                      ? t.studio.streakZero
                      : t.studio.streakDays(n: days),
                  variant: AppTextVariant.titleMedium,
                  maxLines: 2,
                ),
                if (today)
                  AppText(
                    t.studio.streakToday,
                    variant: AppTextVariant.labelMedium,
                    color: scheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
