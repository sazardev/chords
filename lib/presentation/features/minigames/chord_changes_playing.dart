import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/chord_changes_controller.dart';
import 'package:chords/presentation/features/minigames/chord_changes_state.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/theme/app_chord_colors.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/mic_level_bar.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// El acorde que hay que tocar ahora, con el marcador, el tiempo y lo que
/// el micrófono oye.
class ChordChangesPlaying extends StatelessWidget {
  /// Crea la vista de la partida en curso.
  const ChordChangesPlaying({
    required this.state,
    required this.controller,
    super.key,
  });

  /// Estado de la partida.
  final ChordChangesState state;

  /// Controlador que oye, juzga y lleva el reloj.
  final ChordChangesController controller;

  @override
  Widget build(BuildContext context) {
    final Chord? chord = state.target;
    if (chord == null) {
      return const SizedBox.shrink();
    }
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Scoreboard(state: state),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: <Widget>[
              AppText(
                t.chordGames.changes.playThis,
                variant: AppTextVariant.labelMedium,
                color: scheme.onSurfaceVariant,
              ),
              AppText(
                chord.name,
                variant: AppTextVariant.displayLarge,
                weight: FontWeight.w800,
                align: TextAlign.center,
              ),
              AppText(
                qualityLabel(t, chord.quality),
                color: scheme.onSurfaceVariant,
                align: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              ChordDiagram(
                variant: chord.easiestVariant,
                mirror: mirror,
                width: 140,
                height: 190,
              ),
              const SizedBox(height: 8),
              _ChordClock(state: state),
              const SizedBox(height: 12),
              AppText(
                t.chordGames.changes.heard(
                  count: state.heardNotes,
                  total: state.targetNotes,
                ),
                variant: AppTextVariant.labelMedium,
              ),
              const SizedBox(height: 8),
              MicLevelBar(level: state.level01),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: controller.hear,
                    icon: const Icon(Icons.volume_up_rounded),
                    label: Text(t.chordGames.changes.hear),
                  ),
                  TextButton.icon(
                    onPressed: controller.skip,
                    icon: const Icon(Icons.skip_next_rounded),
                    label: Text(t.chordGames.changes.skip),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.state});

  final ChordChangesState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool? clean = state.lastClean;
    return AppCard(
      color: scheme.primaryContainer,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  t.chordGames.changes.clean,
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onPrimaryContainer,
                ),
                AppText(
                  '${state.changes} / ${state.goal}',
                  variant: AppTextVariant.headlineMedium,
                  weight: FontWeight.w800,
                  color: scheme.onPrimaryContainer,
                ),
              ],
            ),
          ),
          if (clean != null)
            Icon(
              clean ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: clean ? chordColorsOf(context).inTune : scheme.error,
              semanticLabel: clean
                  ? t.chordGames.changes.cleanChange
                  : t.chordGames.changes.missed,
            ),
          const SizedBox(width: 12),
          AppText(
            t.chordGames.changes.timeLeft(n: (state.msLeft / 1000).ceil()),
            variant: AppTextVariant.titleMedium,
            color: scheme.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}

class _ChordClock extends StatelessWidget {
  const _ChordClock({required this.state});

  final ChordChangesState state;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double fraction = (state.chordMsLeft / state.chordMs).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: fraction,
        minHeight: 8,
        color: fraction < 0.25 ? scheme.error : scheme.primary,
      ),
    );
  }
}
