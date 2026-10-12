import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/profile_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/difficulty_badge.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tres cifras del progreso: dominados, mejor puntaje y nivel.
class HomeStats extends StatelessWidget {
  /// Crea la fila de estadísticas.
  const HomeStats({
    required this.mastered,
    required this.bestScore,
    required this.level,
    super.key,
  });

  /// Acordes dominados.
  final int mastered;

  /// Mejor puntuación del juego.
  final int bestScore;

  /// Nivel del itinerario en el que está.
  final int level;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: _Stat(
            icon: Icons.check_circle_rounded,
            value: mastered,
            label: t.home.statMastered,
            background: scheme.secondaryContainer,
            ink: scheme.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Stat(
            icon: Icons.star_rounded,
            value: bestScore,
            label: t.home.statBest,
            background: scheme.tertiaryContainer,
            ink: scheme.onTertiaryContainer,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Stat(
            icon: Icons.trending_up_rounded,
            value: level,
            label: t.home.statLevel,
            background: scheme.surfaceContainerHigh,
            ink: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    required this.background,
    required this.ink,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color background;
  final Color ink;

  @override
  Widget build(BuildContext context) => AppCard(
    color: background,
    borderRadius: 24,
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: ink, size: 22),
        const SizedBox(height: 10),
        TweenAnimationBuilder<int>(
          tween: IntTween(end: value),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (BuildContext context, int shown, Widget? _) => AppText(
            '$shown',
            variant: AppTextVariant.headlineMedium,
            color: ink,
            weight: FontWeight.w800,
          ),
        ),
        AppText(label, variant: AppTextVariant.labelMedium, color: ink),
      ],
    ),
  );
}

/// Carrusel "Para ti" con los acordes recomendados según el perfil.
class HomeRecommendations extends StatelessWidget {
  /// Crea la sección de recomendaciones.
  const HomeRecommendations({
    required this.chords,
    required this.profile,
    super.key,
    this.mirror = false,
  });

  /// Acordes recomendados.
  final List<Chord> chords;

  /// Perfil con el que se eligieron.
  final PlayerProfile profile;

  /// Si los diagramas se muestran en espejo.
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    t.home.recommendedTitle,
                    variant: AppTextVariant.titleLarge,
                  ),
                  AppText(
                    profile.personalized
                        ? profileSummary(t, profile)
                        : t.profile.setupHint,
                    variant: AppTextVariant.labelMedium,
                    color: scheme.onSurfaceVariant,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: t.profile.edit,
              onPressed: () => context.push(kProfilePath),
              icon: const Icon(Icons.tune_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 218,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: chords.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) =>
                _RecommendedCard(chord: chords[index], mirror: mirror),
          ),
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({required this.chord, required this.mirror});

  final Chord chord;
  final bool mirror;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () =>
          context.push('$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Center(
              child: ChordDiagram(
                variant: chord.easiestVariant,
                mirror: mirror,
                width: 92,
                height: 118,
              ),
            ),
          ),
          const SizedBox(height: 6),
          AppText(chord.name, variant: AppTextVariant.titleLarge),
          const SizedBox(height: 4),
          DifficultyBadge(difficulty: chord.difficulty, compact: true),
        ],
      ),
    ),
  );
}

/// Un acceso a otra sección de la app.
class HomeToolTile extends StatelessWidget {
  /// Crea el acceso.
  const HomeToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.ink,
    required this.onTap,
    super.key,
  });

  /// Icono.
  final IconData icon;

  /// Título.
  final String title;

  /// Descripción corta.
  final String subtitle;

  /// Color del fondo.
  final Color background;

  /// Color del contenido.
  final Color ink;

  /// Acción al pulsar.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
    color: background,
    onTap: onTap,
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: ink.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: ink, size: 26),
          ),
        ),
        const SizedBox(height: 16),
        AppText(
          title,
          variant: AppTextVariant.titleMedium,
          color: ink,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        AppText(
          subtitle,
          variant: AppTextVariant.labelMedium,
          color: ink.withValues(alpha: 0.8),
          maxLines: 2,
        ),
      ],
    ),
  );
}
