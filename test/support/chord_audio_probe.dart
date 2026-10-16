import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/services/chord_recognizer.dart';

/// Frecuencia de muestreo de las pruebas de reconocimiento de acordes.
const int kProbeRate = 44100;

/// Bloque de 20 ms: lo que entrega el micrófono en la app.
const int kProbeChunk = kProbeRate ~/ 50;

/// Pasa [audio] por un [ChordRecognizer] en bloques de 20 ms y devuelve todas
/// las lecturas que produce, en orden.
List<ChordReading> recognize(Float64List audio, {ChordRecognizer? recognizer}) {
  final ChordRecognizer r =
      recognizer ?? ChordRecognizer(sampleRate: kProbeRate);
  final List<ChordReading> readings = <ChordReading>[];
  for (int s = 0; s + kProbeChunk <= audio.length; s += kProbeChunk) {
    readings.addAll(
      r.addSamples(Float64List.sublistView(audio, s, s + kProbeChunk)),
    );
  }
  return readings;
}

/// Convierte muestras (-1..1) a bloques PCM16 little-endian de 20 ms, como los
/// entrega el micrófono.
List<Uint8List> pcmChunks(Float64List samples, {double gain = 1}) {
  final List<Uint8List> out = <Uint8List>[];
  for (
    int start = 0;
    start + kProbeChunk <= samples.length;
    start += kProbeChunk
  ) {
    final ByteData data = ByteData(kProbeChunk * 2);
    for (int i = 0; i < kProbeChunk; i++) {
      final double value = (samples[start + i] * gain).clamp(-1.0, 1.0);
      data.setInt16(i * 2, (value * 32767).round(), Endian.little);
    }
    out.add(data.buffer.asUint8List());
  }
  return out;
}

/// Lectura que corresponde al instante [seconds] (cada lectura son 100 ms).
ChordReading readingAt(List<ChordReading> readings, double seconds) =>
    readings[math.min(readings.length - 1, (seconds * 10).round() - 1)];

/// Ruido blanco aproximadamente gaussiano de valor eficaz [rms].
Float64List whiteNoise(int length, double rms, {int seed = 1}) {
  final math.Random random = math.Random(seed);
  final Float64List out = Float64List(length);
  for (int i = 0; i < length; i++) {
    double sum = 0;
    for (int k = 0; k < 6; k++) {
      sum += random.nextDouble() - 0.5;
    }
    out[i] = sum * rms * math.sqrt(2);
  }
  return out;
}

/// Suma de dos señales (la más corta manda sobre la longitud útil de [b]).
Float64List mix(Float64List a, Float64List b) {
  final Float64List out = Float64List.fromList(a);
  for (int i = 0; i < out.length && i < b.length; i++) {
    out[i] += b[i];
  }
  return out;
}

/// Filtro paso alto de primer orden: imita el recorte de graves de un móvil.
Float64List highPass(Float64List samples, double cutoffHz) {
  final double rc = 1 / (2 * math.pi * cutoffHz);
  final double a = rc / (rc + 1 / kProbeRate);
  final Float64List out = Float64List(samples.length);
  for (int i = 1; i < samples.length; i++) {
    out[i] = a * (out[i - 1] + samples[i] - samples[i - 1]);
  }
  return out;
}

/// Suma de senoides puras de las frecuencias dadas (amplitud [amplitude]).
Float64List sines(
  List<double> frequencies,
  double seconds, {
  double amplitude = 0.1,
}) {
  final Float64List out = Float64List((seconds * kProbeRate).round());
  for (final double f in frequencies) {
    for (int i = 0; i < out.length; i++) {
      out[i] += amplitude * math.sin(2 * math.pi * f * i / kProbeRate);
    }
  }
  return out;
}
