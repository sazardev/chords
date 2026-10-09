import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/usecases/match_chords_by_pitch_classes_use_case.dart';
import 'package:test/test.dart';

/// Tests del caso de uso de coincidencia por notas detectadas.
void main() {
  /// Construye un acorde con las notas indicadas.
  Chord chordOf(String id, List<String> notes) => Chord(
    id: id,
    root: ChordRoot.c,
    quality: ChordQuality.major,
    variants: <ChordVariant>[
      ChordVariant(
        id: '$id-1',
        positionLabel: 'Prueba',
        frets: const <int>[-1, 3, 5, 5, 3],
        fingers: const <int>[0, 1, 3, 3, 4],
        difficulty: Difficulty.beginner,
        notes: notes,
      ),
    ],
  );

  final List<Chord> chords = <Chord>[
    chordOf('C-maj', const <String>['C', 'E', 'G']),
    chordOf('Cm-maj', const <String>['C', 'D#', 'G']),
    chordOf('C-aug', const <String>['C', 'E', 'G#']),
  ];
  const MatchChordsByPitchClassesUseCase useCase =
      MatchChordsByPitchClassesUseCase();

  group('MatchChordsByPitchClassesUseCase', () {
    test('devuelve vacío sin notas detectadas', () {
      expect(useCase(chords, const <int>{}), isEmpty);
    });

    test('coincidencia exacta con C mayor', () {
      final List<Chord> result = useCase(chords, <int>{0, 4, 7});
      expect(result.single.id, 'C-maj');
    });

    test('sin coincidencia con notas ajenas', () {
      final List<Chord> result = useCase(chords, <int>{0, 4, 10});
      expect(result, isEmpty);
    });
  });

  group('PitchReading', () {
    test('la claridad alta marca la lectura como fiable', () {
      const PitchReading reading = PitchReading(
        frequency: 440,
        note: 'A4',
        cents: 2,
        clarity: 0.9,
      );
      expect(reading.isReliable, isTrue);
      expect(MicStatus.listening, isNot(MicStatus.idle));
    });

    test('la claridad baja no es fiable', () {
      const PitchReading reading = PitchReading(
        frequency: 440,
        note: 'A4',
        cents: 2,
        clarity: 0.2,
      );
      expect(reading.isReliable, isFalse);
    });
  });
}
