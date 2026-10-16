import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/dsp/dsp_kit.dart';

/// Duración (s) del tramo que se repite en los sonidos sostenidos.
const double kLoopSeconds = 2;

/// Constante de tiempo que hace de "sin caída" para un parcial sostenido.
const double _forever = 100000;

/// Una voz sostenida es un tramo de ataque seguido de un tramo periódico.
///
/// Los parciales se afinan al ciclo entero más cercano dentro de
/// [kLoopSeconds], así el final del búfer encaja exactamente con el
/// principio del bucle (error de afinación < 0,25 Hz).
class LoopPlan {
  /// Plan de un sonido con [attack] segundos de ataque antes del bucle.
  const LoopPlan(this.attack);

  /// Segundos del tramo inicial.
  final double attack;

  /// Muestras del ataque.
  int get attackSamples => samplesOf(attack);

  /// Muestras del búfer entero (ataque + un periodo).
  int get totalSamples => attackSamples + samplesOf(kLoopSeconds);

  /// Frecuencia ajustada al ciclo entero más cercano.
  double snap(double hz) =>
      math.max(1, (hz * kLoopSeconds).round()) / kLoopSeconds;
}

/// Suma un parcial de amplitud constante (sostenido) a [out].
void addSustained(Float64List out, double hz, double amp, {double phase = 0}) =>
    addDamped(out, hz, _forever, amp, phase: phase);

/// Suma [count] armónicos de [hz] con amplitud `amp(k)`; con [plan] las
/// frecuencias se ajustan al bucle.
void addHarmonics(
  Float64List out,
  double hz,
  int count,
  double Function(int harmonic) amp, {
  LoopPlan? plan,
  double detuneCents = 0,
}) {
  final double base = detuneCents == 0 ? hz : shiftedHz(hz, detuneCents / 100);
  for (int k = 1; k <= count; k++) {
    final double fk = base * k;
    if (fk >= kBandRate / 2.4) {
      break;
    }
    addSustained(out, plan?.snap(fk) ?? fk, amp(k));
  }
}

/// Multiplica el principio de [out] por una rampa de [attack] segundos y,
/// si [release] es mayor que 0, aplica una caída final de esa duración.
void applyAttackRelease(
  Float64List out, {
  required double attack,
  double release = 0,
}) {
  final int rise = math.max(1, samplesOf(attack));
  for (int i = 0; i < math.min(rise, out.length); i++) {
    out[i] *= i / rise;
  }
  final int fall = samplesOf(release);
  for (int i = 0; i < math.min(fall, out.length); i++) {
    out[out.length - 1 - i] *= i / fall;
  }
}

/// Modulación de amplitud (trémolo) de [hz] ciclos por segundo y [depth].
///
/// Con [hz] múltiplo de 1/[kLoopSeconds] no rompe el empalme del bucle.
void applyTremolo(Float64List out, double hz, double depth) {
  for (int i = 0; i < out.length; i++) {
    out[i] *= 1 + depth * math.sin(kTwoPi * hz * i / kBandRate);
  }
}
