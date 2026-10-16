import 'package:chords/domain/chords/entities/chord_family.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_suffixes.dart';
import 'package:chords/presentation/widgets/molecules/genre_filter_row.dart';
import 'package:test/test.dart';

/// Coherencia de las calidades de acorde: construcción, fórmula, géneros y
/// metadatos.
void main() {
  /// Semitonos de un grado de acorde (`b3`, `#11`, `13`) desde la raíz.
  int semitones(String degree) {
    const Map<String, int> natural = <String, int>{
      '1': 0,
      '2': 2,
      '3': 4,
      '4': 5,
      '5': 7,
      '6': 9,
      '7': 11,
      '9': 14,
      '11': 17,
      '13': 21,
    };
    final String number = degree.replaceAll(RegExp('[b#]'), '');
    final int shift = degree.split('#').length - degree.split('b').length;
    return natural[number]! + shift;
  }

  group('ChordQuality', () {
    test('hay al menos 30 calidades con identificadores únicos', () {
      expect(ChordQuality.values.length, greaterThanOrEqualTo(30));
      final Set<String> ids = ChordQuality.values
          .map((ChordQuality q) => q.id)
          .toSet();
      expect(ids.length, ChordQuality.values.length);
      for (final String id in ids) {
        expect(
          id,
          matches(RegExp(r'^[A-Za-z0-9]+$')),
          reason: 'id seguro: $id',
        );
      }
      final Set<String> suffixes = ChordQuality.values
          .map((ChordQuality q) => q.suffix)
          .toSet();
      expect(suffixes.length, ChordQuality.values.length);
    });

    test('cada id y cada sufijo se resuelve a su calidad', () {
      for (final ChordQuality quality in ChordQuality.values) {
        expect(ChordQuality.fromId(quality.id), quality);
        expect(qualityOfSuffix(quality.suffix), quality, reason: quality.id);
      }
      expect(ChordQuality.fromId('nada'), isNull);
    });

    test('la fórmula describe exactamente los intervalos de la calidad', () {
      for (final ChordQuality quality in ChordQuality.values) {
        expect(
          quality.formula.length,
          quality.intervals.length,
          reason: quality.id,
        );
        for (int i = 0; i < quality.intervals.length; i++) {
          expect(
            semitones(quality.formula[i]),
            quality.intervals[i],
            reason: '${quality.id} ${quality.formula[i]}',
          );
        }
        expect(quality.intervals.first, 0);
      }
    });

    test('los intervalos imprescindibles incluyen la raíz y no la quinta '
        'cuando es opcional', () {
      for (final ChordQuality quality in ChordQuality.values) {
        expect(quality.requiredIntervals, contains(0), reason: quality.id);
        expect(
          quality.requiredIntervals.length,
          greaterThanOrEqualTo(2),
          reason: quality.id,
        );
      }
      expect(ChordQuality.seven.requiredIntervals, <int>{
        0,
        4,
        10,
      }, reason: 'la quinta del 7 se puede omitir');
      expect(ChordQuality.power.requiredIntervals, <int>{0, 7});
      expect(ChordQuality.thirteenth.requiredIntervals, <int>{0, 4, 10, 9});
      expect(ChordQuality.eleventh.requiredIntervals, <int>{0, 10, 5});
      expect(ChordQuality.halfDiminished.requiredIntervals.length, 4);
    });

    test('los géneros son del catálogo y alguno sale en el filtro de la '
        'biblioteca', () {
      for (final ChordQuality quality in ChordQuality.values) {
        expect(quality.genres, isNotEmpty, reason: quality.id);
        for (final String genre in quality.genres) {
          expect(kChordGenres, contains(genre), reason: quality.id);
        }
        expect(
          quality.genres.any(GenreFilterRow.kDefaultGenreFilters.contains),
          isTrue,
          reason: '${quality.id} no se podría filtrar por ningún género',
        );
      }
    });

    test('la dificultad mínima y el uso están en rango y cada familia '
        'tiene calidades', () {
      for (final ChordQuality quality in ChordQuality.values) {
        expect(quality.minDifficulty, inInclusiveRange(1, 3));
        expect(quality.popularity, inInclusiveRange(1, 5));
        expect(quality.description, isNotEmpty);
      }
      for (final ChordFamily family in ChordFamily.values) {
        expect(
          ChordQuality.values.any((ChordQuality q) => q.family == family),
          isTrue,
          reason: family.name,
        );
      }
    });

    test('las clases de tono sobre una raíz', () {
      expect(ChordQuality.major.pitchClassesOn(0), <int>{0, 4, 7});
      expect(ChordQuality.ninth.pitchClassesOn(7), <int>{7, 11, 2, 5, 9});
      expect(ChordQuality.diminishedSeven.pitchClassesOn(0), <int>{0, 3, 6, 9});
    });
  });

  group('sufijos de cifrado', () {
    test('reconoce las formas habituales de escribir un acorde', () {
      expect(qualityOfSuffix('M7'), ChordQuality.majorSeven);
      expect(qualityOfSuffix('-7'), ChordQuality.minorSeven);
      expect(qualityOfSuffix('ø'), ChordQuality.halfDiminished);
      expect(qualityOfSuffix('°7'), ChordQuality.diminishedSeven);
      expect(qualityOfSuffix('+'), ChordQuality.augmented);
      expect(qualityOfSuffix('7#9'), ChordQuality.sevenSharpNine);
      expect(qualityOfSuffix('6/9'), ChordQuality.sixNine);
      expect(qualityOfSuffix('sus'), ChordQuality.suspendedFourth);
      expect(qualityOfSuffix('xyz'), isNull);
    });
  });
}
