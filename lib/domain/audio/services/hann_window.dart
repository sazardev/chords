import 'dart:math' as math;
import 'dart:typed_data';

/// Ventana de Hann periódica: suaviza los bordes de la trama antes de la FFT
/// para que la fuga espectral de una nota no tape a las vecinas.
class HannWindow {
  /// Crea la ventana de [size] puntos.
  HannWindow(this.size) : coefficients = Float64List(size) {
    for (int i = 0; i < size; i++) {
      coefficients[i] = 0.5 - 0.5 * math.cos(2 * math.pi * i / size);
    }
  }

  /// Longitud de la ventana.
  final int size;

  /// Coeficientes de la ventana.
  final Float64List coefficients;

  /// Escribe `source * ventana` en [target] (ambos de longitud [size]).
  void apply(Float64List source, Float64List target) {
    for (int i = 0; i < size; i++) {
      target[i] = source[i] * coefficients[i];
    }
  }
}
