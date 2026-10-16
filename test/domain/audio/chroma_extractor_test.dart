import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/services/chroma_extractor.dart';
import 'package:chords/domain/audio/services/spectral_peaks.dart';
import 'package:test/test.dart';

import '../../support/chord_audio_probe.dart';

/// Trama de [samples] con el tamaño de FFT indicado (a partir de 1 s).
Float64List _frame(Float64List samples, int size) =>
    Float64List.fromList(samples.sublist(kProbeRate, kProbeRate + size));

/// Clases de nota ordenadas de más a menos energía.
List<int> _ranking(Float64List chroma) =>
    List<int>.generate(12, (int i) => i)
      ..sort((int a, int b) => chroma[b].compareTo(chroma[a]));

double _hz(double base, double cents) => base * math.pow(2, cents / 1200);

/// Tests del extractor de cromagrama y del buscador de picos.
void main() {
  group('SpectralPeakPicker', () {
    test('interpola la frecuencia de una senoide por debajo de un bin', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(_frame(sines(<double>[261.63], 2), extractor.fftSize));

      final SpectralPeaks peaks = extractor.peaks;
      expect(peaks.count, greaterThan(0));
      expect(peaks.frequency[0], closeTo(261.63, 0.3));
      expect(peaks.midi[0], closeTo(60, 0.02));
    });

    test('el ruido blanco no deja picos', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(
        _frame(whiteNoise(kProbeRate * 2, 0.1), extractor.fftSize),
      );

      expect(extractor.peaks.count, 0);
      expect(extractor.chroma.every((double v) => v == 0), isTrue);
    });

    test('ignora lo que cae fuera de 70-2000 Hz', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(
        _frame(sines(<double>[40, 3500], 2), extractor.fftSize),
      );

      expect(extractor.peaks.count, 0);
    });
  });

  group('ChromaExtractor', () {
    test('una tríada mayor enciende sus tres notas', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(
        _frame(sines(<double>[261.63, 329.63, 392], 2), extractor.fftSize),
      );

      expect(_ranking(extractor.chroma).take(3).toSet(), <int>{0, 4, 7});
      final double top = extractor.chroma.reduce(math.max);
      for (final int other in <int>[1, 2, 3, 5, 6, 8, 9, 10, 11]) {
        expect(extractor.chroma[other] / top, lessThan(0.2), reason: '$other');
      }
    });

    test('una nota suelta enciende solo su clase y marca el bajo', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(_frame(sines(<double>[440], 2), extractor.fftSize));

      expect(_ranking(extractor.chroma).first, 9);
      expect(extractor.bass, 9);
    });

    test('compensa una guitarra afinada 40 cents baja', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      final Float64List audio = sines(<double>[
        _hz(261.63, -40),
        _hz(329.63, -40),
        _hz(392, -40),
      ], 2);
      for (int i = 0; i < 30; i++) {
        extractor.extract(_frame(audio, extractor.fftSize));
      }

      expect(extractor.tuningCents, closeTo(-40, 4));
      expect(_ranking(extractor.chroma).take(3).toSet(), <int>{0, 4, 7});
    });

    test('compensa una guitarra afinada 40 cents alta', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      final Float64List audio = sines(<double>[
        _hz(220, 40),
        _hz(277.18, 40),
        _hz(329.63, 40),
      ], 2);
      for (int i = 0; i < 30; i++) {
        extractor.extract(_frame(audio, extractor.fftSize));
      }

      expect(extractor.tuningCents, closeTo(40, 4));
      expect(_ranking(extractor.chroma).take(3).toSet(), <int>{9, 1, 4});
    });

    test('una serie armónica sin fundamental se atribuye a su nota', () {
      // La, 110 Hz, solo con sus armónicos 2 a 8 (el móvil recorta los graves).
      final List<double> partials = <double>[
        for (int h = 2; h <= 8; h++) 110.0 * h,
      ];
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(_frame(sines(partials, 2), extractor.fftSize));

      expect(_ranking(extractor.chroma).first, 9);
    });

    test('el bajo es la nota más grave con cuerpo', () {
      final ChromaExtractor extractor = ChromaExtractor(sampleRate: kProbeRate);
      extractor.extract(
        _frame(sines(<double>[110, 164.81, 220, 277.18], 2), extractor.fftSize),
      );

      expect(extractor.bass, 9);
    });
  });
}
