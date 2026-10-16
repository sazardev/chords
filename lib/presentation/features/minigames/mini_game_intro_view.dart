import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_bar.dart';
import 'package:chords/presentation/features/minigames/mini_game_catalog.dart';
import 'package:chords/presentation/features/minigames/mini_game_level_hint.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Bienvenida de un minijuego: cómo se juega y qué dificultad elegir.
class MiniGameIntroView extends StatefulWidget {
  /// Crea la bienvenida de [kind].
  const MiniGameIntroView({
    required this.kind,
    required this.onStart,
    super.key,
    this.guitar = false,
  });

  /// Juego que se va a jugar.
  final MiniGameKind kind;

  /// Se llama con la dificultad elegida al pulsar "Empezar".
  final ValueChanged<MiniGameLevel> onStart;

  /// Si la partida se maneja tocando cuerdas al aire con la guitarra.
  final bool guitar;

  @override
  State<MiniGameIntroView> createState() => _MiniGameIntroViewState();
}

class _MiniGameIntroViewState extends State<MiniGameIntroView> {
  MiniGameLevel _level = MiniGameLevel.easy;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final MiniGameProgressController progress = context
        .watch<MiniGameProgressController>();
    final int best = progress.bestFor(widget.kind, _level);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 88,
              height: 88,
              child: Icon(
                miniGameIcon(widget.kind),
                size: 44,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppText(
          gameTitle(t, widget.kind),
          variant: AppTextVariant.headlineMedium,
          weight: FontWeight.w800,
          align: TextAlign.center,
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                t.minigames.howToPlay,
                variant: AppTextVariant.titleMedium,
              ),
              const SizedBox(height: 6),
              AppText(
                gameHowTo(t, widget.kind),
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Icon(
                    widget.kind.usesMic
                        ? Icons.mic_rounded
                        : Icons.headphones_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      widget.kind.usesMic
                          ? t.minigames.micTip
                          : t.minigames.earTip,
                      variant: AppTextVariant.labelMedium,
                      color: scheme.onSurfaceVariant,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppText(t.minigames.levelTitle, variant: AppTextVariant.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<MiniGameLevel>(
          showSelectedIcon: false,
          segments: <ButtonSegment<MiniGameLevel>>[
            for (final MiniGameLevel level in MiniGameLevel.values)
              ButtonSegment<MiniGameLevel>(
                value: level,
                label: Text(levelLabel(t, level)),
              ),
          ],
          selected: <MiniGameLevel>{_level},
          onSelectionChanged: (Set<MiniGameLevel> value) =>
              setState(() => _level = value.first),
        ),
        MiniGameLevelHint(kind: widget.kind, level: _level),
        const SizedBox(height: 8),
        if (best > 0)
          AppText(
            t.minigames.levelBest(percent: best),
            variant: AppTextVariant.labelMedium,
            color: scheme.onSurfaceVariant,
            align: TextAlign.center,
          ),
        const SizedBox(height: 20),
        if (widget.guitar)
          GuitarCommandBar(actions: _guitarActions(t))
        else
          FilledButton.icon(
            onPressed: () => widget.onStart(_level),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(t.minigames.start),
          ),
      ],
    );
  }

  /// Empezar, cambiar de dificultad y salir sin soltar la guitarra.
  List<GuitarAction> _guitarActions(Translations t) => <GuitarAction>[
    GuitarAction(
      command: GuitarCommand.next,
      label: t.minigames.start,
      icon: Icons.play_arrow_rounded,
      emphasized: true,
      onTrigger: () => widget.onStart(_level),
    ),
    GuitarAction(
      command: GuitarCommand.skip,
      label: '${t.minigames.levelTitle}: ${levelLabel(t, _level)}',
      icon: Icons.tune_rounded,
      onTrigger: _nextLevel,
    ),
    GuitarAction(
      command: GuitarCommand.exit,
      label: t.guitar.leave,
      icon: Icons.logout_rounded,
      onTrigger: () => context.pop(),
    ),
  ];

  void _nextLevel() {
    const List<MiniGameLevel> levels = MiniGameLevel.values;
    setState(() => _level = levels[(_level.index + 1) % levels.length]);
  }
}
