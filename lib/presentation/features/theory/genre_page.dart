import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/theory/animated_strum_pattern.dart';
import 'package:chords/presentation/features/theory/theory_widgets.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/router/router_error_screen.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Ficha de un género: qué lo define, ritmo, escalas, acordes, progresiones
/// para jammear y canciones.
class GenrePage extends StatelessWidget {
  /// Crea la ficha del género [genreId].
  const GenrePage({required this.genreId, super.key});

  /// Identificador recibido en la ruta.
  final String? genreId;

  @override
  Widget build(BuildContext context) {
    final GenreGuide? guide = genreGuideById(genreId);
    if (guide == null) {
      return RouterErrorScreen(location: 'genre:$genreId');
    }
    final Translations t = context.t;
    return Scaffold(
      appBar: AppBar(
        title: Text('${guide.emoji}  ${genreGuideName(t, guide.id)}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: <Widget>[
            _About(guide: guide),
            SectionHeader(title: t.theory.genreScales),
            _Scales(guide: guide),
            SectionHeader(title: t.theory.genreChords),
            _Chords(guide: guide),
            SectionHeader(title: t.theory.genreProgressions),
            for (final ChordProgression p in progressionsOf(guide.id))
              _ProgressionTile(progression: p),
            ..._songs(context, t, guide),
          ],
        ),
      ),
    );
  }

  List<Widget> _songs(BuildContext context, Translations t, GenreGuide g) {
    final List<Song> songs = kSongs.where((Song s) => s.genre == g.id).toList();
    if (songs.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      SectionHeader(title: t.theory.genreSongs),
      for (final Song song in songs)
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: const Icon(Icons.lyrics_rounded),
          title: Text(songTitle(t, song)),
          subtitle: Text(songAuthor(t, song)),
          onTap: () => unawaited(context.push('$kSongPath?id=${song.id}')),
        ),
    ];
  }
}

class _About extends StatelessWidget {
  const _About({required this.guide});

  final GenreGuide guide;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? library = guide.libraryGenre;
    final String tempo = t.theory.tempoRange(
      min: guide.minBpm,
      max: guide.maxBpm,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(
            t.theory.genreAbout[guide.id] ?? '',
            variant: AppTextVariant.bodyLarge,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          _RhythmCard(guide: guide, tempo: tempo),
          const SizedBox(height: 12),
          AppCard(
            color: scheme.tertiaryContainer,
            child: AppText(
              '💡 ${t.theory.genreTip[guide.id] ?? ''}',
              color: scheme.onTertiaryContainer,
              overflow: TextOverflow.visible,
            ),
          ),
          if (library != null)
            TextButton.icon(
              icon: const Icon(Icons.grid_view_rounded),
              label: Text(t.theory.genreLibrary(genre: genreLabel(t, library))),
              onPressed: () => unawaited(
                context.push(
                  '$kChordsPath?genre=${Uri.encodeComponent(library)}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RhythmCard extends StatelessWidget {
  const _RhythmCard({required this.guide, required this.tempo});

  final GenreGuide guide;
  final String tempo;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      color: scheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            '${t.theory.genreRhythmTitle} · $tempo',
            variant: AppTextVariant.titleMedium,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(height: 4),
          AppText(
            t.theory.genreRhythm[guide.id] ?? '',
            color: scheme.onSecondaryContainer,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 10),
          AppText(
            t.theory.strumLabel(name: strumName(t, guide.strum)),
            variant: AppTextVariant.labelLarge,
            color: scheme.onSecondaryContainer,
          ),
          const SizedBox(height: 2),
          AppText(
            strumAbout(t, guide.strum),
            variant: AppTextVariant.labelMedium,
            color: scheme.onSecondaryContainer,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 6),
          AnimatedStrumPattern(
            pattern: guide.strum,
            bpm: (guide.minBpm + guide.maxBpm) ~/ 2,
          ),
          if (guide.strum.hasMutedStrokes)
            AppText(
              t.theory.strumMutedHint,
              variant: AppTextVariant.labelMedium,
              color: scheme.onSecondaryContainer,
            ),
        ],
      ),
    );
  }
}

class _Scales extends StatelessWidget {
  const _Scales({required this.guide});

  final GenreGuide guide;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordSymbol first = ChordSymbol.parse(guide.chords.first);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          for (final ScaleType scale in guide.scales)
            ActionChip(
              avatar: const Icon(Icons.stairs_rounded),
              label: Text(scaleInKey(t, scale, first.root)),
              onPressed: () => unawaited(
                context.push(
                  '$kScalesPath?scale=${scale.id}&key=${first.root}&pos=1',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chords extends StatelessWidget {
  const _Chords({required this.guide});

  final GenreGuide guide;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final String name in guide.chords)
          ActionChip(
            label: Text(name),
            onPressed: () => unawaited(
              context.push(chordDetailRoute(ChordSymbol.parse(name).chordId)),
            ),
          ),
      ],
    ),
  );
}

class _ProgressionTile extends StatelessWidget {
  const _ProgressionTile({required this.progression});

  final ChordProgression progression;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final String chords = progression
        .barsIn(progression.tonic)
        .map((List<ChordSymbol> bar) => bar.map((ChordSymbol c) => c.name))
        .expand((Iterable<String> names) => names)
        .toSet()
        .join(' ');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: const Icon(Icons.album_rounded),
      title: Text(progressionName(t, progression)),
      subtitle: Text(
        '${progression.summary}\n'
        '${keyName(t, progression.tonic, minor: progression.minor)}: $chords',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.play_circle_rounded),
      onTap: () => unawaited(context.push('$kJamPath?prog=${progression.id}')),
    );
  }
}
