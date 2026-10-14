import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/search_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Cancionero: búsqueda, filtro por género y lista de canciones.
class SongsPage extends StatefulWidget {
  /// Crea la pantalla.
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  String _query = '';
  String? _genre;

  List<Song> _visible(Translations t) {
    final String query = _query.trim().toLowerCase();
    return <Song>[
      for (final Song song in kSongs)
        if ((_genre == null || song.genre == _genre) &&
            (query.isEmpty ||
                songTitle(t, song).toLowerCase().contains(query) ||
                (song.author ?? '').toLowerCase().contains(query)))
          song,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<Song> songs = _visible(t);
    final Set<String> genres = <String>{
      for (final Song song in kSongs) song.genre,
    };
    return Scaffold(
      appBar: AppBar(title: Text(t.songs.title)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: SearchField(
                hintText: t.songs.searchHint,
                initialValue: _query,
                onChanged: (String value) => setState(() => _query = value),
              ),
            ),
            _GenreChips(
              genres: genres,
              selected: _genre,
              onSelected: (String? g) => setState(() => _genre = g),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: songs.isEmpty
                  ? AppEmptyState(
                      icon: Icons.search_off_rounded,
                      title: t.songs.empty,
                      message: t.songs.emptyBody,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                      itemCount: songs.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int i) =>
                          SongCard(song: songs[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreChips extends StatelessWidget {
  const _GenreChips({
    required this.genres,
    required this.selected,
    required this.onSelected,
  });

  final Set<String> genres;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          ChoiceChip(
            label: Text(t.songs.all),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final GenreGuide guide in kGenreGuides)
            if (genres.contains(guide.id)) ...<Widget>[
              const SizedBox(width: 6),
              ChoiceChip(
                label: Text('${guide.emoji} ${genreGuideName(t, guide.id)}'),
                selected: selected == guide.id,
                onSelected: (_) =>
                    onSelected(selected == guide.id ? null : guide.id),
              ),
            ],
        ],
      ),
    );
  }
}

/// Tarjeta de una canción: título, autoría, nivel, acordes y récord.
class SongCard extends StatelessWidget {
  /// Crea la tarjeta.
  const SongCard({required this.song, super.key});

  /// Canción.
  final Song song;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GenreGuide? guide = genreGuideById(song.genre);
    final int best = context.select<StudioProgressController, int>(
      (StudioProgressController p) => p.jamBest('song:${song.id}'),
    );
    return AppCard(
      onTap: () => unawaited(context.push('$kSongPath?id=${song.id}')),
      child: Row(
        children: <Widget>[
          Text(guide?.emoji ?? '🎵', style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  songTitle(t, song),
                  variant: AppTextVariant.titleMedium,
                  maxLines: 2,
                ),
                AppText(
                  '${songAuthor(t, song)} · '
                  '${t.songs.level(n: song.difficulty)}',
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onSurfaceVariant,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                AppText(
                  song.chords().map((ChordSymbol c) => c.name).join('  '),
                  variant: AppTextVariant.labelLarge,
                  color: scheme.primary,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (best > 0)
            Chip(
              avatar: const Icon(Icons.emoji_events_rounded, size: 16),
              label: Text('$best'),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
