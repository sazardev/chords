import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

/// Teoría musical: cifras, grados, tonalidades, escalas y rasgueos.
void main() {
  group('ChordSymbol', () {
    test('interpreta cifras con sostenidos, bemoles y sufijos', () {
      expect(ChordSymbol.parse('G').chordId, 'G-maj');
      expect(ChordSymbol.parse('Em').chordId, 'E-min');
      expect(ChordSymbol.parse('Bb7').chordId, 'A#-7');
      expect(ChordSymbol.parse('F#m7').chordId, 'F#-m7');
      expect(ChordSymbol.parse('Cmaj7').chordId, 'C-maj7');
      expect(ChordSymbol.parse('E5').chordId, 'E-5');
      expect(ChordSymbol.parse('Dsus4').chordId, 'D-sus4');
      expect(ChordSymbol.parse('Cb').root, 11);
    });

    test('rechaza cifras que no existen', () {
      expect(ChordSymbol.tryParse('H7'), isNull);
      expect(ChordSymbol.tryParse('Cxyz'), isNull);
      expect(() => ChordSymbol.parse(''), throwsFormatException);
    });

    test('transporta en las dos direcciones', () {
      expect(ChordSymbol.parse('G').transpose(2).name, 'A');
      expect(ChordSymbol.parse('C').transpose(-1).name, 'B');
      expect(ChordSymbol.parse('Am').transpose(12).name, 'Am');
    });

    test('conoce sus notas', () {
      expect(ChordSymbol.parse('C').pitchClasses, <int>{0, 4, 7});
      expect(ChordSymbol.parse('A5').pitchClasses, <int>{9, 4});
    });
  });

  group('RomanChord', () {
    test('mayúsculas mayores, minúsculas menores y sufijos', () {
      expect(RomanChord.parse('I').inKey(7).name, 'G');
      expect(RomanChord.parse('vi').inKey(7).name, 'Em');
      expect(RomanChord.parse('V7').inKey(9).name, 'E7');
      expect(RomanChord.parse('ii7').inKey(0).name, 'Dm7');
      expect(RomanChord.parse('Imaj7').inKey(0).name, 'Cmaj7');
      expect(RomanChord.parse('vii°').inKey(0).name, 'Bdim');
      expect(RomanChord.parse('iv').inKey(0).name, 'Fm');
      expect(RomanChord.parse('IV9').inKey(4).name, 'A9');
    });

    test('las alteraciones mueven el grado un semitono', () {
      expect(RomanChord.parse('bVII').inKey(2).name, 'C');
      expect(RomanChord.parse('bVI5').inKey(4).name, 'C5');
      expect(RomanChord.parse('bII5').inKey(4).name, 'F5');
      expect(RomanChord.parse('#IV').offset, 6);
    });

    test('rechaza grados mal escritos', () {
      expect(() => RomanChord.parse('X'), throwsFormatException);
      expect(() => RomanChord.parse('Vfoo'), throwsFormatException);
    });
  });

  group('MusicalKey', () {
    List<String> names(MusicalKey key, {bool sevenths = false}) => <String>[
      for (final DiatonicChord c in key.harmony(sevenths: sevenths))
        c.symbol.name,
    ];

    test('Do mayor: C Dm Em F G Am B°', () {
      expect(names(const MusicalKey(0)), <String>[
        'C',
        'Dm',
        'Em',
        'F',
        'G',
        'Am',
        'Bdim',
      ]);
      expect(
        const MusicalKey(0).harmony().map((DiatonicChord c) => c.roman),
        <String>['I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii°'],
      );
    });

    test('La menor: Am B° C Dm Em F G', () {
      expect(names(const MusicalKey(9, minor: true)), <String>[
        'Am',
        'Bdim',
        'C',
        'Dm',
        'Em',
        'F',
        'G',
      ]);
    });

    test('cuatriadas en Sol: Gmaj7 Am7 Bm7 Cmaj7 D7 Em7', () {
      expect(names(const MusicalKey(7), sevenths: true).take(6), <String>[
        'Gmaj7',
        'Am7',
        'Bm7',
        'Cmaj7',
        'D7',
        'Em7',
      ]);
    });

    test('relativas: Do mayor ↔ La menor', () {
      expect(const MusicalKey(0).relative, const MusicalKey(9, minor: true));
      expect(const MusicalKey(4, minor: true).relative, const MusicalKey(7));
    });
  });

  group('ScaleType', () {
    test('notas de la escala desde su tónica', () {
      expect(ScaleType.major.pitchClasses(7), <int>[7, 9, 11, 0, 2, 4, 6]);
      expect(ScaleType.minorPentatonic.pitchClasses(9), <int>[9, 0, 2, 4, 7]);
      expect(ScaleType.blues.contains(9, 3), isTrue);
    });

    test('la menor natural es menor y la mixolidia no', () {
      expect(ScaleType.naturalMinor.isMinor, isTrue);
      expect(ScaleType.mixolydian.isMinor, isFalse);
    });

    test('grados con su símbolo', () {
      expect(degreeSymbol(0, 3), 'b3');
      expect(degreeSymbol(0, 6, scale: ScaleType.lydian), '#4');
      expect(degreeSymbol(0, 6, scale: ScaleType.blues), 'b5');
    });

    test('cada id se resuelve', () {
      for (final ScaleType scale in ScaleType.values) {
        expect(ScaleType.fromId(scale.id), scale);
      }
    });
  });

  test('cada rasgueo tiene un compás entero de corcheas', () {
    for (final StrumPattern pattern in StrumPattern.values) {
      expect(pattern.notation.length, anyOf(6, 8), reason: pattern.name);
      expect(pattern.strokes.length, pattern.notation.length);
    }
    expect(StrumPattern.waltz.beatsPerBar, 3);
    expect(StrumPattern.pop.beatsPerBar, 4);
    expect(ChordQuality.values, isNotEmpty);
  });
}
