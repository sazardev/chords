import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Diagrama del enunciado de una pregunta (el del acorde y la posición que
/// indica la pregunta), con o sin números de dedo según `question.diagram`.
class QuizPromptDiagram extends StatelessWidget {
  /// Crea el diagrama de [question] para el acorde [chord] del banco.
  const QuizPromptDiagram({
    required this.question,
    required this.chord,
    super.key,
  });

  /// Pregunta mostrada.
  final QuizQuestion question;

  /// Acorde del banco al que se refiere la pregunta; `null` si no hay.
  final Chord? chord;

  @override
  Widget build(BuildContext context) {
    final Chord? shown = chord;
    if (question.diagram == QuizDiagram.none || shown == null) {
      return const SizedBox.shrink();
    }
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    final int last = shown.variants.length - 1;
    final bool compact = MediaQuery.sizeOf(context).height < 640;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ChordDiagram(
        variant: shown.variants[question.variantIndex.clamp(0, last)],
        mirror: mirror,
        showFingers: question.diagram == QuizDiagram.fingers,
        focusString: question.stringNumber,
        width: compact ? 120 : 150,
        height: compact ? 166 : 208,
      ),
    );
  }
}
