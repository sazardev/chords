import 'dart:async';

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/chord_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/presentation/features/chords/chord_filter_controller.dart';
import 'package:flutter/foundation.dart';

/// Estado de la carga de la biblioteca.
enum ChordsStatus {
  /// Cargando el banco de acordes.
  loading,

  /// Banco cargado y visible.
  ready,

  /// Falló la carga.
  error,
}

/// Controlador de la biblioteca de acordes.
///
/// Responsabilidad única: cargar el banco y mantener la lista visible, que
/// deriva de los filtros que publica [ChordFilterController]. Los filtros y sus
/// controles viven en ese otro controlador.
class ChordsController extends ChangeNotifier {
  /// Crea el controlador con el banco, la búsqueda y los filtros a observar.
  ChordsController(this._repository, this._searchChords, this._filters) {
    _filters.addListener(_onFiltersChanged);
  }

  final ChordRepository _repository;
  final SearchChordsUseCase _searchChords;
  final ChordFilterController _filters;

  ChordsStatus _status = ChordsStatus.loading;
  List<Chord> _visible = const <Chord>[];
  ChordFilters _lastFilters = const ChordFilters.empty();
  Timer? _searchDebounce;

  /// Estado de carga.
  ChordsStatus get status => _status;

  /// Acordes que cumplen los filtros (esenciales primero).
  List<Chord> get visibleChords => _visible;

  /// Todos los acordes del banco.
  List<Chord> get allChords => _repository.chords;

  /// Carga inicial del banco de acordes.
  Future<void> load() async {
    _status = ChordsStatus.loading;
    notifyListeners();
    try {
      await _repository.load();
      _applyFilters();
      _status = ChordsStatus.ready;
    } on Object catch (error, stackTrace) {
      appLogger.error(
        'no se pudo cargar la biblioteca de acordes',
        channel: LogChannel.chords,
        error: error,
        stackTrace: stackTrace,
      );
      _status = ChordsStatus.error;
    }
    notifyListeners();
  }

  void _onFiltersChanged() => _applyFilters();

  void _applyFilters() {
    _visible = _repository.essentialFirst(
      _searchChords(_repository.chords, _filters.filters),
    );
    _trackFilters();
    notifyListeners();
  }

  void _trackFilters() {
    final ChordFilters current = _filters.filters;
    final ChordFilters previous = _lastFilters;
    if (current == previous) {
      return;
    }
    _lastFilters = current;
    _trackSearch(current.query, previous.query);
    final ({String name, Object? value})? change = _changedFilter(
      previous,
      current,
    );
    if (change == null) {
      return;
    }
    appLogger.debug(
      'filtro ${change.name}=${change.value ?? '—'} '
      '(${_visible.length} resultados)',
      channel: LogChannel.chords,
    );
    analytics.filterChanged(
      filter: change.name,
      value: change.value,
      results: _visible.length,
    );
  }

  void _trackSearch(String current, String previous) {
    if (current == previous) {
      return;
    }
    _searchDebounce?.cancel();
    if (current.trim().isEmpty) {
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 700), () {
      final String query = _filters.filters.query;
      if (query.trim().isEmpty) {
        return;
      }
      appLogger.debug(
        'búsqueda "$query" (${_visible.length} resultados)',
        channel: LogChannel.chords,
      );
      analytics.searchPerformed(query: query, results: _visible.length);
    });
  }

  ({String name, Object? value})? _changedFilter(
    ChordFilters previous,
    ChordFilters current,
  ) {
    final List<({String name, Object? value})> changes =
        <({String name, Object? value})>[
          if (previous.root != current.root)
            (name: 'root', value: current.root?.name),
          if (previous.quality != current.quality)
            (name: 'quality', value: current.quality?.id),
          if (previous.genre != current.genre)
            (name: 'genre', value: current.genre),
          if (previous.level != current.level)
            (name: 'level', value: current.level),
          if (previous.maxDifficulty != current.maxDifficulty)
            (name: 'max_difficulty', value: current.maxDifficulty),
        ];
    if (changes.isEmpty) {
      return null;
    }
    if (changes.length > 1) {
      return (name: 'all', value: null);
    }
    return changes.first;
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _filters.removeListener(_onFiltersChanged);
    super.dispose();
  }
}
