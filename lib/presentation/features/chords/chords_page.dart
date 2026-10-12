import 'dart:async' show unawaited;

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chord_filters_sheet.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/profile/profile_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/theme/app_motion.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/atoms/app_text.dart';
import 'package:chords/presentation/widgets/molecules/genre_filter_row.dart';
import 'package:chords/presentation/widgets/molecules/search_field.dart';
import 'package:chords/presentation/widgets/organisms/chord_grid.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Biblioteca de acordes: búsqueda, filtros por género, nivel y dificultad.
///
/// Acepta parámetros de consulta (`?root=C&quality=maj&difficulty=2&q=blues`)
/// para deep links.
class ChordsPage extends StatefulWidget {
  /// Crea la biblioteca.
  const ChordsPage({super.key});

  @override
  State<ChordsPage> createState() => _ChordsPageState();
}

class _ChordsPageState extends State<ChordsPage> {
  String? _appliedQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String query = GoRouterState.of(context).uri.query;
    if (query == _appliedQuery) {
      return;
    }
    _appliedQuery = query;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _applyQueryParams();
      }
    });
  }

  void _applyQueryParams() {
    final Map<String, String> params = GoRouterState.of(context)
        .uri
        .queryParameters;
    final ChordFilterController filters = context.read<ChordFilterController>();
    final String? root = params['root'];
    final String? quality = params['quality'];
    final String? difficulty = params['difficulty'];
    final String? query = params['q'];
    if (root != null) {
      filters.selectRoot(ChordRoot.fromName(root));
    }
    if (quality != null && quality.isNotEmpty) {
      filters.selectQuality(ChordQuality.fromId(quality));
    }
    if (difficulty != null) {
      filters.setMaxDifficulty(int.tryParse(difficulty));
    }
    if (query != null && query.isNotEmpty) {
      filters.setQuery(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final ChordsController controller = context.watch<ChordsController>();
    final ChordFilterController filters = context
        .watch<ChordFilterController>();
    final PlayerProfile profile = context.watch<ProfileController>().profile;
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );
    final int advanced = _advancedFilterCount(filters.filters);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.chords.title),
        actions: <Widget>[
          IconButton(
            tooltip: t.chords.filters,
            icon: Badge(
              isLabelVisible: advanced > 0,
              label: Text('$advanced'),
              child: const Icon(Icons.tune_rounded),
            ),
            onPressed: () => unawaited(showChordFiltersSheet(context)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SearchField(
                hintText: t.chords.searchHint,
                initialValue: filters.filters.query,
                onChanged: filters.setQuery,
              ),
            ),
            GenreFilterRow(
              selected: filters.filters.genre,
              onSelected: filters.selectGenre,
              genres: _orderedGenres(profile),
              highlighted: profile.genres,
              leading: <Widget>[
                _LevelShortcut(filters: filters, profile: profile),
              ],
            ),
            _ResultsBar(
              count: controller.visibleChords.length,
              filters: filters,
            ),
            Expanded(child: _body(controller, mirror)),
          ],
        ),
      ),
    );
  }

  /// Número de filtros avanzados activos (los que viven en la hoja).
  int _advancedFilterCount(ChordFilters filters) =>
      (filters.level != null ? 1 : 0) +
      (filters.quality != null ? 1 : 0) +
      (filters.maxDifficulty != null ? 1 : 0);

  /// Géneros con los favoritos de la persona primero.
  List<String> _orderedGenres(PlayerProfile profile) => <String>[
    ...GenreFilterRow.kDefaultGenreFilters.where(profile.genres.contains),
    ...GenreFilterRow.kDefaultGenreFilters.where(
      (String g) => !profile.genres.contains(g),
    ),
  ];

  Widget _body(ChordsController controller, bool mirror) {
    final Translations t = context.t;
    return switch (controller.status) {
      ChordsStatus.loading => AppLoading(message: t.chords.loading),
      ChordsStatus.error => AppEmptyState(
        icon: Icons.error_outline_rounded,
        title: t.chords.loadErrorTitle,
        message: t.chords.loadErrorMessage,
      ),
      ChordsStatus.ready when controller.visibleChords.isEmpty => AppEmptyState(
        icon: Icons.search_off_rounded,
        title: t.chords.emptyTitle,
        message: t.chords.emptyMessage,
      ),
      ChordsStatus.ready => ChordGrid(
        chords: controller.visibleChords,
        mirror: mirror,
        onSelect: (String id) =>
            context.push('$kChordDetailPath?id=${Uri.encodeComponent(id)}'),
        onPlay: (String id) =>
            context.push('$kChordDetailPath?id=${Uri.encodeComponent(id)}'),
      ),
    };
  }
}

/// Atajo: limita la dificultad a la que corresponde a la experiencia.
class _LevelShortcut extends StatelessWidget {
  const _LevelShortcut({required this.filters, required this.profile});

  final ChordFilterController filters;
  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final int max = profile.experience.maxDifficulty;
    final bool active = filters.filters.maxDifficulty == max;
    return FilterChip(
      avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
      label: Text(t.chords.forMyLevel),
      selected: active,
      showCheckmark: false,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      onSelected: (_) => filters.setMaxDifficulty(active ? null : max),
    );
  }
}

/// Recuento de resultados y atajo para limpiar los filtros.
class _ResultsBar extends StatelessWidget {
  const _ResultsBar({required this.count, required this.filters});

  final int count;
  final ChordFilterController filters;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AppText(
              t.chords.results(n: count),
              variant: AppTextVariant.labelLarge,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          AnimatedOpacity(
            opacity: filters.filters.isEmpty ? 0 : 1,
            duration: kMotionMedium,
            child: TextButton.icon(
              onPressed: filters.filters.isEmpty ? null : filters.clearFilters,
              icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
              label: Text(t.chords.clearFilters),
            ),
          ),
        ],
      ),
    );
  }
}
