import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/game/game_feedback_cards.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_bar.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_problem_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Lo que se muestra bajo el acorde según la fase de la ronda.
///
/// Esperando: la cuenta atrás que da tiempo a colocar la mano. Escuchando:
/// el feedback en vivo. Resuelta: el resultado y las órdenes de guitarra para
/// seguir, repetir, practicar o salir.
class GamePhaseSection extends StatelessWidget {
  /// Crea la sección de [controller] con la escucha [tuner].
  const GamePhaseSection({
    required this.controller,
    required this.tuner,
    super.key,
  });

  /// Controlador de la partida.
  final GameController controller;

  /// Escucha de la ronda en curso.
  final GameAudioController tuner;

  @override
  Widget build(BuildContext context) => switch (controller.phase) {
    GamePhase.listening => GameListeningCard(tuner: tuner),
    GamePhase.idle => _Waiting(controller: controller, tuner: tuner),
    GamePhase.won || GamePhase.lost => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GameResultCard(controller: controller, tuner: tuner),
        const SizedBox(height: 12),
        GuitarCommandBar(actions: _roundActions(context)),
      ],
    ),
    GamePhase.finished => GuitarCommandBar(actions: _finishedActions(context)),
  };

  List<GuitarAction> _roundActions(BuildContext context) {
    final Translations t = context.t;
    final bool won = controller.phase == GamePhase.won;
    final bool complete =
        controller.currentRound?.result?.outcome == GameOutcome.success;
    final GuitarAction listen = GuitarAction(
      command: GuitarCommand.listen,
      label: t.practice.listenChord,
      icon: Icons.volume_up_rounded,
      onTrigger: () => unawaited(
        controller.playTarget(controller.currentRound?.chordId ?? ''),
      ),
    );
    final GuitarAction exit = GuitarAction(
      command: GuitarCommand.exit,
      label: t.guitar.leave,
      icon: Icons.logout_rounded,
      onTrigger: () => context.pop(),
    );
    if (won) {
      return <GuitarAction>[
        GuitarAction(
          command: GuitarCommand.next,
          label: complete ? t.game.correctNext : t.game.almostNext,
          icon: Icons.arrow_forward_rounded,
          emphasized: true,
          onTrigger: controller.next,
        ),
        listen,
        exit,
      ];
    }
    return <GuitarAction>[
      GuitarAction(
        command: GuitarCommand.retry,
        label: t.guitar.retry,
        icon: Icons.replay_rounded,
        emphasized: true,
        onTrigger: controller.retry,
      ),
      listen,
      GuitarAction(
        command: GuitarCommand.skip,
        label: t.game.practiceChord,
        icon: Icons.mic_rounded,
        onTrigger: () => unawaited(_practice(context)),
      ),
      exit,
    ];
  }

  List<GuitarAction> _finishedActions(BuildContext context) {
    final Translations t = context.t;
    return <GuitarAction>[
      GuitarAction(
        command: GuitarCommand.next,
        label: t.minigames.playAgain,
        icon: Icons.replay_rounded,
        emphasized: true,
        onTrigger: () => controller.start(level: 1),
      ),
      GuitarAction(
        command: GuitarCommand.exit,
        label: t.minigames.moreGames,
        icon: Icons.apps_rounded,
        onTrigger: () => context.pop(),
      ),
    ];
  }

  /// Abre la práctica cuerda a cuerda del acorde de la ronda.
  Future<void> _practice(BuildContext context) async {
    final GameRound? round = controller.currentRound;
    final Chord? chord = round == null
        ? null
        : controller.chordOf(round.chordId);
    if (round == null || chord == null) {
      return;
    }
    final int variant = chord.variants.indexOf(chord.easiestVariant);
    await context.push(
      '$kChordPracticePath?id=${Uri.encodeComponent(round.chordId)}'
      '&v=${variant < 0 ? 0 : variant}',
    );
  }
}

/// Antes de escuchar: cuenta atrás, aviso de micrófono o botón de "listo".
class _Waiting extends StatelessWidget {
  const _Waiting({required this.controller, required this.tuner});

  final GameController controller;
  final GameAudioController tuner;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (MicProblemCard.isProblem(tuner.micStatus)) ...<Widget>[
          MicProblemCard(
            status: tuner.micStatus,
            onRetry: controller.playRound,
          ),
          const SizedBox(height: 12),
        ],
        if (controller.readyIn > 0)
          _CountdownCard(controller: controller)
        else
          FilledButton.icon(
            onPressed: controller.playRound,
            icon: const Icon(Icons.mic_rounded),
            label: Text(t.game.ready),
          ),
      ],
    );
  }
}

/// Cuenta atrás para colocar la mano; se puede adelantar con "¡Ya!".
class _CountdownCard extends StatelessWidget {
  const _CountdownCard({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: AppText(
                  '${controller.readyIn}',
                  variant: AppTextVariant.headlineMedium,
                  weight: FontWeight.w800,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.guitar.getReady,
                  variant: AppTextVariant.titleMedium,
                  color: scheme.onPrimaryContainer,
                  maxLines: 2,
                ),
                AppText(
                  t.guitar.startsIn(n: controller.readyIn),
                  color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: controller.playRound,
            child: Text(t.guitar.imReady),
          ),
        ],
      ),
    );
  }
}

/// Resumen de la serie terminada.
class GameFinishedCard extends StatelessWidget {
  /// Crea el resumen.
  const GameFinishedCard({
    required this.controller,
    required this.score,
    super.key,
  });

  /// Controlador de la partida.
  final GameController controller;

  /// Puntuación de la partida.
  final GameScoreController score;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        children: <Widget>[
          Icon(
            Icons.emoji_events_rounded,
            size: 48,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          AppText(
            t.game.finishedTitle,
            variant: AppTextVariant.headlineMedium,
            weight: FontWeight.w800,
            color: scheme.onPrimaryContainer,
            align: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            t.game.finishedMessage(
              won: score.wonRounds,
              total: controller.rounds.length,
              score: score.score,
            ),
            variant: AppTextVariant.titleMedium,
            color: scheme.onPrimaryContainer,
            align: TextAlign.center,
          ),
          AppText(
            t.game.finishedBest(best: score.bestScore),
            color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
