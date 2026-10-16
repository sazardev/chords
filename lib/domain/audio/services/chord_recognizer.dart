import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/services/bass_tracker.dart';
import 'package:chords/domain/audio/services/chord_matcher.dart';
import 'package:chords/domain/audio/services/chord_stabilizer.dart';
import 'package:chords/domain/audio/services/chroma_extractor.dart';
import 'package:chords/domain/audio/services/chroma_smoother.dart';
import 'package:chords/domain/audio/services/signal_level.dart';

/// Reconocedor polifónico de acordes sobre un flujo de muestras.
///
/// Guarda las últimas [fftSize] muestras en un anillo y, cada [hopSeconds],
/// las pasa por el cromagrama, el suavizado temporal, las plantillas y el
/// estabilizador. El tiempo lo marcan las muestras recibidas (no el reloj),
/// así que el resultado es idéntico venga el audio en bloques de 20 ms o de
/// un segundo, y los tests son deterministas.
///
/// La puerta de ruido mira el nivel de los últimos ~200 ms: por debajo de
/// [silenceRms] no se intenta reconocer nada y se emite una lectura de
/// silencio.
class ChordRecognizer {
  /// Crea el reconocedor.
  ChordRecognizer({
    required this.sampleRate,
    this.fftSize = 16384,
    this.hopSeconds = 0.1,
    this.silenceRms = 0.004,
    ChromaExtractor? extractor,
    ChordMatcher? matcher,
    ChordStabilizer? stabilizer,
  }) : _extractor =
           extractor ??
           ChromaExtractor(sampleRate: sampleRate, fftSize: fftSize),
       _matcher = matcher ?? ChordMatcher(),
       _stabilizer = stabilizer ?? ChordStabilizer(),
       _hop = (sampleRate * hopSeconds).round(),
       _ring = Float64List(fftSize),
       _frame = Float64List(fftSize);

  /// Frecuencia de muestreo del audio.
  final int sampleRate;

  /// Muestras analizadas por trama (potencia de dos).
  final int fftSize;

  /// Segundos entre dos análisis.
  final double hopSeconds;

  /// RMS por debajo del cual se considera silencio (≈ -46 dBFS).
  final double silenceRms;

  /// Cuántas lecturas de silencio seguidas hacen olvidar lo acumulado.
  static const int _forgetAfterSilentFrames = 3;

  /// Relación de energía entre dos tramas que se toma por un ataque nuevo.
  static const double _onsetRatio = 1.8;

  final ChromaExtractor _extractor;
  final ChordMatcher _matcher;
  final ChordStabilizer _stabilizer;
  final ChromaSmoother _smoother = ChromaSmoother();
  final BassTracker _bassTracker = BassTracker();
  final int _hop;
  final Float64List _ring;
  final Float64List _frame;
  int _write = 0;
  int _sinceHop = 0;
  int _silentFrames = 0;
  double _previousRms = 0;

  /// Olvida el audio y lo aprendido (al cerrar el micrófono o la puerta).
  void reset() {
    _ring.fillRange(0, fftSize, 0);
    _write = 0;
    _sinceHop = 0;
    _silentFrames = 0;
    _previousRms = 0;
    _smoother.reset();
    _bassTracker.reset();
    _stabilizer.reset();
    _extractor.reset();
  }

  /// Añade muestras (-1..1) y devuelve las lecturas que completan (0 o más).
  List<ChordReading> addSamples(Float64List samples) {
    List<ChordReading>? readings;
    int offset = 0;
    while (offset < samples.length) {
      final int take = math.min(samples.length - offset, _hop - _sinceHop);
      _push(samples, offset, take);
      offset += take;
      _sinceHop += take;
      if (_sinceHop >= _hop) {
        _sinceHop = 0;
        (readings ??= <ChordReading>[]).add(_analyze());
      }
    }
    return readings ?? const <ChordReading>[];
  }

  void _push(Float64List samples, int offset, int count) {
    for (int i = 0; i < count; i++) {
      _ring[_write] = samples[offset + i];
      _write = (_write + 1) % fftSize;
    }
  }

  ChordReading _analyze() {
    final int recent = math.min(fftSize, _hop * 2);
    final double rms = _recentRms(recent);
    final double level = levelOfRms(rms);
    final double previous = _previousRms;
    _previousRms = rms;
    if (rms < silenceRms) {
      return _silence(level);
    }
    _silentFrames = 0;
    _copyFrame();
    _extractor.extract(_frame);
    _smoother.update(
      _extractor.chroma,
      onset: previous > 0 && rms > previous * _onsetRatio,
    );
    _bassTracker.update(_extractor.bass);
    return _read(level);
  }

  /// RMS de las últimas [count] muestras del anillo.
  double _recentRms(int count) {
    double energy = 0;
    for (int i = 1; i <= count; i++) {
      final double sample = _ring[(_write - i + fftSize) % fftSize];
      energy += sample * sample;
    }
    return count == 0 ? 0 : math.sqrt(energy / count);
  }

  /// Copia el anillo en orden cronológico a la trama de análisis.
  void _copyFrame() {
    final int tail = fftSize - _write;
    _frame.setRange(0, tail, _ring, _write);
    _frame.setRange(tail, fftSize, _ring, 0);
  }

  ChordReading _silence(double level) {
    _silentFrames++;
    if (_silentFrames >= _forgetAfterSilentFrames) {
      _smoother.reset();
      _bassTracker.reset();
    }
    _stabilizer.update(const <ChordCandidate>[]);
    return ChordReading(
      chroma: ChordReading.silence.chroma,
      candidates: const <ChordCandidate>[],
      level: level,
      isSilent: true,
    );
  }

  /// Cromagrama para mostrar: el suavizado, con la nota más fuerte a 1.
  List<double> _displayChroma() {
    double top = 0;
    for (final double value in _smoother.value) {
      top = math.max(top, value);
    }
    return List<double>.unmodifiable(<double>[
      for (final double value in _smoother.value)
        if (top > 0) value / top else 0.0,
    ]);
  }

  ChordReading _read(double level) {
    final int bass = _bassTracker.bass;
    final List<ChordCandidate> ranked = _matcher.rank(_smoother.value, bass);
    final ChordCandidate? chord = _stabilizer.update(ranked);
    return ChordReading(
      chroma: _displayChroma(),
      candidates: ranked,
      chord: chord,
      bass: bass < 0 ? null : bass,
      level: level,
    );
  }
}
