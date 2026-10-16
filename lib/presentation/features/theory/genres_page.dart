import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/theory_labels.dart';
import 'package:chords/presentation/widgets/atoms/app_card.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/atoms/entrance.dart';
import 'package:chords/presentation/widgets/molecules/search_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Guía de géneros: tarjetas por estilo, agrupadas por familia y con búsqueda.
class GenresPage extends StatefulWidget {
  /// Crea la guía.
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  String _query = '';

  /// `true` si el género coincide con la búsqueda por nombre, id o acordes.
  bool _matches(Translations t, GenreGuide guide) {
    final String query = _query.trim().toLowerCase();
    return query.isEmpty ||
        genreGuideName(t, guide.id).toLowerCase().contains(query) ||
        guide.id.toLowerCase().contains(query) ||
        guide.chords.any((String c) => c.toLowerCase() == query);
  }

  /// Cabeceras de familia y tarjetas de los géneros que coinciden.
  List<Widget> _sections(Translations t) {
    final List<Widget> sections = <Widget>[];
    int index = 0;
    for (final GenreFamily family in GenreFamily.values) {
      final List<GenreGuide> guides = <GenreGuide>[
        for (final GenreGuide g in genreGuidesOf(family))
          if (_matches(t, g)) g,
      ];
      if (guides.isEmpty) {
        continue;
      }
      sections.add(_FamilyHeader(family: family, count: guides.length));
      for (final GenreGuide guide in guides) {
        sections.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Entrance(
              index: index++,
              child: _GenreCard(guide: guide),
            ),
          ),
        );
      }
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final List<Widget> sections = _sections(t);
    return Scaffold(
      appBar: AppBar(title: Text(t.theory.genresTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: AppText(
                t.theory.genresSubtitle,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchField(
                hintText: t.theory.genresSearch,
                initialValue: _query,
                onChanged: (String value) => setState(() => _query = value),
              ),
            ),
            if (sections.isEmpty)
              SizedBox(
                height: 280,
                child: AppEmptyState(
                  icon: Icons.search_off_rounded,
                  title: t.theory.genresEmpty,
                  message: t.theory.genresEmptyBody,
                ),
              )
            else
              ...sections,
          ],
        ),
      ),
    );
  }
}

class _FamilyHeader extends StatelessWidget {
  const _FamilyHeader({required this.family, required this.count});

  final GenreFamily family;
  final int count;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AppText(
              genreFamilyName(t, family),
              variant: AppTextVariant.titleLarge,
            ),
          ),
          AppText(
            '$count',
            variant: AppTextVariant.labelLarge,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  const _GenreCard({required this.guide});

  final GenreGuide guide;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: () => unawaited(context.push('$kGenrePath?id=${guide.id}')),
      child: Row(
        children: <Widget>[
          Text(guide.emoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  genreGuideName(t, guide.id),
                  variant: AppTextVariant.titleMedium,
                ),
                AppText(
                  '${t.theory.tempoRange(min: guide.minBpm, max: guide.maxBpm)}'
                  ' · ${guide.chords.join(' ')}',
                  variant: AppTextVariant.labelMedium,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
