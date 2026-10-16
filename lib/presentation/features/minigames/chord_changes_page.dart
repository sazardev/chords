import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/chord_changes_controller.dart';
import 'package:chords/presentation/features/minigames/chord_changes_playing.dart';
import 'package:chords/presentation/features/minigames/chord_changes_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_frame.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pantalla de "cambios de acorde": cuántos cambios limpios en 60 segundos.
class ChordChangesPage extends StatefulWidget {
  /// Crea la pantalla.
  const ChordChangesPage({super.key});

  @override
  State<ChordChangesPage> createState() => _ChordChangesPageState();
}

class _ChordChangesPageState extends State<ChordChangesPage> {
  late final ChordChangesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ChordChangesController>()..open();
  }

  @override
  void dispose() {
    _controller.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChordChangesController controller = context
        .watch<ChordChangesController>();
    final ChordChangesState state = controller.state;
    return MiniGameFrame(
      kind: MiniGameKind.chordChanges,
      phase: state.phase,
      level: state.level,
      score: state.score,
      index: state.elapsedSeconds,
      total: state.totalMs ~/ 1000,
      isNewBest: state.isNewBest,
      onStart: controller.start,
      bodyBuilder: (BuildContext context) =>
          _Body(state: state, controller: controller),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.controller});

  final ChordChangesState state;
  final ChordChangesController controller;

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (MicProblemCard.isProblem(state.micStatus)) {
      content = MicProblemCard(
        status: state.micStatus,
        onRetry: () => controller.start(state.level),
      );
    } else if (state.phase == MiniGamePhase.asking) {
      content = _GetReady(state: state);
    } else {
      content = ChordChangesPlaying(state: state, controller: controller);
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[content],
    );
  }
}

/// Cuenta atrás antes del primer acorde.
class _GetReady extends StatelessWidget {
  const _GetReady({required this.state});

  final ChordChangesState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return AppCard(
      child: Column(
        children: <Widget>[
          const Icon(Icons.timer_rounded, size: 40),
          const SizedBox(height: 8),
          AppText(
            t.chordGames.changes.getReady,
            variant: AppTextVariant.titleLarge,
            align: TextAlign.center,
          ),
          AppText(
            t.chordGames.changes.startsIn(n: (state.readyMs / 1000).ceil()),
            variant: AppTextVariant.titleMedium,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
