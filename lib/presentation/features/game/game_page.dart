import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/game/game_phase_section.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/chord_play_button.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Modo juego: toca el acorde y encadena una serie.
///
/// Durante la escucha muestra feedback en vivo —notas acertadas, cuerdas que
/// faltan y notas que suenan de más— para que el jugador se acomode sin
/// esperar al resultado. Cada ronda empieza sola tras una cuenta atrás y, al
/// terminar, se sigue, se repite o se sale tocando cuerdas al aire: no hace
/// falta soltar la guitarra. Si falla, solo puede reintentar la misma ronda.
class GamePage extends StatefulWidget {
  /// Crea la pantalla del juego.
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<GameController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.setActive(active: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.setActive(active: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final GameController controller = context.watch<GameController>();
    final GameScoreController score = context.watch<GameScoreController>();
    final GameAudioController tuner = context.watch<GameAudioController>();
    final GameRound? round = controller.currentRound;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.game.title),
        actions: <Widget>[_scoreBadges(score, t)],
      ),
      floatingActionButton: round == null
          ? FloatingActionButton.extended(
              onPressed: () => controller.start(level: 1),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(t.game.start),
            )
          : null,
      body: SafeArea(
        child: round == null
            ? AppEmptyState(
                icon: Icons.sports_esports_rounded,
                title: t.game.emptyTitle,
                message: t.game.emptyMessage(best: score.bestScore),
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  _RoundHeader(round: round),
                  const SizedBox(height: 12),
                  if (controller.phase == GamePhase.finished)
                    GameFinishedCard(controller: controller, score: score)
                  else
                    _TargetCard(
                      round: round,
                      controller: controller,
                      tuner: tuner,
                    ),
                  const SizedBox(height: 20),
                  GamePhaseSection(controller: controller, tuner: tuner),
                  const SizedBox(height: 16),
                  _SeriesRow(controller: controller),
                ],
              ),
      ),
    );
  }

  Widget _scoreBadges(GameScoreController score, Translations t) => Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Row(
      children: <Widget>[
        Tooltip(
          message: t.game.streak,
          child: const Icon(Icons.local_fire_department_rounded),
        ),
        const SizedBox(width: 4),
        AppText('${score.streak}'),
        const SizedBox(width: 12),
        Tooltip(message: t.game.score, child: const Icon(Icons.star_rounded)),
        const SizedBox(width: 4),
        AppText('${score.score}'),
      ],
    ),
  );
}

/// Estado de la ronda actual.
class _RoundHeader extends StatelessWidget {
  const _RoundHeader({required this.round});

  final GameRound round;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Row(
      children: <Widget>[
        AppText(
          t.game.round(number: round.index + 1),
          variant: AppTextVariant.titleLarge,
        ),
        const Spacer(),
        Chip(
          avatar: const Icon(Icons.timer_outlined),
          label: Text('${round.timeLimitMs ~/ 1000}s'),
        ),
      ],
    );
  }
}

/// Acorde objetivo con su diagrama.
class _TargetCard extends StatelessWidget {
  const _TargetCard({
    required this.round,
    required this.controller,
    required this.tuner,
  });

  final GameRound round;
  final GameController controller;
  final GameAudioController tuner;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final Chord? chord = controller.chordOf(round.chordId);
    return AppCard(
      child: Column(
        children: <Widget>[
          AppText(t.game.playThisChord, variant: AppTextVariant.titleLarge),
          const SizedBox(height: 4),
          AppText(
            chord?.name ?? round.chordId,
            variant: AppTextVariant.displayLarge,
          ),
          const SizedBox(height: 8),
          ChordPlayButton(
            size: 52,
            onPressed: () => controller.playTarget(round.chordId),
          ),
          const SizedBox(height: 12),
          if (chord == null)
            AppText(t.game.loadingChord)
          else
            ChordDiagram(
              variant: chord.easiestVariant,
              width: 150,
              height: 208,
              stringStates: controller.phase == GamePhase.idle
                  ? null
                  : tuner.stringStatuses,
              stringNames: <String>[
                for (final GuitarString string in kStandardTuning)
                  openNoteName(t, string),
              ],
            ),
        ],
      ),
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
