import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/live_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/data/audio/mic_pitch_analyzer.dart';
import 'package:chords/data/audio/microphone_stream_service.dart';
import 'package:chords/data/audio/wav_encoder.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Implementación del repositorio de audio.
///
/// Reproduce acordes sintetizados con SoLoud y analiza el micrófono con el
/// detector YIN sobre flujos PCM16.
class AudioRepositoryImpl implements AudioRepository {
  /// Crea el repositorio con los colaboradores indicados.
  AudioRepositoryImpl({ChordAudioSynthesizer? synthesizer, WavEncoder? encoder})
    : _synthesizer = synthesizer ?? const ChordAudioSynthesizer(),
      _encoder = encoder ?? const WavEncoder() {
    _sampleRate = encoder?.sampleRate ?? 44100;
    _analyzer = MicPitchAnalyzer(sampleRate: _sampleRate);
  }

  MicrophoneStreamService? _microphone;

  /// Micrófono creado de forma perezosa (evita tocar el canal de plataforma
  /// hasta que realmente se necesita escuchar).
  MicrophoneStreamService get _mic => _microphone ??= MicrophoneStreamService();

  final ChordAudioSynthesizer _synthesizer;
  final WavEncoder _encoder;
  late final int _sampleRate;
  late final MicPitchAnalyzer _analyzer;

  final StreamController<MicStatus> _statusController =
      StreamController<MicStatus>.broadcast();
  final Map<String, AudioSource> _sources = <String, AudioSource>{};

  /// Notas sueltas en caché, de la más antigua a la más reciente.
  final Queue<String> _toneKeys = Queue<String>();

  /// Máximo de notas sueltas guardadas a la vez.
  static const int _maxToneSources = 48;

  StreamSubscription<Uint8List>? _micSubscription;
  bool _engineReady = false;

  @override
  Stream<MicStatus> get statusStream => _statusController.stream;

  @override
  Stream<PitchReading> get readings => _analyzer.readings;

  @override
  Stream<double> get levels => _analyzer.levels;

  @override
  Future<MicStatus> requestAccess() async {
    if (_micSubscription != null) {
      return MicStatus.listening;
    }
    try {
      final Stream<Uint8List> stream = await _mic.start(
        sampleRate: _sampleRate,
      );
      await _micSubscription?.cancel();
      _micSubscription = stream.listen(
        (Uint8List bytes) => _analyzer.addBytes(bytes),
      );
      _statusController.add(MicStatus.listening);
      appLogger.info(
        'micrófono: escucha iniciada',
        channel: LogChannel.microphone,
      );
      analytics.micPermission(granted: true);
      return MicStatus.listening;
    } on Object catch (error, stackTrace) {
      appLogger.warning(
        'micrófono: acceso denegado o fallo al iniciar',
        channel: LogChannel.microphone,
        error: error,
        stackTrace: stackTrace,
      );
      analytics.micPermission(granted: false);
      _statusController.add(MicStatus.permissionDenied);
      return MicStatus.permissionDenied;
    }
  }

  @override
  Future<void> startListening() async {
    await requestAccess();
  }

  @override
  Future<void> stopListening() async {
    await _micSubscription?.cancel();
    _micSubscription = null;
    try {
      await _mic.stop();
    } on Object catch (error, stackTrace) {
      appLogger.warning(
        'micrófono: fallo al detener la captura',
        channel: LogChannel.microphone,
        error: error,
        stackTrace: stackTrace,
      );
    }
    _analyzer.reset();
    _statusController.add(MicStatus.idle);
    appLogger.info(
      'micrófono: escucha detenida',
      channel: LogChannel.microphone,
    );
  }

  @override
  Future<void> playChord(Chord chord, ChordVariant variant) async {
    appLogger.debug('reproducir acorde ${chord.id}', channel: LogChannel.audio);
    await _ensureEngine();
    final AudioSource source = await _loadCached(
      key: '${chord.id}:${variant.id}',
      samples: () => _synthesizer.synthesize(variant),
    );
    _play(source);
  }

  @override
  Future<void> playArpeggio(
    Chord chord,
    ChordVariant variant,
    ArpeggioPattern pattern,
  ) async {
    appLogger.debug(
      'reproducir arpegio ${chord.id}/${pattern.id}',
      channel: LogChannel.audio,
    );
    await _ensureEngine();
    final AudioSource source = await _loadCached(
      key: '${chord.id}:${variant.id}:arp-${pattern.id}',
      samples: () => _synthesizer.synthesizeArpeggio(
        variant,
        pattern.stringOrder,
        pattern.intervalMs,
      ),
    );
    _play(source);
  }

  @override
  Future<void> playReferenceTone(double frequency) async {
    appLogger.debug(
      'reproducir nota de referencia ${frequency.toStringAsFixed(1)} Hz',
      channel: LogChannel.audio,
    );
    await _ensureEngine();
    final String key = 'tone:${frequency.toStringAsFixed(1)}';
    final AudioSource source = await _loadCached(
      key: key,
      samples: () => _synthesizer.synthesizeNote(frequency),
    );
    _rememberTone(key);
    _play(source);
  }

  @override
  Future<void> dispose() async {
    await _micSubscription?.cancel();
    await _microphone?.dispose();
    await _statusController.close();
    await _analyzer.dispose();
    if (_engineReady) {
      await SoLoud.instance.deinitAsync();
    }
  }

  Future<void> _ensureEngine() async {
    if (_engineReady) {
      return;
    }
    await SoLoud.instance.init();
    _engineReady = true;
    appLogger.debug(
      'motor de audio (SoLoud) iniciado',
      channel: LogChannel.audio,
    );
  }

  /// Marca una nota como la más reciente y libera las más antiguas.
  ///
  /// Los minijuegos de oído piden cientos de frecuencias distintas; sin tope
  /// la memoria crecería con cada partida.
  void _rememberTone(String key) {
    _toneKeys
      ..remove(key)
      ..addLast(key);
    while (_toneKeys.length > _maxToneSources) {
      final AudioSource? stale = _sources.remove(_toneKeys.removeFirst());
      if (stale != null) {
        unawaited(SoLoud.instance.disposeSource(stale));
      }
    }
  }

  Future<AudioSource> _loadCached({
    required String key,
    required Float64List Function() samples,
  }) async {
    final AudioSource? cached = _sources[key];
    if (cached != null) {
      return cached;
    }
    final Uint8List wav = _encoder.encode(samples());
    final AudioSource source = await SoLoud.instance.loadMem('$key.wav', wav);
    _sources[key] = source;
    return source;
  }

  void _play(AudioSource source) {
    if (_engineReady) {
      SoLoud.instance.play(source, volume: 0.9);
    }
  }
}
