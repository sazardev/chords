import 'dart:math' as math;
import 'dart:typed_data';

/// Filtro de segundo orden (cookbook de Robert Bristow-Johnson).
///
/// Se usa para dar color al ruido y a los osciladores: pasa-bajos, pasa-altos,
/// pasa-banda y campana.
class Biquad {
  Biquad._(this._b0, this._b1, this._b2, this._a1, this._a2);

  /// Pasa-bajos en [hz] con resonancia [q].
  factory Biquad.lowPass(double hz, double q, int sampleRate) {
    final _Parts p = _Parts(hz, q, sampleRate);
    final double c = math.cos(p.w);
    return Biquad._((1 - c) / 2, 1 - c, (1 - c) / 2, -2 * c, 1 - p.alpha)
      .._normalize(1 + p.alpha);
  }

  /// Pasa-altos en [hz] con resonancia [q].
  factory Biquad.highPass(double hz, double q, int sampleRate) {
    final _Parts p = _Parts(hz, q, sampleRate);
    final double c = math.cos(p.w);
    return Biquad._((1 + c) / 2, -(1 + c), (1 + c) / 2, -2 * c, 1 - p.alpha)
      .._normalize(1 + p.alpha);
  }

  /// Pasa-banda centrado en [hz] con ganancia de pico 1.
  factory Biquad.bandPass(double hz, double q, int sampleRate) {
    final _Parts p = _Parts(hz, q, sampleRate);
    return Biquad._(p.alpha, 0, -p.alpha, -2 * math.cos(p.w), 1 - p.alpha)
      .._normalize(1 + p.alpha);
  }

  /// Campana: realza (o recorta) [gainDb] decibelios alrededor de [hz].
  factory Biquad.peaking(double hz, double q, double gainDb, int sampleRate) {
    final _Parts p = _Parts(hz, q, sampleRate);
    final double a = math.pow(10, gainDb / 40) as double;
    final double c = math.cos(p.w);
    return Biquad._(
      1 + p.alpha * a,
      -2 * c,
      1 - p.alpha * a,
      -2 * c,
      1 - p.alpha / a,
    ).._normalize(1 + p.alpha / a);
  }

  double _b0;
  double _b1;
  double _b2;
  double _a1;
  double _a2;
  double _x1 = 0;
  double _x2 = 0;
  double _y1 = 0;
  double _y2 = 0;

  void _normalize(double a0) {
    _b0 /= a0;
    _b1 /= a0;
    _b2 /= a0;
    _a1 /= a0;
    _a2 /= a0;
  }

  /// Procesa una muestra.
  double next(double x) {
    final double y = _b0 * x + _b1 * _x1 + _b2 * _x2 - _a1 * _y1 - _a2 * _y2;
    _x2 = _x1;
    _x1 = x;
    _y2 = _y1;
    _y1 = y;
    return y;
  }

  /// Filtra [samples] en el sitio y devuelve el mismo búfer.
  Float64List apply(Float64List samples) {
    for (int i = 0; i < samples.length; i++) {
      samples[i] = next(samples[i]);
    }
    return samples;
  }
}

class _Parts {
  _Parts(double hz, double q, int sampleRate)
    : w = 2 * math.pi * hz.clamp(10.0, sampleRate * 0.45) / sampleRate,
      alpha =
          math.sin(
            2 * math.pi * hz.clamp(10.0, sampleRate * 0.45) / sampleRate,
          ) /
          (2 * q);

  final double w;
  final double alpha;
}
