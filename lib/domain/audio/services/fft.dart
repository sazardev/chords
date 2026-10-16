import 'dart:math' as math;
import 'dart:typed_data';

/// Transformada rápida de Fourier radix-2 en el sitio, sin asignaciones.
///
/// Las tablas de giros y la permutación de bits se calculan una vez al
/// construir; [transform] solo recorre los arrays que recibe, así que puede
/// llamarse en cada trama sin generar basura.
class Fft {
  /// Crea una FFT de [size] puntos (potencia de dos).
  Fft(this.size)
    : _cos = Float64List(size ~/ 2),
      _sin = Float64List(size ~/ 2),
      _reverse = Int32List(size) {
    if (size < 2 || (size & (size - 1)) != 0) {
      throw ArgumentError.value(size, 'size', 'debe ser potencia de dos');
    }
    _fillTables();
  }

  /// Número de puntos.
  final int size;

  final Float64List _cos;
  final Float64List _sin;
  final Int32List _reverse;

  void _fillTables() {
    for (int k = 0; k < size ~/ 2; k++) {
      final double angle = -2 * math.pi * k / size;
      _cos[k] = math.cos(angle);
      _sin[k] = math.sin(angle);
    }
    final int bits = size.bitLength - 1;
    for (int i = 0; i < size; i++) {
      int reversed = 0;
      for (int b = 0; b < bits; b++) {
        reversed |= ((i >> b) & 1) << (bits - 1 - b);
      }
      _reverse[i] = reversed;
    }
  }

  /// Transformada directa de ([re], [im]), ambos de longitud [size].
  void transform(Float64List re, Float64List im) {
    _permute(re, im);
    for (int half = 1; half < size; half <<= 1) {
      _combine(re, im, half);
    }
  }

  void _permute(Float64List re, Float64List im) {
    for (int i = 0; i < size; i++) {
      final int j = _reverse[i];
      if (j > i) {
        final double tr = re[i];
        re[i] = re[j];
        re[j] = tr;
        final double ti = im[i];
        im[i] = im[j];
        im[j] = ti;
      }
    }
  }

  /// Una pasada de mariposas sobre bloques de `2 * half` puntos.
  void _combine(Float64List re, Float64List im, int half) {
    final int step = size ~/ (half * 2);
    for (int start = 0; start < size; start += half * 2) {
      for (int k = 0; k < half; k++) {
        final int a = start + k;
        final int b = a + half;
        final double wr = _cos[k * step];
        final double wi = _sin[k * step];
        final double tr = re[b] * wr - im[b] * wi;
        final double ti = re[b] * wi + im[b] * wr;
        re[b] = re[a] - tr;
        im[b] = im[a] - ti;
        re[a] += tr;
        im[a] += ti;
      }
    }
  }
}
