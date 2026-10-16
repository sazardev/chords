import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/services/fft.dart';
import 'package:chords/domain/audio/services/hann_window.dart';
import 'package:test/test.dart';

/// Índice del mayor módulo de los primeros `size / 2` bins.
int _peakBin(Float64List re, Float64List im, int size) {
  int best = 1;
  double top = 0;
  for (int k = 1; k < size ~/ 2; k++) {
    final double magnitude = re[k] * re[k] + im[k] * im[k];
    if (magnitude > top) {
      top = magnitude;
      best = k;
    }
  }
  return best;
}

/// Tests de la FFT radix-2 y de la ventana de Hann.
void main() {
  group('Fft', () {
    test('una senoide pura cae en el bin correcto', () {
      const int size = 4096;
      const int bin = 123;
      final Fft fft = Fft(size);
      final Float64List re = Float64List(size);
      final Float64List im = Float64List(size);
      for (int i = 0; i < size; i++) {
        re[i] = math.sin(2 * math.pi * bin * i / size);
      }

      fft.transform(re, im);

      expect(_peakBin(re, im, size), bin);
      // Una senoide de amplitud 1 mide size / 2 en su bin y ~0 en los demás.
      expect(
        math.sqrt(re[bin] * re[bin] + im[bin] * im[bin]),
        closeTo(2048, 1),
      );
      expect(re[bin + 5].abs() + im[bin + 5].abs(), lessThan(1e-6));
    });

    test('una senoide entre dos bins se reparte entre ambos', () {
      const int size = 2048;
      final Fft fft = Fft(size);
      final Float64List re = Float64List(size);
      final Float64List im = Float64List(size);
      for (int i = 0; i < size; i++) {
        re[i] = math.sin(2 * math.pi * 50.5 * i / size);
      }

      fft.transform(re, im);

      final int peak = _peakBin(re, im, size);
      expect(<int>[50, 51], contains(peak));
    });

    test('cumple Parseval: la energía se conserva', () {
      const int size = 1024;
      final Fft fft = Fft(size);
      final math.Random random = math.Random(3);
      final Float64List re = Float64List(size);
      final Float64List im = Float64List(size);
      double timeEnergy = 0;
      for (int i = 0; i < size; i++) {
        re[i] = random.nextDouble() - 0.5;
        timeEnergy += re[i] * re[i];
      }

      fft.transform(re, im);

      double freqEnergy = 0;
      for (int k = 0; k < size; k++) {
        freqEnergy += re[k] * re[k] + im[k] * im[k];
      }
      expect(freqEnergy / size, closeTo(timeEnergy, 1e-9));
    });

    test('la transformada de un impulso es plana', () {
      const int size = 256;
      final Fft fft = Fft(size);
      final Float64List re = Float64List(size)..[0] = 1;
      final Float64List im = Float64List(size);

      fft.transform(re, im);

      for (int k = 0; k < size; k++) {
        expect(re[k], closeTo(1, 1e-12));
        expect(im[k], closeTo(0, 1e-12));
      }
    });

    test('rechaza tamaños que no son potencia de dos', () {
      expect(() => Fft(1000), throwsArgumentError);
      expect(() => Fft(1), throwsArgumentError);
    });
  });

  group('HannWindow', () {
    test('vale 0 en el borde, 1 en el centro y es simétrica', () {
      final HannWindow window = HannWindow(1024);
      expect(window.coefficients[0], closeTo(0, 1e-12));
      expect(window.coefficients[512], closeTo(1, 1e-12));
      expect(window.coefficients[100], closeTo(window.coefficients[924], 1e-9));
    });

    test('apply multiplica muestra a muestra', () {
      final HannWindow window = HannWindow(8);
      final Float64List source = Float64List.fromList(
        List<double>.filled(8, 2),
      );
      final Float64List target = Float64List(8);

      window.apply(source, target);

      for (int i = 0; i < 8; i++) {
        expect(target[i], closeTo(2 * window.coefficients[i], 1e-12));
      }
    });
  });
}
