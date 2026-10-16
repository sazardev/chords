import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/chord_game_labels.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Posición dibujable a partir del valor de una opción de diagrama
/// (`x,3,2,0,1,0` con `-1` por cuerda muteada).
ChordVariant variantOfDiagramChoice(String value) => ChordVariant(
  id: 'quiz-$value',
  positionLabel: '',
  frets: <int>[
    for (final String fret in value.split(',')) int.tryParse(fret) ?? -1,
  ],
  fingers: List<int>.filled(6, 0),
  difficulty: Difficulty.beginner,
);

/// Un diagrama como opción de respuesta: sin dedos, sobre un fondo neutro
/// para que se lea igual esté la opción en reposo, acertada o fallada.
class QuizDiagramChoice extends StatelessWidget {
  /// Crea el diagrama de la opción [choice]; [number] lo nombra a los lectores
  /// de pantalla.
  const QuizDiagramChoice({
    required this.choice,
    required this.number,
    super.key,
  });

  /// Opción de tipo diagrama.
  final QuizChoice choice;

  /// Posición de la opción (desde 1).
  final int number;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Semantics(
          label: diagramChoiceLabel(t, number),
          child: ChordDiagram(
            variant: variantOfDiagramChoice(choice.value),
            mirror: mirror,
            showFingers: false,
            width: 112,
            height: 150,
          ),
        ),
      ),
    );
  }
}
