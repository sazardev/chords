import 'dart:math' as math;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/chords/entities/chord_practice_session.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:test/test.dart';

/// Frecuencia de la cuerda [number] pulsada en el traste [fret].
double _note(int number, int fret, {double cents = 0}) =>
    standardStringByNumber(number)!.frequency *
    math.pow(2, (fret * 100 + cents) / 1200);

/// Do mayor abierto: x32010 (de la sexta a la primera).
ChordPracticeSession _cMajor() => ChordPracticeSession(
  frets: const <int>[-1, 3, 2, 0, 1, 0],
  fingers: const <int>[0, 3, 2, 0, 1, 0],
);

/// Tests de la sesión de práctica de acordes cuerda a cuerda.
void main() {
  test('la sexta muda no cuenta y la quinta es la primera en foco', () {
    final ChordPracticeSession session = _cMajor();
    expect(session.total, 5);
    expect(session.strings.first.isMuted, isTrue);
    expect(session.focus?.number, 5);
    expect(session.isComplete, isFalse);
  });

  test('reconoce cada cuerda en cualquier orden y completa el acorde', () {
    final ChordPracticeSession session = _cMajor();
    expect(session.feed(_note(1, 0)), PracticeFeedResult.matched);
    expect(session.lastMatched, 1);
    expect(session.feed(_note(5, 3)), PracticeFeedResult.matched);
    expect(session.feed(_note(4, 2)), PracticeFeedResult.matched);
    expect(session.feed(_note(3, 0)), PracticeFeedResult.matched);
    expect(session.feed(_note(2, 1)), PracticeFeedResult.matched);
    expect(session.isComplete, isTrue);
    expect(session.feed(_note(5, 3)), PracticeFeedResult.ignored);
  });

  test('repetir una cuerda ya reconocida no cambia nada', () {
    final ChordPracticeSession session = _cMajor()..feed(_note(5, 3));
    expect(session.feed(_note(5, 3)), PracticeFeedResult.ignored);
    expect(session.matchedCount, 1);
  });

  test('cuerda al aire cuando debía ir pulsada: suena al aire', () {
    final ChordPracticeSession session = _cMajor();
    expect(session.feed(_note(5, 0)), PracticeFeedResult.tip);
    expect(session.tip?.kind, PracticeTipKind.soundsOpen);
    expect(session.tip?.stringNumber, 5);
    expect(session.tip?.finger, 3);
  });

  test('un traste de menos pide subir el dedo; de más, bajarlo', () {
    final ChordPracticeSession low = _cMajor()..feed(_note(5, 2));
    expect(low.tip?.kind, PracticeTipKind.moveUp);
    expect(low.tip?.steps, 1);

    final ChordPracticeSession high = _cMajor()..feed(_note(5, 5));
    expect(high.tip?.kind, PracticeTipKind.moveDown);
    expect(high.tip?.steps, 2);
  });

  test('pulsada y algo floja o alta: consejo fino', () {
    final ChordPracticeSession flat = _cMajor()..feed(_note(5, 3, cents: -45));
    expect(flat.tip?.kind, PracticeTipKind.tooFlat);

    final ChordPracticeSession sharp = _cMajor()..feed(_note(5, 3, cents: 45));
    expect(sharp.tip?.kind, PracticeTipKind.tooSharp);
  });

  test('al aire desafinada pide reafinar en el sentido correcto', () {
    final ChordPracticeSession session = ChordPracticeSession(
      frets: const <int>[0, 0, 0, 0, 0, 0],
      fingers: const <int>[0, 0, 0, 0, 0, 0],
    )..feed(_note(6, 0, cents: -40));
    expect(session.tip?.kind, PracticeTipKind.retuneUp);
    session.feed(_note(6, 0, cents: 40));
    expect(session.tip?.kind, PracticeTipKind.retuneDown);
  });

  test('tolera el margen de un dedo real sin dar consejo', () {
    final ChordPracticeSession session = _cMajor();
    expect(session.feed(_note(5, 3, cents: -25)), PracticeFeedResult.matched);
  });

  test('un error de octava del detector no bloquea la cuerda grave', () {
    final ChordPracticeSession session = ChordPracticeSession(
      frets: const <int>[0, -1, -1, -1, -1, -1],
      fingers: const <int>[0, 0, 0, 0, 0, 0],
    );
    expect(session.feed(_note(6, 0) * 2), PracticeFeedResult.matched);
  });

  test('una nota sin relación da el consejo desconocido y reset limpia', () {
    final ChordPracticeSession session = _cMajor()
      ..feed(_note(5, 3))
      ..feed(_note(1, 7));
    expect(session.tip?.kind, PracticeTipKind.unknown);
    session.reset();
    expect(session.matchedCount, 0);
    expect(session.tip, isNull);
    expect(session.focus?.number, 5);
  });
}
