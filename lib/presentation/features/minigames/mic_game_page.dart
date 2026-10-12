import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/l10n/translations.g.dart';
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
    final Translations t = context.t;
    final bool asking = state.phase == MiniGamePhase.asking;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        _ChallengeCard(state: state, challenge: challenge),
        const SizedBox(height: 16),
        if (state.phase == MiniGamePhase.listening)
          _ListeningCard(
            state: state,
            challenge: challenge,
            controller: controller,
          )
        else if (state.phase == MiniGamePhase.feedback)
          _ResultCard(state: state, onNext: controller.next)
        else ...<Widget>[
          if (asking && MicProblemCard.isProblem(state.micStatus)) ...<Widget>[
            MicProblemCard(status: state.micStatus, onRetry: controller.listen),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            onPressed: controller.hear,
            icon: const Icon(Icons.volume_up_rounded),
            label: Text(
              challenge.isSequence
                  ? t.minigames.micHearMelody
                  : t.minigames.micHearIt,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: controller.listen,
            icon: const Icon(Icons.mic_rounded),
            label: Text(t.minigames.micReady),
          ),
        ],
      ],
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
          TextButton.icon(
            onPressed: controller.skip,
            icon: const Icon(Icons.skip_next_rounded),
            label: Text(t.minigames.micSkip),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state, required this.onNext});

  final MicGameState state;
  final VoidCallback onNext;

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
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onNext,
            child: Text(last ? t.minigames.seeResult : t.minigames.next),
          ),
        ],
      ),
    );
  }
}
