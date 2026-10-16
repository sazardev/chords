/// Validador de las posiciones (variantes) de un acorde.
///
/// Una posición se valida campo a campo: trastes, dedos, dificultad, cejillo y
/// etiquetas. Cada campo tiene su propio comprobador para que los fallos sean
/// precisos y el archivo siga siendo pequeño.
library;

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import 'chord_variant_theory.dart';
import 'fingering/fingering_rules.dart';
import 'fingering/physical_difficulty.dart';
import 'validation_report.dart';

/// Cuánto puede superar la dificultad declarada a la física antes de
/// considerarse incoherente.
const int kMaxDifficultyExcess = 2;

/// Valida la estructura de una posición individual.
List<ValidationIssue> validateChordVariant(Object? variant, String path) {
  if (variant is! Map<String, Object?>) {
    return <ValidationIssue>[
      ValidationIssue(path, 'La posición debe ser un objeto'),
    ];
  }
  return <ValidationIssue>[
    ..._validateId(variant['id'], '$path.id'),
    ..._validateSixInts(variant['frets'], '$path.frets', -1, 15),
    ..._validateSixInts(variant['fingers'], '$path.fingers', 0, 4),
    ..._validateDifficulty(variant['difficulty'], '$path.difficulty'),
    ..._validateBarre(variant['barre'], '$path.barre'),
  ];
}

List<ValidationIssue> _validateId(Object? id, String path) =>
    id is String && id.isNotEmpty
    ? const <ValidationIssue>[]
    : <ValidationIssue>[ValidationIssue(path, 'Identificador inválido')];

/// Comprueba una lista de seis enteros dentro de [min, max].
List<ValidationIssue> _validateSixInts(
  Object? values,
  String path,
  int min,
  int max,
) {
  if (values is! List<Object?> || values.length != 6) {
    return <ValidationIssue>[ValidationIssue(path, 'Debe tener 6 cuerdas')];
  }
  return <ValidationIssue>[
    for (int s = 0; s < 6; s++)
      if (values[s] is! int ||
          (values[s]! as int) < min ||
          (values[s]! as int) > max)
        ValidationIssue('$path[$s]', 'Valor fuera de rango: ${values[s]}'),
  ];
}

List<ValidationIssue> _validateDifficulty(Object? difficulty, String path) {
  if (difficulty is! int) {
    return <ValidationIssue>[
      ValidationIssue(path, 'Dificultad ausente o inválida'),
    ];
  }
  return Difficulty.fromLevel(difficulty) == null
      ? <ValidationIssue>[
          ValidationIssue(path, 'Dificultad fuera de rango: $difficulty'),
        ]
      : const <ValidationIssue>[];
}

/// Comprueba el cejillo `[traste, cuerdaInicial, cuerdaFinal]` si existe.
List<ValidationIssue> _validateBarre(Object? barre, String path) {
  if (barre == null) {
    return const <ValidationIssue>[];
  }
  if (barre is! List<Object?> ||
      barre.length != 3 ||
      barre.any((Object? v) => v is! int)) {
    return <ValidationIssue>[ValidationIssue(path, 'Cejillo incompleto')];
  }
  final int from = barre[1]! as int;
  final int to = barre[2]! as int;
  return from < 0 || to > 5 || to - from < 1
      ? <ValidationIssue>[ValidationIssue(path, 'Rango de cuerdas inválido')]
      : const <ValidationIssue>[];
}

/// Comprobaciones de fondo de una posición ya válida en estructura.
///
/// Que las notas sean las del acorde, que la digitación se pueda tocar con
/// una mano (dedos, cejillo y estiramiento) y que la dificultad declarada sea
/// coherente con lo que exige la mano.
List<ValidationIssue> validateChordVariantSemantics(
  Object? variant,
  ChordRoot root,
  ChordQuality quality,
  String path,
) {
  if (variant is! Map<String, Object?>) {
    return const <ValidationIssue>[];
  }
  final List<int> frets = (variant['frets']! as List<Object?>).cast<int>();
  final List<int> fingers = (variant['fingers']! as List<Object?>).cast<int>();
  final VariantIdentity identity = VariantIdentity.parse(
    variant['id']! as String,
  );
  return <ValidationIssue>[
    for (final String problem in theoryIssues(
      root,
      quality,
      frets,
      expectedBass: identity.bassInterval,
    ))
      ValidationIssue(path, problem),
    for (final String problem in fingeringIssues(frets, fingers))
      ValidationIssue('$path.fingers', problem),
    ..._barreMatchesFingers(variant['barre'], frets, fingers, path),
    ..._difficultyIsCoherent(
      variant['difficulty']! as int,
      frets,
      fingers,
      path,
    ),
  ];
}

/// La dificultad no puede ser menor que la física ni exceder demasiado.
List<ValidationIssue> _difficultyIsCoherent(
  int declared,
  List<int> frets,
  List<int> fingers,
  String path,
) {
  final int physical = physicalDifficulty(frets, fingers);
  if (declared < physical) {
    return <ValidationIssue>[
      ValidationIssue(
        '$path.difficulty',
        'dificultad $declared menor que la que exige la mano ($physical)',
      ),
    ];
  }
  return declared > physical + kMaxDifficultyExcess
      ? <ValidationIssue>[
          ValidationIssue(
            '$path.difficulty',
            'dificultad $declared exagerada (la mano exige $physical)',
          ),
        ]
      : const <ValidationIssue>[];
}

/// El cejillo declarado debe ser el que implican los dedos.
List<ValidationIssue> _barreMatchesFingers(
  Object? barre,
  List<int> frets,
  List<int> fingers,
  String path,
) {
  final ({int fret, int from, int to})? expected = barreOf(frets, fingers);
  final List<Object?> declared = barre is List<Object?>
      ? barre
      : const <Object?>[];
  final bool matches = expected == null
      ? declared.isEmpty
      : declared.length == 3 &&
            declared[0] == expected.fret &&
            declared[1] == expected.from &&
            declared[2] == expected.to;
  return matches
      ? const <ValidationIssue>[]
      : <ValidationIssue>[
          ValidationIssue('$path.barre', 'No coincide con los dedos'),
        ];
}
