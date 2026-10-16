import 'dart:typed_data';

/// Picos de un espectro en arrays de capacidad fija (sin asignar por trama).
///
/// Cada pico guarda su frecuencia interpolada, su amplitud y su altura en
/// notas MIDI (con decimales).
class SpectralPeaks {
  /// Crea el contenedor con espacio para [capacity] picos.
  SpectralPeaks([this.capacity = defaultCapacity])
    : frequency = Float64List(capacity),
      amplitude = Float64List(capacity),
      midi = Float64List(capacity);

  /// Capacidad por defecto.
  static const int defaultCapacity = 192;

  /// Máximo de picos que caben.
  final int capacity;

  /// Frecuencia de cada pico en Hz, de grave a aguda.
  final Float64List frequency;

  /// Amplitud espectral de cada pico (escala relativa).
  final Float64List amplitude;

  /// Nota MIDI con decimales de cada pico (69 = La 440 Hz).
  final Float64List midi;

  /// Picos guardados.
  int count = 0;

  /// `true` si no cabe ningún pico más.
  bool get isFull => count >= capacity;

  /// Vacía el contenedor.
  void clear() => count = 0;

  /// Amplitud del pico más fuerte (0 si no hay).
  double get maxAmplitude {
    double best = 0;
    for (int i = 0; i < count; i++) {
      if (amplitude[i] > best) {
        best = amplitude[i];
      }
    }
    return best;
  }

  /// Añade un pico; ignora el exceso de capacidad.
  void add(double hz, double amp, double note) {
    if (isFull) {
      return;
    }
    frequency[count] = hz;
    amplitude[count] = amp;
    midi[count] = note;
    count++;
  }
}
