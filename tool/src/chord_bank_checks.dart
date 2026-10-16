/// Comprobaciones que miran el conjunto de posiciones de un acorde y la
/// cobertura del banco entero (no una posición suelta).
library;

import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import 'builder/chord_drafts.dart' show kSearchedPenalty;
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

/// La primera posición es la recomendada: debe ser la más fácil, contando que
/// un voicing buscado pesa [kSearchedPenalty] más que una forma de siempre.
List<ValidationIssue> validateFirstIsEasiest(
  String id,
  List<Object?> variants,
) {
  final List<double> weights = <double>[
    for (final Object? v in variants)
      if (v is Map<String, Object?> &&
          v['difficulty'] is int &&
          v['id'] is String)
        _weight(v['difficulty']! as int, v['id']! as String),
  ];
  if (weights.isEmpty || weights.first == weights.reduce(math.min)) {
    return const <ValidationIssue>[];
  }
  return <ValidationIssue>[
    ValidationIssue(
      '$id.variants',
      'la primera posición no es la más fácil (pesa ${weights.first})',
    ),
  ];
}

double _weight(int difficulty, String variantId) =>
    difficulty +
    (VariantIdentity.parse(variantId).isShape ? 0 : kSearchedPenalty);

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
