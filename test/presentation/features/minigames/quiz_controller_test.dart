import 'dart:math' as math;

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_controller.dart';
import 'package:chords/presentation/features/minigames/quiz_state.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';

/// Tests del controlador de los minijuegos de preguntas de opciones.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService preferences;
  late FakeAudioRepository audio;
  late FakeChordRepository bank;
  late MiniGameProgressController progress;
  late QuizController quiz;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    audio = FakeAudioRepository();
    bank = loadChordBank();
    progress = MiniGameProgressController(preferences);
    quiz = QuizController(
      bank,
      SoundCuePlayer(audio, bank, wait: (Duration d) async {}),
      progress,
      buildQuiz: BuildQuizUseCase(bank, random: math.Random(11)),
    );
  });

  Future<void> begin(MiniGameKind kind, MiniGameLevel level) async {
    quiz.open(kind);
    await quiz.start(level);
    await pumpEventQueue();
  }

  /// Responde bien la pregunta actual (todas las notas de una secuencia).
  void answerRight() {
    final QuizQuestion q = quiz.state.question!;
    q.answer.forEach(quiz.answer);
  }

  /// Responde mal la pregunta actual.
  void answerWrong() {
    final QuizQuestion q = quiz.state.question!;
    final int wrong = List<int>.generate(
      q.choices.length,
      (int i) => i,
    ).firstWhere((int i) => i != q.answer.first);
    quiz.answer(wrong);
  }

  test('open deja la bienvenida del juego sin partida', () {
    quiz.open(MiniGameKind.interval);
    expect(quiz.state.kind, MiniGameKind.interval);
    expect(quiz.state.phase, MiniGamePhase.intro);
    expect(quiz.state.question, isNull);
  });

  test('start prepara las preguntas y suena la primera', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.easy);
    expect(quiz.state.phase, MiniGamePhase.asking);
    expect(quiz.state.total, 10);
    expect(audio.tones.length, 1);
    expect(quiz.state.isPlaying, isFalse);
    expect(quiz.state.replaysLeft, MiniGameLevel.easy.replays);
  });

  test('los juegos con acordes cargan el banco si aún no está', () async {
    expect(bank.isLoaded, isFalse);
    await begin(MiniGameKind.nameChord, MiniGameLevel.easy);
    expect(bank.isLoaded, isTrue);
    expect(audio.played.length, 1);
  });

  test(
    'acertar suma, fallar corta la racha y se muestra el resultado',
    () async {
      await begin(MiniGameKind.guessNote, MiniGameLevel.easy);
      answerRight();
      expect(quiz.state.phase, MiniGamePhase.feedback);
      expect(quiz.state.wasCorrect, isTrue);
      expect(quiz.state.score.correct, 1);
      await quiz.next();
      answerWrong();
      expect(quiz.state.wasCorrect, isFalse);
      expect(quiz.state.score.streak, 0);
      expect(quiz.state.score.total, 2);
    },
  );

  test('no se puede responder dos veces la misma pregunta', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.easy);
    answerRight();
    quiz.answer(0);
    expect(quiz.state.score.total, 1);
  });

  test('next no avanza si aún no se ha respondido', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.easy);
    await quiz.next();
    expect(quiz.state.index, 0);
  });

  test('una partida perfecta termina con tres estrellas y récord', () async {
    await begin(MiniGameKind.whichString, MiniGameLevel.medium);
    for (int i = 0; i < quiz.state.total; i++) {
      answerRight();
      await quiz.next();
    }
    expect(quiz.state.phase, MiniGamePhase.finished);
    expect(quiz.state.score.stars, 3);
    expect(quiz.state.isNewBest, isTrue);
    expect(preferences.miniGameBest('whichString_medium'), 100);
    expect(progress.starsFor(MiniGameKind.whichString), 3);
    expect(progress.totalStars, 3);
  });

  test('una partida peor no pisa el récord ni cuenta como nuevo', () async {
    await begin(MiniGameKind.whichString, MiniGameLevel.easy);
    for (int i = 0; i < quiz.state.total; i++) {
      answerRight();
      await quiz.next();
    }
    await begin(MiniGameKind.whichString, MiniGameLevel.easy);
    for (int i = 0; i < quiz.state.total; i++) {
      answerWrong();
      await quiz.next();
    }
    expect(quiz.state.score.percent, 0);
    expect(quiz.state.isNewBest, isFalse);
    expect(progress.bestFor(MiniGameKind.whichString, MiniGameLevel.easy), 100);
  });

  test('las repeticiones se gastan y después no suena más', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.hard);
    expect(quiz.state.replaysLeft, 3);
    for (int i = 0; i < 3; i++) {
      await quiz.replay();
    }
    expect(quiz.state.replaysLeft, 0);
    expect(quiz.state.canReplay, isFalse);
    final int heard = audio.tones.length;
    await quiz.replay();
    expect(audio.tones.length, heard);
  });

  test('tras responder se puede volver a escuchar sin gastar', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.hard);
    answerRight();
    final int left = quiz.state.replaysLeft;
    final int heard = audio.tones.length;
    await quiz.replay();
    expect(audio.tones.length, heard + 1);
    expect(quiz.state.replaysLeft, left);
  });

  test('cada pregunta recupera sus repeticiones', () async {
    await begin(MiniGameKind.guessNote, MiniGameLevel.hard);
    await quiz.replay();
    answerRight();
    await quiz.next();
    expect(quiz.state.replaysLeft, 3);
  });

  test('las secuencias piden todas las cuerdas en orden', () async {
    await begin(MiniGameKind.memory, MiniGameLevel.easy);
    final QuizQuestion q = quiz.state.question!;
    expect(q.isSequence, isTrue);
    expect(audio.tones.length, q.answer.length);
    quiz.answer(q.answer.first);
    expect(quiz.state.phase, MiniGamePhase.asking);
    expect(quiz.state.input, <int>[q.answer.first]);
    q.answer.skip(1).forEach(quiz.answer);
    expect(quiz.state.phase, MiniGamePhase.feedback);
    expect(quiz.state.wasCorrect, isTrue);
  });

  test('en una secuencia un fallo la da por perdida al instante', () async {
    await begin(MiniGameKind.memory, MiniGameLevel.easy);
    final QuizQuestion q = quiz.state.question!;
    final int wrong = List<int>.generate(
      q.choices.length,
      (int i) => i,
    ).firstWhere((int i) => i != q.answer.first);
    quiz.answer(wrong);
    expect(quiz.state.phase, MiniGamePhase.feedback);
    expect(quiz.state.wasCorrect, isFalse);
  });

  test('salir corta el sonido en curso', () async {
    await begin(MiniGameKind.interval, MiniGameLevel.easy);
    quiz.leave();
    expect(quiz.state.kind, MiniGameKind.interval);
  });

  test('QuizState.copyWith conserva lo que no se cambia', () {
    const QuizState state = QuizState(
      kind: MiniGameKind.interval,
      level: MiniGameLevel.hard,
      index: 3,
    );
    final QuizState copy = state.copyWith(isPlaying: true);
    expect(copy.kind, MiniGameKind.interval);
    expect(copy.level, MiniGameLevel.hard);
    expect(copy.index, 3);
    expect(copy.isPlaying, isTrue);
  });
}
