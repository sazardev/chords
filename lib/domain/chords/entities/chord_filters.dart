import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:meta/meta.dart';

/// Criterios de filtrado del listado de acordes.
@immutable
class ChordFilters {
  /// Crea unos filtros vacíos (sin restricciones).
  const ChordFilters({
    this.root,
    this.quality,
    this.maxDifficulty,
    this.query = '',
  });

  /// Filtros sin restricciones.
  const ChordFilters.empty() : this();

  /// Raíz seleccionada (opcional).
  final ChordRoot? root;

  /// Calidad seleccionada (opcional).
  final ChordQuality? quality;

  /// Dificultad máxima permitida (1-5).
  final int? maxDifficulty;

  /// Texto de búsqueda libre.
  final String query;

  /// `true` si no hay ningún filtro activo.
  bool get isEmpty =>
      root == null &&
      quality == null &&
      maxDifficulty == null &&
      query.trim().isEmpty;

  /// Devuelve una copia con los campos indicados reemplazados.
  ChordFilters copyWith({
    ChordRoot? root,
    ChordQuality? quality,
    int? maxDifficulty,
    String? query,
    bool clearRoot = false,
    bool clearQuality = false,
  }) => ChordFilters(
    root: clearRoot ? null : (root ?? this.root),
    quality: clearQuality ? null : (quality ?? this.quality),
    maxDifficulty: maxDifficulty ?? this.maxDifficulty,
    query: query ?? this.query,
  );

  @override
  bool operator ==(Object other) =>
      other is ChordFilters &&
      other.root == root &&
      other.quality == quality &&
      other.maxDifficulty == maxDifficulty &&
      other.query == query;

  @override
  int get hashCode => Object.hash(root, quality, maxDifficulty, query);

  @override
  String toString() =>
      'ChordFilters(root: ${root?.name}, quality: ${quality?.id}, '
      'maxDifficulty: $maxDifficulty, query: $query)';
}
