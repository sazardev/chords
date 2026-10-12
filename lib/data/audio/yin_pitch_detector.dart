import 'dart:math' as math;
import 'dart:typed_data';

/// Estimación de tono: frecuencia y seguridad de la detección.
class PitchEstimate {
  /// Crea la estimación.
  const PitchEstimate({required this.frequency, required this.confidence});

  /// Frecuencia fundamental en Hz.
  final double frequency;

  /// Seguridad (0-1) de que la señal es periódica: 1 = tono limpio.
  final double confidence;
}

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
  double? detectPitch(Float64List buffer, int sampleRate) =>
      estimate(buffer, sampleRate)?.frequency;

  /// Estima frecuencia y confianza de la ventana [buffer].
  PitchEstimate? estimate(Float64List buffer, int sampleRate) {
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
    return PitchEstimate(
      frequency: sampleRate / betterTau,
      confidence: (1 - difference[tau]).clamp(0.0, 1.0),
    );
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

  /// Valor eficaz (RMS) de la ventana, entre 0 y 1.
  static double rmsOf(Float64List buffer) {
    if (buffer.isEmpty) {
      return 0;
    }
    double energy = 0;
    for (final double value in buffer) {
      energy += value * value;
    }
    return math.sqrt(energy / buffer.length);
  }

  /// Nivel de entrada normalizado (0-1) a partir del RMS.
  ///
  /// Escala logarítmica: -55 dBFS es 0 y -10 dBFS es 1, un rango que refleja
  /// bien una guitarra acústica frente a un micrófono de móvil.
  static double levelOf(double rms) {
    if (rms <= 0) {
      return 0;
    }
    final double decibels = 20 * math.log(rms) / math.ln10;
    return ((decibels + 55) / 45).clamp(0.0, 1.0);
  }
}
