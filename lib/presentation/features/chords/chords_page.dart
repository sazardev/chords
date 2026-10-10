import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/molecules/filter_chip_row.dart';
import 'package:chords/presentation/widgets/molecules/genre_filter_row.dart';
import 'package:chords/presentation/widgets/molecules/level_filter_row.dart';
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
  bool _paramsApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_paramsApplied) {
      return;
    }
    _paramsApplied = true;
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
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(t.chords.title),
        actions: <Widget>[
          IconButton(
            tooltip: t.chords.clearFilters,
            icon: const Icon(Icons.filter_alt_off_outlined),
            onPressed: filters.clearFilters,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SearchField(
                hintText: t.chords.searchHint,
                initialValue: filters.filters.query,
                onChanged: filters.setQuery,
              ),
            ),
            GenreFilterRow(
              selected: filters.filters.genre,
              onSelected: filters.selectGenre,
            ),
            const SizedBox(height: 8),
            LevelFilterRow(
              selected: filters.filters.level,
              onSelected: filters.selectLevel,
            ),
            const SizedBox(height: 8),
            FilterChipRow(
              selected: filters.filters.quality,
              onSelected: filters.selectQuality,
            ),
            const SizedBox(height: 4),
            _DifficultySlider(filters: filters),
            const SizedBox(height: 8),
            Expanded(child: _body(controller, mirror)),
          ],
        ),
      ),
    );
  }

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
            context.go('$kChordDetailPath?id=${Uri.encodeComponent(id)}'),
        onPlay: (String id) =>
            context.go('$kChordDetailPath?id=${Uri.encodeComponent(id)}'),
      ),
    };
  }
}

/// Slider de dificultad máxima.
class _DifficultySlider extends StatelessWidget {
  const _DifficultySlider({required this.filters});

  final ChordFilterController filters;

  @override
  Widget build(BuildContext context) {
    final Translations t = context.t;
    final int? max = filters.filters.maxDifficulty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Text(
            t.chords.maxDifficulty(level: max ?? 5),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Expanded(
            child: Slider(
              min: 1,
              max: 5,
              divisions: 4,
              value: (max ?? 5).toDouble(),
              label: '${max ?? 5}',
              onChanged: (double value) {
                filters.setMaxDifficulty(value == 5 ? null : value.round());
              },
            ),
          ),
        ],
      ),
    );
  }
}
