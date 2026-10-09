import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';

/// Servicio de captura de micrófono basado en el paquete `record`.
///
/// Abstrae el formato (PCM16 mono) usado por el detector de tono.
class MicrophoneStreamService {
  /// Crea el servicio de captura.
  MicrophoneStreamService({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  StreamSubscription<Uint8List>? _subscription;

  /// Inicia la captura y devuelve el flujo de bytes PCM16.
  Future<Stream<Uint8List>> start({int sampleRate = 44100}) async {
    final bool permitted = await _recorder.hasPermission();
    if (!permitted) {
      throw StateError('Permiso de micrófono denegado');
    }
    return _recorder.startStream(
      RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: sampleRate,
        numChannels: 1,
      ),
    );
  }

  /// Detiene la captura y libera el micrófono.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _recorder.stop();
    await _recorder.dispose();
  }
}
