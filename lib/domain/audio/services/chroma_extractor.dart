import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/domain/audio/services/fft.dart';
import 'package:chords/domain/audio/services/hann_window.dart';
import 'package:chords/domain/audio/services/note_dictionary.dart';
import 'package:chords/domain/audio/services/note_solver.dart';
import 'package:chords/domain/audio/services/spectral_peak_picker.dart';
import 'package:chords/domain/audio/services/spectral_peaks.dart';
import 'package:chords/domain/audio/services/tuning_estimator.dart';

/// Convierte una trama de audio en un cromagrama de 12 notas.
///
/// Pasos: ventana de Hann → FFT → picos del espectro entre 70 y 2000 Hz →
/// desviación de afinación común → notas que explican los picos
/// ([NoteSolver], con sus armónicos) → suma de cada nota en su clase, con una
/// compresión de potencia para que una nota suave pese casi como una fuerte.
/// Todos los arrays se reservan en el constructor: [extract] no asigna
/// memoria.
class ChromaExtractor {
  /// Crea el extractor para [sampleRate] y tramas de [fftSize] muestras.
  ChromaExtractor({
    required this.sampleRate,
    this.fftSize = 16384,
    this.exponent = 0.7,
    this.octaveWeight = 0.25,
    this.picker = const SpectralPeakPicker(),
    NoteSolver? solver,
  }) : solver = solver ?? NoteSolver(),
       _fft = Fft(fftSize),
       _window = HannWindow(fftSize),
       _re = Float64List(fftSize),
       _im = Float64List(fftSize),
       _power = Float64List(fftSize ~/ 2 + 1);

  /// Frecuencia de muestreo del audio.
  final int sampleRate;

  /// Muestras por trama (potencia de dos).
  final int fftSize;

  /// Exponente de la compresión de potencia de cada nota (menos = más plano).
  final double exponent;

  /// Peso (0-1) de las notas de otras octavas de la misma clase: 0 cuenta solo
  /// la más fuerte y 1 las suma todas. Un acorde con tres Do y un solo Mi no
  /// debe dejar al Mi diez veces más bajo.
  final double octaveWeight;

  /// Buscador de picos del espectro.
  final SpectralPeakPicker picker;

  /// Resolutor de notas a partir de los picos.
  final NoteSolver solver;

  final Fft _fft;
  final HannWindow _window;
  final Float64List _re;
  final Float64List _im;
  final Float64List _power;
  final SpectralPeaks _peaks = SpectralPeaks();
  final TuningEstimator _tuning = TuningEstimator();
  final Float64List _strongest = Float64List(12);

  /// Energía de cada nota (0 = Do) de la última trama, sin normalizar.
  final Float64List chroma = Float64List(12);

  /// Nota (0-11) del sonido más grave de la última trama; -1 si no hay.
  int bass = -1;

  /// Desviación de afinación estimada (cents, -50..50).
  double get tuningCents => _tuning.cents;

  /// Picos de la última trama (para diagnóstico y tests).
  SpectralPeaks get peaks => _peaks;

  /// Olvida la afinación estimada.
  void reset() => _tuning.reset();

  /// Calcula el cromagrama de [frame] (de [fftSize] muestras).
  void extract(Float64List frame) {
    _window.apply(frame, _re);
    _im.fillRange(0, fftSize, 0);
    _fft.transform(_re, _im);
    for (int k = 0; k < _power.length; k++) {
      _power[k] = _re[k] * _re[k] + _im[k] * _im[k];
    }
    picker.pick(_power, sampleRate / fftSize, _peaks);
    _tuning.update(_peaks.midi, _peaks.amplitude, _lowPeakCount());
    solver.solve(_peaks, _tuning.cents);
    _accumulate();
    bass = _findBass();
  }

  /// Picos por debajo de 700 Hz: los que mejor reflejan la afinación.
  int _lowPeakCount() {
    int count = 0;
    while (count < _peaks.count && _peaks.frequency[count] <= 700) {
      count++;
    }
    return count;
  }

  /// Suma las notas de cada clase: la más fuerte entera y las demás
  /// octavas con [octaveWeight].
  void _accumulate() {
    chroma.fillRange(0, 12, 0);
    _strongest.fillRange(0, 12, 0);
    final NoteDictionary d = solver.dictionary;
    for (int n = 0; n < d.noteCount; n++) {
      final int pitchClass = d.pitchClassOf(n);
      final double value = math.pow(_noteLevel(n), exponent).toDouble();
      chroma[pitchClass] += value;
      _strongest[pitchClass] = math.max(_strongest[pitchClass], value);
    }
    for (int i = 0; i < 12; i++) {
      chroma[i] = _strongest[i] + octaveWeight * (chroma[i] - _strongest[i]);
    }
  }

  /// Cuánto suena la nota [note]: suma de sus columnas (formas de timbre).
  double _noteLevel(int note) {
    final int shapes = solver.dictionary.shapes.length;
    double total = 0;
    for (int s = 0; s < shapes; s++) {
      total += solver.activation[note * shapes + s];
    }
    return total;
  }

  /// Nota más grave con cuerpo suficiente (el bajo del acorde).
  int _findBass() {
    final NoteDictionary d = solver.dictionary;
    double top = 0;
    for (int n = 0; n < d.noteCount; n++) {
      top = math.max(top, _noteLevel(n));
    }
    for (int n = 0; n < d.noteCount; n++) {
      if (top > 0 && _noteLevel(n) >= top * 0.25) {
        return d.pitchClassOf(n);
      }
    }
    return -1;
  }
}
