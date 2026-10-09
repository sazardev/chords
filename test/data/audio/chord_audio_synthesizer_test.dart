import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:test/test.dart';

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

    test('una cuerda al aire suena más grave que un traste alto', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      final Float64List low = synthesizer.synthesize(
        variantOf(const <int>[0, -1, -1, -1, -1, -1]),
        duration: 1,
      );
      final Float64List high = synthesizer.synthesize(
        variantOf(const <int>[12, -1, -1, -1, -1, -1]),
        duration: 1,
      );
      final int lowCrossings = _zeroCrossings(low, 6000);
      final int highCrossings = _zeroCrossings(high, 6000);
      expect(highCrossings, greaterThan(lowCrossings * 3 ~/ 2));
    });

    test('convierte notas MIDI a frecuencias correctas', () {
      expect(ChordAudioSynthesizer.midiToFrequency(69), closeTo(440, 0.01));
      expect(ChordAudioSynthesizer.midiToFrequency(81), closeTo(880, 0.01));
      expect(ChordAudioSynthesizer.midiToFrequency(40), closeTo(82.41, 0.1));
    });
  });
}

/// Cuenta cruces por cero desde [offset] hasta el final.
int _zeroCrossings(Float64List samples, int offset) {
  int crossings = 0;
  for (int i = offset + 1; i < samples.length; i++) {
    if (samples[i - 1] <= 0 && samples[i] > 0) {
      crossings++;
    }
  }
  return crossings;
}
