import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/router/router_error_screen.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Una lección de teoría: explicación, ideas clave, demostración en el
/// mástil y accesos para practicarla con un juego o en el jam.
class LessonPage extends StatelessWidget {
  /// Crea la lección con identificador [lessonId].
  const LessonPage({required this.lessonId, super.key});

  /// Identificador recibido en la ruta.
  final String? lessonId;

  @override
  Widget build(BuildContext context) {
    final TheoryLesson? lesson = lessonById(lessonId);
    if (lesson == null) {
      return RouterErrorScreen(location: 'lesson:$lessonId');
    }
    final Translations t = context.t;
    final bool learned = context
        .watch<StudioProgressController>()
        .completedLessons
        .contains(lesson.id);
    return Scaffold(
      appBar: AppBar(title: Text(lessonTitle(t, lesson))),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: <Widget>[
                Text(lesson.emoji, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 8),
                AppText(
                  lessonSummary(t, lesson),
                  variant: AppTextVariant.titleMedium,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                for (final String paragraph in lessonParagraphs(
                  t,
                  lesson,
                )) ...<Widget>[
                  AppText(
                    paragraph,
                    variant: AppTextVariant.bodyLarge,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 12),
                ],
                _KeyPoints(points: lessonPoints(t, lesson)),
                ..._demo(lesson),
                const SizedBox(height: 16),
                ..._practice(context, t, lesson),
                const SizedBox(height: 8),
                _LearnedButton(lesson: lesson, learned: learned),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _demo(TheoryLesson lesson) {
    final ScaleType? scale = lesson.scale;
    return <Widget>[
      if (scale != null) ...<Widget>[
        const SizedBox(height: 16),
        ScaleDemo(
          scale: scale,
          tonic: lesson.tonic,
          showPositions: lesson.showPositions,
        ),
      ],
      if (lesson.showHarmony) ...<Widget>[
        const SizedBox(height: 16),
        HarmonyCard(musicalKey: MusicalKey(lesson.tonic)),
        const SizedBox(height: 12),
        HarmonyCard(musicalKey: MusicalKey(lesson.tonic).relative),
      ],
    ];
  }

  List<Widget> _practice(
    BuildContext context,
    Translations t,
    TheoryLesson lesson,
  ) {
    final MiniGameKind? game = lesson.game;
    final ChordProgression? progression = progressionById(lesson.progressionId);
    return <Widget>[
      if (game != null)
        FilledButton.tonalIcon(
          icon: const Icon(Icons.sports_esports_rounded),
          label: Text(t.theory.practiceGame(game: gameTitle(t, game))),
          onPressed: () =>
              unawaited(context.push('$kMiniGamePath?kind=${game.id}')),
        ),
      if (game != null && progression != null) const SizedBox(height: 8),
      if (progression != null)
        FilledButton.tonalIcon(
          icon: const Icon(Icons.album_rounded),
          label: Text(
            t.theory.practiceJam(name: progressionName(t, progression)),
          ),
          onPressed: () =>
              unawaited(context.push('$kJamPath?prog=${progression.id}')),
        ),
    ];
  }
}

class _KeyPoints extends StatelessWidget {
  const _KeyPoints({required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            t.theory.keyPoints,
            variant: AppTextVariant.titleMedium,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(height: 8),
          for (final String point in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: scheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      point,
                      color: scheme.onSecondaryContainer,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LearnedButton extends StatelessWidget {
  const _LearnedButton({required this.lesson, required this.learned});

  final TheoryLesson lesson;
  final bool learned;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    void toggle() => unawaited(
      context.read<StudioProgressController>().toggleLesson(lesson.id),
    );
    return learned
        ? OutlinedButton.icon(
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(t.theory.learned),
            onPressed: toggle,
          )
        : FilledButton.icon(
            icon: const Icon(Icons.done_all_rounded),
            label: Text(t.theory.markLearned),
            onPressed: toggle,
          );
  }
}
