import 'dart:typed_data';

/// Codificador de audio PCM a formato WAV (16 bits, mono).
class WavEncoder {
  /// Crea el codificador.
  const WavEncoder({this.sampleRate = 44100});

  /// Frecuencia de muestreo de salida.
  final int sampleRate;

  /// Convierte muestras normalizadas (-1..1) a bytes WAV.
  Uint8List encode(Float64List samples) {
    final int dataBytes = samples.length * 2;
    final ByteData data = ByteData(44 + dataBytes);
    _writeHeader(data, samples.length);
    for (int i = 0; i < samples.length; i++) {
      final double clamped = samples[i].clamp(-1.0, 1.0);
      final int value = (clamped * 32767).round();
      data.setInt16(44 + i * 2, value, Endian.little);
    }
    return data.buffer.asUint8List();
  }

  void _writeHeader(ByteData data, int sampleCount) {
    final int byteRate = sampleRate * 2;

    void writeAscii(int offset, String text) {
      for (int i = 0; i < text.length; i++) {
        data.setUint8(offset + i, text.codeUnitAt(i));
      }
    }

    writeAscii(0, 'RIFF');
    data
      ..setUint32(4, 36 + sampleCount * 2, Endian.little)
      ..setUint32(16, 16, Endian.little)
      ..setUint16(20, 1, Endian.little)
      ..setUint16(22, 1, Endian.little)
      ..setUint32(24, sampleRate, Endian.little)
      ..setUint32(28, byteRate, Endian.little)
      ..setUint16(32, 2, Endian.little)
      ..setUint16(34, 16, Endian.little)
      ..setUint32(40, sampleCount * 2, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    writeAscii(36, 'data');
  }
}
