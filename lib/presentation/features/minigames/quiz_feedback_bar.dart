import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:chords/presentation/l10n/chord_game_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Aviso tras responder: acierto o fallo y botón para seguir.
class QuizFeedbackBar extends StatelessWidget {
  /// Crea el aviso del resultado de la pregunta actual de [state].
  const QuizFeedbackBar({required this.state, required this.onNext, super.key});

  /// Estado de la partida.
  final QuizState state;

  /// Pasa a la pregunta siguiente o al resultado.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final QuizQuestion? question = state.question;
    if (question == null) {
      return const SizedBox.shrink();
    }
    final bool ok = state.wasCorrect;
    final String? why = questionExplanation(t, question);
    final bool whyIsHeadline =
        !ok && question.kind == MiniGameKind.wrongDiagram;
    final bool last = state.index + 1 >= state.total;
    final Color background = ok
        ? chordColorsOf(context).inTune.withValues(alpha: 0.22)
        : scheme.errorContainer;
    final Color ink = ok ? scheme.onSurface : scheme.onErrorContainer;
    return AppCard(
      color: background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: ink,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppText(
                  ok
                      ? t.minigames.correct
                      : (whyIsHeadline ? why! : _wrongText(t, question)),
                  variant: AppTextVariant.titleMedium,
                  color: ink,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          if (why != null && !whyIsHeadline) ...<Widget>[
            const SizedBox(height: 8),
            AppText(
              why,
              color: ink,
              maxLines: 4,
              overflow: TextOverflow.visible,
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onNext,
            child: Text(last ? t.minigames.seeResult : t.minigames.next),
          ),
        ],
      ),
    );
  }

  String _wrongText(Translations t, QuizQuestion question) {
    if (state.timedOut) {
      final String answer = choiceLabel(t, question.correctChoice);
      return '${t.chordGames.timeUp} ${t.minigames.wrong(answer: answer)}';
    }
    if (question.isSequence) {
      final String sequence = question.answer
          .map((int i) => choiceLabel(t, question.choices[i]))
          .join(' → ');
      return t.minigames.wrongSequence(sequence: sequence);
    }
    return t.minigames.wrong(answer: choiceLabel(t, question.correctChoice));
  }
}
