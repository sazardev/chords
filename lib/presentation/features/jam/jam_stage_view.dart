import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_hud.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/theory/scale_marks.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:chords/presentation/widgets/organisms/scale_fretboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Escenario del jam en marcha: acorde actual y siguiente, compases que
/// vienen, rasgueo golpe a golpe, marcador y escala para improvisar.
class JamStageView extends StatelessWidget {
  /// Crea la vista.
  const JamStageView({required this.state, super.key});

  /// Estado de la sesión.
  final JamState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final JamTrack track = state.track!;
    final JamController controller = context.read<JamController>();
    return Column(
      children: <Widget>[
        LinearProgressIndicator(value: state.progress),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: <Widget>[
              if (state.mode == JamMode.score) ...<Widget>[
                JamScoreBar(state: state),
                const SizedBox(height: 12),
              ],
              if (state.phase == JamPhase.countIn)
                _CountIn(count: state.countdown)
              else
                _NowNext(state: state),
              const SizedBox(height: 12),
              _Lyric(state: state),
              JamBarsLane(state: state),
              const SizedBox(height: 12),
              StrumPatternView(
                pattern: track.strum,
                active: state.phase == JamPhase.playing ? state.slot : null,
              ),
              const SizedBox(height: 4),
              Center(
                child: AppText(
                  '${t.jam.barOf(n: state.bar + 1, total: track.bars.length)}'
                  ' · ${t.jam.bpm(n: track.bpm)}',
                  variant: AppTextVariant.labelMedium,
                ),
              ),
              if (state.micProblem) ...<Widget>[
                const SizedBox(height: 8),
                AppText(t.jam.micProblem, maxLines: 2),
              ],
              if (track.scale != null) ...<Widget>[
                const SizedBox(height: 12),
                _ScaleHint(scale: track.scale!, tonic: track.tonic),
              ],
            ],
          ),
        ),
        _Controls(state: state, controller: controller),
      ],
    );
  }
}

class _CountIn extends StatelessWidget {
  const _CountIn({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.tertiaryContainer,
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppText(
              t.jam.countIn,
              variant: AppTextVariant.titleLarge,
              color: scheme.onTertiaryContainer,
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: scheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NowNext extends StatelessWidget {
  const _NowNext({required this.state});

  final JamState state;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordSymbol? now = state.currentChord;
    final ChordSymbol? next = state.nextChord;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: _ChordCard(
              label: t.jam.now,
              chord: now,
              emphasized: true,
              beat: state.beat,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _ChordCard(
              label: next == null ? t.jam.end : t.jam.next,
              chord: next,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChordCard extends StatelessWidget {
  const _ChordCard({
    required this.label,
    required this.chord,
    this.emphasized = false,
    this.beat,
  });

  final String label;
  final ChordSymbol? chord;
  final bool emphasized;
  final int? beat;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Chord? bank = chord == null
        ? null
        : context.read<JamController>().chordOf(chord!);
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    final Color ink = emphasized
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;
    return AppCard(
      color: emphasized ? scheme.primaryContainer : scheme.surfaceContainer,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          AppText(label, variant: AppTextVariant.labelLarge, color: ink),
          FittedBox(
            child: Text(
              chord?.name ?? '—',
              style: TextStyle(
                fontSize: emphasized ? 52 : 34,
                fontWeight: FontWeight.w900,
                color: ink,
              ),
            ),
          ),
          if (bank != null)
            ChordDiagram(
              variant: bank.easiestVariant,
              mirror: mirror,
              width: emphasized ? 120 : 84,
              height: emphasized ? 150 : 108,
            ),
          if (beat != null) ...<Widget>[
            const SizedBox(height: 6),
            BeatDots(
              beat: beat!,
              color: ink,
              beats: context
                  .read<JamController>()
                  .state
                  .track!
                  .strum
                  .beatsPerBar,
            ),
          ],
        ],
      ),
    );
  }
}

class _Lyric extends StatelessWidget {
  const _Lyric({required this.state});

  final JamState state;

  @override
  Widget build(BuildContext context) {
    final JamTrack track = state.track!;
    String lyric = '';
    for (int b = state.bar; b >= 0 && lyric.isEmpty; b--) {
      lyric = track.bars[b].lyric;
    }
    if (lyric.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppText(
        lyric,
        variant: AppTextVariant.titleLarge,
        align: TextAlign.center,
        maxLines: 3,
      ),
    );
  }
}

class _ScaleHint extends StatelessWidget {
  const _ScaleHint({required this.scale, required this.tonic});

  final ScaleType scale;
  final int tonic;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        leading: const Icon(Icons.stairs_rounded),
        title: Text(t.jam.scaleHint(scale: scaleInKey(t, scale, tonic))),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: ScaleFretboard(
              marks: scaleMarks(t, scale, tonic, position: 1),
              window: positionWindow(scale, tonic, 1),
              mirror: mirror,
            ),
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.state, required this.controller});

  final JamState state;
  final JamController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final int bpm = state.track!.bpm;
    final bool paused = state.phase == JamPhase.paused;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: <Widget>[
          IconButton.filledTonal(
            tooltip: t.jam.slower,
            icon: const Icon(Icons.remove_rounded),
            onPressed: () => controller.setTempo(bpm - 5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              icon: Icon(
                paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              ),
              label: Text(paused ? t.jam.resume : t.jam.pause),
              onPressed: state.phase == JamPhase.countIn
                  ? null
                  : controller.togglePause,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.outlined(
            tooltip: t.jam.stop,
            icon: const Icon(Icons.stop_rounded),
            onPressed: () => unawaited(controller.stop()),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: t.jam.faster,
            icon: const Icon(Icons.add_rounded),
            onPressed: () => controller.setTempo(bpm + 5),
          ),
        ],
      ),
    );
  }
}
