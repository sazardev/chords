import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_tone.dart';
import 'package:chords/domain/chords/entities/essential_chords.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/domain/chords/services/chord_relatives.dart';
import 'package:chords/domain/chords/services/chord_sorter.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/chord_key_roles.dart';
import 'package:chords/domain/theory/services/chord_progression_usage.dart';
import 'package:test/test.dart';

import '../../support/real_bank.dart';

/// Orden de la biblioteca, itinerario de aprendizaje y datos de la ficha.
void main() {
  const ChordSorter sorter = ChordSorter();

  group('ChordSorter', () {
    test('esenciales primero, en el orden de la lista de esenciales', () {
      final List<Chord> sorted = sorter.sort(realBank(), ChordSort.essentials);
      expect(
        sorted.take(kEssentialChordIds.length).map((Chord c) => c.id),
        kEssentialChordIds,
      );
      expect(sorted.length, realBank().length);
    });

    test('por dificultad: de lo fácil a lo difícil', () {
      final List<Chord> sorted = sorter.sort(realBank(), ChordSort.difficulty);
      for (int i = 1; i < sorted.length; i++) {
        expect(
          sorted[i].difficulty.level,
          greaterThanOrEqualTo(sorted[i - 1].difficulty.level),
        );
      }
    });

    test('por raíz y por tipo agrupan seguido', () {
      final List<Chord> byRoot = sorter.sort(realBank(), ChordSort.root);
      expect(byRoot.first.root.pitchClass, 0);
      expect(byRoot.last.root.pitchClass, 11);
      final List<Chord> byQuality = sorter.sort(realBank(), ChordSort.quality);
      expect(byQuality.first.quality, ChordQuality.major);
      expect(byQuality.take(12).map((Chord c) => c.quality).toSet().length, 1);
    });

    test('la relevancia manda y el orden desempata', () {
      final List<Chord> chords = <Chord>[
        realChord('E-7'),
        realChord('C-maj'),
        realChord('A-min'),
      ];
      final List<Chord> ranked = sorter.sortRanked(
        chords,
        ChordSort.root,
        (Chord c) => c.id == 'A-min' ? 0 : 1,
      );
      expect(ranked.map((Chord c) => c.id), <String>['A-min', 'C-maj', 'E-7']);
    });

    test('el orden de estudio alterna tipos y empieza por lo fácil', () {
      final List<Chord> level2 = sorter.learningOrder(<Chord>[
        for (final Chord c in realBank())
          if (LearningLevel.of(c).level == 2) c,
      ]);
      final List<ChordQuality> firstQualities = level2
          .take(6)
          .map((Chord c) => c.quality)
          .toList();
      expect(firstQualities.toSet().length, greaterThanOrEqualTo(3));
      expect(level2.first.quality, ChordQuality.seven);
    });
  });

  group('itinerario de aprendizaje', () {
    test('los ocho acordes de siempre son el nivel 1', () {
      final Set<String> first = <String>{
        for (final Chord c in realBank())
          if (LearningLevel.of(c).level == 1) c.id,
      };
      expect(first, <String>{
        'C-maj',
        'G-maj',
        'D-maj',
        'A-maj',
        'E-maj',
        'A-min',
        'E-min',
        'D-min',
      });
    });

    test('cada nivel tiene acordes suficientes para su itinerario', () {
      for (final LearningLevel level in LearningLevel.values) {
        final int count = realBank()
            .where((Chord c) => LearningLevel.of(c).level == level.level)
            .length;
        expect(count, greaterThanOrEqualTo(8), reason: level.title);
      }
    });

    test('los de jazz (extendidos y alterados) no caen en la cejilla', () {
      expect(LearningLevel.of(realChord('C-13')), LearningLevel.fifth);
      expect(LearningLevel.of(realChord('C-7s9')), LearningLevel.fifth);
      expect(LearningLevel.of(realChord('A-m7')), LearningLevel.fourth);
      expect(
        LearningLevel.of(realChord('B-min')),
        anyOf(LearningLevel.third, LearningLevel.second),
      );
    });
  });

  group('ChordRelatives', () {
    test('los parientes comparten raíz y van de más a menos usados', () {
      final Chord chord = realChord('C-maj7');
      final ChordRelatives finder = ChordRelatives(realBank());
      final List<Chord> relatives = finder.sameRoot(chord);
      expect(relatives.length, 12);
      expect(relatives.every((Chord c) => c.root == chord.root), isTrue);
      expect(relatives.map((Chord c) => c.id), isNot(contains('C-maj7')));
      expect(relatives.first.quality.popularity, 5);
      expect(
        relatives.map((Chord c) => c.id),
        containsAll(<String>['C-maj', 'C-min', 'C-7']),
      );
    });

    test('la relativa de Do es La menor y la de La menor es Do', () {
      final ChordRelatives finder = ChordRelatives(realBank());
      expect(finder.relative(realChord('C-maj'))?.id, 'A-min');
      expect(finder.relative(realChord('A-min'))?.id, 'C-maj');
      expect(finder.relative(realChord('E-min'))?.id, 'G-maj');
      expect(finder.relative(realChord('C-7')), isNull);
    });
  });

  group('ChordInsights', () {
    test('notas y grados de un Do7', () {
      final ChordInsights insights = ChordInsights.of(
        realChord('C-7'),
        realBank(),
      );
      expect(
        insights.tones.map((ChordTone t) => '${t.note}:${t.degree}').toList(),
        <String>['C:1', 'E:3', 'G:5', 'A#:b7'],
      );
      expect(insights.tones[2].isOptional, isTrue);
      expect(insights.tones[0].isOptional, isFalse);
      expect(insights.scales.first, ScaleType.mixolydian);
    });

    test('un acorde de 13 marca como opcionales la quinta y la novena', () {
      final ChordInsights insights = ChordInsights.of(
        realChord('C-13'),
        realBank(),
      );
      final Map<String, bool> optional = <String, bool>{
        for (final ChordTone t in insights.tones) t.degree: t.isOptional,
      };
      expect(optional, <String, bool>{
        '1': false,
        '3': false,
        '5': true,
        'b7': false,
        '9': true,
        '13': false,
      });
    });
  });

  group('tonalidades y progresiones', () {
    test('Do mayor es I en Do, IV en Sol y V en Fa', () {
      final List<ChordKeyRole> roles = keyRolesOf(
        const ChordSymbol(0, ChordQuality.major),
      );
      String has(int tonic, ScaleType scale) => roles
          .firstWhere((ChordKeyRole r) => r.tonic == tonic && r.scale == scale)
          .roman;
      expect(has(0, ScaleType.major), 'I');
      expect(has(7, ScaleType.major), 'IV');
      expect(has(5, ScaleType.major), 'V');
      expect(has(9, ScaleType.naturalMinor), 'III');
    });

    test('Gmaj7 (cuatriada) es Imaj7 en Sol y IVmaj7 en Re', () {
      final List<ChordKeyRole> roles = keyRolesOf(
        const ChordSymbol(7, ChordQuality.majorSeven),
      );
      expect(
        roles
            .where((ChordKeyRole r) => r.scale == ScaleType.major)
            .map((ChordKeyRole r) => '${r.tonic}:${r.roman}'),
        containsAll(<String>['7:Imaj7', '2:IVmaj7']),
      );
    });

    test('el 13 no es diatónico y el aumentado sí (III+ de la armónica)', () {
      expect(
        keyRolesOf(const ChordSymbol(0, ChordQuality.thirteenth)),
        isEmpty,
      );
      expect(
        keyRolesOf(const ChordSymbol(0, ChordQuality.augmented)),
        isNotEmpty,
        reason: 'el III+ de La menor armónica es Do aumentado',
      );
    });

    test(
      'Do mayor está en las progresiones del catálogo, como tónica primero',
      () {
        final List<ProgressionUse> uses = progressionsWith(
          const ChordSymbol(0, ChordQuality.major),
        );
        expect(uses, isNotEmpty);
        expect(uses.length, lessThanOrEqualTo(6));
        expect(uses.first.degree, 'I');
        expect(uses.first.chords.first.name, anyOf('C', 'F', 'G'));
        for (final ProgressionUse use in uses) {
          expect(
            use.chords.map((ChordSymbol c) => c.name),
            contains('C'),
            reason: use.progression.id,
          );
        }
      },
    );

    test('un acorde de jazz solo está en las progresiones que lo traen', () {
      final List<ProgressionUse> uses = progressionsWith(
        const ChordSymbol(0, ChordQuality.majorSeven),
      );
      expect(uses, isNotEmpty);
      expect(
        uses.every(
          (ProgressionUse u) => u.progression.bars.join(' ').contains('maj7'),
        ),
        isTrue,
      );
      expect(
        progressionsWith(const ChordSymbol(0, ChordQuality.sevenFlatNine)),
        isEmpty,
      );
    });
  });
}
