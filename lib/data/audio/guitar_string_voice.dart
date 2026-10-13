import 'dart:math' as math;
import 'dart:typed_data';

/// Una cuerda de guitarra pulsada, sintetizada con Karplus-Strong afinado.
///
/// La línea de retardo se ajusta al periodo exacto de la nota: la parte
/// fraccionaria del retardo la aporta un filtro pasa-todo y la fase del filtro
/// de pérdidas se descuenta, de modo que la afinación queda a menos de un
/// cent en todo el mástil (con el periodo redondeado a muestras enteras las
/// notas agudas se desafinaban hasta medio semitono).
///
/// El carácter sale de tres cosas: la excitación (ruido filtrado por la
/// posición de la púa y por la fuerza del golpe), la pérdida de agudos en cada
/// vuelta (los armónicos altos se apagan antes) y un tiempo de caída que
/// depende de la nota: las graves sostienen más.
class GuitarStringVoice {
  /// Crea la voz para la frecuencia de muestreo [sampleRate].
  const GuitarStringVoice({this.sampleRate = 44100});

  /// Frecuencia de muestreo en Hz.
  final int sampleRate;

  /// Genera [length] muestras de la cuerda a [frequency] Hz.
  ///
  /// [velocity] (0-1) es la fuerza del golpe: más fuerte, más brillante.
  /// [pickPosition] es el punto de pulsación como fracción de la cuerda;
  /// [seed] fija el ruido de la excitación para que el sonido sea repetible.
  Float64List render(
    double frequency,
    int length, {
    double velocity = 0.8,
    double pickPosition = 0.14,
    int seed = 7,
  }) {
    final double omega = 2 * math.pi * frequency / sampleRate;
    final double smoothing = _smoothing(frequency);
    final double lossGain = _lossGain(smoothing, omega);
    final double lossDelay = _lossDelay(smoothing, omega);
    final double total = sampleRate / frequency - lossDelay;
    final int line = (total - 0.5).floor();
    final double fraction = total - line;
    final double allpass = _allpassCoefficient(fraction, omega);
    final double feedback = math.min(
      0.9999,
      math.pow(10, -3 / (frequency * _decaySeconds(frequency))) / lossGain,
    );
    final Float64List buffer = _excitation(
      line,
      velocity,
      pickPosition,
      math.Random(seed),
    );
    return _ring(buffer, length, smoothing, allpass, feedback);
  }

  /// Cuánta energía se mezcla con la muestra anterior en cada vuelta.
  ///
  /// Más suavizado = los agudos se apagan antes. Las notas agudas dan muchas
  /// más vueltas por segundo y ya pierden brillo rápido; las graves, con pocas
  /// vueltas, necesitan más suavizado para no sonar a zumbido.
  double _smoothing(double frequency) =>
      (0.5 - 0.05 * math.log(frequency / 82.41) / math.ln2).clamp(0.3, 0.5);

  /// Ganancia del filtro de pérdidas a la frecuencia fundamental.
  double _lossGain(double smoothing, double omega) => math.sqrt(
    math.pow(1 - smoothing + smoothing * math.cos(omega), 2) +
        math.pow(smoothing * math.sin(omega), 2),
  );

  /// Retardo de fase (en muestras) del filtro de pérdidas a la fundamental.
  double _lossDelay(double smoothing, double omega) =>
      math.atan2(
        smoothing * math.sin(omega),
        1 - smoothing + smoothing * math.cos(omega),
      ) /
      omega;

  /// Coeficiente del pasa-todo que retrasa [fraction] muestras a [omega].
  double _allpassCoefficient(double fraction, double omega) {
    final double ratio = math.tan(omega * fraction / 2) / math.tan(omega / 2);
    return (1 - ratio) / (1 + ratio);
  }

  /// Segundos que tarda la cuerda en caer 60 dB: las graves duran más.
  double _decaySeconds(double frequency) =>
      (6.2 - 1.15 * math.log(frequency / 82.41) / math.ln2).clamp(1.4, 6.2);

  /// Ruido de la púa: peine por la posición de pulsación y filtro de fuerza.
  Float64List _excitation(
    int length,
    double velocity,
    double pickPosition,
    math.Random random,
  ) {
    final Float64List noise = Float64List(length);
    for (int i = 0; i < length; i++) {
      noise[i] = random.nextDouble() * 2 - 1;
    }
    final int pickLag = math.max(1, (pickPosition * length).round());
    // Dos filtros de un polo en cascada: el espectro de una cuerda pulsada
    // cae unos 12 dB por octava desde unos 2 kHz (más arriba cuanto más
    // fuerte el golpe).
    final double cutoff = 700 + 1500 * velocity.clamp(0.0, 1.0);
    final double softness = 1 - math.exp(-2 * math.pi * cutoff / sampleRate);
    final Float64List shaped = Float64List(length);
    double first = 0;
    double second = 0;
    double mean = 0;
    for (int i = 0; i < length; i++) {
      final double combed = noise[i] - noise[(i - pickLag) % length];
      first += softness * (combed - first);
      second += softness * (first - second);
      shaped[i] = second;
      mean += second;
    }
    mean /= length;
    for (int i = 0; i < length; i++) {
      shaped[i] -= mean;
    }
    return shaped;
  }

  /// Hace circular la línea de retardo con el filtro de pérdidas y el
  /// pasa-todo de afinación.
  Float64List _ring(
    Float64List buffer,
    int length,
    double smoothing,
    double allpass,
    double feedback,
  ) {
    final int size = buffer.length;
    final Float64List out = Float64List(length);
    int index = 0;
    double previous = 0;
    double allpassIn = 0;
    double allpassOut = 0;
    for (int i = 0; i < length; i++) {
      final double current = buffer[index];
      out[i] = current;
      final double lossy =
          feedback * ((1 - smoothing) * current + smoothing * previous);
      previous = current;
      allpassOut = allpass * (lossy - allpassOut) + allpassIn;
      allpassIn = lossy;
      buffer[index] = allpassOut;
      index = (index + 1) % size;
    }
    return out;
  }
}
