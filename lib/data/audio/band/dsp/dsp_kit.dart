import 'dart:math' as math;
import 'dart:typed_data';

/// Frecuencia de muestreo de toda la banda.
const int kBandRate = 44100;

/// Vuelta completa en radianes.
const double kTwoPi = 2 * math.pi;

/// Muestras que caben en [seconds] segundos.
int samplesOf(double seconds) => (seconds * kBandRate).round();

/// Búfer en silencio de [seconds] segundos.
Float64List silence(double seconds) => Float64List(samplesOf(seconds));

/// Frecuencia en Hz de la nota MIDI [midi].
double midiHz(int midi) => 440 * math.pow(2, (midi - 69) / 12) as double;

/// Frecuencia [semitones] por encima de [hz].
double shiftedHz(double hz, double semitones) =>
    hz * math.pow(2, semitones / 12);

/// Caída exponencial: 1 en 0 y 1/e en [tau] segundos.
double decayAt(double seconds, double tau) => math.exp(-seconds / tau);

/// Aproximación racional de la tangente hiperbólica (saturación suave).
double softClip(double x) {
  if (x >= 3) {
    return 1;
  }
  if (x <= -3) {
    return -1;
  }
  final double x2 = x * x;
  return x * (27 + x2) / (27 + 9 * x2);
}

/// Generador de ruido blanco repetible.
class Noise {
  /// Crea el generador con una semilla fija.
  Noise(int seed) : _random = math.Random(seed);

  final math.Random _random;

  /// Siguiente muestra entre -1 y 1.
  double next() => _random.nextDouble() * 2 - 1;

  /// Búfer de [length] muestras de ruido.
  Float64List buffer(int length) {
    final Float64List out = Float64List(length);
    for (int i = 0; i < length; i++) {
      out[i] = next();
    }
    return out;
  }
}

/// Suma a [out] una sinusoide amortiguada: `amp·e^(-t/tau)·sin(2π·hz·t+phase)`.
///
/// Usa la recurrencia de un resonador (dos multiplicaciones por muestra, sin
/// `sin` ni `exp`), así que sirve para sumar docenas de parciales de piano o
/// de platos sin que la precarga se note.
void addDamped(
  Float64List out,
  double hz,
  double tau,
  double amp, {
  int start = 0,
  double phase = 0,
}) {
  if (hz <= 0 || hz >= kBandRate / 2 || start >= out.length) {
    return;
  }
  final double w = kTwoPi * hz / kBandRate;
  final double r = math.exp(-1 / (tau * kBandRate));
  final double c = 2 * r * math.cos(w);
  final double r2 = r * r;
  double current = amp * math.sin(phase);
  double following = amp * r * math.sin(w + phase);
  for (int i = start; i < out.length; i++) {
    out[i] += current;
    final double next = c * following - r2 * current;
    current = following;
    following = next;
  }
}

/// Suma a [out] una sinusoide pura de frecuencia constante en un tramo.
void addSine(
  Float64List out,
  double hz,
  double amp, {
  int start = 0,
  int? end,
  double phase = 0,
}) {
  final int stop = math.min(out.length, end ?? out.length);
  final double w = kTwoPi * hz / kBandRate;
  for (int i = start; i < stop; i++) {
    out[i] += amp * math.sin(phase + w * (i - start));
  }
}

/// Multiplica [samples] por una envolvente de ataque lineal y caída
/// exponencial (`tau`).
void shapeAttackDecay(
  Float64List samples, {
  required double attack,
  required double tau,
}) {
  final int rise = math.max(1, samplesOf(attack));
  for (int i = 0; i < samples.length; i++) {
    final double rampUp = i < rise ? i / rise : 1;
    samples[i] *= rampUp * decayAt(i / kBandRate, tau);
  }
}
