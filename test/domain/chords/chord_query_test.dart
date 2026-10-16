import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/services/chord_query.dart';
import 'package:chords/domain/chords/services/note_name_parser.dart';
import 'package:chords/domain/chords/services/search_text.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:test/test.dart';

import '../../support/real_bank.dart';

/// Búsqueda de acordes por cifrado, nombre en español, notas y texto libre.
void main() {
  const SearchChordsUseCase search = SearchChordsUseCase();

  /// Identificadores de los resultados de [query] sobre el banco real.
  List<String> ids(String query) => <String>[
    for (final Chord chord in search(realBank(), ChordFilters(query: query)))
      chord.id,
  ];

  group('normalización y notas', () {
    test('quita tildes, mayúsculas y espacios de más', () {
      expect(normalizeSearchText('  Séptima   MENOR '), 'septima menor');
      expect(compactSearchText('Menor 7'), 'menor7');
      expect(compactSearchText('m7(b5)'), 'm7b5');
    });

    test('lee notas en inglés y en español con su alteración', () {
      expect(parseWholeNote('C'), 0);
      expect(parseWholeNote('C#'), 1);
      expect(parseWholeNote('Bb'), 10);
      expect(parseWholeNote('Do'), 0);
      expect(parseWholeNote('Sol#'), 8);
      expect(parseWholeNote('Sib'), 10);
      expect(parseWholeNote('mi bemol'), 3);
      expect(parseWholeNote('Fa sostenido'), 6);
      expect(parseWholeNote('mayor'), isNull);
      expect(parseLeadingNote('Lam7')?.rest, 'm7');
      expect(parseLeadingNote('Lam7')?.pitchClass, 9);
    });
  });

  group('ChordQuery', () {
    test('interpreta el cifrado', () {
      final ChordQuery query = ChordQuery.parse('F#m7b5');
      expect(query.root, ChordRoot.fSharp);
      expect(query.quality, ChordQuality.halfDiminished);
    });

    test('interpreta nombres en español', () {
      expect(ChordQuery.parse('Do mayor').quality, ChordQuality.major);
      expect(ChordQuery.parse('Re menor 7').root, ChordRoot.d);
      expect(ChordQuery.parse('Re menor 7').quality, ChordQuality.minorSeven);
      expect(ChordQuery.parse('Lam').quality, ChordQuality.minor);
      expect(ChordQuery.parse('Sol7').quality, ChordQuality.seven);
      expect(ChordQuery.parse('si bemol mayor 7').root, ChordRoot.aSharp);
    });

    test('interpreta nombres en inglés', () {
      expect(ChordQuery.parse('D minor 7').quality, ChordQuality.minorSeven);
      expect(ChordQuery.parse('A major').quality, ChordQuality.major);
      expect(
        ChordQuery.parse('G half diminished').quality,
        ChordQuality.halfDiminished,
      );
    });

    test('una lista de notas se reconoce como tal', () {
      expect(ChordQuery.parse('C E G').notes, <int>{0, 4, 7});
      expect(ChordQuery.parse('do, mi, sol').notes, <int>{0, 4, 7});
      expect(ChordQuery.parse('C').notes, isEmpty);
      expect(ChordQuery.parse('C mayor').notes, isEmpty);
    });

    test('el texto vacío no filtra', () {
      expect(ChordQuery.parse('  ').isEmpty, isTrue);
      expect(ChordQuery.parse('').relevance(realChord('C-maj')), 0);
    });
  });

  group('búsqueda sobre el banco real', () {
    test('el cifrado exacto va primero', () {
      expect(ids('Cm7').first, 'C-m7');
      expect(ids('C#m7b5').first, 'C#-m7b5');
      expect(ids('Bb7').first, 'A#-7');
      expect(ids('G7#9').first, 'G-7s9');
      expect(ids('Dsus2').first, 'D-sus2');
      expect(ids('E6/9').first, 'E-69');
      expect(ids('Adim7').first, 'A-dim7');
    });

    test('distingue M7 de m7', () {
      expect(ids('CM7').first, 'C-maj7');
      expect(ids('Cm7').first, 'C-m7');
      expect(ids('Cmaj7').first, 'C-maj7');
    });

    test('entiende nombres en español', () {
      expect(ids('Do mayor').first, 'C-maj');
      expect(ids('Re menor 7').first, 'D-m7');
      expect(ids('La menor').first, 'A-min');
      expect(ids('Sol séptima').first, 'G-7');
      expect(ids('Fa sostenido menor').first, 'F#-min');
      expect(ids('Lam7').first, 'A-m7');
    });

    test('entiende nombres en inglés', () {
      expect(ids('D minor 7').first, 'D-m7');
      expect(ids('E dominant 7').first, 'E-7');
      expect(ids('Cmaj7').first, 'C-maj7');
    });

    test('busca por notas: C E G da el Do mayor y sus parientes', () {
      final List<String> found = ids('C E G');
      expect(found.first, 'C-maj');
      expect(found, contains('C-maj7'));
      expect(found, contains('A-min7'.replaceAll('min7', 'm7')));
      for (final String id in found) {
        final Chord chord = realChord(id);
        final Set<int> tones = chord.quality.pitchClassesOn(
          chord.root.pitchClass,
        );
        expect(tones.containsAll(<int>{0, 4, 7}), isTrue, reason: id);
      }
    });

    test(
      'una sola raíz muestra su mayor primero y luego el resto de la raíz',
      () {
        final List<String> found = ids('G');
        expect(found.first, 'G-maj');
        expect(
          found.take(10).every((String id) => id.startsWith('G-')),
          isTrue,
        );
      },
    );

    test('con una o dos letras solo mira los nombres: sin ruido', () {
      expect(ids('C').every((String id) => id.startsWith('C')), isTrue);
      expect(ids('Do').every((String id) => id.startsWith('C')), isTrue);
      expect(ids('La').first, 'A-maj');
      expect(ids('mi menor').take(5), contains('E-min'));
      expect(
        ids('mi menor').take(12).every((String id) => id.startsWith('E-')),
        isTrue,
      );
      expect(ids('7'), contains('C-7'));
      expect(ids('7'), contains('G-m7'));
    });

    test('busca por tipo en español y en inglés', () {
      expect(ids('sus').every((String id) => id.contains('sus')), isTrue);
      expect(
        ids('semidisminuido')
            .take(12)
            .every((String id) => id.endsWith('m7b5')),
        isTrue,
      );
      expect(ids('half diminished').first.endsWith('m7b5'), isTrue);
      expect(ids('menor con séptima mayor').first.endsWith('mMaj7'), isTrue);
    });

    test('busca por género y por tipo de posición', () {
      expect(ids('blues'), isNotEmpty);
      expect(ids('drop 2'), isNotEmpty);
      expect(ids('shell'), isNotEmpty);
    });

    test('un texto sin sentido no encuentra nada', () {
      expect(ids('zzzz'), isEmpty);
    });

    test('combina el texto con los demás filtros', () {
      final List<Chord> found = search(
        realBank(),
        const ChordFilters(query: 'm7', maxDifficulty: 1),
      );
      expect(found, isNotEmpty);
      expect(found.every((Chord c) => c.difficulty.level <= 1), isTrue);
    });
  });
}
