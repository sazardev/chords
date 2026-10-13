import 'dart:async';

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/tuner_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/note_onset_gate.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_practice_session.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:flutter/foundation.dart';

/// Controlador del modo práctica: un acorde, cuerda a cuerda.
///
/// Escucha el micrófono, convierte las lecturas en notas pulsadas y las pasa
/// a la [ChordPracticeSession], que decide si la cuerda es correcta o qué
/// consejo dar. Ignora el micrófono mientras suena una referencia.
///
/// Al completar el acorde, si se maneja la app con la guitarra, el micrófono
/// sigue abierto para oír la orden siguiente (repetir, escuchar o volver);
/// [stop] lo cierra al salir.
class ChordPracticeController extends ChangeNotifier {
  /// Crea el controlador.
  ChordPracticeController(
    this._audio,
    this._chords, {
    this.silenceGap = const Duration(milliseconds: 450),
    this.referenceMute = const Duration(milliseconds: 2400),
    this._guitar,
  });

  final AudioRepository _audio;
  final ChordRepository _chords;
  final GuitarCommandListener? _guitar;

  static const Duration _settleMute = Duration(milliseconds: 900);

  /// Silencio que rearma la detección para poder repetir la misma cuerda.
  final Duration silenceGap;

  /// Tiempo que se ignora el micrófono tras reproducir una referencia.
  final Duration referenceMute;

  final NoteOnsetGate _gate = NoteOnsetGate();
  Chord? _chord;
  ChordVariant? _variant;
  ChordPracticeSession? _session;
  MicStatus _status = MicStatus.idle;
  double _level = 0;
  StreamSubscription<PitchReading>? _readings;
  StreamSubscription<double>? _levels;
  StreamSubscription<MicStatus>? _statuses;
  Timer? _silenceTimer;
  DateTime? _mutedUntil;
  DateTime? _startedAt;

  /// Acorde que se practica.
  Chord? get chord => _chord;

  /// Posición que se practica.
  ChordVariant? get variant => _variant;

  /// Sesión en curso (`null` hasta abrir un acorde).
  ChordPracticeSession? get session => _session;

  /// Estado del micrófono.
  MicStatus get status => _status;

  /// Nivel de entrada (0-1).
  double get level => _level;

  /// Prepara la práctica de la posición [variantIndex] del acorde [chordId].
  ///
  /// Devuelve `false` si el acorde no existe.
  Future<bool> open(String chordId, int variantIndex) async {
    await stop();
    if (!_chords.isLoaded) {
      await _chords.load();
    }
    final Chord? chord = _chords.chordById(chordId);
    if (chord == null || chord.variants.isEmpty) {
      return false;
    }
    final ChordVariant variant =
        chord.variants[variantIndex.clamp(0, chord.variants.length - 1)];
    _chord = chord;
    _variant = variant;
    _session = ChordPracticeSession(
      frets: variant.frets,
      fingers: variant.fingers,
    );
    notifyListeners();
    return true;
  }

  /// Empieza a escuchar; con [keepProgress] conserva las cuerdas ya
  /// reconocidas (p. ej. al volver de afinar).
  ///
  /// Con [settle] ignora un instante el micrófono: la nota con la que se
  /// ordenó repetir puede seguir sonando y no debe contar como cuerda tocada.
  ///
  /// Si ya estaba escuchando, reinicia la práctica.
  Future<void> start({bool keepProgress = false, bool settle = false}) async {
    if (settle) {
      _mutedUntil = DateTime.now().add(_settleMute);
    }
    if (!keepProgress) {
      _session?.reset();
      _startedAt = DateTime.now();
    }
    _startedAt ??= DateTime.now();
    _gate.reset();
    await _cancelStreams();
    _readings = _audio.readings.listen(_onReading);
    _levels = _audio.levels.listen(_onLevel);
    _statuses = _audio.statusStream.listen(_onStatus);
    _status = await _audio.requestAccess();
    notifyListeners();
  }

  /// Detiene la escucha y deja constancia de la sesión. No hace nada si el
  /// micrófono no estaba escuchando.
  Future<void> stop() async {
    if (!_status.isListening) {
      return;
    }
    _silenceTimer?.cancel();
    await _audio.stopListening();
    await _cancelStreams();
    _track();
    _status = MicStatus.idle;
    _level = 0;
    notifyListeners();
  }

  /// Reproduce el acorde completo para escuchar cómo debe sonar.
  Future<void> playChord() async {
    final Chord? chord = _chord;
    final ChordVariant? variant = _variant;
    if (chord == null || variant == null) {
      return;
    }
    _mute();
    await _audio.playChord(chord, variant);
  }

  /// Reproduce la nota que debe dar [string].
  Future<void> playString(PracticeString string) async {
    _mute();
    await _audio.playReferenceTone(string.frequency);
  }

  void _mute() {
    _mutedUntil = DateTime.now().add(referenceMute);
    _gate.reset();
    _guitar?.muteFor(referenceMute);
  }

  void _onStatus(MicStatus status) {
    if (status != _status) {
      _status = status;
      notifyListeners();
    }
  }

  void _onLevel(double level) {
    _level = level;
    notifyListeners();
  }

  void _onReading(PitchReading reading) {
    final DateTime? muted = _mutedUntil;
    final ChordPracticeSession? session = _session;
    if (session == null ||
        session.isComplete ||
        !reading.isReliable ||
        (_guitar?.claims(reading) ?? false) ||
        (muted != null && DateTime.now().isBefore(muted))) {
      return;
    }
    _silenceTimer?.cancel();
    _silenceTimer = Timer(silenceGap, _gate.reset);
    final double? note = _gate.feed(reading.frequency);
    if (note == null) {
      return;
    }
    session.feed(note);
    notifyListeners();
    if (session.isComplete) {
      unawaited(_complete());
    }
  }

  /// El acorde salió completo: se deja constancia y, si se manejan las
  /// órdenes con la guitarra, el micrófono queda abierto para oírlas.
  Future<void> _complete() async {
    if (!(_guitar?.enabled ?? false)) {
      await stop();
      return;
    }
    _silenceTimer?.cancel();
    _track();
  }

  void _track() {
    final DateTime? startedAt = _startedAt;
    final ChordPracticeSession? session = _session;
    final ChordVariant? variant = _variant;
    if (startedAt == null || session == null || variant == null) {
      return;
    }
    _startedAt = null;
    final Duration duration = DateTime.now().difference(startedAt);
    appLogger.info(
      'práctica ${_chord?.id}: ${session.matchedCount}/${session.total} '
      'cuerdas',
      channel: LogChannel.microphone,
      context: <String, Object?>{'durationMs': duration.inMilliseconds},
    );
    analytics.practiceSessionEnded(
      chordId: _chord?.id ?? '',
      variantId: variant.id,
      duration: duration,
      matchedStrings: session.matchedCount,
      totalStrings: session.total,
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

  @override
  void dispose() {
    _silenceTimer?.cancel();
    unawaited(_cancelStreams());
    super.dispose();
  }
}
