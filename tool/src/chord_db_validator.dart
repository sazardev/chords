/// Validador del banco de acordes.
///
/// Comprueba la estructura del JSON, los rangos de trastes y dedos, las
/// notas de cada posición y la ausencia de identificadores duplicados.
library;

import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';

/// Problema encontrado durante la validación.
class ValidationIssue {
  /// Crea un problema de validación.
  const ValidationIssue(this.path, this.message);

  /// Ruta JSON donde se detectó el problema.
  final String path;

  /// Descripción del problema.
  final String message;

  @override
  String toString() => '$path: $message';
}

/// Resultado de validar el banco.
class ValidationReport {
  /// Crea el informe de validación.
  const ValidationReport({
    required this.chordCount,
    required this.variantCount,
    required this.issues,
  });

  /// Número de acordes validados.
  final int chordCount;

  /// Número de posiciones validadas.
  final int variantCount;

  /// Problemas encontrados (vacío si todo es correcto).
  final List<ValidationIssue> issues;

  /// `true` si no se encontró ningún problema.
  bool get isValid => issues.isEmpty;
}

/// Valida el archivo JSON del banco de acordes.
ValidationReport validateChordDatabase(String path) {
  final File file = File(path);
  final List<ValidationIssue> issues = <ValidationIssue>[];
  int variantCount = 0;
  if (!file.existsSync()) {
    return ValidationReport(
      chordCount: 0,
      variantCount: 0,
      issues: <ValidationIssue>[ValidationIssue(path, 'El archivo no existe')],
    );
  }

  final Object? decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    return const ValidationReport(
      chordCount: 0,
      variantCount: 0,
      issues: <ValidationIssue>[
        ValidationIssue('root', 'La raíz debe ser un objeto'),
      ],
    );
  }

  final Object? chords = decoded['chords'];
  if (chords is! List<Object?>) {
    return const ValidationReport(
      chordCount: 0,
      variantCount: 0,
      issues: <ValidationIssue>[
        ValidationIssue('chords', 'Falta la lista de acordes'),
      ],
    );
  }

  final Set<String> ids = <String>{};
  for (int i = 0; i < chords.length; i++) {
    final Object? entry = chords[i];
    if (entry is! Map<String, Object?>) {
      issues.add(
        ValidationIssue('chords[$i]', 'Cada acorde debe ser un objeto'),
      );
      continue;
    }
    final Object? id = entry['id'];
    if (id is! String || id.isEmpty) {
      issues.add(ValidationIssue('chords[$i].id', 'Identificador inválido'));
      continue;
    }
    if (!ids.add(id)) {
      issues.add(
        ValidationIssue('chords[$i].id', 'Identificador duplicado: $id'),
      );
    }

    final Object? root = entry['root'];
    if (root is! String) {
      issues.add(ValidationIssue('$id.root', 'Raíz ausente o inválida'));
    } else {
      if (ChordRoot.fromName(root) == null) {
        issues.add(ValidationIssue('$id.root', 'Raíz no reconocida: $root'));
      }
    }

    final Object? quality = entry['quality'];
    if (quality is! String) {
      issues.add(ValidationIssue('$id.quality', 'Calidad ausente o inválida'));
    } else {
      if (ChordQuality.fromId(quality) == null) {
        issues.add(
          ValidationIssue('$id.quality', 'Calidad no reconocida: $quality'),
        );
      }
    }

    final Object? variants = entry['variants'];
    if (variants is! List<Object?> || variants.isEmpty) {
      issues.add(
        ValidationIssue('$id.variants', 'Debe tener al menos una posición'),
      );
      continue;
    }
    for (int v = 0; v < variants.length; v++) {
      variantCount++;
      issues.addAll(_validateVariant(variants[v], '$id.variants[$v]'));
    }
  }

  final List<String> expectedRoots = ChordRoot.values
      .map((ChordRoot r) => r.name)
      .toList();
  for (final String expected in expectedRoots) {
    if (!ids.any((String id) => id.startsWith('$expected-'))) {
      issues.add(
        ValidationIssue(expected, 'Sin acordes para la raíz $expected'),
      );
    }
  }

  return ValidationReport(
    chordCount: chords.length,
    variantCount: variantCount,
    issues: issues,
  );
}

/// Valida una posición individual.
List<ValidationIssue> _validateVariant(Object? variant, String path) {
  final List<ValidationIssue> issues = <ValidationIssue>[];
  if (variant is! Map<String, Object?>) {
    return <ValidationIssue>[
      ValidationIssue(path, 'La posición debe ser un objeto'),
    ];
  }

  final Object? frets = variant['frets'];
  if (frets is! List<Object?> || frets.length != 6) {
    issues.add(ValidationIssue('$path.frets', 'Debe tener 6 cuerdas'));
  } else {
    for (int s = 0; s < 6; s++) {
      final Object? fret = frets[s];
      if (fret is! int || fret < -1 || fret > 15) {
        issues.add(
          ValidationIssue('$path.frets[$s]', 'Traste fuera de rango: $fret'),
        );
      }
    }
  }

  final Object? fingers = variant['fingers'];
  if (fingers is! List<Object?> || fingers.length != 6) {
    issues.add(ValidationIssue('$path.fingers', 'Debe tener 6 cuerdas'));
  } else {
    for (int s = 0; s < 6; s++) {
      final Object? finger = fingers[s];
      if (finger is! int || finger < 0 || finger > 4) {
        issues.add(
          ValidationIssue('$path.fingers[$s]', 'Dedo inválido: $finger'),
        );
      }
    }
  }

  final Object? difficulty = variant['difficulty'];
  if (difficulty is! int) {
    issues.add(
      ValidationIssue('$path.difficulty', 'Dificultad ausente o inválida'),
    );
  } else {
    if (Difficulty.fromLevel(difficulty) == null) {
      issues.add(
        ValidationIssue(
          '$path.difficulty',
          'Dificultad fuera de rango: $difficulty',
        ),
      );
    }
  }

  final Object? barre = variant['barre'];
  if (barre is Map<String, Object?> && barre.isNotEmpty) {
    final Object? fret = barre['fret'];
    final Object? from = barre['from'];
    final Object? to = barre['to'];
    if (fret is! int || from is! int || to is! int) {
      issues.add(ValidationIssue('$path.barre', 'Cejillo incompleto'));
    } else if (from > to || to - from < 1) {
      issues.add(ValidationIssue('$path.barre', 'Rango de cuerdas inválido'));
    }
  }

  final Object? notes = variant['notes'];
  if (notes is! List<Object?> || notes.isEmpty) {
    issues.add(ValidationIssue('$path.notes', 'Debe contener notas'));
  }

  return issues;
}
