import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/usecases/get_chords_use_case.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:flutter/foundation.dart';

/// Estado de la carga del listado.
enum ChordsStatus {
  /// Cargando el banco de acordes.
  loading,

  /// Banco cargado y visible.
  ready,

  /// Falló la carga.
  error,
}

/// Estado del listado de acordes.
class ChordsState {
  /// Crea un estado del listado.
  const ChordsState({
    this.status = ChordsStatus.loading,
    this.chords = const <Chord>[],
    this.error,
  });

  /// Estado de carga.
  final ChordsStatus status;

  /// Todos los acordes cargados.
  final List<Chord> chords;

  /// Mensaje de error si la carga falló.
  final String? error;
}

/// Controlador del listado de acordes y sus filtros.
class ChordsController extends ChangeNotifier {
  /// Crea el controlador con los casos de uso indicados.
  ChordsController(this._getChords, this._searchChords);

  final GetChordsUseCase _getChords;
  final SearchChordsUseCase _searchChords;

  ChordsState _state = const ChordsState();
  ChordFilters _filters = const ChordFilters.empty();
  List<Chord> _visible = const <Chord>[];

  /// Estado actual.
  ChordsState get state => _state;

  /// Filtros activos.
  ChordFilters get filters => _filters;

  /// Acordes que cumplen los filtros.
  List<Chord> get visibleChords => _visible;

  /// Carga inicial del banco de acordes.
  Future<void> load() async {
    _state = const ChordsState();
    notifyListeners();
    try {
      final List<Chord> chords = await _getChords();
      _state = ChordsState(status: ChordsStatus.ready, chords: chords);
      _applyFilters();
    } on Object catch (error) {
      _state = ChordsState(status: ChordsStatus.error, error: '$error');
      notifyListeners();
    }
  }

  /// Cambia el texto de búsqueda.
  void setQuery(String value) {
    _filters = _filters.copyWith(query: value);
    _applyFilters();
  }

  /// Selecciona o deselecciona la raíz.
  void selectRoot(ChordRoot? root) {
    _filters = root == null
        ? _filters.copyWith(clearRoot: true)
        : _filters.copyWith(root: root);
    _applyFilters();
  }

  /// Selecciona o deselecciona la calidad.
  void selectQuality(ChordQuality? quality) {
    _filters = quality == null
        ? _filters.copyWith(clearQuality: true)
        : _filters.copyWith(quality: quality);
    _applyFilters();
  }

  /// Ajusta la dificultad máxima (nulo = sin límite).
  void setMaxDifficulty(int? level) {
    _filters = _filters.copyWith(maxDifficulty: level);
    _applyFilters();
  }

  /// Limpia todos los filtros.
  void clearFilters() {
    _filters = const ChordFilters.empty();
    _applyFilters();
  }

  void _applyFilters() {
    _visible = _searchChords(_state.chords, _filters);
    notifyListeners();
  }
}
