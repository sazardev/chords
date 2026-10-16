import 'dart:typed_data';

import 'package:chords/data/audio/band/band_render_job.dart';
import 'package:chords/data/audio/band/band_voice_engine.dart';
import 'package:chords/data/audio/band_audio_repository_impl.dart';
import 'package:chords/domain/audio/services/playback_echo_gate.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:flutter_test/flutter_test.dart';

/// Motor falso: apunta qué se cargó, tocó y cortó.
class _FakeEngine implements BandVoiceEngine {
  final List<String> loaded = <String>[];
  final List<({int handle, double volume, Duration? loop, Object source})>
  plays = <({int handle, double volume, Duration? loop, Object source})>[];
  final List<int> fades = <int>[];
  final List<Object> unloaded = <Object>[];
  bool failPlay = false;
  int _next = 1;

  @override
  Future<void> ensureReady() async {}

  @override
  Future<Object> load(String name, Uint8List wav) async {
    loaded.add(name);
    return name;
  }

  @override
  int play(Object source, {required double volume, Duration? loopStart}) {
    if (failPlay) {
      throw StateError('sin voces');
    }
    final int handle = _next++;
    plays.add((
      handle: handle,
      volume: volume,
      loop: loopStart,
      source: source,
    ));
    return handle;
  }

  @override
  void fadeOut(int handle, Duration fade) => fades.add(handle);

  @override
  Future<void> unload(Object source) async => unloaded.add(source);
}

BandSound _bass(int midi) =>
    BandSound.bass(BassKind.finger, midi, NoteLength.medium);

BandSound _drum(DrumVoice voice) =>
    BandSound.drum(voice, DrumKit.acoustic, hard: true);

/// Fotografía de los lotes que pidió la precarga.
class _Renderer {
  final List<List<BandSound>> batches = <List<BandSound>>[];
  int running = 0;
  int peak = 0;
  Duration delay = Duration.zero;

  Future<List<EncodedSound>> call(List<BandSound> batch) async {
    batches.add(batch);
    running++;
    peak = running > peak ? running : peak;
    await Future<void>.delayed(delay);
    running--;
    return <EncodedSound>[
      for (final BandSound sound in batch)
        EncodedSound(
          key: sound.key,
          wav: Uint8List(8),
          audible: const Duration(milliseconds: 300),
          loopStart: sound.shape == NoteLength.long
              ? const Duration(milliseconds: 100)
              : null,
        ),
    ];
  }
}

/// El audio de la banda: precarga por lotes, cortes entre notas y silencio.
void main() {
  late _FakeEngine engine;
  late _Renderer renderer;
  late BandAudioRepositoryImpl repo;

  setUp(() {
    engine = _FakeEngine();
    renderer = _Renderer();
    repo = BandAudioRepositoryImpl(
      engine: engine,
      renderer: renderer.call,
      batchSize: 2,
    );
  });

  group('precarga', () {
    test('carga cada sonido una vez, por lotes, y avisa del avance', () async {
      final List<double> progress = <double>[];
      final List<BandSound> sounds = <BandSound>[
        for (int i = 0; i < 7; i++) _bass(30 + i),
        _bass(30),
      ];
      await repo.preload(sounds, onProgress: progress.add);
      expect(engine.loaded.length, 7, reason: 'sin repetir');
      expect(renderer.batches.map((List<BandSound> b) => b.length), <int>[
        2,
        2,
        2,
        1,
      ]);
      expect(progress.last, 1);
      for (int i = 1; i < progress.length; i++) {
        expect(progress[i], greaterThanOrEqualTo(progress[i - 1]));
      }
      expect(sounds.every(repo.isReady), isTrue);
      await repo.preload(sounds);
      expect(engine.loaded.length, 7, reason: 'ya estaban cargados');
    });

    test('no sintetiza más lotes a la vez que la concurrencia', () async {
      renderer.delay = const Duration(milliseconds: 5);
      repo = BandAudioRepositoryImpl(
        engine: engine,
        renderer: renderer.call,
        concurrency: 2,
        batchSize: 1,
      );
      await repo.preload(<BandSound>[
        for (int i = 0; i < 9; i++) _bass(30 + i),
      ]);
      expect(renderer.peak, 2);
      expect(engine.loaded.length, 9);
    });

    test('dos precargas que se solapan no repiten trabajo', () async {
      renderer.delay = const Duration(milliseconds: 10);
      final List<BandSound> sounds = <BandSound>[
        for (int i = 0; i < 4; i++) _bass(30 + i),
      ];
      final Future<void> first = repo.preload(sounds);
      final Future<void> second = repo.preload(sounds);
      await Future.wait(<Future<void>>[first, second]);
      expect(engine.loaded.length, 4);
      expect(sounds.every(repo.isReady), isTrue);
    });

    test('sin nada que cargar avisa de que está listo', () async {
      final List<double> progress = <double>[];
      await repo.preload(const <BandSound>[], onProgress: progress.add);
      expect(progress, <double>[1]);
    });

    test(
      'un fallo de síntesis llega a quien llama y deja el estado limpio',
      () async {
        repo = BandAudioRepositoryImpl(
          engine: engine,
          renderer: (List<BandSound> batch) async => throw StateError('falló'),
        );
        await expectLater(
          repo.preload(<BandSound>[_bass(30)]),
          throwsStateError,
        );
        expect(repo.isReady(_bass(30)), isFalse);
        repo = BandAudioRepositoryImpl(engine: engine, renderer: renderer.call);
        await repo.preload(<BandSound>[_bass(30)]);
        expect(repo.isReady(_bass(30)), isTrue);
      },
    );
  });

  group('tocar', () {
    test('lo que no está cargado no suena y lo cargado sí', () async {
      repo.play(_bass(30), volume: 0.8);
      expect(engine.plays, isEmpty);
      await repo.preload(<BandSound>[_bass(30)]);
      repo
        ..play(_bass(30), volume: 0.8)
        ..play(_bass(30), volume: 1.7)
        ..play(_bass(30), volume: 0);
      expect(
        engine.plays.map(
          (({int handle, Duration? loop, Object source, double volume}) p) =>
              p.volume,
        ),
        <double>[0.8, 1],
      );
    });

    test('un sonido sostenido se repite desde su punto de bucle', () async {
      final BandSound pad = BandSound.keys(
        KeysKind.pad,
        NoteLength.long,
        const <int>[48, 55],
      );
      await repo.preload(<BandSound>[pad]);
      repo.play(pad, volume: 0.5);
      expect(engine.plays.single.loop, const Duration(milliseconds: 100));
    });

    test('un golpe con retardo suena después, no antes', () async {
      await repo.preload(<BandSound>[_drum(DrumVoice.kick)]);
      repo.play(
        _drum(DrumVoice.kick),
        volume: 0.9,
        delay: const Duration(milliseconds: 40),
      );
      expect(engine.plays, isEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 90));
      expect(engine.plays.length, 1);
    });

    test('un fallo del motor al tocar no rompe la sesión', () async {
      await repo.preload(<BandSound>[_bass(30)]);
      engine.failPlay = true;
      repo.play(_bass(30), volume: 0.5);
      engine.failPlay = false;
      repo.play(_bass(30), volume: 0.5);
      expect(engine.plays.length, 1);
    });

    test('avisa a la puerta de eco con la duración audible', () async {
      DateTime now = DateTime(2026);
      final PlaybackEchoGate gate = PlaybackEchoGate(clock: () => now);
      repo = BandAudioRepositoryImpl(
        engine: engine,
        renderer: renderer.call,
        echoGate: gate,
      );
      await repo.preload(<BandSound>[_bass(30)]);
      expect(gate.isMuting, isFalse);
      repo.play(_bass(30), volume: 0.5);
      expect(gate.isMuting, isTrue);
      expect(gate.admits(0.2), isFalse);
      now = now.add(const Duration(seconds: 3));
      expect(gate.admits(0.001), isTrue);
    });
  });

  group('cortes', () {
    test(
      'una nota de bajo corta la anterior; un plato no corta nada',
      () async {
        await repo.preload(<BandSound>[
          _bass(30),
          _bass(32),
          _drum(DrumVoice.crash),
        ]);
        repo
          ..play(_bass(30), volume: 0.5)
          ..play(_drum(DrumVoice.crash), volume: 0.5)
          ..play(_bass(32), volume: 0.5)
          ..play(_drum(DrumVoice.crash), volume: 0.5);
        expect(engine.fades, <int>[1], reason: 'solo cae la primera nota');
      },
    );

    test('el charles cerrado corta al abierto', () async {
      await repo.preload(<BandSound>[
        _drum(DrumVoice.hatOpen),
        _drum(DrumVoice.hatClosed),
      ]);
      repo
        ..play(_drum(DrumVoice.hatOpen), volume: 0.5)
        ..play(_drum(DrumVoice.hatClosed), volume: 0.5);
      expect(engine.fades, <int>[1]);
    });

    test(
      'silenciar un canal calla solo sus voces y anula lo pendiente',
      () async {
        await repo.preload(<BandSound>[
          _bass(30),
          _drum(DrumVoice.kick),
          _drum(DrumVoice.snare),
        ]);
        repo
          ..play(_bass(30), volume: 0.5)
          ..play(_drum(DrumVoice.kick), volume: 0.5)
          ..play(
            _drum(DrumVoice.snare),
            volume: 0.5,
            delay: const Duration(milliseconds: 30),
          )
          ..silence(channel: BandChannel.drums);
        expect(engine.fades, <int>[2], reason: 'solo el bombo');
        await Future<void>.delayed(const Duration(milliseconds: 80));
        expect(engine.plays.length, 2, reason: 'la caja pendiente se anuló');
        repo.silence();
        expect(engine.fades, <int>[2, 1]);
        repo.play(_bass(30), volume: 0.5);
        expect(engine.fades.length, 2, reason: 'el corte previo ya no existe');
      },
    );

    test('release libera lo que no se conserva', () async {
      await repo.preload(<BandSound>[_bass(30), _bass(31), _bass(32)]);
      await repo.release(keep: <String>{_bass(31).key});
      expect(repo.isReady(_bass(31)), isTrue);
      expect(repo.isReady(_bass(30)), isFalse);
      expect(engine.unloaded.length, 2);
      await repo.dispose();
      expect(repo.isReady(_bass(31)), isFalse);
    });
  });

  group('síntesis real en lote', () {
    test('codifica WAV válido y marca el bucle de lo sostenido', () {
      final List<EncodedSound> encoded = renderBatch(<BandSound>[
        _drum(DrumVoice.snare),
        BandSound.keys(KeysKind.organ, NoteLength.long, const <int>[48, 55]),
        BandSound.click(ClickAccent.accent),
      ]);
      expect(encoded.length, 3);
      for (final EncodedSound sound in encoded) {
        expect(String.fromCharCodes(sound.wav.sublist(0, 4)), 'RIFF');
        expect(String.fromCharCodes(sound.wav.sublist(8, 12)), 'WAVE');
        expect(sound.wav.length, greaterThan(1000));
      }
      expect(encoded[0].loopStart, isNull);
      expect(
        encoded[0].audible,
        greaterThan(const Duration(milliseconds: 100)),
      );
      expect(encoded[1].loopStart, isNotNull);
      expect(encoded[2].audible, lessThan(const Duration(milliseconds: 100)));
    });
  });
}
