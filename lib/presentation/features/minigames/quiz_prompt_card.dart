import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_progression_strip.dart';
import 'package:chords/presentation/features/minigames/quiz_prompt_diagram.dart';
import 'package:chords/presentation/features/minigames/quiz_sequence_progress.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:chords/presentation/features/minigames/quiz_timer_bar.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Tarjeta del enunciado: texto, progresión o diagrama (si los hay), reloj y
/// botón de escuchar.
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
    final String? chordId = question.chordId;
    final Chord? chord = chordId == null ? null : controller.chordOf(chordId);
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
          if (question.bars.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            QuizProgressionStrip(bars: question.bars),
          ],
          if (question.isSequence) ...<Widget>[
            const SizedBox(height: 12),
            QuizSequenceProgress(question: question, input: state.input),
          ],
          QuizPromptDiagram(question: question, chord: chord),
          if (state.kind.timed) QuizTimerBar(state: state),
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
