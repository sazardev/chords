import 'dart:math' as math;

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';
import '../../../fakes/manual_question_clock.dart';

/// El reloj de los retos con tiempo: se agota, puntúa la rapidez y se para.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService preferences;
  late FakeChordRepository bank;
  late ManualQuestionClock clock;
  late QuizController quiz;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    bank = loadChordBank();
    clock = ManualQuestionClock();
    quiz = QuizController(
      bank,
      SoundCuePlayer(FakeAudioRepository(), bank, wait: (Duration d) async {}),
      MiniGameProgressController(preferences),
      buildQuiz: BuildQuizUseCase(bank, random: math.Random(4)),
      clock: clock,
    );
  });

  tearDown(() {
    quiz
      ..leave()
      ..dispose();
  });

  Future<void> begin(MiniGameKind kind, MiniGameLevel level) async {
    quiz.open(kind);
    await quiz.start(level);
    await pumpEventQueue();
  }

  void answerRight() => quiz.state.question!.answer.forEach(quiz.answer);

  test('un reto con tiempo da todo el tiempo al empezar', () async {
    await begin(MiniGameKind.rushOpen, MiniGameLevel.medium);
    expect(clock.running, isTrue);
    expect(
      quiz.state.msLeft,
      MiniGameKind.rushOpen.timeLimitMs(MiniGameLevel.medium),
    );
  });

  test('los juegos sin tiempo no arrancan el reloj', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.easy);
    expect(clock.running, isFalse);
    expect(quiz.state.msLeft, 0);
  });

  test('el tiempo baja con el reloj y al agotarse se falla', () async {
    await begin(MiniGameKind.rushBarre, MiniGameLevel.hard);
    final int limit = MiniGameKind.rushBarre.timeLimitMs(MiniGameLevel.hard);
    clock.elapse(limit ~/ 2);
    expect(quiz.state.msLeft, limit - limit ~/ 2);
    expect(quiz.state.phase, MiniGamePhase.asking);

    clock.elapse(limit);
    expect(quiz.state.phase, MiniGamePhase.feedback);
    expect(quiz.state.wasCorrect, isFalse);
    expect(quiz.state.timedOut, isTrue);
    expect(quiz.state.msLeft, 0);
    expect(quiz.state.score.total, 1);
    expect(quiz.state.score.correct, 0);
    expect(clock.running, isFalse);
  });

  test('contestar a tiempo para el reloj y suma puntos de rapidez', () async {
    await begin(MiniGameKind.rushSeventh, MiniGameLevel.easy);
    answerRight();
    expect(quiz.state.wasCorrect, isTrue);
    expect(quiz.state.timedOut, isFalse);
    expect(clock.running, isFalse);
    expect(
      quiz.state.score.points,
      15,
      reason: '10 por acertar y 5 de rapidez',
    );
  });

  test('cuanto más se tarda menos rapidez se premia', () async {
    await begin(MiniGameKind.rushOpen, MiniGameLevel.easy);
    final int limit = MiniGameKind.rushOpen.timeLimitMs(MiniGameLevel.easy);
    clock.elapse(limit * 3 ~/ 5);
    answerRight();
    expect(quiz.state.score.points, 12);

    await quiz.next();
    clock.elapse(limit - 250);
    answerRight();
    expect(quiz.state.score.points, 12 + 12 + 0);
  });

  test('cada pregunta tiene su tiempo completo y el reloj se rearma', () async {
    await begin(MiniGameKind.rushOpen, MiniGameLevel.medium);
    final int limit = MiniGameKind.rushOpen.timeLimitMs(MiniGameLevel.medium);
    clock.elapse(limit ~/ 2);
    answerRight();
    await quiz.next();
    expect(quiz.state.msLeft, limit);
    expect(quiz.state.timedOut, isFalse);
    expect(clock.running, isTrue);
  });

  test('una partida que acaba con tiempo agotado cuenta como fallos', () async {
    await begin(MiniGameKind.rushOpen, MiniGameLevel.hard);
    final int limit = MiniGameKind.rushOpen.timeLimitMs(MiniGameLevel.hard);
    for (int i = 0; i < MiniGameKind.rushOpen.rounds; i++) {
      clock.elapse(limit);
      await quiz.next();
    }
    expect(quiz.state.phase, MiniGamePhase.finished);
    expect(quiz.state.score.correct, 0);
    expect(quiz.state.score.total, MiniGameKind.rushOpen.rounds);
    expect(clock.running, isFalse);
  });

  test('salir de la partida para el reloj', () async {
    await begin(MiniGameKind.rushOpen, MiniGameLevel.easy);
    quiz.leave();
    expect(clock.running, isFalse);
  });

  test('la respuesta correcta se ve tras agotar el tiempo', () async {
    await begin(MiniGameKind.rushOpen, MiniGameLevel.hard);
    final QuizQuestion q = quiz.state.question!;
    clock.elapse(MiniGameKind.rushOpen.timeLimitMs(MiniGameLevel.hard));
    expect(quiz.state.input, isEmpty);
    expect(q.answer, isNotEmpty);
  });
}
