import 'dart:math' as math;

import 'package:chords/domain/band/clock/swing_grid.dart';
import 'package:chords/domain/band/clock/tick.dart';
import 'package:chords/domain/band/clock/tick_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_timers.dart';

/// El planificador de semicorcheas: plazos absolutos, swing y tempo en marcha.
void main() {
  late ManualClock clock;
  late FakeTimers timers;
  late List<Tick> ticks;
  late TickScheduler scheduler;

  setUp(() {
    clock = ManualClock();
    timers = FakeTimers(clock);
    ticks = <Tick>[];
    scheduler = TickScheduler(
      onTick: ticks.add,
      clock: clock,
      timerFactory: timers.create,
    );
  });

  // A 120 BPM una semicorchea dura 125 ms.
  const int step = 125000;

  test(
    'el n-ésimo golpe cae en n·intervalo exacto aunque el aviso llegue tarde',
    () {
      scheduler.start(bpm: 120);
      final math.Random random = math.Random(3);
      for (int i = 0; i < 400; i++) {
        timers.fireNext(lateness: Duration(milliseconds: random.nextInt(35)));
      }
      expect(ticks.length, greaterThanOrEqualTo(400));
      for (final Tick tick in ticks) {
        expect(
          tick.scheduledAt.inMicroseconds,
          tick.index * step,
          reason: 'tick ${tick.index}',
        );
        expect(tick.lateness, lessThan(const Duration(milliseconds: 35)));
      }
    },
  );

  test(
    'no acumula deriva: el golpe 1000 sigue en su sitio tras mil retrasos',
    () {
      scheduler.start(bpm: 93);
      final math.Random random = math.Random(8);
      while (ticks.length < 1001) {
        timers.fireNext(
          lateness: Duration(microseconds: random.nextInt(20000)),
        );
      }
      // 60 s / (93·4) = 161290,32 µs: el cálculo no redondea paso a paso.
      expect(
        ticks[1000].scheduledAt.inMicroseconds,
        (1000 * 15000000 / 93).floor(),
      );
    },
  );

  test('cada aviso se arma contra el siguiente plazo absoluto', () {
    scheduler.start(bpm: 120);
    timers.fireNext(lateness: const Duration(milliseconds: 30));
    // El primer aviso llegó con 30 ms de retraso: el siguiente espera solo lo
    // que falta para el plazo de 125 ms, no un intervalo entero.
    expect(timers.requested.last, const Duration(milliseconds: 95));
    timers.fireNext();
    expect(timers.requested.last, const Duration(milliseconds: 125));
  });

  test('si el sistema se atrasa dos golpes, los entrega con su retraso', () {
    scheduler.start(bpm: 120);
    timers.fireNext();
    clock.now = const Duration(milliseconds: 300);
    timers.fireNext();
    final List<Tick> late = ticks.where((Tick t) => t.index > 0).toList();
    expect(late.map((Tick t) => t.index), <int>[1, 2]);
    expect(late.first.lateness, const Duration(milliseconds: 175));
    expect(late.first.isStale(const Duration(milliseconds: 90)), isTrue);
    expect(late.last.isStale(const Duration(milliseconds: 90)), isFalse);
  });

  test('tras una parada larga se reancla en vez de disparar un chaparrón', () {
    scheduler.start(bpm: 120);
    timers.fireNext();
    clock.now = const Duration(seconds: 5);
    timers.fireNext();
    expect(ticks.length, 2, reason: 'solo el golpe 0 y uno al volver');
    expect(ticks.last.lateness, Duration.zero);
    timers.fireNext();
    expect(
      ticks.last.scheduledAt - ticks[1].scheduledAt,
      const Duration(microseconds: step),
    );
  });

  group('swing', () {
    test('de corcheas: la segunda corchea se retrasa 2/3 de semicorchea', () {
      scheduler.start(bpm: 120, swing: 1);
      const Duration beat = Duration(microseconds: 4 * step);
      expect(scheduler.scheduledAt(0), Duration.zero);
      expect(scheduler.scheduledAt(1), const Duration(microseconds: step));
      // Con swing completo la corchea cae a 2/3 del pulso (tresillo).
      expect(
        scheduler.scheduledAt(2).inMicroseconds,
        closeTo(beat.inMicroseconds * 2 / 3, 1),
      );
      expect(scheduler.scheduledAt(4), beat);
    });

    test('con swing 0 todo cae en la rejilla recta', () {
      scheduler.start(bpm: 120);
      for (int i = 0; i < 16; i++) {
        expect(scheduler.scheduledAt(i).inMicroseconds, i * step);
      }
    });

    test('con medio swing la corchea se retrasa la mitad', () {
      scheduler.start(bpm: 120, swing: 0.5);
      const int straight = 2 * step;
      final int full = (4 * step * 2 / 3).round();
      expect(
        scheduler.scheduledAt(2).inMicroseconds,
        closeTo((straight + full) / 2, 1),
      );
    });

    test('de semicorchas: solo se retrasan las impares', () {
      scheduler.start(bpm: 120, swing: 1, grid: SwingGrid.sixteenth);
      expect(scheduler.scheduledAt(0), Duration.zero);
      expect(scheduler.scheduledAt(2).inMicroseconds, 2 * step);
      expect(
        scheduler.scheduledAt(1).inMicroseconds,
        closeTo(step + step / 3, 1),
      );
      expect(
        scheduler.scheduledAt(3).inMicroseconds,
        closeTo(3 * step + step / 3, 1),
      );
    });

    test('el swing nunca invierte el orden de los golpes', () {
      for (final SwingGrid grid in SwingGrid.values) {
        scheduler.start(bpm: 200, swing: 1, grid: grid);
        for (int i = 1; i < 64; i++) {
          expect(
            scheduler.scheduledAt(i),
            greaterThan(scheduler.scheduledAt(i - 1)),
            reason: '$grid $i',
          );
        }
      }
    });

    test('los avisos llegan en el instante con swing', () {
      scheduler.start(bpm: 120, swing: 1);
      for (int i = 0; i < 8; i++) {
        timers.fireNext();
      }
      expect(ticks.map((Tick t) => t.scheduledAt), <Duration>[
        for (int i = 0; i < 8; i++) scheduler.scheduledAt(i),
      ]);
      expect(ticks[2].scheduledAt.inMicroseconds, isNot(2 * step));
    });
  });

  group('tempo en marcha', () {
    test('cambia sin saltos: el próximo golpe conserva su hora', () {
      scheduler.start(bpm: 120);
      for (int i = 0; i < 4; i++) {
        timers.fireNext();
      }
      final Duration next = scheduler.scheduledAt(scheduler.nextIndex);
      scheduler.setBpm(60);
      expect(scheduler.scheduledAt(scheduler.nextIndex), next);
      expect(
        scheduler.scheduledAt(scheduler.nextIndex + 1) -
            scheduler.scheduledAt(scheduler.nextIndex),
        const Duration(microseconds: 2 * step),
      );
    });

    test('los golpes siguientes usan el intervalo nuevo y no retroceden', () {
      scheduler.start(bpm: 120);
      for (int i = 0; i < 6; i++) {
        timers.fireNext();
      }
      scheduler.setBpm(180);
      for (int i = 0; i < 8; i++) {
        timers.fireNext();
      }
      for (int i = 1; i < ticks.length; i++) {
        expect(ticks[i].scheduledAt, greaterThan(ticks[i - 1].scheduledAt));
      }
      const int fast = 15000000 ~/ 180;
      expect(
        ticks.last.scheduledAt - ticks[ticks.length - 2].scheduledAt,
        const Duration(microseconds: fast),
      );
    });

    test('un cambio al mismo tempo no hace nada', () {
      scheduler.start(bpm: 120);
      final int created = timers.created.length;
      scheduler.setBpm(120);
      expect(timers.created.length, created);
    });
  });

  test('el adelanto avisa antes del golpe sin cambiar su instante', () {
    scheduler
      ..lead = const Duration(milliseconds: 10)
      ..start(bpm: 120, delay: const Duration(milliseconds: 100));
    expect(timers.requested.last, const Duration(milliseconds: 90));
    timers.fireNext();
    expect(ticks.single.scheduledAt, const Duration(milliseconds: 100));
    expect(clock.now, const Duration(milliseconds: 90));
  });

  test('pausa y reanuda sin perder el hueco que faltaba', () {
    scheduler.start(bpm: 120);
    timers
      ..fireNext()
      ..fireNext();
    clock.now = const Duration(milliseconds: 230);
    scheduler.pause();
    expect(scheduler.isRunning, isFalse);
    expect(timers.active, isNull);
    clock.now = const Duration(seconds: 10);
    scheduler.resume();
    expect(scheduler.isRunning, isTrue);
    // Faltaban 20 ms (hasta 250) y siguen faltando tras reanudar.
    expect(timers.requested.last, const Duration(milliseconds: 20));
    timers.fireNext();
    expect(ticks.last.index, 2);
  });

  test('parar cancela el aviso y empezar de nuevo reinicia la cuenta', () {
    scheduler.start(bpm: 120);
    timers.fireNext();
    scheduler.stop();
    expect(timers.active, isNull);
    expect(scheduler.isRunning, isFalse);
    ticks.clear();
    clock.now = const Duration(seconds: 3);
    scheduler.start(bpm: 90);
    timers.fireNext();
    expect(ticks.single.index, 0);
    expect(ticks.single.scheduledAt, const Duration(seconds: 3));
  });

  test('si el aviso para el planificador, no sigue disparando', () {
    scheduler = TickScheduler(
      onTick: (Tick t) {
        ticks.add(t);
        if (ticks.length == 2) {
          scheduler.stop();
        }
      },
      clock: clock,
      timerFactory: timers.create,
    )..start(bpm: 120);
    clock.now = const Duration(seconds: 1);
    timers.fireNext();
    expect(ticks.length, 2);
    expect(timers.active, isNull);
  });
}
