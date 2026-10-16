import 'dart:async';

import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/repositories/band_audio_repository.dart';
import 'package:chords/domain/band/clock/monotonic_clock.dart';
import 'package:chords/domain/band/clock/tick.dart';
import 'package:chords/domain/band/clock/tick_scheduler.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_timeline.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/presentation/features/jam/band_activity.dart';
import 'package:chords/presentation/features/jam/band_settings_controller.dart';
import 'package:chords/presentation/features/jam/jam_band.dart';
import 'package:chords/presentation/features/jam/jam_cursor_state.dart';
import 'package:chords/presentation/features/jam/jam_score_keeper.dart';
import 'package:chords/presentation/features/jam/jam_session.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:flutter/foundation.dart';

/// Controlador del jam guiado.
///
/// Lleva el estado de la sesión y la puntuación; el reloj y el sonido de la
/// banda los lleva [JamSession]. En modo acompañar prepara las muestras
/// (con barra de progreso), da la cuenta atrás configurada y toca la banda;
/// en modo puntuar la banda calla y el micrófono califica cada compás.
class JamController extends ChangeNotifier {
  /// Crea el controlador.
  ///
  /// [band] es el audio de la banda (sin él la sesión corre en silencio) y
  /// [settings] sus ajustes. [clock] y [timerFactory] sustituyen el reloj y
  /// los temporizadores en las pruebas.
  JamController(
    AudioRepository audio,
    this._chords,
    StudioProgressController progress, {
    required BandSettingsController settings,
    BandAudioRepository? band,
    MonotonicClock? clock,
    TimerFactory? timerFactory,
  }) : _scoring = JamScoreKeeper(audio, progress),
       _band = JamBand(band, _chords),
       _settings = settings,
       activity = BandActivity() {
    _session = JamSession(
      _band,
      activity,
      onCursor: _onCursor,
      clock: clock,
      timerFactory: timerFactory,
    );
    _config = settings.config;
    settings.addListener(_onSettings);
  }

  final ChordRepository _chords;
  final BandSettingsController _settings;
  final JamScoreKeeper _scoring;
  final JamBand _band;

  /// Qué instrumentos acaban de sonar (para los indicadores de la escena).
  final BandActivity activity;

  late final JamSession _session;
  late BandConfig _config;
  JamState _state = const JamState();
  JamTrack? _baseTrack;
  int _run = 0;

  /// Estado actual.
  JamState get state => _state;

  /// Acorde del banco para una cifra (para dibujar su diagrama).
  Chord? chordOf(ChordSymbol symbol) => _band.chordOf(symbol);

  /// Carga una pista y vuelve a la pantalla de preparación.
  Future<void> load(JamTrack track) async {
    _halt();
    if (!_chords.isLoaded) {
      await _chords.load();
    }
    _baseTrack = track;
    _state = _state.copyWith(
      track: _transposed(track),
      phase: JamPhase.setup,
      bar: 0,
      slot: 0,
      score: const JamScore(),
      clearGrade: true,
      isNewBest: false,
      micProblem: false,
    );
    notifyListeners();
  }

  /// Cambia el modo (solo antes de empezar).
  void setMode(JamMode mode) {
    _state = _state.copyWith(mode: mode);
    notifyListeners();
  }

  /// Cambia el tempo; se aplica también en marcha y sin saltos.
  void setTempo(int bpm) {
    final JamTrack? base = _baseTrack;
    if (base == null) {
      return;
    }
    final int value = bpm.clamp(kJamMinBpm, kJamMaxBpm);
    _baseTrack = base.withBpm(value);
    _state = _state.copyWith(track: _state.track!.withBpm(value));
    _session.setBpm(value);
    notifyListeners();
  }

  /// Prepara la banda y empieza la sesión (con la cuenta atrás elegida).
  Future<void> start() async {
    final JamTrack? base = _baseTrack;
    if (base == null) {
      return;
    }
    _halt();
    final int run = ++_run;
    final JamTrack track = _transposed(base);
    _config = _settings.config;
    final BandArranger arranger = BandArranger(track, _config);
    final bool audible = _state.mode == JamMode.backing;
    _state = _state.copyWith(
      track: track,
      phase: JamPhase.loading,
      loadProgress: 0,
      bar: 0,
      slot: 0,
      countdown: 0,
      score: const JamScore(),
      clearGrade: true,
      isNewBest: false,
      micProblem: false,
    );
    notifyListeners();
    if (audible) {
      await _band.prepare(arranger, _config, onProgress: _loading(run));
    } else if (!await _scoring.open()) {
      _state = _state.copyWith(micProblem: true);
    }
    if (run != _run) {
      return;
    }
    final bool counting = _config.countInBars > 0;
    _state = _state.copyWith(
      phase: counting ? JamPhase.countIn : JamPhase.playing,
      countdown: counting ? track.strum.beatsPerBar * _config.countInBars : 0,
    );
    notifyListeners();
    _session.start(
      track: track,
      arranger: arranger,
      config: _config,
      audible: audible,
    );
  }

  /// Pausa o reanuda.
  void togglePause() {
    if (_state.phase == JamPhase.playing) {
      _session.pause();
      _scoring.hold();
      _state = _state.copyWith(phase: JamPhase.paused);
    } else if (_state.phase == JamPhase.paused) {
      _scoring.resume();
      _state = _state.copyWith(phase: JamPhase.playing);
      _session.resume();
    }
    notifyListeners();
  }

  /// Termina la sesión ahora y muestra el resultado.
  Future<void> stop() => _finish();

  /// Sale de la pantalla: corta el reloj, la banda y el micrófono sin avisar.
  void leave() {
    _halt();
    _state = _state.copyWith(phase: JamPhase.setup);
  }

  /// Anota el avance de la preparación si la sesión sigue siendo [run].
  void Function(double) _loading(int run) => (double progress) {
    if (run == _run) {
      _state = _state.copyWith(loadProgress: progress);
      notifyListeners();
    }
  };

  /// La pista con la transposición (capo) de los ajustes.
  JamTrack _transposed(JamTrack track) =>
      track.transposed(_settings.config.transpose);

  /// Reacciona a un cambio de ajustes: en la preparación refresca la pista
  /// transpuesta; en marcha reajusta la banda sin cortar el compás.
  void _onSettings() {
    final BandConfig next = _settings.config;
    final BandConfig previous = _config;
    _config = next;
    final JamTrack? track = _state.track;
    if (track == null) {
      return;
    }
    if (_state.phase == JamPhase.setup) {
      _state = _state.copyWith(track: _transposed(_baseTrack!));
      notifyListeners();
    } else if (_state.isRunning && _state.phase != JamPhase.loading) {
      _session.retune(track, previous, next);
    }
  }

  /// Recibe cada semicorchea de la sesión y actualiza el estado.
  void _onCursor(JamCursor cursor, Tick _) {
    if (cursor.kind == CursorKind.finished) {
      _closeBar();
      unawaited(_finish());
      return;
    }
    if (cursor.kind == CursorKind.playing) {
      if (cursor.step == 0 && cursor.bar > 0) {
        _closeBar();
      }
      if (_state.phase != JamPhase.playing) {
        _scoring.begin();
      }
    }
    final JamState next = advanceTo(_state, cursor);
    if (!identical(next, _state)) {
      _state = next;
      notifyListeners();
    }
  }

  void _closeBar() => _state = _scoring.closeBar(_state);

  Future<void> _finish() async {
    if (_state.phase == JamPhase.finished || _state.track == null) {
      return;
    }
    _halt();
    _state = await _scoring.finish(_state);
    notifyListeners();
  }

  void _halt() {
    _run++;
    _session.stop();
    _scoring.close();
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettings);
    _halt();
    super.dispose();
  }
}
