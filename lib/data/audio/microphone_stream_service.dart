import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';

/// Servicio de captura de micrófono basado en el paquete `record`.
///
/// Abstrae el formato (PCM16 mono) usado por el detector de tono. El grabador
/// se reutiliza entre sesiones: [stop] suelta el micrófono sin destruirlo, y
/// [dispose] lo libera de forma definitiva al cerrar la aplicación.
class MicrophoneStreamService {
  /// Crea el servicio de captura.
  MicrophoneStreamService({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  bool _disposed = false;

  /// Inicia la captura y devuelve el flujo de bytes PCM16.
  ///
  /// Si ya había una captura activa, la detiene antes de volver a arrancar.
  Future<Stream<Uint8List>> start({int sampleRate = 44100}) async {
    if (_disposed) {
      throw StateError('Servicio de micrófono liberado');
    }
    await _stopIfRecording();
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

  /// Detiene la captura y suelta el micrófono sin destruir el grabador.
  Future<void> stop() async {
    if (_disposed) {
      return;
    }
    await _stopIfRecording();
  }

  /// Libera el grabador de forma definitiva; el servicio deja de ser usable.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await _stopIfRecording();
    await _recorder.dispose();
  }

  Future<void> _stopIfRecording() async {
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
  }
}
