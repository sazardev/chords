/// Muestra en texto las posiciones de uno o varios acordes del banco.
///
/// Sirve para revisar el banco a ojo: trastes, dedos, notas, dificultad y
/// etiquetas de cada posición, tal y como las ve la aplicación.
library;

import 'dart:io';

import 'package:chords/data/chords/models/chord_database_parser.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Texto con las posiciones de los acordes cuyo identificador (`C-maj7`) o
/// calidad (`maj7`, para la raíz Do) coincide con [queries].
String describeChords(String path, List<String> queries) {
  final ParsedChordDatabase bank = parseChordDatabaseText(
    File(path).readAsStringSync(),
  );
  final StringBuffer out = StringBuffer();
  for (final Chord chord in bank.chords) {
    if (queries.any((String q) => _matches(chord, q))) {
      out.writeln(_describe(chord));
    }
  }
  return out.toString();
}

bool _matches(Chord chord, String query) =>
    chord.id == query || (chord.root.name == 'C' && chord.id == 'C-$query');

String _describe(Chord chord) {
  final StringBuffer out = StringBuffer(
    '== ${chord.name} (${chord.id}) · ${chord.variantCount} posiciones · '
    'dificultad ${chord.difficulty.level}\n',
  );
  for (final ChordVariant v in chord.variants) {
    final String frets = v.frets
        .map((int f) => f < 0 ? 'x' : '$f')
        .join(' ')
        .padLeft(13);
    out.writeln(
      '  d${v.difficulty.level} [$frets] dedos ${v.fingers.join()} · '
      '${v.positionLabel} · ${v.notes.join(' ')} · ${v.tags.join(',')}',
    );
  }
  return out.toString();
}
