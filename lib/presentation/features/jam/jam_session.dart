import 'dart:async' show unawaited;

import 'package:chords/domain/band/clock/monotonic_clock.dart';
import 'package:chords/domain/band/clock/tick.dart';
import 'package:chords/domain/band/clock/tick_scheduler.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/jam/jam_timeline.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/presentation/features/jam/band_activity.dart';
import 'package:chords/presentation/features/jam/jam_band.dart';

/// Avisa de la posición de cada semicorchea que llega.
typedef CursorHandler = void Function(JamCursor cursor, Tick tick);

/// El bucle de una sesión de jam: lleva el reloj de semicorcheas, saca de la
/// partitura lo que toca cada instrumento y lo manda a la banda en su hora.
///
/// No sabe de pantalla ni de puntuación; avisa de cada posición a
/// [onCursor] y el controlador del jam hace lo suyo.
class JamSession {
  /// Crea la sesión sobre la banda y el indicador de actividad.
  ///
  /// [clock] y [timerFactory] permiten controlar el tiempo en las pruebas.
  JamSession(
    this._band,
    this.activity, {
    required this.onCursor,
    MonotonicClock? clock,
    TimerFactory? timerFactory,
  }) {
    _scheduler = TickScheduler(
      onTick: _onTick,
      clock: clock,
      timerFactory: timerFactory,
    );
  }

  final JamBand _band;

  /// Indicador de actividad de los instrumentos.
  final BandActivity activity;

  /// Recibe cada posición después de tocar su sonido.
  final CursorHandler onCursor;

  late final TickScheduler _scheduler;
  JamTimeline? _timeline;
  BandArranger? _arranger;
  BandConfig _config = const BandConfig();
  bool _audible = true;

  /// Planificador (para consultar el tempo y la posición).
  TickScheduler get scheduler => _scheduler;

  /// Arranca la sesión desde el principio.
  ///
  /// Con [audible] en `false` (modo puntuar) la banda no suena: el micrófono
  /// de la persona oiría al altavoz.
  void start({
    required JamTrack track,
    required BandArranger arranger,
    required BandConfig config,
    required bool audible,
  }) {
    _timeline = JamTimeline(
      stepsPerBar: track.stepsPerBar,
      bars: track.bars.length,
      countInBars: config.countInBars,
    );
    _audible = audible;
    _arranger = arranger;
    _config = config;
    _scheduler
      ..lead = humanizeLead(config.humanize)
      ..start(bpm: track.bpm, swing: arranger.swing, grid: arranger.swingGrid);
  }

  /// Aplica en caliente un cambio de ajustes: reescribe el arreglo, calla
  /// los canales recién silenciados y carga lo que falte en segundo plano.
  void retune(JamTrack track, BandConfig previous, BandConfig next) {
    final BandArranger arranger = BandArranger(track, next);
    _arranger = arranger;
    _config = next;
    _scheduler
      ..lead = humanizeLead(next.humanize)
      ..setSwing(arranger.swing, arranger.swingGrid);
    for (final BandChannel channel in BandChannel.values) {
      if (previous.isOn(channel) && !next.isOn(channel)) {
        _band.silence(channel: channel);
      }
    }
    unawaited(_band.topUp(arranger));
  }

  /// Cambia el tempo sin saltos.
  void setBpm(int bpm) => _scheduler.setBpm(bpm);

  /// Pausa: el reloj se detiene y la banda calla.
  void pause() {
    _scheduler.pause();
    _band.silence();
    activity.clear();
  }

  /// Reanuda tras una pausa.
  void resume() => _scheduler.resume();

  /// Termina: para el reloj y calla la banda.
  void stop() {
    _scheduler.stop();
    _band.silence();
    activity.clear();
  }

  void _onTick(Tick tick) {
    final JamTimeline? timeline = _timeline;
    final BandArranger? arranger = _arranger;
    if (timeline == null || arranger == null) {
      return;
    }
    final JamCursor cursor = timeline.cursorAt(tick.index);
    if (_audible) {
      _sound(arranger, cursor, tick);
    }
    onCursor(cursor, tick);
  }

  void _sound(BandArranger arranger, JamCursor cursor, Tick tick) {
    final bool counting = cursor.kind == CursorKind.countIn;
    final List<BandEvent> events = switch (cursor.kind) {
      CursorKind.countIn => arranger.clickAt(cursor.step),
      CursorKind.playing => arranger.eventsAt(cursor.bar, cursor.step),
      CursorKind.finished => const <BandEvent>[],
    };
    _band.play(events, tick, _config, lead: _scheduler.lead, force: counting);
    activity.mark(
      counting
          ? <BandChannel>{...events.map((BandEvent e) => e.channel)}
          : _band.audible(events, _config),
    );
  }
}
