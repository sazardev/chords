import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';
import 'package:test/test.dart';

/// Cifrado de los acordes nuevos (extendidos, alterados y variantes de
/// escritura) y grados romanos con séptimas.
void main() {
  group('ChordSymbol', () {
    test('lee los tipos nuevos con su identificador de banco', () {
      expect(ChordSymbol.parse('Bm7b5').chordId, 'B-m7b5');
      expect(ChordSymbol.parse('F#maj9').chordId, 'F#-maj9');
      expect(ChordSymbol.parse('C7#9').chordId, 'C-7s9');
      expect(ChordSymbol.parse('Eb13').chordId, 'D#-13');
      expect(ChordSymbol.parse('Ab6/9').chordId, 'G#-69');
      expect(ChordSymbol.parse('Gadd9').quality, ChordQuality.add9);
      expect(ChordSymbol.parse('Dsus4').quality, ChordQuality.suspendedFourth);
      expect(ChordSymbol.parse('A7sus4').quality, ChordQuality.sevenSus4);
      expect(ChordSymbol.parse('Cdim7').quality, ChordQuality.diminishedSeven);
      expect(ChordSymbol.parse('CmMaj7').quality, ChordQuality.minorMajorSeven);
    });

    test('admite las otras formas de escribir un acorde', () {
      expect(ChordSymbol.parse('CM7').quality, ChordQuality.majorSeven);
      expect(ChordSymbol.parse('C-7').quality, ChordQuality.minorSeven);
      expect(ChordSymbol.parse('Cø').quality, ChordQuality.halfDiminished);
      expect(ChordSymbol.parse('C°').quality, ChordQuality.diminished);
      expect(ChordSymbol.parse('C+').quality, ChordQuality.augmented);
      expect(ChordSymbol.tryParse('Cxyz'), isNull);
    });

    test('el nombre se vuelve a leer igual', () {
      for (final ChordQuality quality in ChordQuality.values) {
        final ChordSymbol symbol = ChordSymbol(3, quality);
        expect(ChordSymbol.parse(symbol.name), symbol, reason: quality.id);
      }
    });
  });

  group('RomanChord', () {
    test('lee grados con séptimas, extensiones y semidisminuidos', () {
      expect(RomanChord.parse('ii7').quality, ChordQuality.minorSeven);
      expect(RomanChord.parse('Imaj9').quality, ChordQuality.majorNinth);
      expect(RomanChord.parse('viiø7').quality, ChordQuality.halfDiminished);
      expect(RomanChord.parse('V13').quality, ChordQuality.thirteenth);
      expect(RomanChord.parse('V7sus4').quality, ChordQuality.sevenSus4);
      expect(RomanChord.parse('bVII').offset, 10);
      expect(RomanChord.parse('IV9').quality, ChordQuality.ninth);
    });

    test('en una tonalidad da la cifra concreta', () {
      expect(RomanChord.parse('V7').inKey(0).name, 'G7');
      expect(RomanChord.parse('viiø7').inKey(7).name, 'F#m7b5');
    });
  });

  group('MusicalKey con séptimas', () {
    test('el vii de la mayor es semidisminuido y el de la armónica '
        'disminuido', () {
      final List<String> major = <String>[
        for (final DiatonicChord c in const MusicalKey(
          0,
        ).harmony(sevenths: true))
          c.symbol.name,
      ];
      expect(major.last, 'Bm7b5');
      expect(const MusicalKey(0).harmony(sevenths: true).last.roman, 'viiø7');
    });
  });
}
