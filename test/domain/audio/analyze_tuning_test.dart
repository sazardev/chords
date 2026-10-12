import 'dart:math' as math;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/domain/audio/services/tuning_smoother.dart';
import 'package:chords/domain/audio/usecases/analyze_tuning_use_case.dart';
import 'package:test/test.dart';

/// Frecuencia desviada [cents] respecto a [reference].
double _detuned(double reference, double cents) =>
    reference * math.pow(2, cents / 1200);

GuitarString _string(int number) => standardStringByNumber(number)!;

/// Tests del análisis de afinación por cuerda.
void main() {
  const AnalyzeTuningUseCase analyze = AnalyzeTuningUseCase();

  group('AnalyzeTuningUseCase (automático)', () {
    test('identifica cada cuerda al aire como afinada', () {
      for (final GuitarString string in kStandardTuning) {
        final StringTuningReading? reading = analyze(string.frequency);
        expect(reading?.string, string, reason: string.label);
        expect(reading?.zone, TuningZone.inTune);
        expect(reading?.direction, TuneDirection.none);
      }
    });

    test('una cuerda floja pide subir y una alta pide bajar', () {
      final StringTuningReading flat = analyze(
        _detuned(_string(3).frequency, -30),
      )!;
      expect(flat.string.number, 3);
      expect(flat.cents, closeTo(-30, 0.01));
      expect(flat.direction, TuneDirection.up);
      expect(flat.zone, TuningZone.off);

      final StringTuningReading sharp = analyze(
        _detuned(_string(2).frequency, 12),
      )!;
      expect(sharp.string.number, 2);
      expect(sharp.direction, TuneDirection.down);
      expect(sharp.zone, TuningZone.near);
    });

    test('sigue reconociendo una cuerda muy floja (más de medio tono)', () {
      final StringTuningReading reading = analyze(
        _detuned(_string(5).frequency, -140),
      )!;
      expect(reading.string.number, 5);
      expect(reading.zone, TuningZone.far);
      expect(reading.direction, TuneDirection.up);
    });

    test('tolera el error de octava del detector en las cuerdas graves', () {
      final StringTuningReading reading = analyze(_string(6).frequency * 2)!;
      expect(reading.string.number, 6);
      expect(reading.cents.abs(), lessThan(1));
    });

    test('rechaza frecuencias inválidas', () {
      expect(analyze(0), isNull);
      expect(analyze(double.nan), isNull);
    });
  });

  group('AnalyzeTuningUseCase (manual)', () {
    test('mide contra la cuerda elegida', () {
      final StringTuningReading reading = analyze(
        _detuned(_string(4).frequency, -25),
        target: _string(4),
      )!;
      expect(reading.string.number, 4);
      expect(reading.cents, closeTo(-25, 0.01));
    });

    test('devuelve null si suena otra cuerda lejana', () {
      expect(analyze(_string(1).frequency, target: _string(6)), isNull);
      expect(analyze(_string(1).frequency, target: _string(4)), isNull);
    });
  });

  group('TuningSmoother', () {
    StringTuningReading reading(int string, double cents) =>
        StringTuningReading(
          string: _string(string),
          frequency: _string(string).frequency,
          cents: cents,
        );

    test('usa la mediana y descarta valores extremos', () {
      final TuningSmoother smoother = TuningSmoother()
        ..add(reading(3, -10))
        ..add(reading(3, -12));
      final StringTuningReading smoothed = smoother.add(reading(3, 45));
      expect(smoothed.cents, -10);
    });

    test('empieza de cero al cambiar de cuerda', () {
      final TuningSmoother smoother = TuningSmoother()..add(reading(3, -40));
      final StringTuningReading other = smoother.add(reading(2, 5));
      expect(other.cents, 5);
    });
  });
}
