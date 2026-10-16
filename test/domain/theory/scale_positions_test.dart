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

  test('cada escala reparte el mástil en cajas válidas', () {
    for (final ScaleType scale in ScaleType.values) {
      for (int tonic = 0; tonic < 12; tonic++) {
        final ScalePositions map = ScalePositions(scale, tonic);
        final List<ScalePosition> boxes = map.positions();
        expect(boxes.length, map.positionCount, reason: '${scale.id} $tonic');
        for (final ScalePosition box in boxes) {
          expect(box.minFret, greaterThanOrEqualTo(0), reason: scale.id);
          expect(box.maxFret, lessThanOrEqualTo(kScaleMaxFret));
          expect(
            box.maxFret - box.minFret,
            lessThanOrEqualTo(7),
            reason: '${scale.id} $tonic ${box.number}',
          );
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

  test('5 cajas en las pentatónicas y 7 posiciones en las de 7 notas', () {
    for (final ScaleType scale in ScaleType.values) {
      final int count = const ScalePositions(ScaleType.major, 0).positionCount;
      expect(count, 7);
      final int own = ScalePositions(scale, 0).positionCount;
      if (scale.length == 5) {
        expect(own, 5, reason: scale.id);
      }
      if (scale.length == 7) {
        expect(own, 7, reason: scale.id);
      }
    }
    expect(const ScalePositions(ScaleType.blues, 9).positionCount, 5);
    expect(const ScalePositions(ScaleType.bebopDominant, 0).positionCount, 7);
    expect(const ScalePositions(ScaleType.wholeTone, 0).positionCount, 6);
    expect(
      const ScalePositions(ScaleType.diminishedWholeHalf, 0).positionCount,
      8,
    );
  });

  test('las cajas de cada escala cubren todas sus notas del mástil', () {
    for (final ScaleType scale in ScaleType.values) {
      final ScalePositions map = ScalePositions(scale, 2);
      final Set<int> covered = <int>{
        for (final ScalePosition box in map.positions())
          for (final FretPosition note in box.notes) note.pitchClass,
      };
      expect(covered, scale.pitchClasses(2).toSet(), reason: scale.id);
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
