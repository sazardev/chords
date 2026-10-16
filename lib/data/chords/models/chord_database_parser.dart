import 'dart:convert';

import 'package:chords/data/chords/models/chord_model.dart';
import 'package:chords/domain/chords/entities/chord.dart';

/// Acordes leídos del banco y cuántas entradas se descartaron por estar rotas.
class ParsedChordDatabase {
  /// Crea el resultado.
  const ParsedChordDatabase(this.chords, this.discarded);

  /// Acordes válidos, en el orden del banco.
  final List<Chord> chords;

  /// Entradas ilegibles o incompletas que se ignoraron.
  final int discarded;
}

/// Decodifica el texto JSON del banco y lo convierte en acordes.
///
/// Es una función de nivel superior sin estado para poder ejecutarse en otro
/// isolate (`compute`) sin bloquear la interfaz mientras se lee el banco.
ParsedChordDatabase parseChordDatabaseText(String raw) {
  final Object? decoded = jsonDecode(raw);
  if (decoded is! Map<String, Object?>) {
    throw const FormatException('El banco de acordes no es un objeto JSON');
  }
  return parseChordDatabase(decoded);
}

/// Convierte el documento del banco (ya decodificado) en acordes.
ParsedChordDatabase parseChordDatabase(Map<String, Object?> database) {
  final Object? rawChords = database['chords'];
  if (rawChords is! List<Object?>) {
    throw const FormatException('Falta la lista de acordes');
  }
  final Map<String, String> labels = _shapeLabels(database['labels']);
  final List<Chord> chords = <Chord>[];
  int discarded = 0;
  for (final Object? item in rawChords) {
    final Chord? chord = item is Map<String, Object?>
        ? ChordModel.fromJson(item).toEntity(shapeLabels: labels)
        : null;
    if (chord == null) {
      discarded++;
    } else {
      chords.add(chord);
    }
  }
  return ParsedChordDatabase(chords, discarded);
}

Map<String, String> _shapeLabels(Object? raw) => raw is Map<String, Object?>
    ? <String, String>{
        for (final MapEntry<String, Object?> entry in raw.entries)
          if (entry.value is String) entry.key: entry.value! as String,
      }
    : const <String, String>{};
