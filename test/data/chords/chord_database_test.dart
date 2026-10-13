import 'dart:convert';
import 'dart:io';

import 'package:chords/data/chords/models/chord_model.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:test/test.dart';

import '../../../tool/src/chord_db_validator.dart';

/// Tests de integración del banco de acordes (asset + parser + validador).
void main() {
  group('banco de acordes', () {
    test('el asset contiene 156 acordes y 561 posiciones válidas', () {
      final File file = File('assets/chords/chords_db.json');
      expect(file.existsSync(), isTrue);
      final Map<String, Object?> json =
          jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
      final List<Object?> raw = json['chords']! as List<Object?>;
      expect(raw.length, 156);

      final List<Chord> chords = <Chord>[];
      int variants = 0;
      for (final Object? item in raw) {
        final Chord? chord = ChordModel.fromJson(item! as Map<String, Object?>)
            .toEntity();
        expect(chord, isNotNull);
        chords.add(chord!);
        variants += chord.variantCount;
      }
      expect(variants, 561);
      expect(chords.every((Chord c) => c.variants.isNotEmpty), isTrue);
    });

    test('cubre las 12 raíces y todas las cualidades', () {
      final Map<String, Object?> json = jsonDecode(
        File('assets/chords/chords_db.json').readAsStringSync(),
      ) as Map<String, Object?>;
      final List<Object?> raw = json['chords']! as List<Object?>;
      final Set<String> roots = <String>{
        for (final Object? item in raw)
          (item! as Map<String, Object?>)['root']! as String,
      };
      final Set<String> qualities = <String>{
        for (final Object? item in raw)
          (item! as Map<String, Object?>)['quality']! as String,
      };
      expect(roots.length, ChordRoot.values.length);
      expect(
        qualities.length,
        greaterThanOrEqualTo(ChordQuality.values.length),
      );
    });

    test('el validador acepta el banco generado', () {
      final ValidationReport report = validateChordDatabase(
        'assets/chords/chords_db.json',
      );
      expect(report.issues, isEmpty);
      expect(report.isValid, isTrue);
      expect(report.chordCount, 156);
      expect(report.variantCount, 561);
    });
  });
}
