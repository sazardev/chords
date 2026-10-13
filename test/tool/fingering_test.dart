import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/src/fingering/fingering_rules.dart';
import '../../tool/src/fingering/fingering_solver.dart';

/// Tests de las reglas físicas y del buscador de digitaciones.
void main() {
  group('fingeringIssues', () {
    test('acepta las digitaciones de los acordes abiertos de siempre', () {
      expect(
        fingeringIssues(
          const <int>[-1, 3, 2, 0, 1, 0],
          const <int>[0, 3, 2, 0, 1, 0],
        ),
        isEmpty,
      );
      expect(
        fingeringIssues(
          const <int>[0, 2, 2, 1, 0, 0],
          const <int>[0, 2, 3, 1, 0, 0],
        ),
        isEmpty,
      );
    });

    test('rechaza un dedo en dos trastes distintos', () {
      final List<String> issues = fingeringIssues(
        const <int>[6, 8, 8, -1, -1, -1],
        const <int>[1, 1, 1, 0, 0, 0],
      );
      expect(issues, contains('el dedo 1 está en trastes distintos'));
    });

    test('rechaza dedos desordenados respecto a los trastes', () {
      final List<String> issues = fingeringIssues(
        const <int>[-1, 5, 4, 3, -1, -1],
        const <int>[0, 1, 2, 3, 0, 0],
      );
      expect(issues, isNotEmpty);
    });

    test('rechaza un cejillo que tapa una cuerda al aire', () {
      final List<String> issues = fingeringIssues(
        const <int>[3, 0, 0, 0, 0, 3],
        const <int>[1, 0, 0, 0, 0, 1],
      );
      expect(issues.single, contains('al aire'));
    });

    test('rechaza abrir más de cuatro trastes', () {
      final List<String> issues = fingeringIssues(
        const <int>[-1, 1, 3, 5, -1, -1],
        const <int>[0, 1, 2, 4, 0, 0],
      );
      expect(issues.join(), contains('abre'));
    });

    test('exige dedo en toda cuerda pisada y ninguno en las libres', () {
      expect(
        fingeringIssues(
          const <int>[0, 2, -1, 0, 0, 0],
          const <int>[0, 0, 0, 0, 0, 0],
        ),
        isNotEmpty,
      );
      expect(
        fingeringIssues(
          const <int>[0, 2, -1, 0, 0, 0],
          const <int>[2, 2, 0, 0, 0, 0],
        ),
        isNotEmpty,
      );
    });
  });

  group('solveFingering', () {
    test('reproduce la digitación tradicional de los abiertos', () {
      expect(solveFingering(const <int>[-1, 3, 2, 0, 1, 0]), <int>[
        0,
        3,
        2,
        0,
        1,
        0,
      ]);
      expect(solveFingering(const <int>[0, 2, 0, 1, 0, 0]), <int>[
        0,
        2,
        0,
        1,
        0,
        0,
      ]);
      expect(solveFingering(const <int>[-1, -1, 0, 2, 3, 1]), <int>[
        0,
        0,
        0,
        2,
        3,
        1,
      ]);
    });

    test('usa el índice como cejillo en la forma de Mi', () {
      expect(solveFingering(const <int>[5, 7, 7, 6, 5, 5]), <int>[
        1,
        3,
        4,
        2,
        1,
        1,
      ]);
    });

    test('devuelve null si la mano no llega', () {
      expect(solveFingering(const <int>[1, 2, 3, 4, 5, 6]), isNull);
      expect(solveFingering(const <int>[-1, 1, 5, -1, -1, -1]), isNull);
    });

    test('lo que devuelve siempre cumple las reglas', () {
      final List<List<int>> samples = <List<int>>[
        const <int>[-1, 2, 2, 1, -1, -1],
        const <int>[-1, 12, 11, 9, 10, 9],
        const <int>[8, 7, 5, 5, 5, 8],
        const <int>[-1, 5, 7, 7, 6, 5],
      ];
      for (final List<int> frets in samples) {
        final List<int> fingers = solveFingering(frets)!;
        expect(fingeringIssues(frets, fingers), isEmpty, reason: '$frets');
      }
    });
  });

  group('barreOf', () {
    test('elige el dedo que abarca más cuerdas', () {
      final ({int fret, int from, int to})? barre = barreOf(
        const <int>[-1, 3, 5, 5, 5, 3],
        const <int>[0, 1, 3, 3, 3, 1],
      );
      expect(barre, (fret: 3, from: 1, to: 5));
    });

    test('no hay cejillo si cada dedo pisa una cuerda', () {
      expect(
        barreOf(const <int>[-1, 3, 2, 0, 1, 0], const <int>[0, 3, 2, 0, 1, 0]),
        isNull,
      );
    });
  });

  test('los acordes de siempre conservan su digitación tradicional', () {
    final Map<String, Object?> json = jsonDecode(
      File('assets/chords/chords_db.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final Map<String, List<int>> fingersByFrets = <String, List<int>>{};
    for (final Object? chord in json['chords']! as List<Object?>) {
      final Map<String, Object?> entry = chord! as Map<String, Object?>;
      for (final Object? variant in entry['variants']! as List<Object?>) {
        final Map<String, Object?> v = variant! as Map<String, Object?>;
        fingersByFrets[(v['frets']! as List<Object?>).join(',')] =
            (v['fingers']! as List<Object?>).cast<int>();
      }
    }
    const Map<String, List<int>> expected = <String, List<int>>{
      '-1,3,2,0,1,0': <int>[0, 3, 2, 0, 1, 0], // C
      '-1,0,2,2,2,0': <int>[0, 0, 1, 2, 3, 0], // A
      '-1,0,2,2,1,0': <int>[0, 0, 2, 3, 1, 0], // Am
      '-1,-1,0,2,3,2': <int>[0, 0, 0, 1, 3, 2], // D
      '-1,-1,0,2,3,1': <int>[0, 0, 0, 2, 3, 1], // Dm
      '0,2,2,1,0,0': <int>[0, 2, 3, 1, 0, 0], // E
      '0,2,2,0,0,0': <int>[0, 2, 3, 0, 0, 0], // Em
      '0,2,0,1,0,0': <int>[0, 2, 0, 1, 0, 0], // E7
      '3,2,0,0,0,3': <int>[2, 1, 0, 0, 0, 3], // G
      '1,3,3,2,1,1': <int>[1, 3, 4, 2, 1, 1], // F con cejillo
      '-1,2,4,4,3,2': <int>[0, 1, 3, 4, 2, 1], // Bm
    };
    for (final MapEntry<String, List<int>> entry in expected.entries) {
      expect(fingersByFrets[entry.key], entry.value, reason: entry.key);
    }
  });
}
