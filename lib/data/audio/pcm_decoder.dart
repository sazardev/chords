import 'dart:typed_data';

/// Decodificador de audio PCM16 little-endian a muestras en coma flotante.
class PcmDecoder {
  /// Crea el decodificador.
  const PcmDecoder();

  /// Convierte bytes PCM16 entrelazados a muestras normalizadas.
  Float64List decode(Uint8List bytes) {
    final ByteData data = ByteData.sublistView(bytes);
    final int sampleCount = data.lengthInBytes ~/ 2;
    final Float64List out = Float64List(sampleCount);
    for (int i = 0; i < sampleCount; i++) {
      out[i] = data.getInt16(i * 2, Endian.little) / 32768.0;
    }
    return out;
  }
}
