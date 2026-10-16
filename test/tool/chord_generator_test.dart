import 'dart:convert';
import 'dart:io';

import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:test/test.dart';

import '../../tool/src/builder/chord_drafts.dart';
import '../../tool/src/builder/shape_variants.dart';
import '../../tool/src/builder/voicing_kind.dart';
import '../../tool/src/builder/voicing_plan.dart';
import '../../tool/src/chord_db_validator.dart';
import '../../tool/src/chord_shape_spec.dart';
import '../../tool/src/chord_variant_draft.dart';
import '../../tool/src/chord_variant_theory.dart';
import '../../tool/src/fingering/physical_difficulty.dart';
import '../../tool/src/shapes/shape_dsl.dart';

/// Tests del generador del banco: formas, voicings, dificultad y validador.
void main() {
  group('physicalDifficulty', () {
    test('los acordes abiertos de tres dedos son de nivel 1', () {
      expect(
        physicalDifficulty(
          const <int>[-1, 3, 2, 0, 1, 0],
          const <int>[0, 3, 2, 0, 1, 0],
        ),
        1,
      );
      expect(
        physicalDifficulty(
          const <int>[3, 2, 0, 0, 0, 3],
          const <int>[2, 1, 0, 0, 0, 3],
        ),
        1,
      );
    });

    test('cuatro dedos suben un nivel y el cejillo completo vale tres', () {
      expect(
        physicalDifficulty(
          const <int>[-1, 2, 1, 2, 0, 2],
          const <int>[0, 2, 1, 3, 0, 4],
        ),
        2,
        reason: 'Si7 abierto',
      );
      expect(
        physicalDifficulty(
          const <int>[1, 3, 3, 2, 1, 1],
          const <int>[1, 3, 4, 2, 1, 1],
        ),
        3,
        reason: 'Fa con cejillo',
      );
    });

    test('un cejillo con el meñique es más duro que con el índice', () {
      final int withIndex = physicalDifficulty(
        const <int>[-1, -1, 5, 5, 3, 3],
        const <int>[0, 0, 3, 4, 1, 1],
      );
      final int withPinky = physicalDifficulty(
        const <int>[-1, -1, 3, 3, 5, 5],
        const <int>[0, 0, 1, 1, 4, 4],
      );
      expect(withPinky, greaterThanOrEqualTo(withIndex));
    });
  });

  group('formas del catálogo', () {
    test('el DSL deduce cuerda de anclaje y desplazamientos', () {
      final MovableShapeSpec spec = refShape(
        '7',
        'c7-shape',
        'Forma de Do 7',
        'x32310',
        'C',
      );
      expect(spec.rootString, 1);
      expect(spec.anchorSemitones, 0);
      expect(spec.fretOffsets, <int?>[null, 3, 2, 3, 1, 0]);
      expect(parseFrets('x 10 12 12 12 10'), <int?>[null, 10, 12, 12, 12, 10]);
    });

    test('una forma sin cuerdas al aire baja por debajo de su referencia', () {
      final MovableShapeSpec spec = refShape(
        'm7b5',
        'c-m7b5-shape',
        'Forma de Do m7b5',
        'x3434x',
        'C',
      );
      final TransposedShape? atB = transposeShape(spec, ChordRoot.b);
      expect(atB?.frets, <int>[-1, 2, 3, 2, 3, -1]);
      final TransposedShape? atA = transposeShape(spec, ChordRoot.a);
      expect(atA?.frets, <int>[-1, 0, 1, 0, 1, -1]);
    });

    test('las formas solo abiertas no se desplazan', () {
      final MovableShapeSpec spec = refShape(
        'maj',
        'x',
        'Forma',
        '320003',
        'G',
        openOnly: true,
      );
      expect(transposeShape(spec, ChordRoot.g), isNotNull);
      expect(transposeShape(spec, ChordRoot.a), isNull);
    });

    test('las formas que pasan del traste 14 se descartan', () {
      final MovableShapeSpec spec = refShape(
        'maj',
        'x',
        'Forma',
        '022100',
        'E',
      );
      expect(transposeShape(spec, ChordRoot.dSharp)?.frets.first, 11);
      expect(
        transposeShape(spec, ChordRoot.dSharp)?.frets.any((int f) => f > 14),
        isFalse,
      );
    });
  });

  group('buildChordDrafts', () {
    test('no repite trastes y deja las formas antes que los voicings', () {
      for (final ChordQuality quality in ChordQuality.values) {
        final List<VariantDraft> drafts = buildChordDrafts(
          ChordRoot.a,
          quality,
        );
        expect(drafts, isNotEmpty, reason: quality.id);
        expect(
          drafts.map((VariantDraft d) => d.frets.join(',')).toSet().length,
          drafts.length,
        );
        bool seenSearched = false;
        for (final VariantDraft draft in drafts) {
          if (draft.kind != VariantKind.shape) {
            seenSearched = true;
          } else {
            expect(seenSearched, isFalse, reason: '${quality.id} ${draft.id}');
          }
        }
      }
    });

    test('cada posición generada pasa las reglas musicales', () {
      for (final ChordRoot root in ChordRoot.values) {
        for (final ChordQuality quality in ChordQuality.values) {
          for (final VariantDraft draft in buildChordDrafts(root, quality)) {
            final VariantIdentity identity = VariantIdentity.parse(draft.id);
            expect(
              theoryIssues(
                root,
                quality,
                draft.frets,
                expectedBass: identity.bassInterval,
              ),
              isEmpty,
              reason: '${root.name}${quality.suffix} ${draft.id}',
            );
          }
        }
      }
    });

    test('las posiciones de un acorde son como mucho 12 más las formas', () {
      for (final ChordQuality quality in ChordQuality.values) {
        final List<VariantDraft> drafts = buildChordDrafts(
          ChordRoot.c,
          quality,
        );
        final int shapes = drafts
            .where((VariantDraft d) => d.kind == VariantKind.shape)
            .length;
        expect(
          drafts.length,
          lessThanOrEqualTo(kMaxVariantsPerChord + shapes),
          reason: quality.id,
        );
      }
    });
  });

  group('voicings', () {
    test('un drop 2 se reconoce por las alturas', () {
      // Do7 drop 2 en las cuatro cuerdas agudas: x x 5 5 5 6 (G C E Bb).
      expect(
        voicingKind(
          const VoicingPlan(VoicingKind.fourString, <int>[2, 3, 4, 5]),
          const <int>[-1, -1, 5, 5, 5, 6],
        ),
        VariantKind.drop2,
      );
      // Un cluster cerrado en posición fundamental no es drop.
      expect(
        voicingKind(
          const VoicingPlan(VoicingKind.fourString, <int>[2, 3, 4, 5]),
          const <int>[-1, -1, 10, 9, 8, 7],
        ),
        VariantKind.voicing,
      );
    });

    test('los planes se aplican según el acorde', () {
      const VoicingPlan triad = VoicingPlan(VoicingKind.triad, <int>[1, 2, 3]);
      const VoicingPlan shell = VoicingPlan(VoicingKind.shell, <int>[0, 2, 3]);
      const VoicingPlan four = VoicingPlan(VoicingKind.fourString, <int>[
        2,
        3,
        4,
        5,
      ]);
      expect(triad.applies(ChordQuality.major), isTrue);
      expect(triad.applies(ChordQuality.power), isTrue);
      expect(triad.applies(ChordQuality.seven), isFalse);
      expect(shell.applies(ChordQuality.seven), isTrue);
      expect(shell.applies(ChordQuality.halfDiminished), isFalse);
      expect(four.applies(ChordQuality.minorNinth), isTrue);
      expect(four.applies(ChordQuality.major), isFalse);
    });
  });

  group('validador', () {
    late Map<String, Object?> good;

    setUpAll(() {
      good = jsonDecode(
        File('assets/chords/chords_db.json').readAsStringSync(),
      ) as Map<String, Object?>;
    });

    /// Escribe una copia del banco con [mutate] aplicado y la valida.
    ValidationReport validateMutated(
      void Function(Map<String, Object?>) mutate,
    ) {
      final Map<String, Object?> copy =
          jsonDecode(jsonEncode(good)) as Map<String, Object?>;
      mutate(copy);
      final Directory dir = Directory.systemTemp.createTempSync('chords_val');
      addTearDown(() => dir.deleteSync(recursive: true));
      final File file = File('${dir.path}/db.json')
        ..writeAsStringSync(jsonEncode(copy));
      return validateChordDatabase(file.path);
    }

    /// Primera posición del acorde [id] dentro del documento.
    Map<String, Object?> firstVariant(Map<String, Object?> db, String id) {
      final Map<String, Object?> chord = (db['chords']! as List<Object?>)
          .cast<Map<String, Object?>>()
          .firstWhere((Map<String, Object?> c) => c['id'] == id);
      return (chord['variants']! as List<Object?>).first!
          as Map<String, Object?>;
    }

    test('el banco real es válido', () {
      expect(validateMutated((_) {}).issues, isEmpty);
    });

    test('detecta una nota ajena al acorde', () {
      final ValidationReport report = validateMutated((
        Map<String, Object?> db,
      ) {
        firstVariant(db, 'C-maj')['frets'] = <int>[-1, 3, 2, 0, 1, 1];
      });
      expect(
        report.issues.any(
          (ValidationIssue i) => i.message.contains('no es del acorde'),
        ),
        isTrue,
      );
    });

    test('detecta que falta una nota que define el acorde', () {
      final ValidationReport report = validateMutated((
        Map<String, Object?> db,
      ) {
        firstVariant(db, 'C-7')['frets'] = <int>[-1, 3, 2, 0, 1, 0];
        firstVariant(db, 'C-7')['fingers'] = <int>[0, 3, 2, 0, 1, 0];
      });
      expect(report.isValid, isFalse);
    });

    test('detecta una dificultad por debajo de lo que exige la mano', () {
      final ValidationReport report = validateMutated((
        Map<String, Object?> db,
      ) {
        final Map<String, Object?> chord = (db['chords']! as List<Object?>)
            .cast<Map<String, Object?>>()
            .firstWhere((Map<String, Object?> c) => c['id'] == 'F-maj');
        for (final Object? v in chord['variants']! as List<Object?>) {
          final Map<String, Object?> variant = v! as Map<String, Object?>;
          if ((variant['id']! as String).startsWith('e-shape')) {
            variant['difficulty'] = 1;
          }
        }
      });
      expect(
        report.issues.any(
          (ValidationIssue i) => i.message.contains('menor que la que exige'),
        ),
        isTrue,
      );
    });

    test('detecta una forma sin nombre y un acorde que falta', () {
      final ValidationReport report = validateMutated((
        Map<String, Object?> db,
      ) {
        (db['labels']! as Map<String, Object?>).remove('c-shape');
        (db['chords']! as List<Object?>).removeLast();
      });
      expect(
        report.issues.any(
          (ValidationIssue i) => i.message.contains('Forma sin nombre'),
        ),
        isTrue,
      );
      expect(
        report.issues.any(
          (ValidationIssue i) => i.message.startsWith('Falta el acorde'),
        ),
        isTrue,
      );
    });

    test('detecta posiciones repetidas y desordenadas', () {
      final ValidationReport report = validateMutated((
        Map<String, Object?> db,
      ) {
        final Map<String, Object?> chord = (db['chords']! as List<Object?>)
            .cast<Map<String, Object?>>()
            .firstWhere((Map<String, Object?> c) => c['id'] == 'G-maj');
        final List<Object?> variants = chord['variants']! as List<Object?>;
        variants.add(variants.first);
      });
      expect(
        report.issues.any(
          (ValidationIssue i) => i.message.contains('duplicada'),
        ),
        isTrue,
      );
    });
  });
}
