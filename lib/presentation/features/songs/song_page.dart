import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/jam/jam_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/router/router_error_screen.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Ficha de una canción: acordes con su diagrama, partitura de acordes y
/// letra por secciones, transporte de tono y acceso al jam.
class SongPage extends StatefulWidget {
  /// Crea la ficha de la canción [songId].
  const SongPage({required this.songId, super.key});

  /// Identificador recibido en la ruta.
  final String? songId;

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  int _transpose = 0;

  void _shift(int step) => setState(() {
    _transpose = (_transpose + step).clamp(-6, 6);
  });

  @override
  Widget build(BuildContext context) {
    final Song? song = songById(widget.songId);
    if (song == null) {
      return RouterErrorScreen(location: 'song:${widget.songId}');
    }
    final Translations t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(songTitle(t, song))),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.album_rounded),
        label: Text(t.songs.playJam),
        onPressed: () => unawaited(
          context.push('$kJamPath?song=${song.id}&transpose=$_transpose'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
              children: <Widget>[
                _Header(song: song),
                const SizedBox(height: 12),
                _TransposeBar(
                  value: _transpose,
                  onShift: _shift,
                  onReset: () => setState(() => _transpose = 0),
                ),
                const SizedBox(height: 12),
                AppText(
                  t.songs.chordsUsed,
                  variant: AppTextVariant.titleMedium,
                ),
                const SizedBox(height: 8),
                _ChordStrip(chords: song.chords(transpose: _transpose)),
                const SizedBox(height: 16),
                for (final SongSection section in song.sections)
                  _SectionView(section: section, transpose: _transpose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            songAuthor(t, song),
            variant: AppTextVariant.titleMedium,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 4),
          AppText(
            '${genreGuideName(t, song.genre)} · ${t.jam.bpm(n: song.bpm)} · '
            '${t.songs.level(n: song.difficulty)}',
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 10),
          AppText(
            t.theory.strumLabel(name: strumName(t, song.strum)),
            variant: AppTextVariant.labelLarge,
            color: scheme.onPrimaryContainer,
          ),
          const SizedBox(height: 6),
          StrumPatternView(pattern: song.strum),
        ],
      ),
    );
  }
}

class _TransposeBar extends StatelessWidget {
  const _TransposeBar({
    required this.value,
    required this.onShift,
    required this.onReset,
  });

  final int value;
  final ValueChanged<int> onShift;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Row(
      children: <Widget>[
        AppText(t.songs.transpose, variant: AppTextVariant.labelLarge),
        const Spacer(),
        IconButton.filledTonal(
          icon: const Icon(Icons.remove_rounded),
          onPressed: value > -6 ? () => onShift(-1) : null,
        ),
        SizedBox(
          width: 44,
          child: Center(
            child: AppText(
              value > 0 ? '+$value' : '$value',
              variant: AppTextVariant.titleMedium,
            ),
          ),
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.add_rounded),
          onPressed: value < 6 ? () => onShift(1) : null,
        ),
        IconButton(
          tooltip: t.songs.transposeReset,
          icon: const Icon(Icons.restart_alt_rounded),
          onPressed: value == 0 ? null : onReset,
        ),
      ],
    );
  }
}

class _ChordStrip extends StatelessWidget {
  const _ChordStrip({required this.chords});

  final List<ChordSymbol> chords;

  @override
  Widget build(BuildContext context) {
    final JamController jam = context.read<JamController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController s) => s.mirrorChords,
    );
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chords.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int i) {
          final Chord? chord = jam.chordOf(chords[i]);
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () =>
                unawaited(context.push(chordDetailRoute(chords[i].chordId))),
            child: Column(
              children: <Widget>[
                AppText(chords[i].name, variant: AppTextVariant.titleMedium),
                if (chord != null)
                  ChordDiagram(
                    variant: chord.easiestVariant,
                    mirror: mirror,
                    showFingers: false,
                    width: 82,
                    height: 112,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView({required this.section, required this.transpose});

  final SongSection section;
  final int transpose;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            songPartName(t, section.part).toUpperCase(),
            variant: AppTextVariant.labelLarge,
            color: scheme.tertiary,
          ),
          const SizedBox(height: 6),
          for (final SongLine line in section.lines) ...<Widget>[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: <Widget>[
                for (final String bar in line.bars)
                  _BarChip(bar: bar, transpose: transpose),
              ],
            ),
            if (line.lyric.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 10),
                child: AppText(
                  line.lyric,
                  variant: AppTextVariant.bodyLarge,
                  overflow: TextOverflow.visible,
                ),
              )
            else
              const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _BarChip extends StatelessWidget {
  const _BarChip({required this.bar, required this.transpose});

  final String bar;
  final int transpose;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String names = bar
        .split(' ')
        .map((String c) => ChordSymbol.parse(c).transpose(transpose).name)
        .join('  ');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          names,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: scheme.primary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
