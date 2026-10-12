import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/build_chord_controller.dart';
import 'package:chords/presentation/features/minigames/build_chord_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_frame.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:chords/presentation/widgets/organisms/fretboard_pad.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Pantalla de "arma el acorde": se da el nombre y se ponen los dedos.
class BuildChordPage extends StatefulWidget {
  /// Crea la pantalla.
  const BuildChordPage({super.key});

  @override
  State<BuildChordPage> createState() => _BuildChordPageState();
}

class _BuildChordPageState extends State<BuildChordPage> {
  @override
  void initState() {
    super.initState();
    context.read<BuildChordController>().open();
  }

  @override
  Widget build(BuildContext context) {
    final BuildChordController controller = context
        .watch<BuildChordController>();
    final BuildChordState state = controller.state;
    return MiniGameFrame(
      kind: MiniGameKind.buildChord,
      phase: state.phase,
      level: state.level,
      score: state.score,
      index: state.index,
      total: state.total,
      isNewBest: state.isNewBest,
      onStart: controller.start,
      bodyBuilder: (BuildContext context) =>
          _BuildBody(state: state, controller: controller),
    );
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({required this.state, required this.controller});

  final BuildChordState state;
  final BuildChordController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordRound? round = state.round;
    final Chord? chord = round == null
        ? null
        : controller.chordOf(round.chordId);
    if (round == null || chord == null) {
      return const SizedBox.shrink();
    }
    final bool feedback = state.phase == MiniGamePhase.feedback;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        _TargetCard(
          state: state,
          chord: chord,
          round: round,
          mirror: mirror,
          onListen: controller.playTarget,
        ),
        const SizedBox(height: 16),
        FretboardPad(
          frets: state.placed,
          wrong: state.wrong,
          mirror: mirror,
          stringNames: <String>[
            for (final GuitarString string in kStandardTuning)
              openNoteName(t, string),
          ],
          onCell: controller.tapCell,
          onMark: controller.toggleMark,
        ),
        const SizedBox(height: 8),
        if (!feedback) ...<Widget>[
          AppText(
            state.wrong.isEmpty
                ? t.minigames.buildTapHint
                : t.minigames.buildWrong,
            variant: AppTextVariant.labelMedium,
            color: state.wrong.isEmpty
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.error,
            align: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          _Actions(state: state, controller: controller),
        ] else
          _FeedbackCard(state: state, controller: controller, round: round),
      ],
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.state,
    required this.chord,
    required this.round,
    required this.mirror,
    required this.onListen,
  });

  final BuildChordState state;
  final Chord chord;
  final ChordRound round;
  final bool mirror;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return AppCard(
      child: Column(
        children: <Widget>[
          AppText(
            t.minigames.roundOf(n: state.index + 1, total: state.total),
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          AppText(
            t.minigames.prompt.buildChord(chord: chord.name),
            variant: AppTextVariant.titleLarge,
            align: TextAlign.center,
            maxLines: 2,
          ),
          AppText(
            chord.displayName,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          ChordPlayButton(size: 48, onPressed: onListen),
          if (state.revealsTarget) ...<Widget>[
            const SizedBox(height: 12),
            ChordDiagram(
              variant: chord.variants[round.variantIndex],
              mirror: mirror,
              width: 120,
              height: 166,
            ),
            if (state.hinted && state.phase == MiniGamePhase.asking)
              AppText(
                t.minigames.buildHinted,
                variant: AppTextVariant.labelMedium,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.state, required this.controller});

  final BuildChordState state;
  final BuildChordController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FilledButton.icon(
          onPressed: controller.check,
          icon: const Icon(Icons.check_rounded),
          label: Text(t.minigames.buildCheck),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: <Widget>[
            TextButton.icon(
              onPressed: controller.clear,
              icon: const Icon(Icons.backspace_outlined),
              label: Text(t.minigames.buildClear),
            ),
            if (state.hintsAllowed && !state.hinted)
              TextButton.icon(
                onPressed: controller.showHint,
                icon: const Icon(Icons.lightbulb_outline_rounded),
                label: Text(t.minigames.buildHint),
              ),
            TextButton.icon(
              onPressed: controller.giveUp,
              icon: const Icon(Icons.skip_next_rounded),
              label: Text(t.minigames.micSkip),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.state,
    required this.controller,
    required this.round,
  });

  final BuildChordState state;
  final BuildChordController controller;
  final ChordRound round;

  String _headline(Translations t) {
    if (state.wasCorrect) {
      return t.minigames.buildCorrect;
    }
    return state.solved ? t.minigames.buildHinted : t.minigames.buildMissed;
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool ok = state.wasCorrect;
    final bool last = state.index + 1 >= state.total;
    return AppCard(
      color: ok
          ? chordColorsOf(context).inTune.withValues(alpha: 0.22)
          : scheme.errorContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(
            _headline(t),
            variant: AppTextVariant.titleMedium,
            overflow: TextOverflow.visible,
          ),
          if (state.solved)
            AppText(
              t.minigames.buildCorrectBody,
              overflow: TextOverflow.visible,
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => unawaited(
              context.push(
                '$kChordPracticePath?id=${Uri.encodeComponent(round.chordId)}'
                '&v=${round.variantIndex}',
              ),
            ),
            icon: const Icon(Icons.mic_rounded),
            label: Text(t.minigames.buildPlayIt),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: controller.next,
            child: Text(last ? t.minigames.seeResult : t.minigames.next),
          ),
        ],
      ),
    );
  }
}
