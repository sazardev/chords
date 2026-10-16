import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/services/chord_sorter.dart';
import 'package:flutter/foundation.dart';

/// Estado de los filtros de la biblioteca de acordes.
///
/// Responsabilidad única: conservar los filtros activos y notificar sus
/// cambios. No conoce el banco ni la búsqueda; [ChordsController] reacciona a
/// estos cambios para recalcular la lista visible.
class ChordFilterController extends ChangeNotifier {
  /// Crea el controlador sin filtros activos.
  ChordFilterController();

  ChordFilters _filters = const ChordFilters.empty();
  ChordSort _sort = ChordSort.essentials;

  /// Filtros activos.
  ChordFilters get filters => _filters;

  /// Orden con el que se presentan los acordes.
  ChordSort get sort => _sort;

  /// Cambia el orden de la lista.
  void setSort(ChordSort value) {
    if (value == _sort) {
      return;
    }
    _sort = value;
    notifyListeners();
  }

  /// Cambia el texto de búsqueda.
  void setQuery(String value) => _update(_filters.copyWith(query: value));

  /// Selecciona o deselecciona la raíz.
  void selectRoot(ChordRoot? root) =>
      _update(_filters.copyWith(root: root, clearRoot: root == null));

  /// Selecciona o deselecciona la calidad.
  void selectQuality(ChordQuality? quality) => _update(
    _filters.copyWith(quality: quality, clearQuality: quality == null),
  );

  /// Selecciona o deselecciona el género.
  void selectGenre(String? genre) =>
      _update(_filters.copyWith(genre: genre, clearGenre: genre == null));

  /// Selecciona o deselecciona el nivel de aprendizaje.
  void selectLevel(int? level) => _update(_filters.copyWith(level: level));

  /// Ajusta la dificultad máxima (nulo = sin límite).
  void setMaxDifficulty(int? level) =>
      _update(_filters.copyWith(maxDifficulty: level));

  /// Limpia todos los filtros.
  void clearFilters() => _update(const ChordFilters.empty());

  void _update(ChordFilters value) {
    if (value == _filters) {
      return;
    }
    _filters = value;
    notifyListeners();
  }
}
