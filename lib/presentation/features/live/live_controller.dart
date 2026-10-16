import 'dart:async' show StreamSubscription, unawaited;

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/live_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/find_closest_variant_use_case.dart';
import 'package:chords/presentation/features/live/live_chord_phase.dart';
import 'package:flutter/foundation.dart';

/// Controlador del reconocimiento de acordes en vivo con micrófono.
///
/// Recibe del repositorio las lecturas polifónicas (el acorde estable, sus
/// alternativas y el cromagrama de las 12 notas), guarda el historial de los
/// últimos acordes tocados y resuelve la ficha del banco y la posición más
/// cercana para dibujar su diagrama. Acumula también las estadísticas de la
/// sesión para dejar traza de lo que sonó al terminar.
class LiveController extends ChangeNotifier {
  /// Crea el controlador.
  LiveController(
    this._audio,
    this._chords, {
    this._closestVariant = const FindClosestVariantUseCase(),
  });

  /// Cuántos acordes recuerda el historial.
  static const int historyLength = 8;

  /// Confianza mínima para anotar un acorde en el historial.
  static const double historyConfidence = 0.5;

  final AudioRepository _audio;
  final ChordRepository _chords;
  final FindClosestVariantUseCase _closestVariant;

  MicStatus _status = MicStatus.idle;
  ChordReading? _reading;
  Chord? _chord;
  ChordVariant? _variant;
  String? _shownId;
  int? _shownBass;
  final List<ChordCandidate> _history = <ChordCandidate>[];
  StreamSubscription<ChordReading>? _chordSubscription;
  StreamSubscription<MicStatus>? _statusSubscription;
  DateTime? _startedAt;
  int _readingCount = 0;
  int _reliableCount = 0;
  final List<String> _heardChords = <String>[];

  /// Estado del micrófono.
  MicStatus get status => _status;

  /// Última lectura polifónica (`null` si aún no ha llegado ninguna).
  ChordReading? get reading => _reading;

  /// Qué está pasando para la interfaz: apagado, silencio, oyendo o acorde.
  LiveChordPhase get phase {
    if (_status != MicStatus.listening) {
      return LiveChordPhase.off;
    }
    final ChordReading? reading = _reading;
    if (reading == null || reading.isSilent) {
      return LiveChordPhase.silent;
    }
    return reading.chord == null
        ? LiveChordPhase.listening
        : LiveChordPhase.detected;
  }

  /// Ficha del banco del acorde reconocido (`null` si el banco no la tiene).
  Chord? get chord => _chord;

  /// Posición del acorde reconocido más parecida a lo que suena.
  ChordVariant? get variant => _variant;

  /// Últimos acordes tocados, del más reciente al más antiguo.
  List<ChordCandidate> get history =>
      List<ChordCandidate>.unmodifiable(_history.reversed);

  /// Ficha del banco para [candidate]; `null` si el banco no la tiene.
  Chord? chordOf(ChordCandidate candidate) => _chords.chordById(candidate.id);

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
  ///
  /// Con [resume] se retoma tras una pausa (p. ej. al volver de una ficha) y
  /// se conserva el historial y las estadísticas de la sesión.
  Future<void> start({bool resume = false}) async {
    if (resume) {
      _reading = null;
      _startedAt ??= DateTime.now();
    } else {
      _resetSession();
    }
    notifyListeners();
    await _chordSubscription?.cancel();
    _chordSubscription = _audio.chordReadings.listen(_onChordReading);
    await _statusSubscription?.cancel();
    _statusSubscription = _audio.statusStream.listen(_onStatus);
    _status = await _audio.requestAccess();
    notifyListeners();
    appLogger.info(
      'live: sesión de escucha iniciada',
      channel: LogChannel.microphone,
    );
    analytics.liveSessionStarted();
  }

  /// Detiene la escucha del micrófono.
  Future<void> stop() async {
    await _audio.stopListening();
    await _chordSubscription?.cancel();
    _chordSubscription = null;
    await _statusSubscription?.cancel();
    _statusSubscription = null;
    _status = MicStatus.idle;
    _trackSessionEnd();
    notifyListeners();
  }

  void _resetSession() {
    _reading = null;
    _chord = null;
    _variant = null;
    _shownId = null;
    _shownBass = null;
    _history.clear();
    _startedAt = DateTime.now();
    _readingCount = 0;
    _reliableCount = 0;
    _heardChords.clear();
  }

  void _onStatus(MicStatus status) {
    _status = status;
    notifyListeners();
  }

  void _onChordReading(ChordReading reading) {
    _readingCount++;
    _reading = reading;
    final ChordCandidate? chord = reading.chord;
    if (chord != null && chord.confidence >= historyConfidence) {
      _reliableCount++;
      _remember(chord);
    }
    _resolve(reading);
    notifyListeners();
  }

  /// Anota [chord] en el historial si es distinto del último.
  void _remember(ChordCandidate chord) {
    if (_history.isNotEmpty && _history.last == chord) {
      return;
    }
    _history.add(chord);
    if (_history.length > historyLength) {
      _history.removeAt(0);
    }
    if (!_heardChords.contains(chord.name)) {
      _heardChords.add(chord.name);
    }
  }

  /// Busca la ficha y la posición del acorde mostrado (solo si cambian).
  void _resolve(ChordReading reading) {
    final ChordCandidate? chord = reading.chord;
    if (chord == null) {
      return;
    }
    if (chord.id == _shownId && reading.bass == _shownBass) {
      return;
    }
    _shownId = chord.id;
    _shownBass = reading.bass;
    _chord = _chords.chordById(chord.id);
    final Chord? found = _chord;
    _variant = found == null
        ? null
        : _closestVariant(found, bass: reading.bass);
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
      '($_reliableCount con acorde), acordes [${_heardChords.join(', ')}]',
      channel: LogChannel.microphone,
      context: <String, Object?>{
        'durationMs': duration.inMilliseconds,
        'readings': _readingCount,
        'reliable': _reliableCount,
        'chords': _heardChords.join(','),
      },
    );
    analytics.liveSessionEnded(
      duration: duration,
      readings: _readingCount,
      reliableReadings: _reliableCount,
      notesHeard: _heardChords,
      suggestions: _heardChords.length,
    );
  }

  @override
  void dispose() {
    unawaited(_chordSubscription?.cancel());
    unawaited(_statusSubscription?.cancel());
    super.dispose();
  }
}
