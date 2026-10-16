import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// El catálogo de progresiones: ≥ 90, auténticas y tocables en los 12 tonos.
void main() {
  final FakeChordRepository bank = loadChordBank();

  test('hay al menos 90 progresiones con identificadores únicos', () {
    expect(kProgressions.length, greaterThanOrEqualTo(90));
    final Set<String> ids = <String>{};
    for (final ChordProgression p in kProgressions) {
      expect(ids.add(p.id), isTrue, reason: 'id repetido ${p.id}');
      expect(progressionById(p.id), same(p));
    }
  });

  test('todos los grados parsean y sus acordes existen en los 12 tonos', () {
    for (final ChordProgression p in kProgressions) {
      expect(genreGuideById(p.genre), isNotNull, reason: p.id);
      expect(p.bars, isNotEmpty, reason: p.id);
      for (int key = 0; key < 12; key++) {
        final List<List<ChordSymbol>> bars = p.barsIn(key);
        expect(bars.length, p.bars.length);
        for (final List<ChordSymbol> bar in bars) {
          expect(bar.length, inInclusiveRange(1, 4), reason: p.id);
          for (final ChordSymbol chord in bar) {
            expect(
              bank.chordById(chord.chordId),
              isNotNull,
              reason: '${p.id} en tono $key: ${chord.chordId}',
            );
          }
        }
      }
    }
  });

  test('la tónica y la tonalidad por defecto son coherentes', () {
    for (final ChordProgression p in kProgressions) {
      expect(p.tonic, inInclusiveRange(0, 11), reason: p.id);
      expect(p.bpm, inInclusiveRange(55, 200), reason: p.id);
      expect(<int>[6, 8], contains(p.strum.notation.length), reason: p.id);
      if (p.minor) {
        final bool hasMinorTonic = p
            .barsIn(p.tonic)
            .expand((List<ChordSymbol> bar) => bar)
            .any(
              (ChordSymbol c) =>
                  c.root == p.tonic &&
                  <ChordQuality>[
                    ChordQuality.minor,
                    ChordQuality.minorSeven,
                    ChordQuality.minorSixth,
                    ChordQuality.power,
                  ].contains(c.quality),
            );
        expect(hasMinorTonic, isTrue, reason: '${p.id} debería tener un i');
      }
    }
  });

  test('hay variedad: mayores y menores, tonos, tempos y compases', () {
    final Iterable<ChordProgression> minors = kProgressions.where(
      (ChordProgression p) => p.minor,
    );
    expect(minors.length, greaterThanOrEqualTo(25));
    expect(kProgressions.length - minors.length, greaterThanOrEqualTo(40));
    expect(
      kProgressions.map((ChordProgression p) => p.tonic).toSet().length,
      greaterThanOrEqualTo(8),
    );
    expect(
      kProgressions
          .map((ChordProgression p) => p.bpm)
          .reduce((int a, int b) => a < b ? a : b),
      lessThan(75),
    );
    expect(
      kProgressions.map((ChordProgression p) => p.bars.length).toSet(),
      containsAll(<int>[4, 8, 12]),
    );
  });

  test('los clásicos con nombre propio existen', () {
    for (final String id in <String>[
      'popAxis',
      'dooWop',
      'blues12',
      'bluesQuick',
      'jazz251',
      'jazzRhythmA',
      'andalusian',
      'flamencoCadence',
      'salsaMontuno',
      'cumbiaMajor',
      'cumbiaMinor',
      'reggaetonMinor',
      'grungeMinor',
      'skaClassic',
      'discoMinor',
      'lofiDreamy',
      'tangoMinor',
      'boleroClassic',
    ]) {
      expect(progressionById(id), isNotNull, reason: id);
    }
  });

  for (final AppLocale locale in AppLocale.values) {
    test('${locale.languageCode}: cada progresión tiene nombre', () {
      final Translations t = locale.buildSync();
      for (final ChordProgression p in kProgressions) {
        expect(t.theory.progressionNames[p.id], isNotEmpty, reason: p.id);
      }
    });
  }
}
