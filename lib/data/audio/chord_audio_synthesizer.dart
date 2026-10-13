import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/guitar_body.dart';
import 'package:chords/data/audio/guitar_string_voice.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Sintetizador de guitarra para posiciones de acorde, notas y arpegios.
///
/// Cada cuerda es una voz Karplus-Strong afinada al cent ([GuitarStringVoice]);
/// las cuerdas se suman con un rasgueo escalonado (de la grave a la aguda, con
/// una pizca de irregularidad humana), pasan por la caja de resonancia
/// ([GuitarBody]) y se igualan en volumen con un limitador suave, de modo que
/// una nota suelta, un acorde y un arpegio suenan igual de fuertes y sin
/// recortes.
class ChordAudioSynthesizer {
  /// Crea el sintetizador.
  const ChordAudioSynthesizer({this.sampleRate = 44100});

  /// Afinación estándar (valores MIDI): E2 A2 D3 G3 B3 E4.
  static const List<int> stringTuning = <int>[40, 45, 50, 55, 59, 64];

  /// Frecuencia de muestreo.
  final int sampleRate;

  /// Nivel RMS al que se igualan todos los sonidos (≈ -16 dBFS).
  static const double _targetRms = 0.16;

  /// Tope del limitador suave.
  static const double _ceiling = 0.92;

  /// Milisegundos entre una cuerda y la siguiente en un rasgueo.
  static const int _strumMs = 13;

  /// Sintetiza la posición indicada y devuelve muestras normalizadas.
  ///
  /// [duration] controla la duración total y [offsetsMs] el retardo de cada
  /// cuerda (rasgueo o arpegio); sin él, un rasgueo hacia abajo.
  Float64List synthesize(
    ChordVariant variant, {
    double duration = 2.5,
    List<int?>? offsetsMs,
  }) {
    final int total = (sampleRate * duration).round();
    final Float64List mix = Float64List(total);
    final List<int?> offsets = offsetsMs ?? _strumOffsets(variant.frets);
    const GuitarStringVoice voice = GuitarStringVoice();
    int order = 0;
    for (int s = 0; s < variant.frets.length && s < stringTuning.length; s++) {
      final int fret = variant.frets[s];
      final int? offsetMs = offsets[s];
      if (fret < 0 || offsetMs == null) {
        continue;
      }
      final int offset = (offsetMs * sampleRate / 1000).round();
      if (offset >= total) {
        continue;
      }
      final double frequency = midiToFrequency(stringTuning[s] + fret);
      final Float64List string = voice.render(
        frequency,
        total - offset,
        velocity: (0.92 - 0.04 * order).clamp(0.6, 1.0),
        pickPosition: 0.12 + 0.02 * (s % 3),
        seed: 7 + stringTuning[s] + fret * 31,
      );
      _mixIn(mix, string, offset, s < 3 ? 1.0 : 0.82);
      order++;
    }
    return _master(mix);
  }

  /// Sintetiza una sola cuerda a [frequency] (nota de referencia).
  Float64List synthesizeNote(double frequency, {double duration = 2.2}) {
    final int total = (sampleRate * duration).round();
    final Float64List note = const GuitarStringVoice().render(
      frequency,
      total,
      pickPosition: 0.13,
      seed: 7 + frequency.round(),
    );
    return _master(Float64List.fromList(note));
  }

  /// Sintetiza un arpegio: cada cuerda suena según el orden del patrón.
  Float64List synthesizeArpeggio(
    ChordVariant variant,
    List<int> stringOrder,
    int intervalMs, {
    double duration = 3,
  }) {
    final List<int?> offsets = List<int?>.filled(stringTuning.length, null);
    for (int step = 0; step < stringOrder.length; step++) {
      final int stringIndex = stringOrder[step];
      if (stringIndex < 0 || stringIndex >= offsets.length) {
        continue;
      }
      offsets[stringIndex] = step * intervalMs;
    }
    return synthesize(variant, duration: duration, offsetsMs: offsets);
  }

  /// Retardos de un rasgueo hacia abajo: la primera cuerda que suena arranca
  /// en 0 y cada una siguiente llega unos milisegundos después, con un ligero
  /// desorden fijo para que no suene a máquina.
  List<int?> _strumOffsets(List<int> frets) {
    final List<int?> offsets = List<int?>.filled(frets.length, null);
    int order = 0;
    for (int s = 0; s < frets.length; s++) {
      if (frets[s] < 0) {
        continue;
      }
      final int jitter = order == 0 ? 0 : ((s * 7 + frets[s] * 3) % 5) - 2;
      offsets[s] = math.max(0, order * _strumMs + jitter);
      order++;
    }
    return offsets;
  }

  /// Suma [voice] a [mix] desde [offset] con ganancia [weight].
  ///
  /// Cada voz se iguala antes a un mismo nivel, para que ninguna cuerda tape
  /// a las demás solo por cómo se generó su ruido.
  void _mixIn(Float64List mix, Float64List voice, int offset, double weight) {
    final double scale = weight / math.max(1e-9, _rms(voice, 0.4));
    for (int i = 0; i < voice.length && i + offset < mix.length; i++) {
      mix[i + offset] += voice[i] * scale;
    }
  }

  /// Caja, nivel, limitador y fundidos: lo que convierte la mezcla en sonido.
  Float64List _master(Float64List mix) {
    final Float64List body = GuitarBody(sampleRate: sampleRate).process(mix);
    final double gain = _targetRms / math.max(1e-9, _rms(body, 1.2));
    final int fadeIn = (sampleRate * 0.002).round();
    final int fadeOut = (sampleRate * 0.12).round();
    for (int i = 0; i < body.length; i++) {
      double value = _ceiling * _tanh(body[i] * gain / _ceiling);
      if (i < fadeIn) {
        value *= i / fadeIn;
      }
      final int fromEnd = body.length - 1 - i;
      if (fromEnd < fadeOut) {
        value *= fromEnd / fadeOut;
      }
      body[i] = value;
    }
    return body;
  }

  /// Nivel RMS de los primeros [seconds] segundos de [samples].
  double _rms(Float64List samples, double seconds) {
    final int count = math.min(samples.length, (sampleRate * seconds).round());
    if (count == 0) {
      return 0;
    }
    double energy = 0;
    for (int i = 0; i < count; i++) {
      energy += samples[i] * samples[i];
    }
    return math.sqrt(energy / count);
  }

  double _tanh(double x) {
    final double e = math.exp(2 * x.clamp(-20.0, 20.0));
    return (e - 1) / (e + 1);
  }

  /// Convierte una nota MIDI a frecuencia en Hz.
  static double midiToFrequency(int midi) =>
      440 * math.pow(2, (midi - 69) / 12) as double;
}
