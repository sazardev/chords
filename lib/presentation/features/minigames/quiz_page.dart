import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/presentation/features/minigames/mini_game_frame.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/quiz_choices.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_feedback_bar.dart';
import 'package:chords/presentation/features/minigames/quiz_prompt_card.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pantalla de los minijuegos de preguntas de opciones (oído y mástil).
class QuizPage extends StatefulWidget {
  /// Crea la pantalla de [kind].
  const QuizPage({required this.kind, super.key});

  /// Juego que se juega.
  final MiniGameKind kind;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late final QuizController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<QuizController>()..open(widget.kind);
  }

  @override
  void dispose() {
    _controller.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuizController controller = context.watch<QuizController>();
    final QuizState state = controller.state;
    return MiniGameFrame(
      kind: state.kind,
      phase: state.phase,
      level: state.level,
      score: state.score,
      index: state.index,
      total: state.total,
      isNewBest: state.isNewBest,
      onStart: controller.start,
      bodyBuilder: (BuildContext context) =>
          _QuizBody(state: state, controller: controller),
    );
  }
}

class _QuizBody extends StatelessWidget {
  const _QuizBody({required this.state, required this.controller});

  final QuizState state;
  final QuizController controller;

  @override
  Widget build(BuildContext context) {
    final QuizQuestion? question = state.question;
    if (question == null) {
      return const SizedBox.shrink();
    }
    final bool revealed = state.phase == MiniGamePhase.feedback;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        QuizPromptCard(state: state, controller: controller),
        const SizedBox(height: 16),
        QuizChoices(
          question: question,
          chosen: state.input,
          revealed: revealed,
          onChoose: controller.answer,
        ),
        if (revealed) ...<Widget>[
          const SizedBox(height: 16),
          QuizFeedbackBar(state: state, onNext: controller.next),
        ],
      ],
    );
  }
}
