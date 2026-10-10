import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/chords/entities/chord.dart';
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
    notifyListeners();
  }

  @override
  void dispose() {
    _filters.removeListener(_onFiltersChanged);
    super.dispose();
  }
}
