import 'dart:async';
import 'dart:collection';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/data/audio/band/band_render_job.dart';
import 'package:chords/data/audio/band/band_voice_engine.dart';
import 'package:chords/domain/audio/repositories/band_audio_repository.dart';
import 'package:chords/domain/audio/services/playback_echo_gate.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:flutter/foundation.dart';

/// Sintetiza un lote de sonidos (por defecto en un isolate).
typedef BatchRenderer = Future<List<EncodedSound>> Function(
  List<BandSound> batch,
);

/// Renderiza el lote en otro isolate para no frenar la interfaz.
Future<List<EncodedSound>> renderInIsolate(List<BandSound> batch) =>
    compute(renderBatch, batch);

/// Muestra cargada en el motor.
class _Sample {
  const _Sample(this.source, this.audible, this.loopStart);

  final Object source;
  final Duration audible;
  final Duration? loopStart;
}

/// Audio de la banda sobre un [BandVoiceEngine].
///
/// Sintetiza las muestras en isolates (en paralelo, por lotes), las codifica
/// a WAV y las carga una vez; después tocar un golpe es solo `play`. Cada
/// grupo de choke (bajo, guitarra, charles…) lleva su última voz para
/// cortarla con un fundido de milisegundos al llegar la siguiente, y cada
/// canal sus voces vivas para poder silenciarlo en caliente.
class BandAudioRepositoryImpl implements BandAudioRepository {
  /// Crea el repositorio.
  ///
  /// [echoGate], si se da, recibe aviso de cada golpe para que el micrófono
  /// no oiga al altavoz.
  BandAudioRepositoryImpl({
    BandVoiceEngine? engine,
    BatchRenderer? renderer,
    PlaybackEchoGate? echoGate,
    this.concurrency = 3,
    this.batchSize = 6,
  }) : _engine = engine ?? SoLoudBandEngine(),
       _renderer = renderer ?? renderInIsolate,
       // ignore: prefer_initializing_formals, el parámetro nombrado es público.
       _echoGate = echoGate;

  /// Lotes que se sintetizan a la vez.
  final int concurrency;

  /// Sonidos por lote.
  final int batchSize;

  final BandVoiceEngine _engine;
  final BatchRenderer _renderer;
  final PlaybackEchoGate? _echoGate;

  final Map<String, _Sample> _samples = <String, _Sample>{};
  final Map<String, Future<void>> _inFlight = <String, Future<void>>{};
  final Map<String, ({int handle, BandChannel channel})> _chokeVoices =
      <String, ({int handle, BandChannel channel})>{};
  final Map<BandChannel, List<int>> _voices = <BandChannel, List<int>>{};
  final Map<Timer, BandChannel> _pending = <Timer, BandChannel>{};

  /// Fundido al cortar una nota con la siguiente.
  static const Duration _chokeFade = Duration(milliseconds: 18);

  /// Fundido al silenciar un canal.
  static const Duration _silenceFade = Duration(milliseconds: 45);

  /// Voces vivas que se recuerdan por canal.
  static const int _maxVoices = 32;

  @override
  bool isReady(BandSound sound) => _samples.containsKey(sound.key);

  @override
  Future<void> preload(
    Iterable<BandSound> sounds, {
    void Function(double progress)? onProgress,
  }) async {
    final Map<String, BandSound> todo = <String, BandSound>{};
    final List<Future<void>> waiting = <Future<void>>[];
    for (final BandSound sound in sounds) {
      final Future<void>? running = _inFlight[sound.key];
      if (running != null) {
        waiting.add(running);
      } else if (!_samples.containsKey(sound.key)) {
        todo[sound.key] = sound;
      }
    }
    if (todo.isNotEmpty) {
      await _loadAll(todo.values.toList(), onProgress);
    }
    await Future.wait(waiting);
    onProgress?.call(1);
  }

  /// Sintetiza y carga [sounds]. Los marca como "en curso" antes de ceder el
  /// control, para que otra precarga que llegue a la vez los espere en lugar
  /// de repetirlos.
  Future<void> _loadAll(
    List<BandSound> sounds,
    void Function(double progress)? onProgress,
  ) async {
    final Completer<void> finished = Completer<void>();
    final Set<String> keys = <String>{for (final BandSound s in sounds) s.key};
    for (final String key in keys) {
      _inFlight[key] = finished.future;
    }
    try {
      await _engine.ensureReady();
      await _renderAll(sounds, onProgress);
    } finally {
      _inFlight.removeWhere((String key, Future<void> _) => keys.contains(key));
      finished.complete();
    }
  }

  Future<void> _renderAll(
    List<BandSound> sounds,
    void Function(double progress)? onProgress,
  ) async {
    final Queue<List<BandSound>> batches = Queue<List<BandSound>>();
    for (int i = 0; i < sounds.length; i += batchSize) {
      batches.add(sounds.sublist(i, (i + batchSize).clamp(0, sounds.length)));
    }
    int done = 0;
    Future<void> worker() async {
      while (batches.isNotEmpty) {
        final List<BandSound> batch = batches.removeFirst();
        for (final EncodedSound encoded in await _renderer(batch)) {
          await _register(encoded);
        }
        done += batch.length;
        onProgress?.call(done / sounds.length);
      }
    }

    final int workers = concurrency.clamp(1, batches.length);
    await Future.wait(<Future<void>>[
      for (int i = 0; i < workers; i++) worker(),
    ]);
  }

  Future<void> _register(EncodedSound encoded) async {
    final Object source = await _engine.load(
      'band-${encoded.key}',
      encoded.wav,
    );
    _samples[encoded.key] = _Sample(source, encoded.audible, encoded.loopStart);
  }

  @override
  void play(
    BandSound sound, {
    required double volume,
    Duration delay = Duration.zero,
  }) {
    final _Sample? sample = _samples[sound.key];
    if (sample == null || volume <= 0) {
      return;
    }
    if (delay <= const Duration(milliseconds: 1)) {
      _start(sound, sample, volume);
      return;
    }
    late final Timer timer;
    timer = Timer(delay, () {
      _pending.remove(timer);
      _start(sound, sample, volume);
    });
    _pending[timer] = sound.channel;
  }

  void _start(BandSound sound, _Sample sample, double volume) {
    final String? group = sound.chokeGroup;
    if (group != null) {
      final ({int handle, BandChannel channel})? previous = _chokeVoices[group];
      if (previous != null) {
        _engine.fadeOut(previous.handle, _chokeFade);
      }
    }
    try {
      final int handle = _engine.play(
        sample.source,
        volume: volume.clamp(0.0, 1.0),
        loopStart: sample.loopStart,
      );
      _echoGate?.playbackStarted(sample.audible);
      _remember(sound, group, handle);
    } on Object catch (error, stackTrace) {
      appLogger.warning(
        'banda: no se pudo tocar ${sound.key}',
        channel: LogChannel.audio,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _remember(BandSound sound, String? group, int handle) {
    if (group != null) {
      _chokeVoices[group] = (handle: handle, channel: sound.channel);
    }
    final List<int> voices = _voices.putIfAbsent(sound.channel, () => <int>[])
      ..add(handle);
    if (voices.length > _maxVoices) {
      voices.removeRange(0, voices.length - _maxVoices);
    }
  }

  @override
  void silence({BandChannel? channel}) {
    _pending.removeWhere((Timer timer, BandChannel owner) {
      final bool mine = channel == null || owner == channel;
      if (mine) {
        timer.cancel();
      }
      return mine;
    });
    for (final BandChannel owner in BandChannel.values) {
      if (channel != null && owner != channel) {
        continue;
      }
      for (final int handle in _voices[owner] ?? const <int>[]) {
        _engine.fadeOut(handle, _silenceFade);
      }
      _voices[owner]?.clear();
    }
    _chokeVoices.removeWhere(
      (String group, ({int handle, BandChannel channel}) voice) =>
          channel == null || voice.channel == channel,
    );
  }

  @override
  Future<void> release({Set<String> keep = const <String>{}}) async {
    final List<String> stale = <String>[
      for (final String key in _samples.keys)
        if (!keep.contains(key)) key,
    ];
    for (final String key in stale) {
      final _Sample? sample = _samples.remove(key);
      if (sample != null) {
        await _engine.unload(sample.source);
      }
    }
  }

  @override
  Future<void> dispose() async {
    silence();
    await release();
  }
}
