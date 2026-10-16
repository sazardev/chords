import 'dart:math' as math;
import 'dart:typed_data';

/// Suaviza el cromagrama en el tiempo con una media móvil exponencial.
///
/// Un rasgueo no suena igual en todas las tramas (las cuerdas entran
/// escalonadas y se apagan a ritmos distintos); promediar varias tramas da
/// un cromagrama estable. Cuando se detecta un ataque nuevo el peso de la
/// trama actual sube para que un cambio de acorde no tarde en notarse.
/// Cada trama se normaliza a máximo 1 antes de mezclarla, de modo que el
/// volumen no decide cuánto pesa.
class ChromaSmoother {
  /// Crea el suavizador; [smoothing] y [onsetSmoothing] son el peso (0-1) de
  /// la trama nueva en el caso normal y en un ataque.
  ChromaSmoother({this.smoothing = 0.5, this.onsetSmoothing = 0.85});

  /// Peso de la trama nueva en régimen normal.
  final double smoothing;

  /// Peso de la trama nueva al detectar un ataque.
  final double onsetSmoothing;

  /// Cromagrama suavizado, normalizado a máximo 1 (o ceros si no hay señal).
  final Float64List value = Float64List(12);

  bool _primed = false;

  /// Olvida lo acumulado.
  void reset() {
    value.fillRange(0, 12, 0);
    _primed = false;
  }

  /// Mezcla [raw] (12 valores >= 0) con lo acumulado.
  void update(Float64List raw, {bool onset = false}) {
    double top = 0;
    for (int i = 0; i < 12; i++) {
      top = math.max(top, raw[i]);
    }
    final double weight = _primed ? (onset ? onsetSmoothing : smoothing) : 1;
    for (int i = 0; i < 12; i++) {
      final double sample = top > 0 ? raw[i] / top : 0;
      value[i] = (1 - weight) * value[i] + weight * sample;
    }
    _primed = true;
  }
}
