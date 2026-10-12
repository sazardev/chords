import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/mini_game_intro_view.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_result_view.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Marco común de los minijuegos: bienvenida, partida y resultado.
///
/// Dibuja la barra superior con el marcador y el progreso, y delega el
/// contenido de la partida en [bodyBuilder]; así los tres tipos de juego
/// comparten el mismo recorrido y solo difieren en lo que se juega.
class MiniGameFrame extends StatelessWidget {
  /// Crea el marco de un juego.
  const MiniGameFrame({
    required this.kind,
    required this.phase,
    required this.level,
    required this.score,
    required this.index,
    required this.total,
    required this.isNewBest,
    required this.onStart,
    required this.bodyBuilder,
    super.key,
  });

  /// Juego que se muestra.
  final MiniGameKind kind;

  /// Fase de la partida.
  final MiniGamePhase phase;

  /// Dificultad en curso.
  final MiniGameLevel level;

  /// Marcador.
  final MiniGameScore score;

  /// Posición de la pregunta o ronda actual (desde 0).
  final int index;

  /// Número de preguntas o rondas.
  final int total;

  /// Si la partida terminada es un récord.
  final bool isNewBest;

  /// Empieza una partida con la dificultad indicada.
  final ValueChanged<MiniGameLevel> onStart;

  /// Construye el contenido mientras se juega.
  final WidgetBuilder bodyBuilder;

  bool get _playing =>
      phase != MiniGamePhase.intro && phase != MiniGamePhase.finished;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Scaffold(
      appBar: AppBar(
        title: Text(gameTitle(t, kind)),
        actions: _playing ? <Widget>[_ScoreBadges(score: score)] : null,
        bottom: _playing
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : (index + 1) / total,
                  minHeight: 4,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _content(context),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) => switch (phase) {
    MiniGamePhase.intro => MiniGameIntroView(kind: kind, onStart: onStart),
    MiniGamePhase.finished => MiniGameResultView(
      score: score,
      level: level,
      isNewBest: isNewBest,
      onPlayAgain: onStart,
      onMoreGames: () => context.pop(),
    ),
    _ => bodyBuilder(context),
  };
}

class _ScoreBadges extends StatelessWidget {
  const _ScoreBadges({required this.score});

  final MiniGameScore score;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: <Widget>[
          Tooltip(
            message: t.minigames.streak,
            child: const Icon(Icons.local_fire_department_rounded),
          ),
          const SizedBox(width: 4),
          AppText('${score.streak}'),
          const SizedBox(width: 12),
          Tooltip(
            message: t.minigames.points,
            child: const Icon(Icons.star_rounded),
          ),
          const SizedBox(width: 4),
          AppText('${score.points}'),
        ],
      ),
    );
  }
}
