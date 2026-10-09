import 'dart:math' as math;
import 'dart:typed_data';

/// Detector de tono basado en el algoritmo YIN.
///
/// Devuelve la frecuencia fundamental estimada o `null` si la señal no
/// contiene un tono claro.
class PitchDetector {
  /// Crea el detector con la configuración indicada.
  const PitchDetector({
    this.threshold = 0.12,
    this.minFrequency = 65,
    this.maxFrequency = 1200,
  });

  /// Umbral de la función de diferencia normalizada.
  final double threshold;

  /// Frecuencia mínima detectable en Hz.
  final double minFrequency;

  /// Frecuencia máxima detectable en Hz.
  final double maxFrequency;

  /// Estima la frecuencia fundamental de la ventana [buffer].
  double? detectPitch(Float64List buffer, int sampleRate) {
    final int tauMin = math.max(2, (sampleRate / maxFrequency).floor());
    final int tauMax = math.min(
      buffer.length ~/ 2,
      (sampleRate / minFrequency).ceil(),
    );
    if (tauMax <= tauMin + 2) {
      return null;
    }

    final int w = tauMax;
    final List<double> difference = List<double>.filled(w, 0);
    for (int tau = tauMin; tau < tauMax; tau++) {
      double sum = 0;
      for (int i = 0; i < w; i++) {
        final double delta = buffer[i] - buffer[i + tau];
        sum += delta * delta;
      }
      difference[tau] = sum;
    }

    double runningSum = 0;
    for (int tau = tauMin; tau < tauMax; tau++) {
      runningSum += difference[tau];
      difference[tau] = runningSum == 0
          ? 1
          : difference[tau] * (tau - tauMin + 1) / runningSum;
    }

    int? bestTau;
    for (int tau = tauMin + 1; tau < tauMax; tau++) {
      if (difference[tau] < threshold) {
        while (tau + 1 < tauMax && difference[tau + 1] < difference[tau]) {
          tau++;
        }
        bestTau = tau;
        break;
      }
    }
    if (bestTau == null) {
      return null;
    }

    double betterTau = bestTau.toDouble();
    final int tau = bestTau;
    final int x0 = tau > tauMin ? tau - 1 : tau;
    final int x2 = tau + 1 < tauMax ? tau + 1 : tau;
    if (x0 != tau && x2 != tau) {
      final double s0 = difference[x0];
      final double s1 = difference[tau];
      final double s2 = difference[x2];
      final double denom = 2 * (2 * s1 - s2 - s0);
      if (denom != 0) {
        betterTau += (s2 - s0) / denom;
      }
    }
    return sampleRate / betterTau;
  }

  /// Nota más cercana y desviación en cents para una frecuencia.
  static ({String note, double cents}) nearestNote(double frequency) {
    const List<String> names = <String>[
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    const double a4 = 440;
    final double midiContinuous =
        69 + 12 * (math.log(frequency / a4) / math.ln2);
    final int midiRounded = midiContinuous.round();
    final String note = names[((midiRounded % 12) + 12) % 12];
    final int octave = midiRounded ~/ 12 - 1;
    return (note: '$note$octave', cents: (midiContinuous - midiRounded) * 100);
  }

  /// Claridad estimada (0-1) a partir de la energía de la ventana.
  static double clarityOf(Float64List buffer) {
    if (buffer.isEmpty) {
      return 0;
    }
    double energy = 0;
    for (final double value in buffer) {
      energy += value * value;
    }
    final double rms = math.sqrt(energy / buffer.length);
    return (rms * 8).clamp(0.0, 1.0);
  }
}
