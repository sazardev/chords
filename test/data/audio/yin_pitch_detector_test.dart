import 'dart:math' as math;

import 'dart:typed_data';

import 'package:chords/data/audio/yin_pitch_detector.dart';
import 'package:test/test.dart';

/// Tests del detector de tono YIN.
void main() {
  group('PitchDetector', () {
    test('detecta la frecuencia de un tono puro', () {
      final Float64List buffer = _sine(440, 44100, 2048);
      const PitchDetector detector = PitchDetector();
      final double? frequency = detector.detectPitch(buffer, 44100);
      expect(frequency, isNotNull);
      expect(frequency, closeTo(440, 3));
    });

    test('detecta el tono de una cuerda al aire Mi (82.4 Hz)', () {
      final Float64List buffer = _sine(82.41, 44100, 4096);
      const PitchDetector detector = PitchDetector();
      final double? frequency = detector.detectPitch(buffer, 44100);
      expect(frequency, isNotNull);
      expect(frequency, closeTo(82.41, 1));
    });

    test('devuelve null con silencio', () {
      const PitchDetector detector = PitchDetector();
      expect(detector.detectPitch(Float64List(4096), 44100), isNull);
    });

    test('redondea la nota más cercana y los cents', () {
      final ({String note, double cents}) exact = PitchDetector.nearestNote(
        440,
      );
      expect(exact.note, 'A4');
      expect(exact.cents.abs(), lessThan(0.01));

      final ({String note, double cents}) off = PitchDetector.nearestNote(445);
      expect(off.note, 'A4');
      expect(off.cents, greaterThan(15));
      expect(off.cents, lessThan(25));
    });
  });
}

/// Genera un seno con la amplitud indicada.
Float64List _sine(double frequency, int sampleRate, int length) {
  final Float64List out = Float64List(length);
  for (int i = 0; i < length; i++) {
    out[i] = 0.8 * math.sin(2 * math.pi * frequency * i / sampleRate);
  }
  return out;
}
