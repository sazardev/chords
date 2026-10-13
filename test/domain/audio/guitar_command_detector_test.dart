import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/services/guitar_command_detector.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests del detector de órdenes de guitarra.
void main() {
  final DateTime t0 = DateTime(2026);
  const Set<GuitarCommand> all = <GuitarCommand>{
    GuitarCommand.next,
    GuitarCommand.retry,
    GuitarCommand.listen,
  };

  PitchReading reading(String note, {double clarity = 0.9}) =>
      PitchReading(frequency: 100, note: note, cents: 0, clarity: clarity);

  /// Toca [note] [times] veces seguidas en el instante [at].
  GuitarCommand? play(
    GuitarCommandDetector detector,
    String note,
    DateTime at, {
    int times = 3,
    Set<GuitarCommand> enabled = all,
  }) {
    GuitarCommand? result;
    for (int i = 0; i < times; i++) {
      result = detector.feed(reading(note), at, enabled) ?? result;
    }
    return result;
  }

  group('GuitarCommand', () {
    test('cada comando tiene su cuerda y nota distintas', () {
      expect(GuitarCommand.next.note, 'E');
      expect(GuitarCommand.retry.note, 'A');
      expect(GuitarCommand.listen.note, 'D');
      expect(GuitarCommand.skip.note, 'G');
      expect(GuitarCommand.exit.note, 'B');
      final Set<int> classes = <int>{
        for (final GuitarCommand c in GuitarCommand.values) c.pitchClass,
      };
      expect(classes.length, GuitarCommand.values.length);
    });

    test('se resuelve por clase de tono', () {
      expect(GuitarCommand.ofPitchClass(4), GuitarCommand.next);
      expect(GuitarCommand.ofPitchClass(1), isNull);
    });
  });

  group('GuitarCommandDetector', () {
    test('no acepta nada antes del silencio previo', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      expect(detector.isArmed, isFalse);
      expect(play(detector, 'E2', t0), isNull);
    });

    test('se arma tras el silencio y dispara con una nota firme', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime later = t0.add(const Duration(milliseconds: 600));
      detector.poll(later);
      expect(detector.isArmed, isTrue);
      expect(play(detector, 'E2', later), GuitarCommand.next);
    });

    test('un sonido durante la espera retrasa el armado', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()
        ..arm(t0)
        ..feed(reading('E2'), t0.add(const Duration(milliseconds: 400)), all)
        ..poll(t0.add(const Duration(milliseconds: 800)));
      expect(detector.isArmed, isFalse);
      detector.poll(t0.add(const Duration(milliseconds: 1000)));
      expect(detector.isArmed, isTrue);
    });

    test('exige varias lecturas seguidas de la misma nota', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime at = t0.add(const Duration(seconds: 1));
      expect(play(detector, 'E2', at, times: 2), isNull);
      expect(play(detector, 'A2', at, times: 1), isNull);
      expect(play(detector, 'E2', at, times: 2), isNull);
      expect(play(detector, 'E2', at, times: 1), GuitarCommand.next);
    });

    test('ignora lecturas poco fiables', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime at = t0.add(const Duration(seconds: 1));
      for (int i = 0; i < 5; i++) {
        expect(detector.feed(reading('E2', clarity: 0.3), at, all), isNull);
      }
    });

    test('no repite la orden mientras la nota sigue sonando', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime at = t0.add(const Duration(seconds: 1));
      expect(play(detector, 'E2', at), GuitarCommand.next);
      expect(
        play(detector, 'E3', at.add(const Duration(milliseconds: 100))),
        isNull,
      );
    });

    test('tras un silencio la misma nota vuelve a valer', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime at = t0.add(const Duration(seconds: 1));
      expect(play(detector, 'E2', at), GuitarCommand.next);
      final DateTime again = at.add(const Duration(seconds: 1));
      expect(play(detector, 'E2', again), GuitarCommand.next);
    });

    test('solo dispara las órdenes habilitadas', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime at = t0.add(const Duration(seconds: 1));
      expect(
        play(
          detector,
          'G3',
          at,
          enabled: const <GuitarCommand>{GuitarCommand.next},
        ),
        isNull,
      );
      expect(play(detector, 'E2', at), GuitarCommand.next);
    });

    test('da igual la octava: la 1ª cuerda también vale como Mi', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime at = t0.add(const Duration(seconds: 1));
      expect(play(detector, 'E4', at), GuitarCommand.next);
    });

    test('desarmado no hace caso de nada', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()
        ..arm(t0)
        ..disarm();
      final DateTime at = t0.add(const Duration(seconds: 2));
      detector.poll(at);
      expect(detector.isArmed, isFalse);
      expect(play(detector, 'E2', at), isNull);
    });
  });
}
