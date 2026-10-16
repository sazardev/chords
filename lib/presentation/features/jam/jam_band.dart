import 'dart:math' as math;

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/band_audio_repository.dart';
import 'package:chords/domain/band/clock/tick.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

/// Retraso a partir del cual un golpe se da por perdido y no suena.
const Duration kStaleTolerance = Duration(milliseconds: 90);

/// Milisegundos de desvío de tiempo con la humanización al máximo.
const double kHumanizeMs = 9;

/// Margen con el que se avisa antes del golpe para poder humanizar hacia
/// atrás y hacia delante.
Duration humanizeLead(double humanize) =>
    Duration(microseconds: (humanize * kHumanizeMs * 1000).round());

/// La "banda" del jam: convierte los golpes que escribe el director en
/// sonido.
///
/// Responsabilidad única: preparar las muestras, aplicar la mezcla (canales
/// activos y volúmenes), la humanización y mandar cada golpe al audio en su
/// instante.
class JamBand {
  /// Crea la banda sobre el audio de la banda (puede faltar: sin sonido) y el
  /// banco de acordes.
  JamBand(this._audio, this._chords, {math.Random? random})
    : _random = random ?? math.Random(17);

  final BandAudioRepository? _audio;
  final ChordRepository _chords;
  final math.Random _random;

  /// Acorde del banco para una cifra.
  Chord? chordOf(ChordSymbol symbol) => _chords.chordById(symbol.chordId);

  /// Prepara las muestras de [arranger]: primero las de los canales
  /// encendidos (esperando a que estén listas) y después, sin esperar, las de
  /// los silenciados por si se encienden en caliente.
  ///
  /// Si el audio falla, lo registra y sigue: la sesión corre en silencio.
  Future<void> prepare(
    BandArranger arranger,
    BandConfig config, {
    void Function(double progress)? onProgress,
  }) async {
    final BandAudioRepository? audio = _audio;
    if (audio == null) {
      onProgress?.call(1);
      return;
    }
    final List<BandSound> all = arranger.sounds();
    // La cuenta atrás suena aunque el metrónomo esté apagado.
    bool first(BandSound s) =>
        config.isOn(s.channel) || s.channel == BandChannel.click;
    try {
      await audio.preload(all.where(first), onProgress: onProgress);
      await audio.preload(all.where((BandSound s) => !first(s)));
    } on Object catch (error, stackTrace) {
      appLogger.warning(
        'jam: no se pudo preparar la banda',
        channel: LogChannel.audio,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Carga en segundo plano lo que falte tras un cambio en caliente.
  Future<void> topUp(BandArranger arranger) async =>
      _audio?.preload(arranger.sounds());

  /// Toca los [events] de la semicorchea [tick].
  ///
  /// [force] toca aunque el canal esté silenciado (el clic de la cuenta
  /// atrás). Cada canal desvía su golpe un poco distinto con la
  /// humanización; el clic nunca.
  void play(
    List<BandEvent> events,
    Tick tick,
    BandConfig config, {
    required Duration lead,
    bool force = false,
  }) {
    final BandAudioRepository? audio = _audio;
    if (audio == null || tick.isStale(kStaleTolerance)) {
      return;
    }
    final Map<BandChannel, double> shift = <BandChannel, double>{};
    for (final BandEvent event in events) {
      final BandChannel channel = event.channel;
      if (!force && !config.isOn(channel)) {
        continue;
      }
      final double jitter = shift.putIfAbsent(
        channel,
        () => channel == BandChannel.click ? 0 : _signed() * kHumanizeMs,
      );
      final Duration delay = Duration(
        microseconds:
            lead.inMicroseconds -
            tick.lateness.inMicroseconds +
            (jitter * config.humanize * 1000).round(),
      );
      audio.play(
        event.sound,
        volume: _volume(event, config, force: force),
        delay: delay.isNegative ? Duration.zero : delay,
      );
    }
  }

  /// Canales que suenan de verdad en [events] con la mezcla de [config].
  Set<BandChannel> audible(List<BandEvent> events, BandConfig config) =>
      <BandChannel>{
        for (final BandEvent event in events)
          if (config.isOn(event.channel)) event.channel,
      };

  /// Calla un canal (o toda la banda) con un fundido.
  void silence({BandChannel? channel}) => _audio?.silence(channel: channel);

  double _volume(BandEvent event, BandConfig config, {required bool force}) {
    final double humanized =
        event.velocity * (1 + _signed() * 0.1 * config.humanize);
    final double mix = force && !config.isOn(event.channel)
        ? 0.6
        : config.mixOf(event.channel).volume;
    return (humanized * mix).clamp(0.0, 1.0);
  }

  /// Número aleatorio entre -1 y 1.
  double _signed() => _random.nextDouble() * 2 - 1;
}
