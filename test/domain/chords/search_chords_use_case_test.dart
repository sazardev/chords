import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_filters.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/usecases/search_chords_use_case.dart';
import 'package:test/test.dart';

/// Tests del caso de uso de búsqueda y filtrado.
void main() {
  /// Construye un acorde mínimo para las pruebas.
  Chord chordOf(ChordRoot root, ChordQuality quality, int difficultyLevel) =>
      Chord(
        id: '${root.name}-${quality.id}',
        root: root,
        quality: quality,
        variants: <ChordVariant>[
          ChordVariant(
            id: '${root.name}-${quality.id}-1',
            positionLabel: 'Forma de prueba',
            frets: const <int>[-1, 3, 5, 5, 5, 3],
            fingers: const <int>[0, 1, 3, 3, 4, 1],
            difficulty: Difficulty.fromLevel(difficultyLevel)!,
          ),
        ],
      );

  final List<Chord> chords = <Chord>[
    chordOf(ChordRoot.c, ChordQuality.major, 1),
    chordOf(ChordRoot.c, ChordQuality.minorSeven, 3),
    chordOf(ChordRoot.a, ChordQuality.minor, 1),
    chordOf(ChordRoot.e, ChordQuality.seven, 2),
  ];

  const SearchChordsUseCase useCase = SearchChordsUseCase();

  group('SearchChordsUseCase', () {
    test('sin filtros devuelve todo', () {
      expect(useCase(chords, const ChordFilters.empty()).length, 4);
    });

    test('filtra por raíz', () {
      final List<Chord> result = useCase(
        chords,
        const ChordFilters(root: ChordRoot.c),
      );
      expect(result.length, 2);
      expect(result.every((Chord c) => c.root == ChordRoot.c), isTrue);
    });

    test('filtra por calidad', () {
      final List<Chord> result = useCase(
        chords,
        const ChordFilters(quality: ChordQuality.minor),
      );
      expect(result.length, 1);
      expect(result.single.name, 'Am');
    });

    test('filtra por dificultad máxima', () {
      final List<Chord> result = useCase(
        chords,
        const ChordFilters(maxDifficulty: 1),
      );
      expect(result.length, 2);
    });

    test('busca por texto en nombre y alias', () {
      final List<Chord> result = useCase(
        chords,
        const ChordFilters(query: 'CM7'),
      );
      expect(result.single.name, 'Cm7');
    });
  });
}
