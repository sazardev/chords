import 'dart:math' as math;
import 'dart:typed_data';

/// Mide la frecuencia de una señal por autocorrelación con interpolación
/// parabólica; mucho más fina que el detector del micrófono (que está pensado
/// para tiempo real). Sirve para comprobar la afinación de los sonidos.
class PitchProbe {
  /// Crea la sonda para la frecuencia de muestreo [sampleRate].
  const PitchProbe(this.sampleRate);

  /// Frecuencia de muestreo de las señales.
  final int sampleRate;

  /// Frecuencia (Hz) de [samples] cerca de [expected], midiendo a partir de
  /// [startSeconds] sobre [window] muestras.
  double frequency(
    Float64List samples,
    double expected, {
    double startSeconds = 0.08,
    int window = 8192,
  }) {
    final int start = (startSeconds * sampleRate).round();
    final int end = math.min(samples.length, start + window);
    final int expectedLag = (sampleRate / expected).round();
    final int minLag = (expectedLag * 0.94).floor();
    final int maxLag = (expectedLag * 1.06).ceil();
    double best = -double.infinity;
    int bestLag = expectedLag;
    final Map<int, double> scores = <int, double>{};
    for (int lag = minLag - 1; lag <= maxLag + 1; lag++) {
      double sum = 0;
      for (int i = start; i + lag < end; i++) {
        sum += samples[i] * samples[i + lag];
      }
      scores[lag] = sum;
      if (lag >= minLag && lag <= maxLag && sum > best) {
        best = sum;
        bestLag = lag;
      }
    }
    final double a = scores[bestLag - 1]!;
    final double b = scores[bestLag]!;
    final double c = scores[bestLag + 1]!;
    final double shift = 0.5 * (a - c) / (a - 2 * b + c);
    return sampleRate / (bestLag + shift);
  }

  /// Desviación en cents de [measured] respecto de [expected].
  static double cents(double measured, double expected) =>
      1200 * math.log(measured / expected) / math.ln2;
}
