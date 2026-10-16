/// Validador del banco de acordes.
///
/// Comprueba la estructura del documento JSON, la cobertura de raíces y delega
/// la validación de cada posición en `chord_variant_validator.dart`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

import 'chord_bank_checks.dart';
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

  final _BankIssues issues = _BankIssues(_labelsOf(decoded['labels']));
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
  /// Crea el acumulador con los nombres de las formas del banco.
  _BankIssues(this.labels);

  /// Nombre de cada forma del catálogo (`e-shape` → `Forma de Mi`).
  final Map<String, String> labels;

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
  _validateChordVariants(entry, id, issues);
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
void _validateChordVariants(
  Map<String, Object?> chord,
  String id,
  _BankIssues issues,
) {
  final Object? variants = chord['variants'];
  final Object? root = chord['root'];
  final Object? quality = chord['quality'];
  final ChordRoot? chordRoot = root is String
      ? ChordRoot.values.where((ChordRoot r) => r.name == root).firstOrNull
      : null;
  final ChordQuality? chordQuality = quality is String
      ? ChordQuality.fromId(quality)
      : null;
  if (variants is! List<Object?> || variants.isEmpty) {
    issues.add(
      ValidationIssue('$id.variants', 'Debe tener al menos una posición'),
    );
    return;
  }
  final VariantSetChecker unique = VariantSetChecker();
  for (int position = 0; position < variants.length; position++) {
    issues.variantCount++;
    final String path = '$id.variants[$position]';
    final Object? variant = variants[position];
    final List<ValidationIssue> structural = validateChordVariant(
      variant,
      path,
    );
    issues.addAll(structural);
    if (structural.isNotEmpty) {
      continue;
    }
    final Map<String, Object?> map = variant! as Map<String, Object?>;
    issues.addAll(unique.check(map, path));
    issues.addAll(_validateLabel(map, path, issues.labels));
    if (chordRoot != null && chordQuality != null) {
      issues.addAll(
        validateChordVariantSemantics(variant, chordRoot, chordQuality, path),
      );
    }
  }
  issues.addAll(validateFirstIsEasiest(id, variants));
}

/// Comprueba que existan las 12 raíces con todas las calidades.
void _validateCoverage(_BankIssues issues) =>
    issues.addAll(validateCoverage(issues.ids));

/// Lee el diccionario de nombres de forma (vacío si falta o está mal).
Map<String, String> _labelsOf(Object? raw) => raw is Map<String, Object?>
    ? <String, String>{
        for (final MapEntry<String, Object?> e in raw.entries)
          if (e.value is String) e.key: e.value! as String,
      }
    : const <String, String>{};

/// Toda forma del catálogo necesita su nombre en el diccionario.
List<ValidationIssue> _validateLabel(
  Map<String, Object?> variant,
  String path,
  Map<String, String> labels,
) {
  final VariantIdentity identity = VariantIdentity.parse(
    variant['id']! as String,
  );
  return identity.isShape && !labels.containsKey(identity.key)
      ? <ValidationIssue>[
          ValidationIssue('$path.id', 'Forma sin nombre: ${identity.key}'),
        ]
      : const <ValidationIssue>[];
}
