import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Sintetizador de audio de guitararra para posiciones de acorde.
///
/// Usa una cuerda tipo Karplus-Strong por cuerda pulsada: genera un
/// "pluck" con mezcla de armónicos decrecientes, y suma todas las cuerdas
/// con una ligera disonancia y retardo de rasgueo.
class ChordAudioSynthesizer {
  /// Crea el sintetizador.
  const ChordAudioSynthesizer({this.sampleRate = 44100});

  /// Afinación estándar (valores MIDI): E2 A2 D3 G3 B3 E4.
  static const List<int> stringTuning = <int>[40, 45, 50, 55, 59, 64];

  /// Frecuencia de muestreo.
  final int sampleRate;

  /// Sintetiza la posición indicada y devuelve muestras normalizadas.
  ///
  /// [duration] controla la duración total del acorde en segundos.
  Float64List synthesize(ChordVariant variant, {double duration = 2.5}) {
    final int total = (sampleRate * duration).round();
    final Float64List mix = Float64List(total);
    final math.Random random = math.Random(7);
    final List<int> frets = variant.frets;
    for (int s = 0; s < frets.length && s < stringTuning.length; s++) {
      final int fret = frets[s];
      if (fret < 0) {
        continue;
      }
      final double frequency = midiToFrequency(stringTuning[s] + fret);
      final double amplitude = s < 3 ? 0.5 : 0.36;
      final int offset = s * (sampleRate ~/ 1200);
      final Float64List voice = _pluck(frequency, total - offset, random);
      for (int i = 0; i < voice.length; i++) {
        mix[i + offset] += voice[i] * amplitude;
      }
    }
    _normalize(mix);
    return mix;
  }

  /// Genera una voz de cuerda pulsada con Karplus-Strong.
  ///
  /// El delay line se inicializa con parciales armónicos más un toque de
  /// ruido, de modo que el tono es estable desde el primer ciclo.
  Float64List _pluck(double frequency, int length, math.Random random) {
    final int period = math.max(2, (sampleRate / frequency).round());
    final Float64List buffer = Float64List(period);
    for (int i = 0; i < period; i++) {
      final double phase = 2 * math.pi * i / period;
      buffer[i] =
          0.62 * math.sin(phase) +
          0.28 * math.sin(2 * phase) +
          0.14 * math.sin(3 * phase) +
          (random.nextDouble() * 2 - 1) * 0.08;
    }
    final double gain = (400.0 / period).clamp(0.05, 0.6);
    final Float64List out = Float64List(length);
    int index = 0;
    for (int i = 0; i < length; i++) {
      final int nextIndex = (index + 1) % period;
      final double current = buffer[index];
      buffer[index] = 0.5 * (current + buffer[nextIndex]) * 0.996;
      out[i] = current * gain * math.exp(-i / (sampleRate * 1.4));
      index = nextIndex;
    }
    return out;
  }

  void _normalize(Float64List samples) {
    double peak = 0;
    for (final double value in samples) {
      final double abs = value.abs();
      if (abs > peak) {
        peak = abs;
      }
    }
    if (peak <= 0) {
      return;
    }
    final double scale = 0.9 / peak;
    for (int i = 0; i < samples.length; i++) {
      samples[i] *= scale;
    }
  }

  /// Convierte una nota MIDI a frecuencia en Hz.
  static double midiToFrequency(int midi) =>
      440 * math.pow(2, (midi - 69) / 12) as double;
}
