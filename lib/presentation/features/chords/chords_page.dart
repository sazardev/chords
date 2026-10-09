import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/router/route_paths.dart';
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
    final ChordsController controller = context.read<ChordsController>();
    final String? root = params['root'];
    final String? quality = params['quality'];
    final String? difficulty = params['difficulty'];
    final String? query = params['q'];
    if (root != null) {
      controller.selectRoot(ChordRoot.fromName(root));
    }
    if (quality != null && quality.isNotEmpty) {
      controller.selectQuality(ChordQuality.fromId(quality));
    }
    if (difficulty != null) {
      controller.setMaxDifficulty(int.tryParse(difficulty));
    }
    if (query != null && query.isNotEmpty) {
      controller.setQuery(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChordsController controller = context.watch<ChordsController>();
    final bool mirror = context.select<SettingsController, bool>(
      (SettingsController settings) => settings.mirrorChords,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acordes'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Limpiar filtros',
            icon: const Icon(Icons.filter_alt_off_outlined),
            onPressed: controller.clearFilters,
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
                initialValue: controller.filters.query,
                onChanged: controller.setQuery,
              ),
            ),
            GenreFilterRow(
              selected: controller.filters.genre,
              onSelected: controller.selectGenre,
            ),
            const SizedBox(height: 8),
            LevelFilterRow(
              selected: controller.filters.level,
              onSelected: controller.selectLevel,
            ),
            const SizedBox(height: 8),
            FilterChipRow(
              selected: controller.filters.quality,
              onSelected: controller.selectQuality,
            ),
            const SizedBox(height: 4),
            _DifficultySlider(controller: controller),
            const SizedBox(height: 8),
            Expanded(child: _body(controller, mirror)),
          ],
        ),
      ),
    );
  }

  Widget _body(ChordsController controller, bool mirror) =>
      switch (controller.status) {
        ChordsStatus.loading => const AppLoading(message: 'Cargando acordes…'),
        ChordsStatus.error => const AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'No se pudo cargar el banco',
          message: 'Reinicia la app para reintentar la carga del banco.',
        ),
        ChordsStatus.ready when controller.visibleChords.isEmpty =>
          const AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'Sin resultados',
            message: 'Ajusta la búsqueda o los filtros para ver más acordes.',
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

/// Slider de dificultad máxima.
class _DifficultySlider extends StatelessWidget {
  const _DifficultySlider({required this.controller});

  final ChordsController controller;

  @override
  Widget build(BuildContext context) {
    final int? max = controller.filters.maxDifficulty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Text(
            'Dificultad máx: ${max ?? 5}',
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
                controller.setMaxDifficulty(value == 5 ? null : value.round());
              },
            ),
          ),
        ],
      ),
    );
  }
}
