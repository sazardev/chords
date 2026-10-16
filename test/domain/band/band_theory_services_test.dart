import 'package:chords/domain/band/services/bass_line.dart';
import 'package:chords/domain/band/services/chord_voicing.dart';
import 'package:chords/domain/jam/jam_timeline.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:flutter_test/flutter_test.dart';

/// Notas de cada instrumento a partir de la cifra, y la línea de tiempo.
void main() {
  const ChordVoicing voicing = ChordVoicing();
  const BassLine line = BassLine();
  ChordSymbol chord(String name) => ChordSymbol.parse(name);

  group('ChordVoicing', () {
    test('la guitarra toca la forma abierta de Do', () {
      expect(voicing.guitar(chord('C')), <int>[48, 55, 60, 64, 67]);
      expect(voicing.guitar(chord('Am')), <int>[45, 52, 57, 60, 64]);
      expect(voicing.guitar(chord('Cmaj7')), <int>[48, 55, 60, 64, 71]);
      expect(voicing.power(chord('E')), <int>[40, 47, 52]);
    });

    test('toda cifra cabe en el registro de cada instrumento', () {
      for (int root = 0; root < 12; root++) {
        for (final String suffix in <String>[
          '',
          'm',
          '7',
          'm7',
          'maj7',
          'sus4',
          'sus2',
          '5',
          '6',
          'm6',
          'dim',
          'aug',
          '9',
        ]) {
          final ChordSymbol c = ChordSymbol(
            root,
            ChordSymbol.parse('C$suffix').quality,
          );
          final List<int> guitar = voicing.guitar(c);
          expect(guitar.first, inInclusiveRange(40, 51), reason: c.name);
          expect(guitar.last, lessThanOrEqualTo(84), reason: c.name);
          expect(guitar.first % 12, root, reason: 'raíz en el bajo');
          final List<int> keys = voicing.keys(c);
          expect(keys.first, inInclusiveRange(53, 64), reason: c.name);
          expect(keys.last, lessThanOrEqualTo(77), reason: c.name);
          expect(keys.first % 12, root);
          final List<int> winds = voicing.winds(c);
          expect(winds.first, inInclusiveRange(60, 71));
          expect(
            keys,
            <int>[...keys]..sort(),
            reason: 'el acorde va de grave a agudo',
          );
          expect(voicing.bassRoot(root), inInclusiveRange(28, 39));
          expect(voicing.bassRoot(root) % 12, root);
        }
      }
    });
  });

  group('BassLine', () {
    test('cada letra da su nota sobre el acorde', () {
      final ChordSymbol c = chord('Am7');
      final ChordSymbol next = chord('D7');
      const int root = 33;
      expect(line.noteFor('R', c, next), root);
      expect(line.noteFor('r', c, next), root);
      expect(line.noteFor('5', c, next), root + 7);
      expect(line.noteFor('O', c, next), root + 12);
      expect(line.noteFor('3', c, next), root + 3, reason: 'tercera menor');
      expect(line.noteFor('7', c, next), root + 10);
      expect(line.noteFor('6', c, next), root + 9);
      expect(line.noteFor('F', c, next), root - 5);
      expect(line.noteFor('-', c, next), isNull);
      expect(line.noteFor('.', c, next), isNull);
      expect(line.noteFor('W', c, next), isNull);
    });

    test('la tercera y la séptima respetan la calidad', () {
      expect(line.noteFor('3', chord('C'), chord('C')), 36 + 4);
      expect(line.noteFor('3', chord('Csus4'), chord('C')), 36 + 5);
      expect(line.noteFor('7', chord('Cmaj7'), chord('C')), 36 + 11);
      expect(line.noteFor('5', chord('Cdim'), chord('C')), 36 + 6);
      expect(line.noteFor('5', chord('Caug'), chord('C')), 36 + 8);
    });

    test('la aproximación llega a un semitono de la raíz siguiente', () {
      for (int root = 0; root < 12; root++) {
        final ChordSymbol from = ChordSymbol(root, chord('C').quality);
        final ChordSymbol to = from.transpose(5);
        final int approach = line.noteFor('a', from, to)!;
        final int target = voicing.bassRoot(to.root);
        expect((approach - target).abs(), 1, reason: 'de ${from.name}');
      }
      // Si el acorde no cambia, se apoya en la quinta.
      expect(line.noteFor('a', chord('C'), chord('C')), 36 + 7);
    });

    test('el bajo caminante empieza en la raíz y no da saltos grandes', () {
      for (int root = 0; root < 12; root++) {
        final ChordSymbol c = ChordSymbol(root, chord('C7').quality);
        final ChordSymbol next = c.transpose(5);
        int? previous;
        for (int beat = 0; beat < 4; beat++) {
          final int note = line.walking(beat, 0, c, next, previous: previous);
          expect(note, inInclusiveRange(28, 54));
          if (beat == 0) {
            expect(note % 12, root);
          }
          if (previous != null) {
            expect((note - previous).abs(), lessThanOrEqualTo(9));
          }
          previous = note;
        }
      }
    });
  });

  group('JamTimeline', () {
    test('primero la cuenta atrás y luego los compases de la pista', () {
      const JamTimeline timeline = JamTimeline(
        stepsPerBar: 16,
        bars: 2,
        countInBars: 1,
      );
      expect(timeline.countInSteps, 16);
      expect(timeline.totalSteps, 48);
      expect(
        timeline.cursorAt(0),
        const JamCursor(CursorKind.countIn, countdown: 4),
      );
      expect(
        timeline.cursorAt(5),
        const JamCursor(CursorKind.countIn, step: 5, countdown: 3),
      );
      expect(
        timeline.cursorAt(15),
        const JamCursor(CursorKind.countIn, step: 15, countdown: 1),
      );
      expect(timeline.cursorAt(16), const JamCursor(CursorKind.playing));
      expect(
        timeline.cursorAt(33),
        const JamCursor(CursorKind.playing, bar: 1, step: 1),
      );
      expect(timeline.cursorAt(48).kind, CursorKind.finished);
    });

    test('sin cuenta atrás se toca desde el primer paso; 3/4 usa 12 pasos', () {
      const JamTimeline none = JamTimeline(
        stepsPerBar: 12,
        bars: 3,
        countInBars: 0,
      );
      expect(none.cursorAt(0), const JamCursor(CursorKind.playing));
      expect(none.cursorAt(12), const JamCursor(CursorKind.playing, bar: 1));
      expect(none.cursorAt(36).kind, CursorKind.finished);
      const JamTimeline two = JamTimeline(
        stepsPerBar: 12,
        bars: 1,
        countInBars: 2,
      );
      expect(two.cursorAt(0).countdown, 6);
      expect(two.cursorAt(12).countdown, 3);
      expect(two.cursorAt(24).kind, CursorKind.playing);
    });
  });
}
