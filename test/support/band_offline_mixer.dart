import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/band_sound_renderer.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/rendered_sound.dart';
import 'package:chords/domain/band/clock/monotonic_clock.dart';
import 'package:chords/domain/band/clock/tick_scheduler.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/jam/jam_track.dart';

class _ZeroClock implements MonotonicClock {
  @override
  Duration get now => Duration.zero;
}

/// Una voz ya colocada en el tiempo de la mezcla.
class _Voice {
  _Voice(this.rendered, this.start, this.gain);

  final RenderedSound rendered;
  final int start;
  final double gain;
  int? cutAt;
}

/// Resultado de mezclar una pista entera sin pasar por el motor de audio.
class OfflineMix {
  /// Crea el resultado.
  OfflineMix(this.samples, this.renderMillis);

  /// Mezcla mono.
  final Float64List samples;

  /// Milisegundos que costó sintetizar las muestras.
  final int renderMillis;

  /// Pico absoluto.
  double get peak =>
      samples.fold<double>(0, (double m, double v) => math.max(m, v.abs()));

  /// Nivel RMS global.
  double get rms {
    double energy = 0;
    for (final double v in samples) {
      energy += v * v;
    }
    return math.sqrt(energy / math.max(1, samples.length));
  }
}

/// Mezcla [bars] compases de [track] como lo haría la banda: mismas notas,
/// mismo swing, cortes entre notas del mismo grupo y volúmenes de [config].
OfflineMix mixTrack(
  JamTrack track,
  BandConfig config, {
  int? bars,
  double masterGain = 1,
}) {
  final BandArranger arranger = BandArranger(track, config);
  final int count = math.min(bars ?? track.bars.length, track.bars.length);
  final Stopwatch clock = Stopwatch()..start();
  final Map<String, RenderedSound> cache = <String, RenderedSound>{};
  for (final BandSound sound in arranger.sounds()) {
    cache[sound.key] = renderBandSound(sound);
  }
  final int renderMillis = clock.elapsedMilliseconds;

  final TickScheduler timing =
      TickScheduler(
          onTick: (_) {},
          clock: _ZeroClock(),
          timerFactory: Timer.new,
        )
        ..start(bpm: track.bpm, swing: arranger.swing, grid: arranger.swingGrid)
        ..stop();

  final List<_Voice> voices = <_Voice>[];
  final Map<String, _Voice> groups = <String, _Voice>{};
  final int steps = track.stepsPerBar;
  for (int tick = 0; tick < count * steps; tick++) {
    final int at =
        timing.scheduledAt(tick).inMicroseconds * kBandRate ~/ 1000000;
    for (final BandEvent event in arranger.eventsAt(
      tick ~/ steps,
      tick % steps,
    )) {
      if (!config.isOn(event.channel)) {
        continue;
      }
      final String? group = event.sound.chokeGroup;
      final _Voice? previous = group == null ? null : groups[group];
      previous?.cutAt = at;
      final _Voice voice = _Voice(
        cache[event.sound.key]!,
        at,
        event.velocity * config.mixOf(event.channel).volume * masterGain,
      );
      voices.add(voice);
      if (group != null) {
        groups[group] = voice;
      }
    }
  }
  const int tail = kBandRate * 2;
  final int total =
      timing.scheduledAt(count * steps).inMicroseconds * kBandRate ~/ 1000000 +
      tail;
  final Float64List mix = Float64List(total);
  const int fade = 800;
  for (final _Voice voice in voices) {
    _add(mix, voice, fade);
  }
  return OfflineMix(mix, renderMillis);
}

void _add(Float64List mix, _Voice voice, int fade) {
  final Float64List s = voice.rendered.samples;
  final int? loop = voice.rendered.loopStart;
  final int end =
      voice.cutAt ??
      (loop == null ? voice.start + s.length : voice.start + s.length * 3);
  for (int i = voice.start; i < math.min(end, mix.length); i++) {
    final int n = i - voice.start;
    final double sample = loop == null || n < s.length
        ? (n < s.length ? s[n] : 0)
        : s[loop + (n - loop) % (s.length - loop)];
    double gain = voice.gain;
    if (voice.cutAt != null && end - i < fade) {
      gain *= (end - i) / fade;
    }
    mix[i] += sample * gain;
  }
}
