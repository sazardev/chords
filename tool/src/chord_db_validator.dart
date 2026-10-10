/// Validador del banco de acordes.
///
/// Comprueba la estructura del documento JSON, la cobertura de raíces y delega
/// la validación de cada posición en `chord_variant_validator.dart`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

import 'chord_variant_validator.dart';
import 'validation_report.dart';

export 'validation_report.dart';

/// Valida el archivo JSON del banco de acordes.
ValidationReport validateChordDatabase(String path) {
  final File file = File(path);
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

  final _BankIssues issues = _BankIssues();
  for (int index = 0; index < chords.length; index++) {
    _validateChordEntry(chords[index], index, issues);
  }
  _validateCoverage(issues);

  return ValidationReport(
    chordCount: chords.length,
    variantCount: issues.variantCount,
    issues: issues.all,
  );
}

/// Acumulador de problemas durante el recorrido del banco.
class _BankIssues {
  /// Crea el acumulador.
  _BankIssues();

  /// Problemas encontrados.
  final List<ValidationIssue> all = <ValidationIssue>[];

  /// Identificadores ya vistos, para detectar duplicados.
  final Set<String> ids = <String>{};

  /// Número de posiciones recorridas.
  int variantCount = 0;

  /// Añade un problema.
  void add(ValidationIssue issue) => all.add(issue);

  /// Añade varios problemas.
  void addAll(Iterable<ValidationIssue> issues) => all.addAll(issues);
}

/// Valida una entrada completa del banco (acorde con sus posiciones).
void _validateChordEntry(Object? entry, int index, _BankIssues issues) {
  if (entry is! Map<String, Object?>) {
    issues.add(
      ValidationIssue('chords[$index]', 'Cada acorde debe ser un objeto'),
    );
    return;
  }
  final Map<String, Object?> chord = entry;
  final String? id = _validateIdentity(chord, index, issues);
  if (id == null) {
    return;
  }
  _validateRoot(entry['root'], id, issues);
  _validateQuality(entry['quality'], id, issues);
  _validateChordVariants(entry['variants'], id, issues);
}

/// Comprueba que el identificador exista y no esté repetido.
String? _validateIdentity(
  Map<String, Object?> chord,
  int index,
  _BankIssues issues,
) {
  final Object? id = chord['id'];
  if (id is! String || id.isEmpty) {
    issues.add(ValidationIssue('chords[$index].id', 'Identificador inválido'));
    return null;
  }
  if (!issues.ids.add(id)) {
    issues.add(
      ValidationIssue('chords[$index].id', 'Identificador duplicado: $id'),
    );
    return null;
  }
  return id;
}

/// Comprueba que la raíz del acorde sea reconocida.
void _validateRoot(Object? root, String id, _BankIssues issues) {
  if (root is! String) {
    issues.add(ValidationIssue('$id.root', 'Raíz ausente o inválida'));
    return;
  }
  if (!ChordRoot.values.any((ChordRoot value) => value.name == root)) {
    issues.add(ValidationIssue('$id.root', 'Raíz no reconocida: $root'));
  }
}

/// Comprueba que la calidad del acorde exista en el catálogo.
void _validateQuality(Object? quality, String id, _BankIssues issues) {
  if (quality is! String) {
    issues.add(ValidationIssue('$id.quality', 'Calidad ausente o inválida'));
    return;
  }
  if (ChordQuality.fromId(quality) == null) {
    issues.add(
      ValidationIssue('$id.quality', 'Calidad no reconocida: $quality'),
    );
  }
}

/// Comprueba la lista de posiciones del acorde.
void _validateChordVariants(Object? variants, String id, _BankIssues issues) {
  if (variants is! List<Object?> || variants.isEmpty) {
    issues.add(
      ValidationIssue('$id.variants', 'Debe tener al menos una posición'),
    );
    return;
  }
  for (int position = 0; position < variants.length; position++) {
    issues.variantCount++;
    issues.addAll(
      validateChordVariant(variants[position], '$id.variants[$position]'),
    );
  }
}

/// Comprueba que todas las raíces tengan al menos un acorde.
void _validateCoverage(_BankIssues issues) {
  for (final ChordRoot root in ChordRoot.values) {
    final bool covered = issues.ids.any(
      (String id) => id.startsWith('${root.name}-'),
    );
    if (!covered) {
      issues.add(
        ValidationIssue(root.name, 'Sin acordes para la raíz ${root.name}'),
      );
    }
  }
}
