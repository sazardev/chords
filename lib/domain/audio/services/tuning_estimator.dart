import 'dart:math' as math;
import 'dart:typed_data';

/// Estima cuánto se desvía la guitarra del La 440 (±50 cents).
///
/// Si la guitarra está afinada 30 cents baja, todas las notas caen entre dos
/// semitonos y asignarlas a "la más cercana" sería una moneda al aire.
/// Cada nota aporta su desviación al semitono más próximo como un ángulo
/// (100 cents = una vuelta); la media circular ponderada da la desviación
/// común, y solo se acepta si las notas coinciden entre sí. Se suaviza entre
/// tramas para no bailar con una sola lectura mala.
class TuningEstimator {
  /// Crea el estimador; [smoothing] es el peso de cada trama nueva (0-1).
  TuningEstimator({this.smoothing = 0.2, this.minCoherence = 0.55});

  /// Peso de la trama nueva en la media móvil.
  final double smoothing;

  /// Coherencia mínima (0-1) de las notas para fiarse de una trama.
  final double minCoherence;

  double _x = 1;
  double _y = 0;

  /// Desviación actual en cents (-50..50) respecto a la afinación estándar.
  double get cents => math.atan2(_y, _x) / (2 * math.pi) * 100;

  /// Vuelve a la afinación estándar.
  void reset() {
    _x = 1;
    _y = 0;
  }

  /// Incorpora la desviación de [count] notas (altura MIDI y peso cada una).
  void update(Float64List midi, Float64List weight, int count) {
    double sumX = 0;
    double sumY = 0;
    double total = 0;
    for (int i = 0; i < count; i++) {
      final double angle = 2 * math.pi * (midi[i] - midi[i].roundToDouble());
      sumX += weight[i] * math.cos(angle);
      sumY += weight[i] * math.sin(angle);
      total += weight[i];
    }
    final double length = math.sqrt(sumX * sumX + sumY * sumY);
    if (total <= 0 || length / total < minCoherence) {
      return;
    }
    _x = (1 - smoothing) * _x + smoothing * sumX / length;
    _y = (1 - smoothing) * _y + smoothing * sumY / length;
  }
}
