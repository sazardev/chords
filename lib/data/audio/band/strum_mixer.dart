import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/guitar_string_voice.dart';

/// Pulsación de un conjunto de cuerdas: qué notas, con cuánta fuerza y en qué
/// punto de la cuerda.
class StrumSpec {
  /// Crea la pulsación.
  const StrumSpec({
    required this.notes,
    required this.seconds,
    this.spacingMs = 8,
    this.velocity = 0.85,
    this.pickPosition = 0.13,
    this.seed = 7,
  });

  /// Notas MIDI en el orden en que se tocan (la primera suena primero).
  final List<int> notes;

  /// Duración del búfer.
  final double seconds;

  /// Milisegundos entre una cuerda y la siguiente.
  final double spacingMs;

  /// Fuerza de la púa (0-1): más fuerte, más brillante.
  final double velocity;

  /// Punto de pulsación como fracción de la cuerda.
  final double pickPosition;

  /// Semilla del ruido de la excitación.
  final int seed;
}

/// Suma [strum.notes] como cuerdas Karplus-Strong escalonadas.
///
/// Cada cuerda se iguala en nivel antes de sumarse, para que ninguna tape a
/// las demás solo por cómo se generó su ruido, y la púa pierde algo de fuerza
/// cuerda a cuerda, como en un rasgueo real. Con [startAt] el golpe empieza
/// unas muestras más tarde (para encadenar varios rasgueos).
void addStrum(Float64List out, StrumSpec strum, {int startAt = 0}) {
  const GuitarStringVoice voice = GuitarStringVoice();
  final int total = math.min(out.length - startAt, samplesOf(strum.seconds));
  for (int order = 0; order < strum.notes.length; order++) {
    final int offset = startAt + samplesOf(order * strum.spacingMs / 1000);
    if (offset >= out.length) {
      break;
    }
    final int midi = strum.notes[order];
    final Float64List string = voice.render(
      midiHz(midi),
      math.max(1, total - (offset - startAt)),
      velocity: (strum.velocity - 0.03 * order).clamp(0.3, 1.0),
      pickPosition: strum.pickPosition + 0.015 * (midi % 3),
      seed: strum.seed + midi * 31,
    );
    final double scale = 1 / math.max(1e-9, _rms(string));
    final double weight = order < 3 ? 1 : 0.85;
    for (int i = 0; i < string.length && i + offset < out.length; i++) {
      out[i + offset] += string[i] * scale * weight;
    }
  }
}

/// Nivel RMS de los primeros 0,4 s.
double _rms(Float64List samples) {
  final int count = math.min(samples.length, samplesOf(0.4));
  double energy = 0;
  for (int i = 0; i < count; i++) {
    energy += samples[i] * samples[i];
  }
  return math.sqrt(energy / math.max(1, count));
}

/// Multiplica [samples] por una caída exponencial de constante [tau].
void applyDecay(Float64List samples, double tau) {
  for (int i = 0; i < samples.length; i++) {
    samples[i] *= decayAt(i / kBandRate, tau);
  }
}
