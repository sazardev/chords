import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/usecases/find_closest_variant_use_case.dart';
import 'package:chords/presentation/features/live/live_chord_phase.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:test/test.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';

ChordCandidate _candidate(ChordRoot root, ChordQuality quality) =>
    ChordCandidate(root: root, quality: quality, score: 1, confidence: 0.9);

final ChordCandidate _c = _candidate(ChordRoot.c, ChordQuality.major);
final ChordCandidate _g = _candidate(ChordRoot.g, ChordQuality.major);
final ChordCandidate _am = _candidate(ChordRoot.a, ChordQuality.minor);
final ChordCandidate _em = _candidate(ChordRoot.e, ChordQuality.minor);

/// Tests del ciclo de escucha y del estado del modo acordes en vivo.
void main() {
  late FakeAudioRepository audio;
  late LiveController controller;

  setUp(() {
    audio = FakeAudioRepository();
    controller = LiveController(audio, loadChordBank());
  });

  tearDown(() => controller.dispose());

  /// Deja que lleguen los eventos pendientes de los flujos.
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  group('ciclo de escucha', () {
    test(
      'stopIfListening detiene la escucha solo cuando está activa',
      () async {
        final LiveController other = LiveController(
          audio,
          FakeChordRepository(const <Chord>[]),
        );

        await other.stopIfListening();
        expect(other.status, MicStatus.idle);

        await other.start();
        await audio.startListening();
        await flush();
        expect(other.status, MicStatus.listening);

        await other.stopIfListening();
        expect(other.status, MicStatus.idle);
        expect(audio.stops, 1);

        other.dispose();
      },
    );

    test('sin permiso la fase es apagado y el estado lo dice', () async {
      audio.accessResult = MicStatus.permissionDenied;

      await controller.start();

      expect(controller.status, MicStatus.permissionDenied);
      expect(controller.phase, LiveChordPhase.off);
    });

    test('al detener se deja de escuchar y la fase pasa a apagado', () async {
      await controller.start();
      await flush();
      expect(controller.phase, LiveChordPhase.silent);

      await controller.stop();

      expect(controller.status, MicStatus.idle);
      expect(controller.phase, LiveChordPhase.off);
    });
  });

  group('fases', () {
    test('escuchando sin sonido pide tocar un acorde', () async {
      await controller.start();
      await flush();
      expect(controller.phase, LiveChordPhase.silent);

      audio.emitChordSilence();
      await flush();

      expect(controller.phase, LiveChordPhase.silent);
      expect(controller.reading?.isSilent, isTrue);
    });

    test('suena algo sin acorde fiable: está escuchando', () async {
      await controller.start();
      audio.emitChordReading(
        ChordReading(
          chroma: List<double>.filled(12, 0.2),
          candidates: <ChordCandidate>[_c.withConfidence(0.1)],
          level: 0.5,
        ),
      );
      await flush();

      expect(controller.phase, LiveChordPhase.listening);
      expect(controller.reading?.chord, isNull);
    });

    test('con un acorde estable la fase es detectado', () async {
      await controller.start();

      audio.emitChord(_c);
      await flush();

      expect(controller.phase, LiveChordPhase.detected);
      expect(controller.reading?.chord, _c);
      expect(controller.chord?.id, 'C-maj');
    });
  });

  group('ficha y posición', () {
    test('resuelve la ficha del banco y una posición con ese bajo', () async {
      await controller.start();

      audio.emitChord(_em);
      await flush();

      expect(controller.chord?.id, 'E-min');
      final int? bass = const FindClosestVariantUseCase().bassOf(
        controller.variant!,
      );
      expect(bass, ChordRoot.e.pitchClass);
    });

    test('un acorde que el banco no tiene no rompe nada', () async {
      final LiveController empty = LiveController(
        audio,
        FakeChordRepository(const <Chord>[]),
      );
      await empty.start();

      audio.emitChord(_c);
      await flush();

      expect(empty.phase, LiveChordPhase.detected);
      expect(empty.chord, isNull);
      expect(empty.variant, isNull);
      expect(empty.chordOf(_c), isNull);
      empty.dispose();
    });

    test('chordOf devuelve la ficha de cualquier candidato', () {
      expect(controller.chordOf(_am)?.id, 'A-min');
    });
  });

  group('historial', () {
    test('guarda los acordes distintos, el más reciente primero', () async {
      await controller.start();

      for (final ChordCandidate chord in <ChordCandidate>[_c, _c, _g, _am]) {
        audio.emitChord(chord);
        await flush();
      }

      expect(controller.history.map((ChordCandidate c) => c.id), <String>[
        'A-min',
        'G-maj',
        'C-maj',
      ]);
    });

    test('un acorde poco fiable no entra en el historial', () async {
      await controller.start();

      audio.emitChord(_c, confidence: 0.3);
      await flush();

      expect(controller.history, isEmpty);
    });

    test('recuerda como mucho ocho acordes', () async {
      await controller.start();
      final List<ChordRoot> roots = ChordRoot.values.take(10).toList();

      for (final ChordRoot root in roots) {
        audio.emitChord(_candidate(root, ChordQuality.major));
        await flush();
      }

      expect(controller.history, hasLength(LiveController.historyLength));
      expect(controller.history.first.root, roots.last);
    });

    test(
      'retomar la escucha conserva el historial; empezar de nuevo, no',
      () async {
        await controller.start();
        audio.emitChord(_c);
        await flush();

        await controller.stop();
        await controller.start(resume: true);
        expect(controller.history, hasLength(1));
        expect(controller.reading, isNull);

        await controller.stop();
        await controller.start();
        expect(controller.history, isEmpty);
      },
    );
  });
}
