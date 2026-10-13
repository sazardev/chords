import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/guitar_nav_slot.dart';
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

  group('notas agudas y menú', () {
    PitchReading at(String note, double hz) =>
        PitchReading(frequency: hz, note: note, cents: 0, clarity: 0.9);

    GuitarNote? feedThree(
      GuitarCommandDetector detector,
      PitchReading reading,
      DateTime now,
    ) {
      GuitarNote? result;
      for (int i = 0; i < 3; i++) {
        result = detector.feedNote(reading, now) ?? result;
      }
      return result;
    }

    test('el traste 12 de la 1ª cuerda aún no es una nota aguda', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime now = t0.add(const Duration(seconds: 1));
      final GuitarNote? note = feedThree(detector, at('E', 659), now);
      expect(note?.pitchClass, 4);
      expect(note?.high, isFalse);
    });

    test('a partir del traste 14 la nota es aguda', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime now = t0.add(const Duration(seconds: 1));
      final GuitarNote? note = feedThree(detector, at('F#', 740), now);
      expect(note?.pitchClass, 6);
      expect(note?.high, isTrue);
    });

    test('una nota aguda nunca es una orden de la pantalla', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime now = t0.add(const Duration(seconds: 1));
      GuitarCommand? command;
      for (int i = 0; i < 3; i++) {
        command = detector.feed(at('A', 880), now, all) ?? command;
      }
      expect(command, isNull);
    });

    test('la misma clase en octava normal tras la aguda sí cuenta', () {
      final GuitarCommandDetector detector = GuitarCommandDetector()..arm(t0);
      final DateTime now = t0.add(const Duration(seconds: 1));
      expect(feedThree(detector, at('G', 784), now)?.high, isTrue);
      final GuitarNote? low = feedThree(detector, at('G', 196), now);
      expect(low?.pitchClass, 7);
      expect(low?.high, isFalse);
    });

    test('las opciones del menú siguen el mástil desde el Mi al aire', () {
      expect(GuitarNavSlot.home.fretFromE, 0);
      expect(GuitarNavSlot.learn.fretFromE, 1);
      expect(GuitarNavSlot.back.fretFromE, 7);
      expect(GuitarNavSlot.off.fretFromE, 9);
      expect(GuitarNavSlot.ofPitchClass(7), GuitarNavSlot.game);
      expect(GuitarNavSlot.ofPitchClass(2), isNull);
      final Set<int> classes = <int>{
        for (final GuitarNavSlot slot in GuitarNavSlot.values) slot.pitchClass,
      };
      expect(classes.length, GuitarNavSlot.values.length);
    });
  });
}
