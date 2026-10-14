import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/services/scale_positions.dart';
import 'package:flutter_test/flutter_test.dart';

/// Posiciones (cajas) de las escalas sobre el mástil.
void main() {
  test('la caja 1 de La pentatónica menor es la clásica del traste 5', () {
    final ScalePosition box = const ScalePositions(
      ScaleType.minorPentatonic,
      9,
    ).positions().first;
    expect(box.notes, <FretPosition>{
      const FretPosition(6, 5),
      const FretPosition(6, 8),
      const FretPosition(5, 5),
      const FretPosition(5, 7),
      const FretPosition(4, 5),
      const FretPosition(4, 7),
      const FretPosition(3, 5),
      const FretPosition(3, 7),
      const FretPosition(2, 5),
      const FretPosition(2, 8),
      const FretPosition(1, 5),
      const FretPosition(1, 8),
    });
    expect(box.minFret, 5);
    expect(box.maxFret, 8);
  });

  test('las pentatónicas tienen 5 cajas y las de 7 notas 7 posiciones', () {
    for (final ScaleType scale in ScaleType.values) {
      for (int tonic = 0; tonic < 12; tonic++) {
        final List<ScalePosition> boxes = ScalePositions(
          scale,
          tonic,
        ).positions();
        expect(
          boxes.length,
          scale.length == 7 ? 7 : 5,
          reason: '${scale.id} $tonic',
        );
        for (final ScalePosition box in boxes) {
          expect(box.minFret, greaterThanOrEqualTo(0));
          expect(box.maxFret - box.minFret, lessThanOrEqualTo(6));
          for (final FretPosition note in box.notes) {
            expect(
              scale.contains(tonic, note.pitchClass),
              isTrue,
              reason: '${scale.id} $tonic $note',
            );
          }
        }
      }
    }
  });

  test('las posiciones de 7 notas tocan 3 notas por cuerda', () {
    final ScalePosition box = const ScalePositions(
      ScaleType.major,
      0,
    ).positions().first;
    for (int string = 1; string <= 6; string++) {
      expect(
        box.notes.where((FretPosition p) => p.stringNumber == string).length,
        3,
      );
    }
  });

  test('la caja de blues incluye la blue note', () {
    final ScalePosition box = const ScalePositions(
      ScaleType.blues,
      9,
    ).positions().first;
    expect(box.notes.any((FretPosition p) => p.pitchClass == 3), isTrue);
  });

  test('todas las notas del mástil pertenecen a la escala', () {
    final List<FretPosition> notes = const ScalePositions(
      ScaleType.majorPentatonic,
      7,
    ).allNotes();
    expect(notes, isNotEmpty);
    expect(notes.every((FretPosition p) => p.fret <= kScaleMaxFret), isTrue);
    expect(
      notes.every(
        (FretPosition p) => ScaleType.majorPentatonic.contains(7, p.pitchClass),
      ),
      isTrue,
    );
  });
}
