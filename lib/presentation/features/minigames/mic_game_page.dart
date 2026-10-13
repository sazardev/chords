import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_bar.dart';
import 'package:chords/presentation/features/minigames/mic_game_controller.dart';
import 'package:chords/presentation/features/minigames/mic_game_state.dart';
import 'package:chords/presentation/features/minigames/mini_game_frame.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Pantalla de los minijuegos en los que se toca la guitarra.
class MicGamePage extends StatefulWidget {
  /// Crea la pantalla de [kind].
  const MicGamePage({required this.kind, super.key});

  /// Juego que se juega.
  final MiniGameKind kind;

  @override
  State<MicGamePage> createState() => _MicGamePageState();
}

class _MicGamePageState extends State<MicGamePage> {
  late final MicGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<MicGameController>()..open(widget.kind);
  }

  @override
  void dispose() {
    _controller.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MicGameController controller = context.watch<MicGameController>();
    final MicGameState state = controller.state;
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
          _MicBody(state: state, controller: controller),
    );
  }
}

class _MicBody extends StatelessWidget {
  const _MicBody({required this.state, required this.controller});

  final MicGameState state;
  final MicGameController controller;

  @override
  Widget build(BuildContext context) {
    final MicChallenge? challenge = state.challenge;
    if (challenge == null) {
      return const SizedBox.shrink();
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        _ChallengeCard(state: state, challenge: challenge),
        const SizedBox(height: 16),
        switch (state.phase) {
          MiniGamePhase.listening => _ListeningCard(
            state: state,
            challenge: challenge,
            controller: controller,
          ),
          MiniGamePhase.feedback => _ResultSection(
            state: state,
            challenge: challenge,
            controller: controller,
          ),
          _ => _AskingSection(state: state, controller: controller),
        },
      ],
    );
  }
}

/// Entre retos: avisa si el micrófono falla o si suena la melodía del eco.
///
/// Es un paso breve: en cuanto el micrófono está listo empieza a escuchar sin
/// que la persona tenga que pulsar nada.
class _AskingSection extends StatelessWidget {
  const _AskingSection({required this.state, required this.controller});

  final MicGameState state;
  final MicGameController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    if (MicProblemCard.isProblem(state.micStatus)) {
      return MicProblemCard(
        status: state.micStatus,
        onRetry: controller.listen,
      );
    }
    if (!state.playingCue) {
      return const SizedBox.shrink();
    }
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.volume_up_rounded),
          const SizedBox(width: 10),
          AppText(
            t.minigames.micPlayingMelody,
            variant: AppTextVariant.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.state, required this.challenge});

  final MicGameState state;
  final MicChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? hint = challengeHint(t, challenge);
    return AppCard(
      child: Column(
        children: <Widget>[
          AppText(
            t.minigames.roundOf(n: state.index + 1, total: state.total),
            variant: AppTextVariant.labelMedium,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 6),
          AppText(
            challengePrompt(t, challenge),
            variant: AppTextVariant.titleLarge,
            align: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.visible,
          ),
          if (challenge.isSequence) ...<Widget>[
            const SizedBox(height: 12),
            _MelodyDots(
              done: state.progress,
              total: challenge.pitchClasses.length,
            ),
          ],
          if (hint != null) ...<Widget>[
            const SizedBox(height: 8),
            AppText(
              hint,
              variant: AppTextVariant.labelMedium,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}

class _MelodyDots extends StatelessWidget {
  const _MelodyDots({required this.done, required this.total});

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
              child: const SizedBox(width: 16, height: 16),
            ),
          ),
      ],
    );
  }
}

class _ListeningCard extends StatelessWidget {
  const _ListeningCard({
    required this.state,
    required this.challenge,
    required this.controller,
  });

  final MicGameState state;
  final MicChallenge challenge;
  final MicGameController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final int? heard = state.heard;
    return AppCard(
      child: Column(
        children: <Widget>[
          AppText(
            t.minigames.micListening,
            variant: AppTextVariant.titleMedium,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (state.msLeft / challenge.timeLimitMs).clamp(0.0, 1.0),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 4),
          AppText(
            t.minigames.micSeconds(n: (state.msLeft / 1000).ceil()),
            variant: AppTextVariant.labelMedium,
          ),
          const SizedBox(height: 12),
          MicLevelBar(level: state.level01),
          const SizedBox(height: 12),
          if (heard != null)
            AppText(
              t.minigames.micHeard(note: noteLabel(t, heard)),
              variant: AppTextVariant.titleMedium,
            ),
          if (challenge.isSequence)
            AppText(
              t.minigames.micProgress(
                done: state.progress,
                total: challenge.pitchClasses.length,
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: <Widget>[
              TextButton.icon(
                onPressed: controller.hear,
                icon: const Icon(Icons.volume_up_rounded),
                label: Text(
                  challenge.isSequence
                      ? t.minigames.micHearMelody
                      : t.minigames.micHearIt,
                ),
              ),
              TextButton.icon(
                onPressed: controller.skip,
                icon: const Icon(Icons.skip_next_rounded),
                label: Text(t.minigames.micSkip),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Resultado del reto y las órdenes para seguir, repetir o escuchar.
///
/// Se maneja tocando cuerdas al aire: la persona no suelta la guitarra.
class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.state,
    required this.challenge,
    required this.controller,
  });

  final MicGameState state;
  final MicChallenge challenge;
  final MicGameController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool ok = state.wasCorrect;
    final bool last = state.index + 1 >= state.total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppCard(
          color: ok
              ? chordColorsOf(context).inTune.withValues(alpha: 0.22)
              : scheme.errorContainer,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(ok ? Icons.check_circle_rounded : Icons.cancel_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppText(
                      ok ? t.minigames.micSuccess : t.minigames.micTimeUp,
                      variant: AppTextVariant.titleMedium,
                    ),
                  ),
                ],
              ),
              if (state.retried)
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    t.minigames.micPracticeNote,
                    variant: AppTextVariant.labelMedium,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GuitarCommandBar(
          actions: <GuitarAction>[
            GuitarAction(
              command: GuitarCommand.next,
              label: last ? t.minigames.seeResult : t.guitar.continueLabel,
              icon: last
                  ? Icons.emoji_events_rounded
                  : Icons.arrow_forward_rounded,
              emphasized: ok,
              onTrigger: controller.next,
            ),
            if (!ok)
              GuitarAction(
                command: GuitarCommand.retry,
                label: t.guitar.retry,
                icon: Icons.replay_rounded,
                emphasized: true,
                onTrigger: controller.retry,
              ),
            GuitarAction(
              command: GuitarCommand.listen,
              label: challenge.isSequence
                  ? t.minigames.micHearMelody
                  : t.minigames.micHearIt,
              icon: Icons.volume_up_rounded,
              onTrigger: controller.hear,
            ),
          ],
        ),
      ],
    );
  }
}
