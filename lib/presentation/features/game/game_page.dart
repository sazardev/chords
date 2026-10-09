import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Modo juego: toca el acorde y encadena una serie.
class GamePage extends StatelessWidget {
  /// Crea la pantalla del juego.
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = context.watch<GameController>();
    final GameRound? round = controller.currentRound;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugar'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: <Widget>[
                const Icon(Icons.local_fire_department_rounded),
                const SizedBox(width: 4),
                AppText('${controller.streak}'),
                const SizedBox(width: 12),
                const Icon(Icons.star_rounded),
                const SizedBox(width: 4),
                AppText('${controller.score}'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: round == null
          ? FloatingActionButton.extended(
              onPressed: () => controller.start(level: 1),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Empezar serie'),
            )
          : null,
      body: SafeArea(
        child: round == null
            ? AppEmptyState(
                icon: Icons.sports_esports_rounded,
                title: 'Toca el acorde',
                message:
                    'Encadena una serie de acordes con el micrófono. '
                    'Récord: ${controller.bestScore} puntos.',
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  _RoundHeader(round: round),
                  const SizedBox(height: 12),
                  _TargetCard(round: round, controller: controller),
                  const SizedBox(height: 20),
                  if (controller.phase == GamePhase.listening)
                    _ListeningCard(controller: controller)
                  else
                    _ActionButton(controller: controller),
                  const SizedBox(height: 16),
                  _SeriesRow(controller: controller),
                ],
              ),
      ),
    );
  }
}

/// Estado de la ronda actual.
class _RoundHeader extends StatelessWidget {
  const _RoundHeader({required this.round});

  final GameRound round;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      AppText('Ronda ${round.index + 1}', variant: AppTextVariant.titleLarge),
      const Spacer(),
      Chip(
        avatar: const Icon(Icons.timer_outlined),
        label: Text('${round.timeLimitMs ~/ 1000}s'),
      ),
    ],
  );
}

/// Acorde objetivo con su diagrama.
class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.round, required this.controller});

  final GameRound round;
  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final Chord? chord = controller.chordOf(round.chordId);
    return AppCard(
      child: Column(
        children: <Widget>[
          const AppText('Toca este acorde', variant: AppTextVariant.titleLarge),
          const SizedBox(height: 4),
          AppText(
            controller.nameOf(round.chordId),
            variant: AppTextVariant.displayLarge,
          ),
          const SizedBox(height: 8),
          ChordPlayButton(
            size: 52,
            onPressed: () => controller.playTarget(round.chordId),
          ),
          const SizedBox(height: 12),
          if (chord == null)
            const AppText('Cargando acorde…')
          else
            ChordDiagram(
              variant: chord.easiestVariant,
              width: 150,
              height: 190,
            ),
        ],
      ),
    );
  }
}

/// Indicador de escucha activa.
class _ListeningCard extends StatelessWidget {
  const _ListeningCard({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      children: <Widget>[
        const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        const SizedBox(height: 12),
        const AppText(
          'Escuchando tu guitararra…',
          variant: AppTextVariant.titleMedium,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: controller.matchRatio.clamp(0.0, 1.0),
            minHeight: 12,
          ),
        ),
      ],
    ),
  );
}

/// Botón principal de acción según la fase.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.phase == GamePhase.won) {
      return FilledButton.icon(
        onPressed: controller.next,
        icon: const Icon(Icons.check_rounded),
        label: const Text('¡Correcto! Siguiente'),
      );
    }
    if (controller.phase == GamePhase.lost) {
      return FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
        onPressed: controller.next,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Inténtalo otra vez'),
      );
    }
    return FilledButton.icon(
      onPressed: controller.playRound,
      icon: const Icon(Icons.mic_rounded),
      label: const Text('Estoy listo'),
    );
  }
}

/// Fila con el progreso de la serie.
class _SeriesRow extends StatelessWidget {
  const _SeriesRow({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: <Widget>[
      for (final GameRound round in controller.rounds)
        Chip(
          avatar: Icon(_iconFor(round), size: 18),
          label: Text('${round.index + 1}'),
        ),
    ],
  );

  IconData _iconFor(GameRound round) => switch (round.result?.outcome) {
    GameOutcome.success => Icons.check_rounded,
    GameOutcome.partial => Icons.more_time_rounded,
    GameOutcome.fail || GameOutcome.timeout => Icons.close_rounded,
    null => Icons.circle_outlined,
  };
}
