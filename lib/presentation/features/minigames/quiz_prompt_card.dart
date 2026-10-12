import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tarjeta del enunciado: texto, imagen (si la hay) y botón de escuchar.
class QuizPromptCard extends StatelessWidget {
  /// Crea la tarjeta para la pregunta actual de [state].
  const QuizPromptCard({
    required this.state,
    required this.controller,
    super.key,
  });

  /// Estado de la partida.
  final QuizState state;

  /// Controlador que reproduce el sonido.
  final QuizController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final QuizQuestion? question = state.question;
    if (question == null) {
      return const SizedBox.shrink();
    }
    return AppCard(
      child: Column(
        children: <Widget>[
          AppText(
            t.minigames.questionOf(n: state.index + 1, total: state.total),
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 6),
          AppText(
            questionPrompt(t, question),
            variant: AppTextVariant.titleLarge,
            align: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.visible,
          ),
          if (question.kind == MiniGameKind.memory) ...<Widget>[
            const SizedBox(height: 12),
            _SequenceDots(
              done: state.input.length,
              total: question.answer.length,
            ),
          ],
          _Diagram(question: question, controller: controller),
          if (question.hasSound) ...<Widget>[
            const SizedBox(height: 14),
            _ListenButton(state: state, onPressed: controller.replay),
          ],
        ],
      ),
    );
  }
}

class _ListenButton extends StatelessWidget {
  const _ListenButton({required this.state, required this.onPressed});

  final QuizState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool first = state.replaysLeft == state.level.replays;
    return FilledButton.tonalIcon(
      onPressed: state.canReplay ? onPressed : null,
      icon: Icon(
        state.isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
      ),
      label: Text(
        state.isPlaying
            ? t.minigames.listening
            : (first ? t.minigames.listen : t.minigames.listenAgain),
      ),
    );
  }
}

class _Diagram extends StatelessWidget {
  const _Diagram({required this.question, required this.controller});

  final QuizQuestion question;
  final QuizController controller;

  @override
  Widget build(BuildContext context) {
    final String? chordId = question.chordId;
    final Chord? chord = chordId == null ? null : controller.chordOf(chordId);
    final bool shows =
        question.kind == MiniGameKind.readDiagram ||
        question.kind == MiniGameKind.fingerQuiz;
    if (!shows || chord == null) {
      return const SizedBox.shrink();
    }
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ChordDiagram(
        variant: chord.variants[question.variantIndex],
        mirror: mirror,
        showFingers: question.kind == MiniGameKind.readDiagram,
        focusString: question.stringNumber,
        width: 150,
        height: 208,
      ),
    );
  }
}

class _SequenceDots extends StatelessWidget {
  const _SequenceDots({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < total; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: i < done ? scheme.primary : scheme.outlineVariant,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 14, height: 14),
            ),
          ),
      ],
    );
  }
}
