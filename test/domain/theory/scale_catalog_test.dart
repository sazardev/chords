import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/catalog/scale_catalog.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_accents.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/chord_scale_suggestions.dart';
import 'package:chords/domain/theory/services/scale_harmony.dart';
import 'package:test/test.dart';

/// Intervalos de cada escala escritos a mano, independientes de la fórmula:
/// la red de seguridad de las fórmulas del catálogo.
const Map<ScaleType, List<int>> kExpectedIntervals = <ScaleType, List<int>>{
  ScaleType.major: <int>[0, 2, 4, 5, 7, 9, 11],
  ScaleType.dorian: <int>[0, 2, 3, 5, 7, 9, 10],
  ScaleType.phrygian: <int>[0, 1, 3, 5, 7, 8, 10],
  ScaleType.lydian: <int>[0, 2, 4, 6, 7, 9, 11],
  ScaleType.mixolydian: <int>[0, 2, 4, 5, 7, 9, 10],
  ScaleType.naturalMinor: <int>[0, 2, 3, 5, 7, 8, 10],
  ScaleType.locrian: <int>[0, 1, 3, 5, 6, 8, 10],
  ScaleType.harmonicMinor: <int>[0, 2, 3, 5, 7, 8, 11],
  ScaleType.melodicMinor: <int>[0, 2, 3, 5, 7, 9, 11],
  ScaleType.locrianNatural6: <int>[0, 1, 3, 5, 6, 9, 10],
  ScaleType.ionianSharp5: <int>[0, 2, 4, 5, 8, 9, 11],
  ScaleType.ukrainianDorian: <int>[0, 2, 3, 6, 7, 9, 10],
  ScaleType.phrygianDominant: <int>[0, 1, 4, 5, 7, 8, 10],
  ScaleType.lydianSharp2: <int>[0, 3, 4, 6, 7, 9, 11],
  ScaleType.superLocrianBb7: <int>[0, 1, 3, 4, 6, 8, 9],
  ScaleType.dorianFlat2: <int>[0, 1, 3, 5, 7, 9, 10],
  ScaleType.lydianAugmented: <int>[0, 2, 4, 6, 8, 9, 11],
  ScaleType.lydianDominant: <int>[0, 2, 4, 6, 7, 9, 10],
  ScaleType.mixolydianFlat6: <int>[0, 2, 4, 5, 7, 8, 10],
  ScaleType.locrianSharp2: <int>[0, 2, 3, 5, 6, 8, 10],
  ScaleType.altered: <int>[0, 1, 3, 4, 6, 8, 10],
  ScaleType.minorPentatonic: <int>[0, 3, 5, 7, 10],
  ScaleType.majorPentatonic: <int>[0, 2, 4, 7, 9],
  ScaleType.blues: <int>[0, 3, 5, 6, 7, 10],
  ScaleType.majorBlues: <int>[0, 2, 3, 4, 7, 9],
  ScaleType.minorHexatonic: <int>[0, 2, 3, 5, 7, 10],
  ScaleType.suspendedPentatonic: <int>[0, 2, 5, 7, 10],
  ScaleType.wholeTone: <int>[0, 2, 4, 6, 8, 10],
  ScaleType.diminishedWholeHalf: <int>[0, 2, 3, 5, 6, 8, 9, 11],
  ScaleType.diminishedHalfWhole: <int>[0, 1, 3, 4, 6, 7, 9, 10],
  ScaleType.augmentedScale: <int>[0, 3, 4, 7, 8, 11],
  ScaleType.bebopDominant: <int>[0, 2, 4, 5, 7, 9, 10, 11],
  ScaleType.bebopMajor: <int>[0, 2, 4, 5, 7, 8, 9, 11],
  ScaleType.hungarianMinor: <int>[0, 2, 3, 6, 7, 8, 11],
  ScaleType.doubleHarmonic: <int>[0, 1, 4, 5, 7, 8, 11],
  ScaleType.hirajoshi: <int>[0, 2, 3, 7, 8],
  ScaleType.neapolitanMinor: <int>[0, 1, 3, 5, 7, 8, 11],
  ScaleType.persian: <int>[0, 1, 4, 5, 6, 8, 11],
};

/// Teoría de escalas: fórmulas, modos, familias, armonía y sugerencias.
void main() {
  group('ScaleType', () {
    test('hay 24 escalas o más y todas tienen sus intervalos esperados', () {
      expect(ScaleType.values.length, greaterThanOrEqualTo(24));
      expect(kExpectedIntervals.length, ScaleType.values.length);
      for (final ScaleType scale in ScaleType.values) {
        expect(scale.intervals, kExpectedIntervals[scale], reason: scale.id);
      }
    });

    test('la fórmula se escribe con un grado por nota', () {
      for (final ScaleType scale in ScaleType.values) {
        expect(scale.formula.length, scale.intervals.length, reason: scale.id);
        expect(scale.formula.first, '1');
        expect(scale.length, scale.intervals.length);
      }
      expect(ScaleType.major.formula.join(' '), '1 2 3 4 5 6 7');
      expect(ScaleType.phrygianDominant.formula.join(' '), '1 b2 3 4 5 b6 b7');
      expect(ScaleType.altered.formula.join(' '), '1 b2 #2 3 b5 #5 b7');
      expect(ScaleType.blues.formula.join(' '), '1 b3 4 b5 5 b7');
    });

    test('los pasos suman una octava', () {
      for (final ScaleType scale in ScaleType.values) {
        expect(
          scale.steps.reduce((int a, int b) => a + b),
          12,
          reason: scale.id,
        );
      }
      expect(ScaleType.major.steps, <int>[2, 2, 1, 2, 2, 2, 1]);
      expect(ScaleType.harmonicMinor.steps, <int>[2, 1, 2, 2, 1, 3, 1]);
      expect(ScaleType.wholeTone.steps, <int>[2, 2, 2, 2, 2, 2]);
    });

    test('los identificadores son únicos y se resuelven', () {
      final Set<String> ids = ScaleType.values
          .map((ScaleType s) => s.id)
          .toSet();
      expect(ids.length, ScaleType.values.length);
      for (final ScaleType scale in ScaleType.values) {
        expect(ScaleType.fromId(scale.id), scale);
      }
      expect(ScaleType.fromId('nada'), isNull);
      expect(ScaleType.fromId(null), isNull);
    });

    test('los modos son rotaciones de la escala madre', () {
      List<int> mode(ScaleType parent, int degree) {
        final List<int> p = parent.intervals;
        return <int>[
          for (int i = 0; i < p.length; i++)
            (p[(degree + i) % p.length] - p[degree] + 12) % 12,
        ];
      }

      const List<ScaleType> majorModes = <ScaleType>[
        ScaleType.major,
        ScaleType.dorian,
        ScaleType.phrygian,
        ScaleType.lydian,
        ScaleType.mixolydian,
        ScaleType.naturalMinor,
        ScaleType.locrian,
      ];
      for (final (int i, ScaleType m) in majorModes.indexed) {
        expect(m.intervals, mode(ScaleType.major, i), reason: m.id);
      }
      const List<ScaleType> harmonicModes = <ScaleType>[
        ScaleType.harmonicMinor,
        ScaleType.locrianNatural6,
        ScaleType.ionianSharp5,
        ScaleType.ukrainianDorian,
        ScaleType.phrygianDominant,
        ScaleType.lydianSharp2,
        ScaleType.superLocrianBb7,
      ];
      for (final (int i, ScaleType m) in harmonicModes.indexed) {
        expect(m.intervals, mode(ScaleType.harmonicMinor, i), reason: m.id);
      }
      const List<ScaleType> melodicModes = <ScaleType>[
        ScaleType.melodicMinor,
        ScaleType.dorianFlat2,
        ScaleType.lydianAugmented,
        ScaleType.lydianDominant,
        ScaleType.mixolydianFlat6,
        ScaleType.locrianSharp2,
        ScaleType.altered,
      ];
      for (final (int i, ScaleType m) in melodicModes.indexed) {
        expect(m.intervals, mode(ScaleType.melodicMinor, i), reason: m.id);
      }
    });

    test('las escalas simétricas se repiten al transponerlas', () {
      expect(
        ScaleType.wholeTone.pitchClasses(0).toSet(),
        ScaleType.wholeTone.pitchClasses(2).toSet(),
      );
      expect(
        ScaleType.diminishedWholeHalf.pitchClasses(0).toSet(),
        ScaleType.diminishedWholeHalf.pitchClasses(3).toSet(),
      );
    });

    test('los grados se escriben con la fórmula de la escala', () {
      expect(degreeSymbol(0, 6, scale: ScaleType.lydian), '#4');
      expect(degreeSymbol(0, 6, scale: ScaleType.locrian), 'b5');
      expect(degreeSymbol(0, 3, scale: ScaleType.altered), '#2');
      expect(degreeSymbol(0, 4, scale: ScaleType.altered), '3');
      expect(degreeSymbol(0, 3), 'b3');
      expect(semitonesOfDegree('bb7'), 9);
      expect(semitonesOfDegree('#4'), 6);
    });

    test('las diez escalas de siempre siguen ahí', () {
      expect(ScaleType.classics.length, 10);
      expect(ScaleType.classics, contains(ScaleType.blues));
    });

    test('la nota característica pertenece a su escala', () {
      for (final MapEntry<ScaleType, int> entry in kScaleAccents.entries) {
        expect(
          entry.key.intervals,
          contains(entry.value),
          reason: entry.key.id,
        );
      }
    });
  });

  group('catálogo del selector', () {
    test('todas las escalas están en alguna sección', () {
      final Set<ScaleType> shown = <ScaleType>{
        for (final ScaleSection s in kScaleSections) ...s.scales,
      };
      expect(shown, ScaleType.values.toSet());
    });

    test('hay cuatro bloques y ninguno está vacío', () {
      expect(ScaleGroup.values.length, 4);
      for (final ScaleGroup group in ScaleGroup.values) {
        expect(sectionsOf(group), isNotEmpty, reason: group.name);
      }
      expect(groupOf(ScaleType.altered), ScaleGroup.minor);
      expect(groupOf(ScaleType.blues), ScaleGroup.pentatonic);
      expect(groupOf(ScaleType.wholeTone), ScaleGroup.exotic);
      expect(groupOf(ScaleType.dorian), ScaleGroup.major);
    });
  });

  group('ScaleHarmony', () {
    List<String> names(ScaleType scale, int tonic, {bool sevenths = false}) =>
        <String>[
          for (final DiatonicChord c in ScaleHarmony(
            scale,
            tonic,
          ).chords(sevenths: sevenths))
            c.symbol.name,
        ];

    test('Do mayor: triadas y séptimas', () {
      expect(names(ScaleType.major, 0), <String>[
        'C',
        'Dm',
        'Em',
        'F',
        'G',
        'Am',
        'Bdim',
      ]);
      expect(names(ScaleType.major, 0, sevenths: true), <String>[
        'Cmaj7',
        'Dm7',
        'Em7',
        'Fmaj7',
        'G7',
        'Am7',
        'Bm7b5',
      ]);
    });

    test('coincide con MusicalKey en mayor y menor natural', () {
      for (int tonic = 0; tonic < 12; tonic++) {
        expect(
          names(ScaleType.major, tonic),
          MusicalKey(tonic)
              .harmony()
              .map((DiatonicChord c) => c.symbol.name)
              .toList(),
        );
        expect(
          names(ScaleType.naturalMinor, tonic),
          MusicalKey(
            tonic,
            minor: true,
          ).harmony().map((DiatonicChord c) => c.symbol.name).toList(),
        );
      }
    });

    test('La menor armónica: V mayor, III aumentado y vii°7', () {
      expect(names(ScaleType.harmonicMinor, 9, sevenths: true), <String>[
        'AmMaj7',
        'Bm7b5',
        'Cmaj7#5',
        'Dm7',
        'E7',
        'Fmaj7',
        'G#dim7',
      ]);
      expect(names(ScaleType.harmonicMinor, 9), <String>[
        'Am',
        'Bdim',
        'Caug',
        'Dm',
        'E',
        'F',
        'G#dim',
      ]);
    });

    test('Do menor melódica: Cm(maj7), IV7, VI y VII semidisminuidos', () {
      expect(names(ScaleType.melodicMinor, 0, sevenths: true), <String>[
        'CmMaj7',
        'Dm7',
        'D#maj7#5',
        'F7',
        'G7',
        'Am7b5',
        'Bm7b5',
      ]);
    });

    test('los números romanos llevan alteraciones y cifrado', () {
      final List<String> romans = <String>[
        for (final DiatonicChord c in const ScaleHarmony(
          ScaleType.major,
          0,
        ).chords(sevenths: true))
          c.roman,
      ];
      expect(romans, <String>[
        'Imaj7',
        'ii7',
        'iii7',
        'IVmaj7',
        'V7',
        'vi7',
        'viiø7',
      ]);
      final List<String> phrygian = <String>[
        for (final DiatonicChord c in const ScaleHarmony(
          ScaleType.phrygian,
          4,
        ).chords())
          c.roman,
      ];
      expect(phrygian.first, 'i');
      expect(phrygian[1], 'bII');
    });

    test('las escalas que no tienen siete notas no forman acordes', () {
      expect(
        const ScaleHarmony(ScaleType.minorPentatonic, 0).chords(),
        isEmpty,
      );
      expect(const ScaleHarmony(ScaleType.wholeTone, 0).hasHarmony, isFalse);
      expect(
        const ScaleHarmony(ScaleType.diminishedWholeHalf, 0).chords(),
        isEmpty,
      );
    });

    test('cada acorde de la armonía es un acorde real del banco', () {
      for (final ScaleType scale in ScaleType.values) {
        for (final bool sevenths in <bool>[false, true]) {
          for (final DiatonicChord c in ScaleHarmony(
            scale,
            3,
          ).chords(sevenths: sevenths)) {
            expect(ChordSymbol.tryParse(c.symbol.name), isNotNull);
            expect(c.symbol.pitchClasses.length, sevenths ? 4 : 3);
          }
        }
      }
    });
  });

  group('escalas para improvisar', () {
    test(
      'todas las calidades tienen sugerencia y parten de escalas reales',
      () {
        for (final ChordQuality quality in ChordQuality.values) {
          final List<ScaleType> scales = scalesForQuality(quality);
          expect(scales, isNotEmpty, reason: quality.id);
          for (final ScaleType scale in scales) {
            // Las escalas de siete notas o más contienen todas las notas del
            // acorde (la quinta o la novena opcionales pueden quedar fuera).
            // Las pentatónicas y el blues son un subconjunto: solo se les
            // exige la raíz y la tercera, y sobre un dominante el blues choca
            // a propósito con la tercera mayor.
            final bool small = scale.length <= 6;
            final Set<int> chord = small
                ? quality.requiredIntervals
                      .where((int i) => i == 0 || i == 3 || i == 4 || i == 5)
                      .toSet()
                : <int>{...quality.requiredIntervals};
            if (scale == ScaleType.blues ||
                scale == ScaleType.minorPentatonic) {
              chord.remove(4);
            }
            final Set<int> notes = scale.intervals.toSet();
            expect(
              notes.containsAll(chord),
              isTrue,
              reason:
                  '${scale.id} sobre ${quality.id}: faltan '
                  '${chord.difference(notes)}',
            );
          }
        }
      },
    );

    test('ejemplos conocidos', () {
      expect(scalesForQuality(ChordQuality.minorSeven).first, ScaleType.dorian);
      expect(scalesForQuality(ChordQuality.seven).first, ScaleType.mixolydian);
      expect(
        scalesForQuality(ChordQuality.sevenFlatNine).first,
        ScaleType.phrygianDominant,
      );
      expect(
        scalesForQuality(ChordQuality.halfDiminished).first,
        ScaleType.locrianSharp2,
      );
    });
  });
}
