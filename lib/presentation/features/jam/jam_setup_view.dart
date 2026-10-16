import 'dart:async' show unawaited;

import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_band_panel.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/jam/jam_custom_builder.dart';
import 'package:chords/presentation/features/jam/jam_progression_picker.dart';
import 'package:chords/presentation/features/jam/jam_selection.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/jam/jam_tempo_control.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Preparación del jam: qué tocar, tono, tempo, modo y metrónomo.
class JamSetupView extends StatelessWidget {
  /// Crea la vista.
  const JamSetupView({
    required this.selection,
    required this.onChanged,
    super.key,
  });

  /// Selección actual.
  final JamSelection selection;

  /// Se llama al cambiar la selección.
  final ValueChanged<JamSelection> onChanged;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final JamController controller = context.watch<JamController>();
    final JamState state = controller.state;
    final int best = context.select<StudioProgressController, int>(
      (StudioProgressController p) => p.jamBest(state.track?.key ?? ''),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: <Widget>[
        AppText(
          t.jam.subtitle,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        SegmentedButton<JamSource>(
          segments: <ButtonSegment<JamSource>>[
            ButtonSegment<JamSource>(
              value: JamSource.progression,
              icon: const Icon(Icons.repeat_rounded),
              label: _OneLine(t.jam.progressionsTab),
            ),
            ButtonSegment<JamSource>(
              value: JamSource.song,
              icon: const Icon(Icons.lyrics_rounded),
              label: _OneLine(t.jam.songsTab),
            ),
            ButtonSegment<JamSource>(
              value: JamSource.custom,
              icon: const Icon(Icons.edit_rounded),
              label: _OneLine(t.jam.customTab),
            ),
          ],
          showSelectedIcon: false,
          selected: <JamSource>{selection.source},
          onSelectionChanged: (Set<JamSource> s) =>
              onChanged(selection.copyWith(source: s.first)),
        ),
        const SizedBox(height: 12),
        ..._sourcePicker(context),
        const SizedBox(height: 16),
        _TempoCard(state: state, controller: controller),
        const SizedBox(height: 12),
        _ModeCard(state: state, controller: controller),
        const SizedBox(height: 12),
        JamBandPanel(scoreMode: state.mode == JamMode.score),
        const SizedBox(height: 16),
        if (best > 0) Center(child: AppText(t.jam.best(n: best))),
        const SizedBox(height: 8),
        FilledButton.icon(
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(t.jam.start),
          onPressed:
              state.track == null ||
                  (selection.source == JamSource.custom &&
                      selection.custom.isEmpty)
              ? null
              : () => unawaited(controller.start()),
        ),
      ],
    );
  }

  List<Widget> _sourcePicker(BuildContext context) =>
      switch (selection.source) {
        JamSource.progression => <Widget>[
          JamProgressionPicker(selection: selection, onChanged: onChanged),
        ],
        JamSource.song => <Widget>[
          _SongPicker(selection: selection, onChanged: onChanged),
        ],
        JamSource.custom => <Widget>[
          JamCustomBuilder(selection: selection, onChanged: onChanged),
        ],
      };
}

class _SongPicker extends StatelessWidget {
  const _SongPicker({required this.selection, required this.onChanged});

  final JamSelection selection;
  final ValueChanged<JamSelection> onChanged;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DropdownButtonFormField<String>(
          initialValue: selection.songId,
          isExpanded: true,
          decoration: InputDecoration(labelText: t.jam.chooseTrack),
          items: <DropdownMenuItem<String>>[
            for (final Song song in kSongs)
              DropdownMenuItem<String>(
                value: song.id,
                child: Text(
                  songTitle(t, song),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (String? id) =>
              onChanged(selection.copyWith(songId: id, transpose: 0)),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: AppText(
                t.songs.transpose,
                variant: AppTextVariant.labelLarge,
              ),
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.remove_rounded),
              onPressed: selection.transpose > -6
                  ? () => onChanged(
                      selection.copyWith(transpose: selection.transpose - 1),
                    )
                  : null,
            ),
            SizedBox(
              width: 40,
              child: Center(child: AppText('${selection.transpose}')),
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.add_rounded),
              onPressed: selection.transpose < 6
                  ? () => onChanged(
                      selection.copyWith(transpose: selection.transpose + 1),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _TempoCard extends StatelessWidget {
  const _TempoCard({required this.state, required this.controller});

  final JamState state;
  final JamController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final int bpm = state.track?.bpm ?? 80;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  t.jam.tempo,
                  variant: AppTextVariant.titleMedium,
                ),
              ),
              AppText(t.jam.bpm(n: bpm), variant: AppTextVariant.titleMedium),
            ],
          ),
          Slider(
            value: bpm.toDouble(),
            min: kJamMinBpm.toDouble(),
            max: kJamMaxBpm.toDouble(),
            divisions: (kJamMaxBpm - kJamMinBpm) ~/ 2,
            label: '$bpm',
            onChanged: state.track == null
                ? null
                : (double v) => controller.setTempo(v.round()),
          ),
          if (state.track != null)
            JamTempoControl(bpm: bpm, onChanged: controller.setTempo),
          if (state.track != null) ...<Widget>[
            AppText(
              t.theory.strumLabel(name: strumName(t, state.track!.strum)),
              variant: AppTextVariant.labelLarge,
            ),
            const SizedBox(height: 6),
            StrumPatternView(pattern: state.track!.strum),
          ],
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.state, required this.controller});

  final JamState state;
  final JamController controller;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final bool score = state.mode == JamMode.score;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SegmentedButton<JamMode>(
            segments: <ButtonSegment<JamMode>>[
              ButtonSegment<JamMode>(
                value: JamMode.backing,
                icon: const Icon(Icons.speaker_rounded),
                label: Text(t.jam.modeBacking),
              ),
              ButtonSegment<JamMode>(
                value: JamMode.score,
                icon: const Icon(Icons.mic_rounded),
                label: Text(t.jam.modeScore),
              ),
            ],
            selected: <JamMode>{state.mode},
            onSelectionChanged: (Set<JamMode> s) => controller.setMode(s.first),
          ),
          const SizedBox(height: 8),
          AppText(
            score ? t.jam.modeScoreBody : t.jam.modeBackingBody,
            maxLines: 3,
          ),
          if (score)
            AppText(
              t.jam.headphonesTip,
              variant: AppTextVariant.labelMedium,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              maxLines: 3,
            ),
        ],
      ),
    );
  }
}

/// Etiqueta de una sola línea que se encoge en vez de partirse.
class _OneLine extends StatelessWidget {
  const _OneLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(text, maxLines: 1, softWrap: false),
  );
}
