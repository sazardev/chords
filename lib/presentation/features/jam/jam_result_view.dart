import 'dart:async' show unawaited;

import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/l10n/band_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Resultado del jam: estrellas, precisión, racha y récord; y para seguir,
/// repetir más lento o más rápido.
class JamResultView extends StatelessWidget {
  /// Crea la vista.
  const JamResultView({required this.state, super.key});

  /// Estado de la sesión terminada.
  final JamState state;

  @override
  Widget build(BuildContext context) {
    final bool scored = state.mode == JamMode.score && !state.micProblem;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: <Widget>[
        _ResultCard(state: state, scored: scored),
        const SizedBox(height: 16),
        _Actions(state: state),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state, required this.scored});

  final JamState state;
  final bool scored;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color ink = scheme.onPrimaryContainer;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        children: <Widget>[
          AppText(
            t.jam.resultTitle,
            variant: AppTextVariant.headlineMedium,
            color: ink,
          ),
          const SizedBox(height: 8),
          if (scored)
            _ScoreDetails(state: state, ink: ink)
          else ...<Widget>[
            const Text('🎸', style: TextStyle(fontSize: 56)),
            AppText(
              t.jam.bpm(n: state.track!.bpm),
              variant: AppTextVariant.titleMedium,
              color: ink,
            ),
            _BandSummary(state: state, ink: ink),
          ],
        ],
      ),
    );
  }
}

/// Con qué banda se tocó: estilo y transposición.
class _BandSummary extends StatelessWidget {
  const _BandSummary({required this.state, required this.ink});

  final JamState state;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final BandConfig config = context.read<BandSettingsController>().config;
    final String style = bandStyleName(t, bandStyleOf(state.track!, config));
    return Column(
      children: <Widget>[
        AppText(
          t.jamBand.resultBand(style: style),
          color: ink,
          align: TextAlign.center,
          maxLines: 2,
        ),
        if (config.transpose != 0)
          AppText(
            t.jamBand.resultTranspose(n: signedSemitones(config.transpose)),
            color: ink,
          ),
      ],
    );
  }
}

class _ScoreDetails extends StatelessWidget {
  const _ScoreDetails({required this.state, required this.ink});

  final JamState state;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final JamScore score = state.score;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 3; i++)
              Icon(
                i < score.stars
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: 44,
                color: ink,
              ),
          ],
        ),
        const SizedBox(height: 8),
        AppText(
          t.jam.points(n: score.points),
          variant: AppTextVariant.displayLarge,
          color: ink,
        ),
        if (state.isNewBest)
          AppText(
            '🏆 ${t.jam.newBest}',
            variant: AppTextVariant.titleMedium,
            color: ink,
          ),
        const SizedBox(height: 8),
        AppText(t.jam.accuracy(n: (score.accuracy * 100).round()), color: ink),
        AppText(t.jam.bestStreak(n: score.bestStreak), color: ink),
        AppText(t.jam.perfectBars(n: score.perfect), color: ink),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.state});

  final JamState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final JamController controller = context.read<JamController>();
    final int bpm = state.track!.bpm;
    void restartAt(int value) {
      controller.setTempo(value);
      unawaited(controller.start());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FilledButton.icon(
          icon: const Icon(Icons.replay_rounded),
          label: Text(t.jam.playAgain),
          onPressed: () => unawaited(controller.start()),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.slow_motion_video_rounded),
                label: Text(t.jam.slower),
                onPressed: () => restartAt(bpm - 10),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.speed_rounded),
                label: Text(t.jam.faster),
                onPressed: () => restartAt(bpm + 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => unawaited(controller.load(state.track!)),
          child: Text(t.jam.back),
        ),
      ],
    );
  }
}
