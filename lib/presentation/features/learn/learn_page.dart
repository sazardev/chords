import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/presentation/features/learn/learn_controller.dart';
import 'package:chords/presentation/router/route_paths.dart';
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
    final LearnController controller = context.watch<LearnController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Aprender')),
      body: SafeArea(
        child: switch (controller.status) {
          LearnStatus.loading => const AppLoading(
            message: 'Preparando niveles…',
          ),
          LearnStatus.error => const AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'No se pudo cargar el itinerario',
            message: 'Reinicia la app para reintentar.',
          ),
          LearnStatus.ready => ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: <Widget>[
              _ProgressCard(controller: controller),
              const SectionHeader(title: 'Paso a paso'),
              const _StepsCard(),
              for (final LearningLevel level in LearningLevel.values)
                _LevelSection(controller: controller, level: level),
              const SectionHeader(title: 'Arpegios guiados'),
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
  Widget build(BuildContext context) => Padding(
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
                const AppText(
                  'Tu progreso',
                  variant: AppTextVariant.titleLarge,
                ),
                AppText(
                  '${controller.mastered.length} acordes dominados',
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

/// Tarjeta con contenedor sencillo reutilizable.
class _PlainCard extends StatelessWidget {
  const _PlainCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(24),
    ),
    child: child,
  );
}

/// Instrucciones del método paso a paso.
class _StepsCard extends StatelessWidget {
  const _StepsCard();

  @override
  Widget build(BuildContext context) {
    const List<String> steps = <String>[
      'Coloca los dedos uno a uno sobre el diapasón',
      'Rasgueo lento: escucha cada cuerda',
      'Cambia al acorde siguiente sin parar el ritmo',
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
    final List<Chord> chords = controller.chordsOfLevel(level.level);
    final int percent = (controller.progressOfLevel(level.level) * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(
          title: '${level.emoji}  Nivel ${level.level}: ${level.title}',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  level.goal,
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
            onTap: () => context.go(
              '$kChordDetailPath?id=${Uri.encodeComponent(chord.id)}',
            ),
            onPlay: () => context.go(
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
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: <Widget>[
        for (final ArpeggioPattern pattern in ArpeggioPattern.all) ...<Widget>[
          ActionChip(
            avatar: const Icon(Icons.music_note_rounded),
            label: Text(pattern.label),
            onPressed: () => _openChord(context, pattern.label),
          ),
          const SizedBox(width: 8),
        ],
      ],
    ),
  );

  void _openChord(BuildContext context, String label) {
    final LearnController controller = context.read<LearnController>();
    final String target = controller.nextChordId ?? 'C-maj';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abre el acorde y toca su arpegio $label')),
    );
    context.go('$kChordDetailPath?id=${Uri.encodeComponent(target)}');
  }
}
