import 'dart:async';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/presentation/features/jam/jam_band.dart';
import 'package:chords/presentation/features/jam/jam_mic_judge.dart';
import 'package:chords/presentation/features/jam/jam_state.dart';
import 'package:chords/presentation/features/studio/studio_progress_controller.dart';
import 'package:flutter/foundation.dart';

/// Controlador del jam guiado.
///
/// Lleva el reloj en corcheas: en cada hueco toca el golpe del patrón de
/// rasgueo (modo acompañar) o escucha el micrófono y, al cerrar cada compás,
/// lo puntúa (modo puntuar). Empieza con un compás de cuenta atrás.
class JamController extends ChangeNotifier {
  /// Crea el controlador.
  JamController(AudioRepository audio, this._chords, this._progress)
    : _judge = JamMicJudge(audio),
      _band = JamBand(audio, _chords);

  final ChordRepository _chords;
  final StudioProgressController _progress;

  final JamMicJudge _judge;
  final JamBand _band;

  JamState _state = const JamState();
  Timer? _timer;

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
    _state = _state.copyWith(
      track: track,
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

  /// Cambia el tempo; se aplica también en marcha.
  void setTempo(int bpm) {
    final JamTrack? track = _state.track;
    if (track == null) {
      return;
    }
    _state = _state.copyWith(
      track: track.withBpm(bpm.clamp(kJamMinBpm, kJamMaxBpm)),
    );
    if (_timer != null) {
      _schedule();
    }
    notifyListeners();
  }

  /// Enciende o apaga el metrónomo.
  void toggleMetronome() {
    _state = _state.copyWith(metronome: !_state.metronome);
    notifyListeners();
  }

  /// Empieza la sesión con un compás de cuenta atrás.
  Future<void> start() async {
    final JamTrack? track = _state.track;
    if (track == null) {
      return;
    }
    _halt();
    _state = _state.copyWith(
      phase: JamPhase.countIn,
      bar: 0,
      slot: 0,
      countdown: track.strum.beatsPerBar,
      score: const JamScore(),
      clearGrade: true,
      isNewBest: false,
      micProblem: false,
    );
    notifyListeners();
    if (_state.mode == JamMode.score && !await _judge.open()) {
      _state = _state.copyWith(micProblem: true);
      notifyListeners();
    }
    _click(accent: true);
    _schedule();
  }

  /// Pausa o reanuda.
  void togglePause() {
    if (_state.phase == JamPhase.playing) {
      _timer?.cancel();
      _timer = null;
      _judge.counting = false;
      _state = _state.copyWith(phase: JamPhase.paused);
    } else if (_state.phase == JamPhase.paused) {
      _judge.counting = true;
      _state = _state.copyWith(phase: JamPhase.playing);
      _schedule();
    }
    notifyListeners();
  }

  /// Termina la sesión ahora y muestra el resultado.
  Future<void> stop() => _finish();

  /// Sale de la pantalla: corta el reloj y el micrófono sin avisar.
  void leave() {
    _halt();
    _state = _state.copyWith(phase: JamPhase.setup);
  }

  void _schedule() {
    _timer?.cancel();
    final int bpm = _state.track!.bpm;
    _timer = Timer.periodic(
      Duration(microseconds: 30000000 ~/ bpm),
      (Timer _) => _tick(),
    );
  }

  void _tick() {
    if (_state.phase == JamPhase.countIn) {
      _countInTick();
    } else if (_state.phase == JamPhase.playing) {
      _playTick();
    }
  }

  void _countInTick() {
    final int slot = _state.slot + 1;
    if (slot.isOdd) {
      _state = _state.copyWith(slot: slot);
      return;
    }
    final int left = _state.countdown - 1;
    if (left <= 0) {
      _state = _state.copyWith(phase: JamPhase.playing, slot: 0, countdown: 0);
      _judge
        ..reset()
        ..counting = true;
      _sound();
    } else {
      _state = _state.copyWith(slot: slot, countdown: left);
      _click(accent: false);
    }
    notifyListeners();
  }

  void _playTick() {
    final JamTrack track = _state.track!;
    int slot = _state.slot + 1;
    int bar = _state.bar;
    if (slot >= track.slotsPerBar) {
      _closeBar();
      slot = 0;
      bar++;
      if (bar >= track.bars.length) {
        unawaited(_finish());
        return;
      }
    }
    _state = _state.copyWith(bar: bar, slot: slot);
    _sound();
    notifyListeners();
  }

  /// Toca lo que corresponde al hueco actual.
  void _sound() {
    if (_state.mode == JamMode.score) {
      return;
    }
    final JamTrack track = _state.track!;
    _band.play(
      track.strum.strokes[_state.slot],
      track.chordAt(_state.bar, _state.slot),
      click: _state.metronome && _state.slot.isEven,
    );
  }

  void _click({required bool accent}) {
    if (_state.metronome && _state.mode == JamMode.backing) {
      _band.click(accent: accent);
    }
  }

  void _closeBar() {
    if (_state.mode != JamMode.score || _state.micProblem) {
      return;
    }
    final JamTrack track = _state.track!;
    final ChordSymbol chord = track.chordAt(_state.bar, track.slotsPerBar - 1);
    final BarGrade grade = _judge.grade(chord);
    _state = _state.copyWith(
      score: _state.score.record(grade),
      lastGrade: grade,
    );
  }

  Future<void> _finish() async {
    if (_state.phase == JamPhase.finished || _state.track == null) {
      return;
    }
    _halt();
    final bool scored = _state.mode == JamMode.score && !_state.micProblem;
    final bool record =
        scored &&
        await _progress.saveJam(_state.track!.key, _state.score.points);
    if (!scored) {
      await _progress.markPracticed();
    }
    _state = _state.copyWith(phase: JamPhase.finished, isNewBest: record);
    appLogger.info(
      'jam terminado: ${_state.track!.key}',
      channel: LogChannel.learn,
      context: <String, Object?>{
        'mode': _state.mode.name,
        'points': _state.score.points,
      },
    );
    notifyListeners();
  }

  void _halt() {
    _timer?.cancel();
    _timer = null;
    _judge.close();
  }

  @override
  void dispose() {
    _halt();
    super.dispose();
  }
}
