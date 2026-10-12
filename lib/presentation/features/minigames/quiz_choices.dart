import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';

/// Cuadrícula de opciones de respuesta.
///
/// Antes de responder todas son neutras; al responder, la correcta se pinta
/// de verde y la elegida equivocada de rojo.
class QuizChoices extends StatelessWidget {
  /// Crea la cuadrícula para [question].
  const QuizChoices({
    required this.question,
    required this.chosen,
    required this.revealed,
    required this.onChoose,
    super.key,
  });

  /// Pregunta a la que se responde.
  final QuizQuestion question;

  /// Opciones ya elegidas en la pregunta actual.
  final List<int> chosen;

  /// Si ya se respondió y hay que mostrar el resultado.
  final bool revealed;

  /// Se llama con el índice de la opción pulsada.
  final ValueChanged<int> onChoose;

  static const double _gap = 10;

  int _columns() {
    final int count = question.choices.length;
    if (question.isSequence) {
      return 3;
    }
    return count <= 4 ? 2 : 3;
  }

  @override
  Widget build(BuildContext context) {
    final int columns = _columns();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width =
            (constraints.maxWidth - _gap * (columns - 1)) / columns;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: <Widget>[
            for (int i = 0; i < question.choices.length; i++)
              SizedBox(
                width: width,
                child: _ChoiceButton(
                  choice: question.choices[i],
                  style: _styleOf(i),
                  onTap: revealed ? null : () => onChoose(i),
                ),
              ),
          ],
        );
      },
    );
  }

  _ChoiceStyle _styleOf(int index) {
    if (!revealed) {
      return _ChoiceStyle.neutral;
    }
    if (question.isSequence) {
      return _ChoiceStyle.neutral;
    }
    if (question.answer.contains(index)) {
      return _ChoiceStyle.right;
    }
    return chosen.contains(index) ? _ChoiceStyle.wrong : _ChoiceStyle.neutral;
  }
}

enum _ChoiceStyle { neutral, right, wrong }

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.choice,
    required this.style,
    required this.onTap,
  });

  final QuizChoice choice;
  final _ChoiceStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppChordColors colors = chordColorsOf(context);
    final (Color background, Color ink) = switch (style) {
      _ChoiceStyle.right => (colors.inTune, Colors.black),
      _ChoiceStyle.wrong => (scheme.error, scheme.onError),
      _ChoiceStyle.neutral => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
    };
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Center(
                child: AppText(
                  choiceLabel(t, choice),
                  variant: AppTextVariant.titleMedium,
                  color: ink,
                  align: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
