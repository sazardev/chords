import 'dart:async';

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/tuner_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/tuning_smoother.dart';
import 'package:chords/domain/audio/usecases/analyze_tuning_use_case.dart';
import 'package:flutter/foundation.dart';

/// Instantánea inmutable de lo que muestra el afinador.
@immutable
class TunerState {
  /// Crea la instantánea.
  const TunerState({
    this.status = MicStatus.idle,
    this.level = 0,
    this.reading,
    this.target,
    this.heardOther,
    this.tuned = const <int>{},
  });

  /// Estado del micrófono.
  final MicStatus status;

  /// Nivel de entrada (0-1).
  final double level;

  /// Lectura suavizada de la cuerda que suena ahora; `null` sin señal.
  final StringTuningReading? reading;

  /// Cuerda elegida a mano; `null` = reconocimiento automático.
  final GuitarString? target;

  /// En modo manual, la otra cuerda que suena (si no es la elegida).
  final GuitarString? heardOther;

  /// Números de las cuerdas ya afinadas en esta sesión.
  final Set<int> tuned;

  /// `true` si el micrófono está escuchando.
  bool get isListening => status == MicStatus.listening;

  /// `true` cuando las seis cuerdas están afinadas.
  bool get allTuned => tuned.length == kStandardTuning.length;

  /// Copia el estado cambiando lo indicado; [reading], [target] y
  /// [heardOther] se pueden vaciar con sus banderas `clear…`.
  TunerState copyWith({
    MicStatus? status,
    double? level,
    StringTuningReading? reading,
    bool clearReading = false,
    GuitarString? target,
    bool clearTarget = false,
    GuitarString? heardOther,
    bool clearHeardOther = false,
    Set<int>? tuned,
  }) => TunerState(
    status: status ?? this.status,
    level: level ?? this.level,
    reading: clearReading ? null : reading ?? this.reading,
    target: clearTarget ? null : target ?? this.target,
    heardOther: clearHeardOther ? null : heardOther ?? this.heardOther,
    tuned: tuned ?? this.tuned,
  );
}

/// Controlador del afinador por cuerdas.
///
/// Reconoce qué cuerda suena, suaviza su desviación, marca cada cuerda como
/// afinada cuando se mantiene dentro de la tolerancia y avisa si falta señal.
/// También puede reproducir la nota de referencia, ignorando el micrófono
/// mientras suena para no escucharse a sí mismo.
class TunerController extends ChangeNotifier {
  /// Crea el controlador.
  TunerController(
    this._audio, {
    this.signalTimeout = const Duration(milliseconds: 1200),
    this.referenceMute = const Duration(milliseconds: 2200),
    this.lockReadings = 4,
  });

  final AudioRepository _audio;

  /// Tiempo sin lecturas tras el cual se da la señal por perdida.
  final Duration signalTimeout;

  /// Tiempo que se ignora el micrófono tras reproducir una referencia.
  final Duration referenceMute;

  /// Lecturas seguidas dentro de tolerancia para dar la cuerda por afinada.
  final int lockReadings;

  final AnalyzeTuningUseCase _analyze = const AnalyzeTuningUseCase();
  final TuningSmoother _smoother = TuningSmoother();
  TunerState _state = const TunerState();
  StreamSubscription<PitchReading>? _readings;
  StreamSubscription<double>? _levels;
  StreamSubscription<MicStatus>? _statuses;
  Timer? _signalTimer;
  DateTime? _mutedUntil;
  DateTime? _startedAt;
  int _stableCount = 0;

  /// Estado actual del afinador.
  TunerState get state => _state;

  /// Alterna entre escuchar y detener.
  Future<void> toggleListening() async {
    if (_state.isListening) {
      await stop();
    } else {
      await start();
    }
  }

  /// Detiene la escucha solo si está activa.
  Future<void> stopIfListening() async {
    if (_state.isListening) {
      await stop();
    }
  }

  /// Empieza a escuchar. Conserva la cuerda elegida; reinicia el progreso.
  Future<void> start() async {
    _resetProgress();
    _startedAt = DateTime.now();
    await _cancelStreams();
    _readings = _audio.readings.listen(_onReading);
    _levels = _audio.levels.listen(_onLevel);
    _statuses = _audio.statusStream.listen(_onStatus);
    final MicStatus access = await _audio.requestAccess();
    _setState(_state.copyWith(status: access));
    appLogger.info(
      'afinador: sesión iniciada (${access.name})',
      channel: LogChannel.microphone,
    );
  }

  /// Detiene la escucha y deja constancia del resultado.
  Future<void> stop() async {
    _signalTimer?.cancel();
    await _audio.stopListening();
    await _cancelStreams();
    _track();
    _smoother.reset();
    _stableCount = 0;
    _setState(
      _state.copyWith(
        status: MicStatus.idle,
        level: 0,
        clearReading: true,
        clearHeardOther: true,
      ),
    );
  }

  /// Elige una cuerda a mano; repetirla vuelve al modo automático.
  void selectString(GuitarString? string) {
    final GuitarString? next = string == _state.target ? null : string;
    _smoother.reset();
    _stableCount = 0;
    _setState(
      next == null
          ? _state.copyWith(
              clearTarget: true,
              clearReading: true,
              clearHeardOther: true,
            )
          : _state.copyWith(
              target: next,
              clearReading: true,
              clearHeardOther: true,
            ),
    );
  }

  /// Reproduce la nota de [string] para afinar de oído.
  Future<void> playReference(GuitarString string) async {
    _mutedUntil = DateTime.now().add(referenceMute);
    _smoother.reset();
    _stableCount = 0;
    _setState(_state.copyWith(clearReading: true, clearHeardOther: true));
    await _audio.playReferenceTone(string.frequency);
  }

  /// Borra las cuerdas ya afinadas para empezar de nuevo.
  void resetProgress() {
    _resetProgress();
    notifyListeners();
  }

  void _resetProgress() {
    _stableCount = 0;
    _smoother.reset();
    _state = _state.copyWith(
      tuned: const <int>{},
      clearReading: true,
      clearHeardOther: true,
    );
  }

  void _onStatus(MicStatus status) {
    if (status != _state.status) {
      _setState(_state.copyWith(status: status));
    }
  }

  void _onLevel(double level) => _setState(_state.copyWith(level: level));

  void _onReading(PitchReading reading) {
    final DateTime? muted = _mutedUntil;
    if (!reading.isReliable ||
        (muted != null && DateTime.now().isBefore(muted))) {
      return;
    }
    _restartSignalTimer();
    final StringTuningReading? raw = _analyze(
      reading.frequency,
      target: _state.target,
    );
    if (raw == null) {
      _stableCount = 0;
      _setState(
        _state.copyWith(
          clearReading: true,
          heardOther: _analyze(reading.frequency)?.string,
        ),
      );
      return;
    }
    final StringTuningReading smoothed = _smoother.add(raw);
    _setState(
      _state.copyWith(
        reading: smoothed,
        tuned: _updateTuned(smoothed),
        clearHeardOther: true,
      ),
    );
  }

  Set<int> _updateTuned(StringTuningReading reading) {
    final Set<int> tuned = Set<int>.of(_state.tuned);
    final int number = reading.string.number;
    if (reading.isInTune) {
      _stableCount++;
      if (_stableCount >= lockReadings) {
        tuned.add(number);
      }
    } else {
      _stableCount = 0;
      if (reading.zone == TuningZone.off || reading.zone == TuningZone.far) {
        tuned.remove(number);
      }
    }
    return tuned;
  }

  void _restartSignalTimer() {
    _signalTimer?.cancel();
    _signalTimer = Timer(signalTimeout, () {
      _smoother.reset();
      _stableCount = 0;
      _setState(_state.copyWith(clearReading: true, clearHeardOther: true));
    });
  }

  void _track() {
    final DateTime? startedAt = _startedAt;
    if (startedAt == null) {
      return;
    }
    _startedAt = null;
    final Duration duration = DateTime.now().difference(startedAt);
    appLogger.info(
      'afinador: sesión terminada — ${_state.tuned.length}/6 afinadas',
      channel: LogChannel.microphone,
      context: <String, Object?>{
        'durationMs': duration.inMilliseconds,
        'tuned': (_state.tuned.toList()..sort()).join(','),
      },
    );
    analytics.tunerSessionEnded(
      duration: duration,
      tunedStrings: _state.tuned.length,
    );
  }

  Future<void> _cancelStreams() async {
    await _readings?.cancel();
    await _levels?.cancel();
    await _statuses?.cancel();
    _readings = null;
    _levels = null;
    _statuses = null;
  }

  void _setState(TunerState next) {
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _signalTimer?.cancel();
    unawaited(_cancelStreams());
    super.dispose();
  }
}
