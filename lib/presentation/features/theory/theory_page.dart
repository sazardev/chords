import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:chords/presentation/widgets/atoms/progress_ring.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Escuela de guitarra: las lecciones de teoría por bloques, con progreso.
class TheoryPage extends StatelessWidget {
  /// Crea la pantalla.
  const TheoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final Set<String> done = context
        .watch<StudioProgressController>()
        .completedLessons;
    return Scaffold(
      appBar: AppBar(title: Text(t.theory.title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: _Header(done: done),
                ),
                for (final LessonUnit unit in LessonUnit.values) ...<Widget>[
                  SectionHeader(title: unitTitle(t, unit)),
                  for (final (int i, TheoryLesson lesson)
                      in kTheoryLessons
                          .where((TheoryLesson l) => l.unit == unit)
                          .indexed)
                    Entrance(
                      index: i,
                      child: _LessonTile(
                        lesson: lesson,
                        learned: done.contains(lesson.id),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.done});

  final Set<String> done;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int learned = kTheoryLessons
        .where((TheoryLesson l) => done.contains(l.id))
        .length;
    final double progress = learned / kTheoryLessons.length;
    return AppCard(
      color: scheme.primaryContainer,
      child: Row(
        children: <Widget>[
          ProgressRing(
            progress: progress,
            label: '${(progress * 100).round()}%',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.theory.subtitle,
                  variant: AppTextVariant.titleMedium,
                  color: scheme.onPrimaryContainer,
                  maxLines: 3,
                ),
                const SizedBox(height: 4),
                AppText(
                  t.theory.lessonsDone(
                    done: learned,
                    total: kTheoryLessons.length,
                  ),
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, required this.learned});

  final TheoryLesson lesson;
  final bool learned;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: CircleAvatar(
        backgroundColor: learned
            ? scheme.primaryContainer
            : scheme.surfaceContainerHigh,
        child: Text(lesson.emoji, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(lessonTitle(t, lesson)),
      subtitle: Text(
        lessonSummary(t, lesson),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: learned
          ? Icon(Icons.check_circle_rounded, color: scheme.primary)
          : const Icon(Icons.chevron_right_rounded),
      onTap: () => unawaited(context.push('$kLessonPath?id=${lesson.id}')),
    );
  }
}
