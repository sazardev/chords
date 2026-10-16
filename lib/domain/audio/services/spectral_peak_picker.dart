import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/services/spectral_peaks.dart';

/// Busca los picos de un espectro de potencia en el rango de la guitarra.
///
/// Un máximo local solo cuenta si supera un suelo doble: una fracción del
/// pico más fuerte (descarta los lóbulos laterales de la ventana) y varias
/// veces el nivel de ruido del espectro (la media geométrica de la banda, que
/// apenas se mueve por unos pocos picos). Así el ruido blanco no deja picos y
/// una guitarra suave sí. La frecuencia y la amplitud se afinan por
/// interpolación parabólica sobre el logaritmo, mucho más precisa que el
/// ancho de un bin.
class SpectralPeakPicker {
  /// Crea el buscador con el rango y los suelos indicados.
  const SpectralPeakPicker({
    this.minFrequency = 70,
    this.maxFrequency = 2000,
    this.relativeFloor = 0.04,
    this.noiseFactor = 30,
  });

  /// Frecuencia mínima a considerar (Hz).
  final double minFrequency;

  /// Frecuencia máxima a considerar (Hz).
  final double maxFrequency;

  /// Amplitud mínima respecto al pico más fuerte (0-1).
  final double relativeFloor;

  /// Veces que la potencia de un pico debe superar el ruido del espectro.
  final double noiseFactor;

  static const double _tiny = 1e-30;

  /// Rellena [out] con los picos de [power] (|X|² por bin, [binHz] por bin).
  void pick(Float64List power, double binHz, SpectralPeaks out) {
    out.clear();
    final int lo = math.max(2, (minFrequency / binHz).floor());
    final int hi = math.min(power.length - 2, (maxFrequency / binHz).ceil());
    final double top = _maxPower(power, lo, hi);
    if (top <= 0) {
      return;
    }
    final double floor = math.max(
      top * relativeFloor * relativeFloor,
      noiseFactor * _geometricMean(power, lo, hi),
    );
    for (int k = lo; k <= hi && !out.isFull; k++) {
      if (power[k] >= floor && _isLocalMax(power, k)) {
        _addInterpolated(power, k, binHz, out);
      }
    }
  }

  bool _isLocalMax(Float64List power, int k) =>
      power[k] > power[k - 1] && power[k] >= power[k + 1];

  double _maxPower(Float64List power, int lo, int hi) {
    double best = 0;
    for (int k = lo; k <= hi; k++) {
      if (power[k] > best) {
        best = power[k];
      }
    }
    return best;
  }

  double _geometricMean(Float64List power, int lo, int hi) {
    double sum = 0;
    for (int k = lo; k <= hi; k++) {
      sum += math.log(power[k] + _tiny);
    }
    return math.exp(sum / (hi - lo + 1));
  }

  void _addInterpolated(
    Float64List power,
    int k,
    double binHz,
    SpectralPeaks out,
  ) {
    final double a = math.log(power[k - 1] + _tiny);
    final double b = math.log(power[k] + _tiny);
    final double c = math.log(power[k + 1] + _tiny);
    final double denominator = a - 2 * b + c;
    final double offset = denominator == 0
        ? 0
        : (0.5 * (a - c) / denominator).clamp(-0.5, 0.5);
    final double hz = (k + offset) * binHz;
    final double amplitude = math.exp(0.5 * (b - 0.25 * (a - c) * offset));
    out.add(hz, amplitude, 69 + 12 * math.log(hz / 440) / math.ln2);
  }
}
