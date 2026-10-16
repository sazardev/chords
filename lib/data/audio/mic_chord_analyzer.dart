import 'dart:async';
import 'dart:typed_data';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/audio/mic_sample_sink.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/services/chord_recognizer.dart';

/// Reconoce acordes polifónicos en el audio del micrófono.
///
/// Es el adaptador entre el flujo de muestras de `MicPitchAnalyzer` y el
/// [ChordRecognizer] del dominio: publica una [ChordReading] cada ~100 ms.
/// Solo trabaja mientras alguien escucha [readings] (el afinador y los juegos
/// no pagan el coste de la FFT) y empieza de cero cada vez que la puerta de
/// eco se cierra o la escucha se retoma.
class MicChordAnalyzer implements MicSampleSink {
  /// Crea el analizador para la frecuencia de muestreo indicada.
  MicChordAnalyzer({required int sampleRate, ChordRecognizer? recognizer})
    : _recognizer = recognizer ?? ChordRecognizer(sampleRate: sampleRate);

  final ChordRecognizer _recognizer;
  final StreamController<ChordReading> _readings =
      StreamController<ChordReading>.broadcast();
  bool _fresh = true;
  int _lastLog = 0;

  /// Lecturas de acorde (con el cromagrama para dibujarlo).
  Stream<ChordReading> get readings => _readings.stream;

  @override
  void addSamples(Float64List samples) {
    if (!_readings.hasListener) {
      _fresh = false;
      return;
    }
    if (!_fresh) {
      _recognizer.reset();
      _fresh = true;
    }
    for (final ChordReading reading in _recognizer.addSamples(samples)) {
      _readings.add(reading);
      _log(reading);
    }
  }

  @override
  void hold() {
    if (_fresh && _readings.hasListener) {
      _recognizer.reset();
      _readings.add(ChordReading.silence);
    }
    _fresh = false;
  }

  @override
  void reset() {
    _recognizer.reset();
    _fresh = true;
    if (_readings.hasListener) {
      _readings.add(ChordReading.silence);
    }
  }

  /// Cierra el flujo.
  Future<void> dispose() => _readings.close();

  void _log(ChordReading reading) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastLog < 500 || reading.chord == null) {
      return;
    }
    _lastLog = now;
    appLogger.debug(
      'micrófono: acorde ${reading.chord!.name} '
      'confianza ${reading.confidence.toStringAsFixed(2)}',
      channel: LogChannel.microphone,
      context: <String, Object?>{
        'chord': reading.chord!.name,
        'confidence': reading.confidence,
        'level': reading.level,
      },
    );
  }
}
