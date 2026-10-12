import 'package:chords/domain/audio/services/note_onset_gate.dart';
import 'package:test/test.dart';

/// Tests de la puerta de notas pulsadas.
void main() {
  test('dispara tras varias lecturas estables y no repite mientras suena', () {
    final NoteOnsetGate gate = NoteOnsetGate();
    expect(gate.feed(110), isNull);
    expect(gate.feed(110.2), isNull);
    expect(gate.feed(109.9), closeTo(109.9, 0.001));
    expect(gate.feed(110), isNull);
    expect(gate.feed(110.1), isNull);
  });

  test('ignora un ataque inestable', () {
    final NoteOnsetGate gate = NoteOnsetGate();
    expect(gate.feed(300), isNull);
    expect(gate.feed(150), isNull);
    expect(gate.feed(110), isNull);
    expect(gate.feed(110), isNull);
    expect(gate.feed(110), 110);
  });

  test('una nota distinta o el reset la rearman', () {
    final NoteOnsetGate gate = NoteOnsetGate()
      ..feed(110)
      ..feed(110)
      ..feed(110);
    expect(gate.feed(146.8), isNull);
    expect(gate.feed(146.8), isNull);
    expect(gate.feed(146.8), 146.8);
    gate.reset();
    expect(gate.feed(146.8), isNull);
    expect(gate.feed(146.8), isNull);
    expect(gate.feed(146.8), 146.8);
  });
}
