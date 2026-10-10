/// Validador de las posiciones (variantes) de un acorde.
///
/// Una posición se valida campo a campo: trastes, dedos, dificultad, cejillo y
/// notas. Cada campo tiene su propio comprobador para que los fallos sean
/// precisos y el archivo siga siendo pequeño.
library;

import 'package:chords/domain/chords/entities/difficulty.dart';

import 'validation_report.dart';

/// Valida una posición individual.
List<ValidationIssue> validateChordVariant(Object? variant, String path) {
  if (variant is! Map<String, Object?>) {
    return <ValidationIssue>[
      ValidationIssue(path, 'La posición debe ser un objeto'),
    ];
  }
  return <ValidationIssue>[
    ..._validateFrets(variant['frets'], '$path.frets'),
    ..._validateFingers(variant['fingers'], '$path.fingers'),
    ..._validateDifficulty(variant['difficulty'], '$path.difficulty'),
    ..._validateBarre(variant['barre'], '$path.barre'),
    ..._validateNotes(variant['notes'], '$path.notes'),
  ];
}

/// Comprueba la lista de trastes de las seis cuerdas.
List<ValidationIssue> _validateFrets(Object? frets, String path) {
  if (frets is! List<Object?> || frets.length != 6) {
    return <ValidationIssue>[ValidationIssue(path, 'Debe tener 6 cuerdas')];
  }
  final List<ValidationIssue> issues = <ValidationIssue>[];
  for (int string = 0; string < 6; string++) {
    final Object? fret = frets[string];
    if (fret is! int || fret < -1 || fret > 15) {
      issues.add(
        ValidationIssue('$path[$string]', 'Traste fuera de rango: $fret'),
      );
    }
  }
  return issues;
}

/// Comprueba la lista de dedos de las seis cuerdas.
List<ValidationIssue> _validateFingers(Object? fingers, String path) {
  if (fingers is! List<Object?> || fingers.length != 6) {
    return <ValidationIssue>[ValidationIssue(path, 'Debe tener 6 cuerdas')];
  }
  final List<ValidationIssue> issues = <ValidationIssue>[];
  for (int string = 0; string < 6; string++) {
    final Object? finger = fingers[string];
    if (finger is! int || finger < 0 || finger > 4) {
      issues.add(ValidationIssue('$path[$string]', 'Dedo inválido: $finger'));
    }
  }
  return issues;
}

/// Comprueba que la dificultad sea un nivel conocido.
List<ValidationIssue> _validateDifficulty(Object? difficulty, String path) {
  if (difficulty is! int) {
    return <ValidationIssue>[
      ValidationIssue(path, 'Dificultad ausente o inválida'),
    ];
  }
  if (Difficulty.fromLevel(difficulty) == null) {
    return <ValidationIssue>[
      ValidationIssue(path, 'Dificultad fuera de rango: $difficulty'),
    ];
  }
  return const <ValidationIssue>[];
}

/// Comprueba el cejillo cuando la posición lo declara.
List<ValidationIssue> _validateBarre(Object? barre, String path) {
  if (barre is! Map<String, Object?> || barre.isEmpty) {
    return const <ValidationIssue>[];
  }
  final Object? fret = barre['fret'];
  final Object? from = barre['from'];
  final Object? to = barre['to'];
  if (fret is! int || from is! int || to is! int) {
    return <ValidationIssue>[ValidationIssue(path, 'Cejillo incompleto')];
  }
  if (from > to || to - from < 1) {
    return <ValidationIssue>[
      ValidationIssue(path, 'Rango de cuerdas inválido'),
    ];
  }
  return const <ValidationIssue>[];
}

/// Comprueba que la posición declare sus notas.
List<ValidationIssue> _validateNotes(Object? notes, String path) {
  if (notes is! List<Object?> || notes.isEmpty) {
    return <ValidationIssue>[ValidationIssue(path, 'Debe contener notas')];
  }
  return const <ValidationIssue>[];
}
