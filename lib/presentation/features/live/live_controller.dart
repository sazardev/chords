import 'dart:async' show StreamSubscription, unawaited;

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/live_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/match_chords_by_pitch_classes_use_case.dart';
import 'package:flutter/foundation.dart';

/// Controlador de la afinación en vivo con micrófono.
///
/// Además del estado visible (estado del micrófono, última lectura y
/// sugerencias), acumula las estadísticas de la sesión —lecturas, fiables y
/// notas escuchadas— para dejar traza de lo que sonó al terminar.
class LiveController extends ChangeNotifier {
  /// Crea el controlador.
  LiveController(this._audio, this._chords);

  final AudioRepository _audio;
  final ChordRepository _chords;
  final MatchChordsByPitchClassesUseCase _matchChords =
      const MatchChordsByPitchClassesUseCase();

  MicStatus _status = MicStatus.idle;
  PitchReading? _reading;
  List<Chord> _suggestions = const <Chord>[];
  final Set<int> _detected = <int>{};
  StreamSubscription<PitchReading>? _readingsSubscription;
  StreamSubscription<MicStatus>? _statusSubscription;
  DateTime? _startedAt;
  int _readingCount = 0;
  int _reliableCount = 0;
  final List<String> _heardNotes = <String>[];

  /// Estado del micrófono.
  MicStatus get status => _status;

  /// Última lectura de tono.
  PitchReading? get reading => _reading;

  /// Acordes sugeridos a partir de lo detectado.
  List<Chord> get suggestions => _suggestions;

  /// Clases de tono acumuladas.
  Set<int> get detected => _detected;

  /// Notas fiables escuchadas durante la sesión, en orden de detección.
  List<String> get heardNotes => List<String>.unmodifiable(_heardNotes);

  /// Alterna entre escuchar y detener.
  Future<void> toggleListening() async {
    if (_status == MicStatus.listening) {
      await stop();
    } else {
      await start();
    }
  }

  /// Detiene la escucha solo si está activa.
  ///
  /// La usa la navegación al abandonar la pantalla en vivo para no dejar el
  /// micrófono abierto.
  Future<void> stopIfListening() async {
    if (_status == MicStatus.listening) {
      await stop();
    }
  }

  /// Inicia la escucha del micrófono.
  Future<void> start() async {
    _detected.clear();
    _suggestions = const <Chord>[];
    _reading = null;
    _startedAt = DateTime.now();
    _readingCount = 0;
    _reliableCount = 0;
    _heardNotes.clear();
    notifyListeners();
    await _audio.requestAccess();
    await _readingsSubscription?.cancel();
    _readingsSubscription = _audio.readings.listen(_onReading);
    await _statusSubscription?.cancel();
    _statusSubscription = _audio.statusStream.listen(_onStatus);
    appLogger.info(
      'live: sesión de escucha iniciada',
      channel: LogChannel.microphone,
    );
    analytics.liveSessionStarted();
  }

  /// Detiene la escucha del micrófono.
  Future<void> stop() async {
    await _audio.stopListening();
    await _readingsSubscription?.cancel();
    _readingsSubscription = null;
    await _statusSubscription?.cancel();
    _statusSubscription = null;
    _status = MicStatus.idle;
    _trackSessionEnd();
    notifyListeners();
  }

  void _onStatus(MicStatus status) {
    _status = status;
    notifyListeners();
  }

  void _onReading(PitchReading reading) {
    _readingCount++;
    _reading = reading;
    final int pitchClass = _pitchClassOf(reading.note);
    if (reading.isReliable) {
      _reliableCount++;
      final String note = _noteOf(reading.note);
      if (!_heardNotes.contains(note)) {
        _heardNotes.add(note);
      }
      _detected
        ..clear()
        ..add(pitchClass);
      _suggestions = _matchChords(_chords.chords, _detected);
    }
    notifyListeners();
  }

  void _trackSessionEnd() {
    final DateTime? startedAt = _startedAt;
    if (startedAt == null) {
      return;
    }
    _startedAt = null;
    final Duration duration = DateTime.now().difference(startedAt);
    appLogger.info(
      'live: sesión terminada — $_readingCount lecturas '
      '($_reliableCount fiables), notas [${_heardNotes.join(', ')}], '
      '${_suggestions.length} sugerencias',
      channel: LogChannel.microphone,
      context: <String, Object?>{
        'durationMs': duration.inMilliseconds,
        'readings': _readingCount,
        'reliable': _reliableCount,
        'notes': _heardNotes.join(','),
        'suggestions': _suggestions.length,
      },
    );
    analytics.liveSessionEnded(
      duration: duration,
      readings: _readingCount,
      reliableReadings: _reliableCount,
      notesHeard: _heardNotes,
      suggestions: _suggestions.length,
    );
  }

  String _noteOf(String label) => label.replaceAll(RegExp('[0-9-]'), '');

  int _pitchClassOf(String label) {
    const List<String> names = <String>[
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    return names.indexOf(_noteOf(label));
  }

  @override
  void dispose() {
    unawaited(_readingsSubscription?.cancel());
    unawaited(_statusSubscription?.cancel());
    super.dispose();
  }
}
