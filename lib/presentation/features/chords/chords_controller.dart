import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
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

/// Controlador de la biblioteca de acordes y sus filtros.
class ChordsController extends ChangeNotifier {
  /// Crea el controlador.
  ChordsController(this._repository, this._searchChords, this._preferences);

  final ChordRepository _repository;
  final SearchChordsUseCase _searchChords;
  final PreferencesRepository _preferences;

  ChordsStatus _status = ChordsStatus.loading;
  ChordFilters _filters = const ChordFilters.empty();
  List<Chord> _visible = const <Chord>[];

  /// Estado de carga.
  ChordsStatus get status => _status;

  /// Filtros activos.
  ChordFilters get filters => _filters;

  /// Acordes que cumplen los filtros (esenciales primero).
  List<Chord> get visibleChords => _visible;

  /// Todos los acordes del banco.
  List<Chord> get allChords => _repository.chords;

  /// Si el sonido está activado.
  bool get soundEnabled => _preferences.soundEnabled;

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

  /// Cambia el texto de búsqueda.
  void setQuery(String value) {
    _filters = _filters.copyWith(query: value);
    _applyFilters();
  }

  /// Selecciona o deselecciona la raíz.
  void selectRoot(ChordRoot? root) {
    _filters = _filters.copyWith(root: root, clearRoot: root == null);
    _applyFilters();
  }

  /// Selecciona o deselecciona la calidad.
  void selectQuality(ChordQuality? quality) {
    _filters = _filters.copyWith(
      quality: quality,
      clearQuality: quality == null,
    );
    _applyFilters();
  }

  /// Selecciona o deselecciona el género.
  void selectGenre(String? genre) {
    _filters = _filters.copyWith(genre: genre, clearGenre: genre == null);
    _applyFilters();
  }

  /// Selecciona o deselecciona el nivel de aprendizaje.
  void selectLevel(int? level) {
    _filters = _filters.copyWith(level: level);
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
    _visible = _repository.essentialFirst(
      _searchChords(_repository.chords, _filters),
    );
    notifyListeners();
  }
}
