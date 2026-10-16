import 'dart:typed_data';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/audio/soloud_bootstrap.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Motor que carga muestras y las reproduce (SoLoud en la app; un doble en
/// las pruebas).
abstract interface class BandVoiceEngine {
  /// Deja el motor listo para reproducir.
  Future<void> ensureReady();

  /// Carga un WAV en memoria y devuelve su identificador opaco.
  Future<Object> load(String name, Uint8List wav);

  /// Toca [source] y devuelve el manejador de la voz.
  ///
  /// Con [loopStart] la voz se repite desde ese punto hasta que se corte.
  int play(Object source, {required double volume, Duration? loopStart});

  /// Baja la voz [handle] a cero en [fade] y la detiene.
  void fadeOut(int handle, Duration fade);

  /// Libera una muestra cargada.
  Future<void> unload(Object source);
}

/// Número de voces simultáneas que mezcla el motor: una banda con platos
/// largos y acordes sostenidos pasa de las 16 de serie.
const int kBandVoices = 40;

/// Implementación de [BandVoiceEngine] sobre SoLoud.
class SoLoudBandEngine implements BandVoiceEngine {
  /// Crea el motor.
  SoLoudBandEngine();

  bool _tuned = false;

  @override
  Future<void> ensureReady() async {
    await ensureSoLoudReady();
    if (!_tuned) {
      SoLoud.instance.setMaxActiveVoiceCount(kBandVoices);
      _tuned = true;
    }
  }

  @override
  Future<Object> load(String name, Uint8List wav) =>
      SoLoud.instance.loadMem(name, wav);

  @override
  int play(Object source, {required double volume, Duration? loopStart}) {
    final SoundHandle handle = SoLoud.instance.play(
      source as AudioSource,
      volume: volume,
      looping: loopStart != null,
      loopingStartAt: loopStart ?? Duration.zero,
    );
    return handle.id;
  }

  @override
  void fadeOut(int handle, Duration fade) {
    try {
      final SoundHandle target = SoundHandle(handle);
      if (!SoLoud.instance.getIsValidVoiceHandle(target)) {
        return;
      }
      SoLoud.instance
        ..fadeVolume(target, 0, fade)
        ..scheduleStop(target, fade);
    } on Object catch (error) {
      appLogger.debug(
        'banda: la voz $handle ya había terminado ($error)',
        channel: LogChannel.audio,
      );
    }
  }

  @override
  Future<void> unload(Object source) async {
    try {
      await SoLoud.instance.disposeSource(source as AudioSource);
    } on Object catch (error) {
      appLogger.debug(
        'banda: no se pudo liberar una muestra ($error)',
        channel: LogChannel.audio,
      );
    }
  }
}
