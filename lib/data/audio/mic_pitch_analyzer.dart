import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/audio/pcm_decoder.dart';
import 'package:chords/data/audio/yin_pitch_detector.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';

/// Convierte el flujo PCM del micrófono en lecturas de tono y nivel.
///
/// Mantiene una ventana deslizante de 250 ms, la analiza cada 60 ms con YIN y
/// publica el nivel de entrada aunque no haya tono, para que la interfaz
/// pueda decir "no te oigo" o "toca más fuerte". Por debajo del umbral de
/// ruido no intenta detectar nada.
class MicPitchAnalyzer {
  /// Crea el analizador para la frecuencia de muestreo indicada.
  MicPitchAnalyzer({
    required this.sampleRate,
    this._detector = const PitchDetector(),
    this._decoder = const PcmDecoder(),
    this._clock = _systemClock,
  });

  /// Frecuencia de muestreo del audio entrante.
  final int sampleRate;

  /// RMS mínimo para intentar detectar un tono (≈ -48 dBFS).
  static const double noiseGate = 0.004;

  /// Cada cuántos milisegundos se analiza la ventana.
  static const int _hopMs = 60;

  final PitchDetector _detector;
  final PcmDecoder _decoder;
  final int Function() _clock;
  final StreamController<PitchReading> _readings =
      StreamController<PitchReading>.broadcast();
  final StreamController<double> _levels = StreamController<double>.broadcast();
  final List<double> _window = <double>[];
  int _lastAnalysis = 0;
  int _lastLog = 0;

  static int _systemClock() => DateTime.now().millisecondsSinceEpoch;

  /// Lecturas de tono detectadas.
  Stream<PitchReading> get readings => _readings.stream;

  /// Nivel de entrada normalizado (0-1).
  Stream<double> get levels => _levels.stream;

  /// Procesa un bloque de bytes PCM16 del micrófono.
  void addBytes(Uint8List bytes) {
    _window.addAll(_decoder.decode(bytes));
    final int windowSize = (sampleRate / 4).round();
    if (_window.length > windowSize * 2) {
      _window.removeRange(0, _window.length - windowSize);
    }
    final int now = _clock();
    if (now - _lastAnalysis < _hopMs) {
      return;
    }
    _lastAnalysis = now;
    final int size = math.min(windowSize, _window.length);
    _analyze(Float64List.fromList(_window.sublist(_window.length - size)));
  }

  /// Descarta el audio acumulado (al detener la captura).
  void reset() {
    _window.clear();
    _levels.add(0);
  }

  /// Cierra los flujos.
  Future<void> dispose() async {
    await _readings.close();
    await _levels.close();
  }

  void _analyze(Float64List buffer) {
    final double rms = PitchDetector.rmsOf(buffer);
    final double level = PitchDetector.levelOf(rms);
    _levels.add(level);
    if (rms < noiseGate) {
      return;
    }
    final PitchEstimate? estimate = _detector.estimate(buffer, sampleRate);
    if (estimate == null || estimate.frequency <= 0) {
      return;
    }
    final ({String note, double cents}) nearest = PitchDetector.nearestNote(
      estimate.frequency,
    );
    _log(nearest, estimate.confidence, level);
    _readings.add(
      PitchReading(
        frequency: estimate.frequency,
        note: nearest.note,
        cents: nearest.cents,
        clarity: estimate.confidence,
        level: level,
      ),
    );
  }

  void _log(
    ({String note, double cents}) nearest,
    double confidence,
    double level,
  ) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastLog < 500) {
      return;
    }
    _lastLog = now;
    appLogger.debug(
      'micrófono: ${nearest.note} ${nearest.cents.round()}¢ '
      'confianza ${confidence.toStringAsFixed(2)} '
      'nivel ${level.toStringAsFixed(2)}',
      channel: LogChannel.microphone,
      context: <String, Object?>{
        'note': nearest.note,
        'cents': nearest.cents.round(),
        'confidence': confidence,
        'level': level,
      },
    );
  }
}
