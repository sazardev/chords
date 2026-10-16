import 'dart:convert';
import 'dart:io';

import 'package:chords/data/chords/models/chord_database_parser.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:test/test.dart';

import '../../../tool/src/chord_database_writer.dart';
import '../../../tool/src/chord_db_validator.dart';
import '../../../tool/src/chord_shape_catalog.dart';
import '../../../tool/src/chord_shape_spec.dart';

/// Tests de integración del banco de acordes (asset + parser + validador).
void main() {
  const String path = 'assets/chords/chords_db.json';
  late final ParsedChordDatabase bank;
  late final Map<String, Object?> json;

  setUpAll(() {
    final String raw = File(path).readAsStringSync();
    json = jsonDecode(raw) as Map<String, Object?>;
    bank = parseChordDatabaseText(raw);
  });

  group('banco de acordes', () {
    test('tiene todas las raíces con todas las calidades', () {
      expect(bank.discarded, 0);
      expect(
        bank.chords.length,
        ChordRoot.values.length * ChordQuality.values.length,
      );
      final Set<String> ids = <String>{for (final Chord c in bank.chords) c.id};
      for (final ChordRoot root in ChordRoot.values) {
        for (final ChordQuality quality in ChordQuality.values) {
          expect(ids, contains('${root.name}-${quality.id}'));
        }
      }
    });

    test('hay mucha variedad: 30 calidades o más y más de 3000 posiciones', () {
      final int variants = bank.chords.fold<int>(
        0,
        (int sum, Chord c) => sum + c.variantCount,
      );
      expect(ChordQuality.values.length, greaterThanOrEqualTo(30));
      expect(variants, greaterThan(3000));
      for (final Chord chord in bank.chords) {
        expect(chord.variantCount, greaterThanOrEqualTo(3), reason: chord.id);
      }
    });

    test('el validador acepta el banco generado', () {
      final ValidationReport report = validateChordDatabase(path);
      expect(report.issues, isEmpty);
      expect(report.isValid, isTrue);
      expect(report.chordCount, bank.chords.length);
    });

    test('el asset es exactamente lo que genera el generador', () {
      final Directory dir = Directory.systemTemp.createTempSync('chords_db');
      addTearDown(() => dir.deleteSync(recursive: true));
      final String generated = '${dir.path}/chords_db.json';
      generateChordDatabase(generated);
      expect(
        File(generated).readAsStringSync(),
        File(path).readAsStringSync(),
        reason: 'ejecuta `dart run bin/chords_cli.dart db generate`',
      );
    });

    test('es compacto: menos de 500 KB', () {
      expect(File(path).lengthSync(), lessThan(500 * 1024));
    });

    test('cada forma del catálogo da posiciones y tiene nombre', () {
      final Map<String, Object?> labels =
          json['labels']! as Map<String, Object?>;
      final Set<String> used = <String>{
        for (final Chord chord in bank.chords)
          for (final ChordVariant v in chord.variants)
            if (v.isShape)
              VariantIdentity.parse(v.id.substring(chord.id.length + 1)).key,
      };
      for (final MovableShapeSpec spec in kMovableShapes) {
        expect(used, contains(spec.id), reason: 'la forma ${spec.id} no sale');
        expect(labels[spec.id], spec.positionLabel);
      }
    });

    test(
      'la primera posición de cada acorde es la recomendada (la más fácil)',
      () {
        for (final Chord chord in bank.chords) {
          expect(chord.easiestVariant, chord.variants.first);
        }
      },
    );

    test('las posiciones llevan notas, etiquetas y nombre deducidos', () {
      final Chord c = bank.chords.firstWhere((Chord c) => c.id == 'C-maj');
      final ChordVariant open = c.variants.first;
      expect(open.frets, <int>[-1, 3, 2, 0, 1, 0]);
      expect(open.notes, <String>['C', 'E', 'G']);
      expect(open.positionLabel, 'Forma de Do');
      expect(open.tags, contains('open'));
      expect(open.id, 'C-maj-c-shape-0');
    });

    test('los acordes esenciales abiertos son de dificultad 1', () {
      for (final String id in <String>[
        'C-maj',
        'G-maj',
        'D-maj',
        'A-maj',
        'E-maj',
        'A-min',
        'E-min',
        'D-min',
      ]) {
        final Chord chord = bank.chords.firstWhere((Chord c) => c.id == id);
        expect(chord.difficulty.level, 1, reason: id);
      }
    });
  });
}
