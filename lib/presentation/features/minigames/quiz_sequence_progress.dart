import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Avance de una respuesta en varios pasos.
///
/// En "deletrea el acorde" muestra las notas ya tocadas en orden (y puestos
/// vacíos para las que faltan); en los demás juegos de secuencia, puntos.
class QuizSequenceProgress extends StatelessWidget {
  /// Crea el avance de [question] con las opciones ya elegidas en [input].
  const QuizSequenceProgress({
    required this.question,
    required this.input,
    super.key,
  });

  /// Pregunta en curso.
  final QuizQuestion question;

  /// Índices de las opciones elegidas hasta ahora.
  final List<int> input;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Translations t = context.t;
    final bool labelled = question.kind == MiniGameKind.spellChord;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (int i = 0; i < question.answer.length; i++)
          if (labelled)
            _Slot(
              text: i < input.length
                  ? choiceLabel(t, question.choices[input[i]])
                  : '${i + 1}',
              filled: i < input.length,
              scheme: scheme,
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: i < input.length
                      ? scheme.primary
                      : scheme.outlineVariant,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(width: 14, height: 14),
              ),
            ),
      ],
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.text, required this.filled, required this.scheme});

  final String text;
  final bool filled;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: filled ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 36),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Center(
          widthFactor: 1,
          child: AppText(
            text,
            variant: AppTextVariant.titleMedium,
            color: filled ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}
