import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/usecases/evaluate_chord_match_use_case.dart';
import 'package:chords/domain/chords/usecases/find_closest_variant_use_case.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_audio_repository.dart';

ChordReading _reading(
  ChordRoot root,
  ChordQuality quality, {
  double confidence = 0.9,
}) => ChordReading(
  chroma: List<double>.filled(12, 0.5),
  candidates: const <ChordCandidate>[],
  chord: ChordCandidate(
    root: root,
    quality: quality,
    score: 1,
    confidence: confidence,
  ),
);

/// Tests de los casos de uso que aprovechan el reconocedor de acordes.
void main() {
  group('FindClosestVariantUseCase', () {
    const FindClosestVariantUseCase useCase = FindClosestVariantUseCase();
    final Chord chord = loadChordBank().chordById('C-maj')!;

    test('sin bajo da la posición más fácil', () {
      expect(useCase(chord), chord.easiestVariant);
    });

    test('con bajo elige la posición cuya cuerda más grave lo da', () {
      for (final int bass in <int>[0, 4, 7]) {
        final ChordVariant variant = useCase(chord, bass: bass);
        final bool exists = chord.variants.any(
          (ChordVariant v) => useCase.bassOf(v) == bass,
        );
        if (exists) {
          expect(useCase.bassOf(variant), bass, reason: 'bajo $bass');
        }
      }
    });

    test('si ninguna posición tiene ese bajo, la más fácil', () {
      expect(useCase(chord, bass: 1), chord.easiestVariant);
    });

    test('entre las que coinciden prefiere la más fácil', () {
      final ChordVariant variant = useCase(chord, bass: 0);
      final int level = chord.variants
          .where((ChordVariant v) => useCase.bassOf(v) == 0)
          .map((ChordVariant v) => v.difficulty.level)
          .reduce((int a, int b) => a < b ? a : b);

      expect(variant.difficulty.level, level);
    });

    test('bassOf es la nota de la cuerda más grave que suena', () {
      // x32010: la cuerda más grave que suena es la quinta con el Do.
      final ChordVariant open = chord.variants.firstWhere(
        (ChordVariant v) => v.frets.join(',') == '-1,3,2,0,1,0',
      );

      expect(useCase.bassOf(open), 0);
    });
  });

  group('EvaluateChordMatchUseCase.recognizes', () {
    const EvaluateChordMatchUseCase useCase = EvaluateChordMatchUseCase();
    const List<String> cMajor = <String>['C', 'E', 'G'];

    test('da por bueno el acorde exacto con confianza suficiente', () {
      expect(
        useCase.recognizes(cMajor, _reading(ChordRoot.c, ChordQuality.major)),
        isTrue,
      );
    });

    test('rechaza otro acorde, aunque comparta notas', () {
      expect(
        useCase.recognizes(cMajor, _reading(ChordRoot.c, ChordQuality.seven)),
        isFalse,
      );
      expect(
        useCase.recognizes(cMajor, _reading(ChordRoot.a, ChordQuality.minor)),
        isFalse,
      );
    });

    test('rechaza una confianza baja y una lectura sin acorde', () {
      expect(
        useCase.recognizes(
          cMajor,
          _reading(ChordRoot.c, ChordQuality.major, confidence: 0.3),
        ),
        isFalse,
      );
      expect(useCase.recognizes(cMajor, ChordReading.silence), isFalse);
    });

    test('el equivalente con las mismas notas cuenta (Am7 y C6)', () {
      expect(
        useCase.recognizes(<String>[
          'A',
          'C',
          'E',
          'G',
        ], _reading(ChordRoot.c, ChordQuality.sixth)),
        isTrue,
      );
    });
  });

  group('GameAudioController con el reconocedor polifónico', () {
    test('un rasgueo reconocido da por escuchadas todas las notas', () async {
      final FakeAudioRepository audio = FakeAudioRepository();
      final GameAudioController controller = GameAudioController(audio);

      final Future<bool> round = controller.playRound(
        targetNotes: const <String>['C', 'E', 'G'],
        frets: const <int>[-1, 3, 2, 0, 1, 0],
        timeLimitMs: 300,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      audio.emitChordReading(_reading(ChordRoot.c, ChordQuality.major));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(controller.matchRatio, 1);
      expect(controller.heardNotes.toSet(), <String>{'C', 'E', 'G'});
      expect(controller.reliableReadings, 1);
      expect(await round, isTrue);
      controller.dispose();
    });

    test('un acorde distinto no suma nada', () async {
      final FakeAudioRepository audio = FakeAudioRepository();
      final GameAudioController controller = GameAudioController(audio);

      final Future<bool> round = controller.playRound(
        targetNotes: const <String>['C', 'E', 'G'],
        frets: const <int>[-1, 3, 2, 0, 1, 0],
        timeLimitMs: 300,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      audio.emitChordReading(_reading(ChordRoot.g, ChordQuality.major));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(controller.matchRatio, 0);
      expect(controller.heardNotes, isEmpty);
      await round;
      controller.dispose();
    });
  });
}
