import 'dart:async' show unawaited;

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/domain/chords/usecases/build_game_sequence_use_case.dart';
import 'package:chords/domain/chords/usecases/evaluate_chord_match_use_case.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fakes/fake_audio_repository.dart';
import '../../fakes/fake_chord_repository.dart';

/// Tests del modo juego: secuencia, evaluación y controlador.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Construye un acorde de prueba.
  Chord chord(String id, ChordRoot root, List<String> notes, int level) =>
      Chord(
        id: id,
        root: root,
        quality: ChordQuality.major,
        variants: <ChordVariant>[
          ChordVariant(
            id: '$id-1',
            positionLabel: 'Prueba',
            frets: const <int>[-1, 3, 5, 5, 3, 3],
            fingers: const <int>[0, 1, 3, 3, 2, 2],
            difficulty: Difficulty.fromLevel(level)!,
            notes: notes,
          ),
        ],
      );

  final List<Chord> chords = <Chord>[
    chord('C-maj', ChordRoot.c, const <String>['C', 'E', 'G'], 1),
    chord('G-maj', ChordRoot.g, const <String>['G', 'B', 'D'], 1),
    chord('D-maj', ChordRoot.d, const <String>['D', 'F#', 'A'], 3),
  ];
  final FakeChordRepository repository = FakeChordRepository(chords);

  test('la secuencia tiene la longitud pedida y respeta el nivel', () {
    final BuildGameSequenceUseCase useCase = BuildGameSequenceUseCase(
      repository,
    );
    final List<GameRound> rounds = useCase(fromLevel: 1);
    expect(rounds.length, 5);
    expect(rounds.first.chordId, isNotEmpty);
    final List<GameRound> level3 = useCase(fromLevel: 3, count: 3);
    expect(level3.every((GameRound r) => r.chordId == 'D-maj'), isTrue);
  });

  test('la evaluación calcula la proporción de notas detectadas', () {
    const EvaluateChordMatchUseCase useCase = EvaluateChordMatchUseCase();
    expect(useCase(const <String>['C', 'E', 'G'], <int>{}), 0);
    expect(
      useCase(const <String>['C', 'E', 'G'], <int>{0, 4}),
      closeTo(2 / 3, 0.01),
    );
    expect(
      useCase(const <String>['C', 'E', 'G'], <int>{0, 4, 7}),
      closeTo(1, 0.01),
    );
  });

  test('el controlador empieza, acierta y suma puntos', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    final FakeAudioRepository audio = FakeAudioRepository();
    final GameScoreController score = GameScoreController(preferences)
      ..loadBestScore();
    final GameAudioController tuner = GameAudioController(audio);
    final GameController controller = GameController(
      audio,
      repository,
      score,
      tuner,
    )..start(level: 1);
    final List<GameRound> rounds = controller.rounds;
    expect(rounds.length, 5);
    expect(controller.phase, GamePhase.idle);

    final String targetId = controller.currentRound!.chordId;
    final List<String> targetNotes = chords
        .firstWhere((Chord c) => c.id == targetId)
        .easiestVariant
        .notes;
    // El juego escucha durante el tiempo de la ronda (5 segundos).
    final Future<void> playing = controller.playRound();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    targetNotes.forEach(audio.emitReading);
    unawaited(playing);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(tuner.matchRatio, greaterThan(0.5));
    await Future<void>.delayed(const Duration(seconds: 6));
    expect(score.score, greaterThan(0));
    expect(score.streak, 1);
    expect(controller.phase, GamePhase.won);
  });
}
