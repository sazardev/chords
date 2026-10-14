import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/features/studio/studio_shortcuts.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/progress_ring.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:chords/presentation/widgets/molecules/chord_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Itinerario de aprendizaje: niveles, progreso y arpegios guiados.
class LearnPage extends StatelessWidget {
  /// Crea la pantalla de aprendizaje.
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final LearnController controller = context.watch<LearnController>();
    return Scaffold(
      appBar: AppBar(title: Text(t.learn.title)),
      body: SafeArea(
        child: switch (controller.status) {
          LearnStatus.loading => AppLoading(message: t.learn.loading),
          LearnStatus.error => AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: t.learn.errorTitle,
            message: t.learn.errorMessage,
          ),
          LearnStatus.ready => ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: <Widget>[
              _ProgressCard(controller: controller),
              SectionHeader(title: t.studio.sectionTitle),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StudioShortcuts(),
              ),
              SectionHeader(title: t.learn.stepByStep),
              const _StepsCard(),
              for (final LearningLevel level in LearningLevel.values)
                _LevelSection(controller: controller, level: level),
              SectionHeader(title: t.learn.guidedArpeggios),
              const _ArpeggioRow(),
            ],
          ),
        },
      ),
    );
  }
}

/// Tarjeta de progreso global.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.controller});

  final LearnController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: _PlainCard(
        child: Row(
          children: <Widget>[
            ProgressRing(
              progress: controller.progress,
              label: '${(controller.progress * 100).round()}%',
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    t.learn.yourProgress,
                    variant: AppTextVariant.titleLarge,
                  ),
                  AppText(
                    t.learn.masteredCount(n: controller.mastered.length),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta plana reutilizable con la superficie del contenedor del tema.
class _PlainCard extends StatelessWidget {
  const _PlainCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => AppCard(
    borderRadius: 24,
    color: Theme.of(context).colorScheme.surfaceContainer,
    child: child,
  );
}

/// Instrucciones del método paso a paso.
class _StepsCard extends StatelessWidget {
  const _StepsCard();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<String> steps = <String>[
      t.learn.stepFingers,
      t.learn.stepStrum,
      t.learn.stepChange,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _PlainCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < steps.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(radius: 12, child: AppText('${i + 1}')),
                  const SizedBox(width: 12),
                  Expanded(child: AppText(steps[i])),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sección de un nivel con sus acordes.
class _LevelSection extends StatelessWidget {
  const _LevelSection({required this.controller, required this.level});

  final LearnController controller;
  final LearningLevel level;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<Chord> chords = controller.chordsOfLevel(level.level);
    final int percent = (controller.progressOfLevel(level.level) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(
          title: t.learn.levelSection(
            emoji: level.emoji,
            level: level.level,
            title: learningLevelTitle(t, level),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  learningLevelGoal(t, level),
                  variant: AppTextVariant.labelMedium,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              AppText('$percent%'),
            ],
          ),
        ),
        for (final Chord chord in chords)
          ChordTile(
            chord: chord,
            mastered: controller.mastered.contains(chord.id),
            onTap: () => context.push(
              '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
            ),
            onPlay: () => context.push(
              '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
            ),
            onToggleMastered: () => controller.toggleMastered(chord.id),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Fila de patrones de arpegio.
class _ArpeggioRow extends StatelessWidget {
  const _ArpeggioRow();

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          for (final ArpeggioPattern pattern
              in ArpeggioPattern.all) ...<Widget>[
            ActionChip(
              avatar: const Icon(Icons.music_note_rounded),
              label: Text(arpeggioLabel(t, pattern)),
              onPressed: () => _openChord(context, arpeggioLabel(t, pattern)),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  void _openChord(BuildContext context, String label) {
    final Translations t = context.t;
    final LearnController controller = context.read<LearnController>();
    final String target = controller.nextChordId ?? 'C-maj';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.learn.arpeggioHint(label: label))));
    unawaited(
      context.push('$kChordDetailPath?id=${Uri.encodeComponent(target)}'),
    );
  }
}
