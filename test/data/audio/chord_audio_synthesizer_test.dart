import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:test/test.dart';

import '../../support/pitch_probe.dart';

/// Tests del sintetizador Karplus-Strong de acordes.
void main() {
  /// Construye una posición de prueba.
  ChordVariant variantOf(List<int> frets) => ChordVariant(
    id: 'test',
    positionLabel: 'Prueba',
    frets: frets,
    fingers: const <int>[0, 0, 0, 0, 0, 0],
    difficulty: Difficulty.medium,
  );

  group('ChordAudioSynthesizer', () {
    test('genera audio no silencioso y acotado', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      final Float64List samples = synthesizer.synthesize(
        variantOf(const <int>[-1, 3, 5, 5, 5, 3]),
        duration: 0.5,
      );

      expect(samples.length, synthesizer.sampleRate ~/ 2);
      double peak = 0;
      for (final double value in samples) {
        expect(value.abs() <= 1.0, isTrue);
        if (value.abs() > peak) {
          peak = value.abs();
        }
      }
      expect(peak, greaterThan(0.1));
    });

    test('cada nota del mástil suena afinada a menos de 1,5 cents', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      const PitchProbe probe = PitchProbe(44100);
      for (int midi = 40; midi <= 88; midi++) {
        final double expected = ChordAudioSynthesizer.midiToFrequency(midi);
        final double measured = probe.frequency(
          synthesizer.synthesizeNote(expected),
          expected,
        );
        expect(
          PitchProbe.cents(measured, expected).abs(),
          lessThan(1.5),
          reason: 'MIDI $midi (${expected.toStringAsFixed(1)} Hz)',
        );
      }
    });

    test('una cuerda al aire suena más grave que un traste alto', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      const PitchProbe probe = PitchProbe(44100);
      final double low = probe.frequency(
        synthesizer.synthesize(
          variantOf(const <int>[0, -1, -1, -1, -1, -1]),
          duration: 1,
        ),
        82.41,
      );
      final double high = probe.frequency(
        synthesizer.synthesize(
          variantOf(const <int>[12, -1, -1, -1, -1, -1]),
          duration: 1,
        ),
        164.81,
      );
      expect(high / low, closeTo(2, 0.01));
    });

    test('un acorde suena con todas sus cuerdas y sin notas ajenas', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      // Do mayor abierto: x 3 2 0 1 0 → C3 E3 G3 C4 E4.
      final Float64List samples = synthesizer.synthesize(
        variantOf(const <int>[-1, 3, 2, 0, 1, 0]),
      );
      double power(double frequency) =>
          _goertzel(samples, 44100, frequency, 4410, 22050);
      final double weakestChordTone = <double>[
        130.81,
        164.81,
        196,
        261.63,
        329.63,
      ].map(power).reduce((double a, double b) => a < b ? a : b);
      // Notas que no son de Do mayor: Re, Fa, La, Si.
      for (final double foreign in <double>[146.83, 174.61, 220, 246.94]) {
        expect(
          weakestChordTone,
          greaterThan(power(foreign) * 8),
          reason: 'no debería sonar ${foreign.toStringAsFixed(1)} Hz',
        );
      }
    });

    test('nota y acorde suenan al mismo volumen y no se recortan', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      final Float64List note = synthesizer.synthesizeNote(196);
      final Float64List chord = synthesizer.synthesize(
        variantOf(const <int>[3, 2, 0, 0, 0, 3]),
      );
      final double noteRms = _rms(note, 44100);
      final double chordRms = _rms(chord, 44100);
      expect((noteRms / chordRms).abs(), inInclusiveRange(0.7, 1.4));
      for (final Float64List sound in <Float64List>[note, chord]) {
        expect(
          sound.reduce((double a, double b) => a.abs() > b.abs() ? a : b).abs(),
          lessThanOrEqualTo(0.93),
        );
      }
    });

    test('empieza y acaba sin clics', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      final Float64List chord = synthesizer.synthesize(
        variantOf(const <int>[-1, 3, 2, 0, 1, 0]),
      );
      expect(chord.first.abs(), lessThan(0.01));
      expect(chord.last.abs(), lessThan(0.001));
    });

    test('convierte notas MIDI a frecuencias correctas', () {
      expect(ChordAudioSynthesizer.midiToFrequency(69), closeTo(440, 0.01));
      expect(ChordAudioSynthesizer.midiToFrequency(81), closeTo(880, 0.01));
      expect(ChordAudioSynthesizer.midiToFrequency(40), closeTo(82.41, 0.1));
    });
  });
}

/// Potencia de [samples] a [frequency] (algoritmo de Goertzel) entre
/// [start] y [end].
double _goertzel(
  Float64List samples,
  int sampleRate,
  double frequency,
  int start,
  int end,
) {
  final double coefficient = 2 * math.cos(2 * math.pi * frequency / sampleRate);
  double previous = 0;
  double beforePrevious = 0;
  for (int i = start; i < end && i < samples.length; i++) {
    final double value = samples[i] + coefficient * previous - beforePrevious;
    beforePrevious = previous;
    previous = value;
  }
  return previous * previous +
      beforePrevious * beforePrevious -
      coefficient * previous * beforePrevious;
}

/// Nivel RMS de las primeras [count] muestras.
double _rms(Float64List samples, int count) {
  double energy = 0;
  for (int i = 0; i < count; i++) {
    energy += samples[i] * samples[i];
  }
  return math.sqrt(energy / count);
}
