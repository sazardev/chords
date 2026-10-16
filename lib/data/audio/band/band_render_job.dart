import 'dart:typed_data';

import 'package:chords/data/audio/band/band_sound_renderer.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/rendered_sound.dart';
import 'package:chords/data/audio/wav_encoder.dart';
import 'package:chords/domain/audio/services/playback_echo_gate.dart';
import 'package:chords/domain/band/entities/band_sound.dart';

/// Una muestra ya codificada en WAV, lista para cargar en el motor.
class EncodedSound {
  /// Crea la muestra codificada.
  const EncodedSound({
    required this.key,
    required this.wav,
    required this.audible,
    this.loopStart,
  });

  /// Clave de caché del sonido.
  final String key;

  /// Archivo WAV (16 bits, mono).
  final Uint8List wav;

  /// Duración audible (para la puerta de eco).
  final Duration audible;

  /// Instante en que empieza el bucle; `null` si suena una sola vez.
  final Duration? loopStart;
}

/// Sintetiza y codifica un lote de sonidos.
///
/// Es una función de nivel superior sin estado para poder correr en un
/// isolate (`compute`): lo pesado de la precarga ocurre fuera del hilo de la
/// interfaz.
List<EncodedSound> renderBatch(List<BandSound> sounds) {
  const WavEncoder encoder = WavEncoder();
  return <EncodedSound>[
    for (final BandSound sound in sounds) _encode(encoder, sound),
  ];
}

EncodedSound _encode(WavEncoder encoder, BandSound sound) {
  final RenderedSound rendered = renderBandSound(sound);
  final int? loop = rendered.loopStart;
  return EncodedSound(
    key: sound.key,
    wav: encoder.encode(rendered.samples),
    audible: loop != null
        ? const Duration(seconds: 2)
        : PlaybackEchoGate.audibleLength(rendered.samples, kBandRate),
    loopStart: loop == null
        ? null
        : Duration(microseconds: loop * 1000000 ~/ kBandRate),
  );
}
