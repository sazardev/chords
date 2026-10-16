import 'dart:math' as math;

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/entities/chord_changes_rules.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';
import 'package:chords/domain/minigames/usecases/next_chord_change_use_case.dart';
import 'package:chords/presentation/features/minigames/chord_changes_controller.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';
import '../../../fakes/manual_question_clock.dart';

/// Tests del controlador de "cambios de acorde": cuenta atrás, cambios
/// limpios, acordes fallados, fin de la partida y récord.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService preferences;
  late FakeAudioRepository audio;
  late FakeChordRepository bank;
  late ManualQuestionClock clock;
  late ChordChangesController game;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    audio = FakeAudioRepository();
    bank = loadChordBank();
    clock = ManualQuestionClock();
    game = ChordChangesController(
      audio,
      bank,
      MiniGameProgressController(preferences),
      clock: clock,
      next: NextChordChangeUseCase(bank, random: math.Random(9)),
    );
  });

  tearDown(() {
    game
      ..leave()
      ..dispose();
  });

  /// Empieza una partida y deja pasar la cuenta atrás.
  Future<void> begin([MiniGameLevel level = MiniGameLevel.easy]) async {
    game.open();
    await game.start(level);
    await pumpEventQueue();
    clock.elapse(3000);
  }

  /// Toca todas las notas del acorde pedido (tras el silencio de ajuste).
  Future<void> playTarget() async {
    clock.tick(2);
    final Chord chord = game.state.target!;
    for (final int pc in pitchClassesOfChord(chord)) {
      audio.emitReading(noteNameOfPitchClass(pc));
      await pumpEventQueue();
    }
  }

  test('open deja la bienvenida sin partida ni reloj', () {
    game.open();
    expect(game.state.phase, MiniGamePhase.intro);
    expect(game.state.target, isNull);
    expect(clock.running, isFalse);
  });

  test(
    'start abre el micrófono y cuenta atrás antes del primer acorde',
    () async {
      game.open();
      await game.start(MiniGameLevel.medium);
      await pumpEventQueue();
      expect(audio.requests, 1);
      expect(game.state.phase, MiniGamePhase.asking);
      expect(game.state.micStatus, MicStatus.listening);
      expect(game.state.readyMs, 3000);
      expect(game.state.target, isNull);

      clock.elapse(2000);
      expect(game.state.phase, MiniGamePhase.asking);
      clock.elapse(1000);
      expect(game.state.phase, MiniGamePhase.listening);
      expect(game.state.target, isNotNull);
      expect(game.state.msLeft, 60000);
      expect(game.state.goal, ChordChangesRules.of(MiniGameLevel.medium).goal);
    },
  );

  test('tocar el acorde pedido suma un cambio limpio y pide otro', () async {
    await begin();
    final Chord first = game.state.target!;
    await playTarget();
    expect(game.state.changes, 1);
    expect(game.state.misses, 0);
    expect(game.state.lastClean, isTrue);
    expect(game.state.score.correct, 1);
    expect(game.state.score.streak, 1);
    expect(game.state.target!.id, isNot(first.id));
    expect(game.state.heardNotes, 0);
  });

  test('el eco del acorde anterior no puntúa el siguiente', () async {
    await begin();
    final Chord first = game.state.target!;
    await playTarget();
    final Chord second = game.state.target!;
    clock.tick(2);
    // Solo suenan las notas que el acorde anterior compartía con el nuevo.
    final Set<int> shared = pitchClassesOfChord(first)
        .intersection(pitchClassesOfChord(second));
    for (final int pc in shared) {
      audio.emitReading(noteNameOfPitchClass(pc));
      await pumpEventQueue();
    }
    expect(game.state.changes, 1);
    expect(game.state.heardNotes, lessThan(game.state.targetNotes));
  });

  test('las lecturas durante el ajuste inicial se ignoran', () async {
    await begin();
    for (final int pc in pitchClassesOfChord(game.state.target!)) {
      audio.emitReading(noteNameOfPitchClass(pc));
      await pumpEventQueue();
    }
    expect(game.state.changes, 0, reason: 'el acorde anterior aún se apaga');
  });

  test('un acorde que agota su tiempo se da por fallado', () async {
    await begin();
    final ChordChangesRules rules = ChordChangesRules.of(MiniGameLevel.easy);
    final Chord first = game.state.target!;
    clock.elapse(rules.perChordMs);
    expect(game.state.misses, 1);
    expect(game.state.changes, 0);
    expect(game.state.lastClean, isFalse);
    expect(game.state.score.total, 1);
    expect(game.state.score.streak, 0);
    expect(game.state.target!.id, isNot(first.id));
  });

  test('saltar cuenta como fallo y pasa al acorde siguiente', () async {
    await begin();
    final Chord first = game.state.target!;
    game.skip();
    expect(game.state.misses, 1);
    expect(game.state.target!.id, isNot(first.id));
  });

  test('oír el acorde suena por el altavoz y el micrófono lo ignora', () async {
    await begin();
    final Chord chord = game.state.target!;
    await game.hear();
    expect(audio.played, <String>[chord.id]);
    clock.tick(2);
    for (final int pc in pitchClassesOfChord(chord)) {
      audio.emitReading(noteNameOfPitchClass(pc));
      await pumpEventQueue();
    }
    expect(game.state.changes, 0, reason: 'era el sonido de la propia app');
    clock.tick(12);
    for (final int pc in pitchClassesOfChord(chord)) {
      audio.emitReading(noteNameOfPitchClass(pc));
      await pumpEventQueue();
    }
    expect(game.state.changes, 1);
  });

  test('al acabar los 60 s termina con estrellas y guarda el récord', () async {
    await begin();
    for (int i = 0; i < 8; i++) {
      await playTarget();
    }
    expect(game.state.changes, 8);
    clock.elapse(60000);
    await pumpEventQueue();
    expect(game.state.phase, MiniGamePhase.finished);
    expect(game.state.score.correct, 8);
    expect(game.state.score.total, 8);
    expect(game.state.score.stars, 3);
    expect(game.state.isNewBest, isTrue);
    expect(preferences.miniGameBest('chordChanges_easy'), 100);
    expect(clock.running, isFalse);
  });

  test('menos cambios que la meta dan menos estrellas', () async {
    await begin();
    for (int i = 0; i < 4; i++) {
      await playTarget();
    }
    clock.elapse(60000);
    await pumpEventQueue();
    expect(game.state.score.percent, 50);
    expect(game.state.score.stars, 1);
  });

  test('cambios de más no pasan del cien por cien', () async {
    await begin();
    for (int i = 0; i < 11; i++) {
      await playTarget();
    }
    clock.elapse(60000);
    await pumpEventQueue();
    expect(game.state.changes, 11);
    expect(game.state.score.percent, 100);
  });

  test('sin permiso de micrófono no arranca el reloj', () async {
    audio.accessResult = MicStatus.permissionDenied;
    game.open();
    await game.start(MiniGameLevel.easy);
    await pumpEventQueue();
    expect(game.state.micStatus, MicStatus.permissionDenied);
    expect(clock.running, isFalse);
    expect(audio.stops, greaterThan(0));

    audio.accessResult = MicStatus.listening;
    await game.start(MiniGameLevel.easy);
    await pumpEventQueue();
    expect(game.state.micStatus, MicStatus.listening);
    expect(clock.running, isTrue);
  });

  test('salir corta el reloj y cierra el micrófono', () async {
    await begin();
    game.leave();
    await pumpEventQueue();
    expect(clock.running, isFalse);
    expect(audio.stops, greaterThan(0));
  });
}
