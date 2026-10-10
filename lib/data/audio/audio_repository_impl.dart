import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/data/audio/microphone_stream_service.dart';
import 'package:chords/data/audio/pcm_decoder.dart';
import 'package:chords/data/audio/wav_encoder.dart';
import 'package:chords/data/audio/yin_pitch_detector.dart';
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
  AudioRepositoryImpl({
    PitchDetector? detector,
    ChordAudioSynthesizer? synthesizer,
    WavEncoder? encoder,
    PcmDecoder? decoder,
  }) : _detector = detector ?? const PitchDetector(),
       _synthesizer = synthesizer ?? const ChordAudioSynthesizer(),
       _encoder = encoder ?? const WavEncoder(),
       _decoder = decoder ?? const PcmDecoder() {
    _sampleRate = encoder?.sampleRate ?? 44100;
  }

  MicrophoneStreamService? _microphone;

  /// Micrófono creado de forma perezosa (evita tocar el canal de plataforma
  /// hasta que realmente se necesita escuchar).
  MicrophoneStreamService get _mic => _microphone ??= MicrophoneStreamService();

  final PitchDetector _detector;
  final ChordAudioSynthesizer _synthesizer;
  final WavEncoder _encoder;
  final PcmDecoder _decoder;
  late final int _sampleRate;

  final StreamController<MicStatus> _statusController =
      StreamController<MicStatus>.broadcast();
  final StreamController<PitchReading> _readingsController =
      StreamController<PitchReading>.broadcast();
  final Map<String, AudioSource> _sources = <String, AudioSource>{};

  StreamSubscription<Uint8List>? _micSubscription;
  final List<double> _window = <double>[];
  int _lastEmit = 0;
  bool _engineReady = false;

  @override
  Stream<MicStatus> get statusStream => _statusController.stream;

  @override
  Stream<PitchReading> get readings => _readingsController.stream;

  @override
  Future<MicStatus> requestAccess() async {
    try {
      final Stream<Uint8List> stream = await _mic.start(
        sampleRate: _sampleRate,
      );
      await _micSubscription?.cancel();
      _micSubscription = stream.listen(_onMicData);
      _statusController.add(MicStatus.listening);
      appLogger.info(
        'micrófono: escucha iniciada',
        channel: LogChannel.microphone,
      );
      return MicStatus.listening;
    } on Exception catch (error, stackTrace) {
      appLogger.warning(
        'micrófono: acceso denegado o fallo al iniciar',
        channel: LogChannel.microphone,
        error: error,
        stackTrace: stackTrace,
      );
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
    await _mic.stop();
    _window.clear();
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
      samples: _synthesizer.synthesize(variant),
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
      samples: _synthesizer.synthesizeArpeggio(
        variant,
        pattern.stringOrder,
        pattern.intervalMs,
      ),
    );
    _play(source);
  }

  @override
  Future<void> dispose() async {
    await _micSubscription?.cancel();
    await _microphone?.stop();
    await _statusController.close();
    await _readingsController.close();
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

  Future<AudioSource> _loadCached({
    required String key,
    required Float64List samples,
  }) async {
    final AudioSource? cached = _sources[key];
    if (cached != null) {
      return cached;
    }
    final Uint8List wav = _encoder.encode(samples);
    final AudioSource source = await SoLoud.instance.loadMem('$key.wav', wav);
    _sources[key] = source;
    return source;
  }

  void _play(AudioSource source) {
    if (_engineReady) {
      SoLoud.instance.play(source, volume: 0.9);
    }
  }

  void _onMicData(Uint8List bytes) {
    final Float64List samples = _decoder.decode(bytes);
    _window.addAll(samples);
    final int windowSize = (_sampleRate / 4).round();
    if (_window.length > windowSize * 2) {
      _window.removeRange(0, _window.length - windowSize);
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastEmit < 60) {
      return;
    }
    _lastEmit = now;
    final int size = math.min(windowSize, _window.length);
    final Float64List buffer = Float64List.fromList(
      _window.sublist(_window.length - size),
    );
    _emitReading(buffer);
  }

  void _emitReading(Float64List buffer) {
    final double? frequency = _detector.detectPitch(buffer, _sampleRate);
    if (frequency == null || frequency <= 0) {
      return;
    }
    final ({String note, double cents}) nearest = PitchDetector.nearestNote(
      frequency,
    );
    final double clarity = PitchDetector.clarityOf(buffer);
    _readingsController.add(
      PitchReading(
        frequency: frequency,
        note: nearest.note,
        cents: nearest.cents,
        clarity: clarity,
      ),
    );
  }
}
