/// Comprobaciones que miran el conjunto de posiciones de un acorde y la
/// cobertura del banco entero (no una posición suelta).
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import 'validation_report.dart';

/// Detecta posiciones con identificador o trastes repetidos en un acorde.
class VariantSetChecker {
  /// Crea el comprobador de un acorde.
  VariantSetChecker();

  final Set<String> _ids = <String>{};
  final Set<String> _shapes = <String>{};

  /// Problemas de repetición de [variant] frente a las ya vistas.
  List<ValidationIssue> check(Map<String, Object?> variant, String path) =>
      <ValidationIssue>[
        if (!_ids.add(variant['id']! as String))
          ValidationIssue('$path.id', 'Posición duplicada: ${variant['id']}'),
        if (!_shapes.add((variant['frets']! as List<Object?>).join(',')))
          ValidationIssue('$path.frets', 'Mismos trastes que otra posición'),
      ];
}

/// Las posiciones van ordenadas: primero las formas de siempre y luego los
/// voicings, cada grupo de la más fácil a la más difícil. La primera es la
/// recomendada.
List<ValidationIssue> validateOrder(String id, List<Object?> variants) {
  int previousGroup = 0;
  int previousLevel = 0;
  for (final Object? v in variants) {
    if (v is! Map<String, Object?> ||
        v['difficulty'] is! int ||
        v['id'] is! String) {
      continue;
    }
    final int group = VariantIdentity.parse(v['id']! as String).isShape ? 0 : 1;
    final int level = v['difficulty']! as int;
    if (group < previousGroup ||
        (group == previousGroup && level < previousLevel)) {
      return <ValidationIssue>[
        ValidationIssue(
          '$id.variants',
          'las posiciones no van de fácil a difícil',
        ),
      ];
    }
    if (group != previousGroup) {
      previousLevel = 0;
    }
    previousGroup = group;
    previousLevel = level;
  }
  return const <ValidationIssue>[];
}

/// Debe existir cada raíz con cada calidad y los géneros han de ser conocidos.
List<ValidationIssue> validateCoverage(
  Set<String> chordIds,
) => <ValidationIssue>[
  for (final ChordRoot root in ChordRoot.values)
    for (final ChordQuality quality in ChordQuality.values)
      if (!chordIds.contains('${root.name}-${quality.id}'))
        ValidationIssue(
          '${root.name}-${quality.id}',
          'Falta el acorde ${root.name}-${quality.id}',
        ),
  for (final ChordQuality quality in ChordQuality.values)
    for (final String genre in quality.genres)
      if (!kChordGenres.contains(genre))
        ValidationIssue(quality.id, 'Género desconocido en la calidad: $genre'),
];
