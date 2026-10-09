import 'dart:typed_data';

import 'package:chords/data/audio/wav_encoder.dart';
import 'package:test/test.dart';

/// Tests del codificador WAV.
void main() {
  group('WavEncoder', () {
    test('escribe una cabecera WAV válida', () {
      const WavEncoder encoder = WavEncoder(sampleRate: 8000);
      final Float64List samples = Float64List.fromList(<double>[
        0,
        0.5,
        -0.5,
        1,
      ]);
      final Uint8List wav = encoder.encode(samples);

      expect(wav.length, 44 + samples.length * 2);
      expect(_ascii(wav, 0, 4), 'RIFF');
      expect(_ascii(wav, 8, 4), 'WAVE');
      expect(_ascii(wav, 12, 4), 'fmt ');
      expect(_ascii(wav, 36, 4), 'data');

      final ByteData data = ByteData.sublistView(wav);
      expect(data.getUint32(24, Endian.little), 8000);
      expect(data.getUint16(22, Endian.little), 1);
      expect(data.getUint16(34, Endian.little), 16);
      expect(data.getUint32(40, Endian.little), samples.length * 2);
    });

    test('convierte muestras a PCM16 con saturación', () {
      const WavEncoder encoder = WavEncoder();
      final Uint8List wav = encoder.encode(
        Float64List.fromList(<double>[1, -1, 2, -2]),
      );
      final ByteData data = ByteData.sublistView(wav);
      expect(data.getInt16(44, Endian.little), greaterThan(32000));
      expect(data.getInt16(46, Endian.little), lessThan(-32000));
      expect(data.getInt16(48, Endian.little), 32767);
      expect(data.getInt16(50, Endian.little), -32767);
    });
  });
}

/// Lee un bloque de texto ASCII de la cabecera.
String _ascii(Uint8List bytes, int offset, int length) =>
    String.fromCharCodes(bytes.sublist(offset, offset + length));
