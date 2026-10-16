/// Medidas de nivel de señal compartidas por los analizadores de audio.
library;

import 'dart:math' as math;
import 'dart:typed_data';

/// Valor eficaz (RMS) de [samples] entre [start] y [end] (exclusivo).
double rmsOf(Float64List samples, [int start = 0, int? end]) {
  final int stop = end ?? samples.length;
  if (stop <= start) {
    return 0;
  }
  double energy = 0;
  for (int i = start; i < stop; i++) {
    energy += samples[i] * samples[i];
  }
  return math.sqrt(energy / (stop - start));
}

/// Nivel normalizado (0-1) de un RMS: -55 dBFS = 0 y -10 dBFS = 1.
double levelOfRms(double rms) {
  if (rms <= 0) {
    return 0;
  }
  final double decibels = 20 * math.log(rms) / math.ln10;
  return ((decibels + 55) / 45).clamp(0.0, 1.0);
}
