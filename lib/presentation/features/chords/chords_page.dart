import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/presentation/features/chords/chords_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/router/route_paths.dart';
import 'package:chords/presentation/widgets/atoms/app_empty_state.dart';
import 'package:chords/presentation/widgets/atoms/app_loading.dart';
import 'package:chords/presentation/widgets/molecules/filter_chip_row.dart';
import 'package:chords/presentation/widgets/molecules/search_field.dart';
import 'package:chords/presentation/widgets/organisms/chord_grid.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Listado de acordes con búsqueda, filtros y navegación a detalle.
///
/// Acepta parámetros de consulta: `?root=C&quality=maj&difficulty=2&q=blues`.
class ChordsPage extends StatefulWidget {
  /// Crea el listado.
  const ChordsPage({super.key});

  @override
  State<ChordsPage> createState() => _ChordsPageState();
}

class _ChordsPageState extends State<ChordsPage> {
  bool _paramsApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_paramsApplied) {
      _paramsApplied = true;
      _applyQueryParams();
    }
  }

  void _applyQueryParams() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _applyFiltersFromQuery();
    });
  }

  void _applyFiltersFromQuery() {
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, String> params = state.uri.queryParameters;
    final ChordsController controller = context.read<ChordsController>();
    final String? root = params['root'];
    final String? quality = params['quality'];
    final String? difficulty = params['difficulty'];
    final String? query = params['q'];
    if (root != null && root.isNotEmpty) {
      final ChordRoot? rootEntity = ChordRoot.fromName(root);
      if (rootEntity != null) {
        controller.selectRoot(rootEntity);
      }
    }
    if (quality != null && quality.isNotEmpty) {
      final ChordQuality? qualityEntity = ChordQuality.fromId(quality);
      if (qualityEntity != null) {
        controller.selectQuality(qualityEntity);
      }
    }
    if (difficulty != null && int.tryParse(difficulty) != null) {
      controller.setMaxDifficulty(int.parse(difficulty));
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: SearchField(onChanged: controller.setQuery),
            ),
            FilterChipRow(
              selected: controller.filters.quality,
              onSelected: controller.selectQuality,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _DifficultySlider(controller: controller),
            ),
            const SizedBox(height: 8),
            Expanded(child: _body(controller, mirror)),
          ],
        ),
      ),
    );
  }

  Widget _body(ChordsController controller, bool mirror) =>
      switch (controller.state.status) {
        ChordsStatus.loading => const AppLoading(message: 'Cargando acordes…'),
        ChordsStatus.error => AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'No se pudo cargar el banco',
          message: controller.state.error ?? 'Error desconocido',
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
          onPlay: (String id) {
            context.go('$kChordDetailPath?id=${Uri.encodeComponent(id)}');
          },
        ),
      };
}

class _DifficultySlider extends StatelessWidget {
  const _DifficultySlider({required this.controller});

  final ChordsController controller;

  @override
  Widget build(BuildContext context) {
    final int? max = controller.filters.maxDifficulty;
    return Row(
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
    );
  }
}
