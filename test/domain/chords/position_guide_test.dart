import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/position_guide.dart';
import 'package:test/test.dart';

ChordVariant _variant(List<int> frets, List<int> fingers) => ChordVariant(
  id: 'x',
  positionLabel: 'x',
  frets: frets,
  fingers: fingers,
  difficulty: Difficulty.medium,
);

/// Tests de la explicación de cómo colocar una posición.
void main() {
  test('Do mayor abierto: un dedo por cuerda y cuerdas al aire', () {
    final PositionGuide guide = PositionGuide.of(
      _variant(const <int>[-1, 3, 2, 0, 1, 0], const <int>[0, 3, 2, 0, 1, 0]),
    );
    expect(guide.steps.map((FingerStep s) => s.finger), <int>[1, 2, 3]);
    expect(guide.steps[0].strings, <int>[2]);
    expect(guide.steps[0].fret, 1);
    expect(guide.steps[2].strings, <int>[5]);
    expect(guide.steps[2].fret, 3);
    expect(guide.played, <int>[5, 4, 3, 2, 1]);
    expect(guide.open, <int>[3, 1]);
    expect(guide.muted, <int>[6]);
    expect(guide.isOpenPosition, isTrue);
    expect(guide.steps.any((FingerStep s) => s.isBarre), isFalse);
  });

  test('Fa con cejillo: el índice cubre las seis cuerdas', () {
    final PositionGuide guide = PositionGuide.of(
      _variant(const <int>[1, 3, 3, 2, 1, 1], const <int>[1, 3, 4, 2, 1, 1]),
    );
    final FingerStep index = guide.steps.first;
    expect(index.finger, 1);
    expect(index.isBarre, isTrue);
    expect(index.strings, <int>[6, 2, 1]);
    expect(index.fret, 1);
    expect(guide.muted, isEmpty);
    expect(guide.open, isEmpty);
    expect(guide.isOpenPosition, isFalse);
    expect(guide.firstFret, 1);
    expect(guide.lastFret, 3);
  });

  test('sin cuerdas pisadas no hay pasos', () {
    final PositionGuide guide = PositionGuide.of(
      _variant(const <int>[0, 0, 0, 0, 0, 0], const <int>[0, 0, 0, 0, 0, 0]),
    );
    expect(guide.steps, isEmpty);
    expect(guide.firstFret, 0);
    expect(guide.played.length, 6);
  });
}
