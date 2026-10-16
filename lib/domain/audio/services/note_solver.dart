import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/services/note_dictionary.dart';
import 'package:chords/domain/audio/services/spectral_peaks.dart';

/// Descompone los picos de un espectro en las notas que los producen.
///
/// Es una regresión no negativa por mínimos cuadrados: busca cuánto suena
/// cada nota del [NoteDictionary] para que la suma de sus series armónicas se
/// parezca lo más posible a los picos observados (con compresión logarítmica
/// de las amplitudes). Se resuelve con actualizaciones multiplicativas, que
/// mantienen todo >= 0 y cuestan unas decenas de miles de operaciones por
/// trama, y una penalización suave favorece soluciones con pocas notas.
///
/// Un armónico se atribuye a la nota que lo explica mejor en lugar de contar
/// como nota propia, y una serie con la fundamental ausente (típica de las
/// cuerdas graves) sigue explicándose con sus armónicos 2 a 10.
class NoteSolver {
  /// Crea el resolutor.
  NoteSolver({
    NoteDictionary? dictionary,
    this.iterations = 60,
    this.sparsity = 0.2,
    this.compression = 100,
  }) : dictionary = dictionary ?? NoteDictionary() {
    final NoteDictionary d = this.dictionary;
    _observed = Float64List(d.binCount);
    _model = Float64List(d.binCount);
    _target = Float64List(d.columnCount);
    activation = Float64List(d.columnCount);
  }

  /// Diccionario de notas.
  final NoteDictionary dictionary;

  /// Actualizaciones multiplicativas por trama.
  final int iterations;

  /// Penalización de dispersión relativa a la mayor correlación.
  final double sparsity;

  /// Fuerza de la compresión logarítmica de las amplitudes.
  final double compression;

  late final Float64List _observed;
  late final Float64List _model;
  late final Float64List _target;

  /// Cuánto suena cada columna del diccionario (>= 0) tras [solve].
  late final Float64List activation;

  /// Calcula [activation] a partir de [peaks] corregidos por [tuningCents].
  void solve(SpectralPeaks peaks, double tuningCents) {
    _observe(peaks, tuningCents);
    if (!_correlate()) {
      return;
    }
    for (int i = 0; i < iterations; i++) {
      _step();
    }
  }

  /// Dibuja los picos (comprimidos en logaritmo) sobre el eje de casillas.
  void _observe(SpectralPeaks peaks, double tuningCents) {
    _observed.fillRange(0, _observed.length, 0);
    final double top = peaks.maxAmplitude;
    final double scale = 1 / math.log(1 + compression);
    for (int i = 0; i < peaks.count && top > 0; i++) {
      final double position = dictionary.positionOf(
        peaks.midi[i] - tuningCents / 100,
      );
      if (position < 0 || position >= dictionary.binCount - 1) {
        continue;
      }
      final double value =
          math.log(1 + compression * peaks.amplitude[i] / top) * scale;
      final int lower = position.floor();
      final double fraction = position - lower;
      _observed[lower] += value * (1 - fraction);
      _observed[lower + 1] += value * fraction;
    }
  }

  /// Correlación de cada nota con lo observado y arranque de las activaciones.
  ///
  /// Devuelve `false` (con todas las activaciones a 0) si no hay nada que
  /// explicar: sin picos no hay notas, y dividir 0 entre 0 las envenenaría.
  bool _correlate() {
    final NoteDictionary d = dictionary;
    double total = 0;
    for (int n = 0; n < d.columnCount; n++) {
      double dot = 0;
      double norm = 0;
      for (int k = n * d.stride; k < (n + 1) * d.stride; k++) {
        dot += d.weights[k] * _observed[d.bins[k]];
        norm += d.weights[k] * d.weights[k];
      }
      _target[n] = dot;
      activation[n] = norm > 0 ? dot / norm : 0;
      total += dot;
    }
    if (total <= 0) {
      activation.fillRange(0, activation.length, 0);
    }
    return total > 0;
  }

  /// Un paso de la actualización multiplicativa de mínimos cuadrados.
  void _step() {
    final NoteDictionary d = dictionary;
    _model.fillRange(0, _model.length, 0);
    for (int n = 0; n < d.columnCount; n++) {
      final double x = activation[n];
      if (x <= 0) {
        continue;
      }
      for (int k = n * d.stride; k < (n + 1) * d.stride; k++) {
        _model[d.bins[k]] += d.weights[k] * x;
      }
    }
    double top = 0;
    for (int n = 0; n < d.columnCount; n++) {
      top = math.max(top, _target[n]);
    }
    final double penalty = sparsity * top;
    for (int n = 0; n < d.columnCount; n++) {
      double projection = penalty;
      for (int k = n * d.stride; k < (n + 1) * d.stride; k++) {
        projection += d.weights[k] * _model[d.bins[k]];
      }
      activation[n] *= _target[n] / projection;
    }
  }
}
