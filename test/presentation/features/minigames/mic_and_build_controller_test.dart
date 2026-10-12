import 'dart:math' as math;

import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/presentation/features/minigames/build_chord_controller.dart';
import 'package:chords/presentation/features/minigames/build_chord_state.dart';
import 'package:chords/presentation/features/minigames/mic_game_controller.dart';
import 'package:chords/presentation/features/minigames/mini_game_phase.dart';
import 'package:chords/presentation/features/minigames/mini_game_progress_controller.dart';
import 'package:chords/presentation/features/minigames/sound_cue_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';

/// Tests de "arma el acorde" y de los juegos con micrófono.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PreferencesService preferences;
  late FakeAudioRepository audio;
  late FakeChordRepository bank;
  late MiniGameProgressController progress;
  late SoundCuePlayer player;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    audio = FakeAudioRepository();
    bank = loadChordBank();
    progress = MiniGameProgressController(preferences);
    player = SoundCuePlayer(audio, bank, wait: (Duration d) async {});
  });

  group('juegos con micrófono', () {
    late MicGameController mic;

    setUp(() {
      mic = MicGameController(
        audio,
        player,
        progress,
        buildChallenges: BuildMicChallengesUseCase(random: math.Random(2)),
        confirmations: 2,
      );
    });

    tearDown(() => mic.leave());

    Future<MicChallenge> begin(MiniGameKind kind) async {
      mic
        ..open(kind)
        ..start(MiniGameLevel.easy);
      return mic.state.challenge!;
    }

    /// Toca la nota `pc` (clase de tono) las veces necesarias.
    Future<void> play(int pc, {int times = 2}) async {
      for (int i = 0; i < times; i++) {
        audio.emitReading(noteNameOfPitchClass(pc));
        await pumpEventQueue();
      }
    }

    test('start prepara los retos y hear reproduce la nota', () async {
      final MicChallenge challenge = await begin(MiniGameKind.playNote);
      expect(mic.state.phase, MiniGamePhase.asking);
      expect(mic.state.total, 6);
      await mic.hear();
      expect(audio.tones.length, challenge.cues.length);
    });

    test('tocar la nota pedida supera el reto', () async {
      final MicChallenge challenge = await begin(MiniGameKind.playNote);
      await mic.listen();
      expect(mic.state.phase, MiniGamePhase.listening);
      await play(challenge.pitchClasses.single);
      expect(mic.state.phase, MiniGamePhase.feedback);
      expect(mic.state.wasCorrect, isTrue);
      expect(mic.state.score.correct, 1);
    });

    test('tocar otra nota no supera el reto y se ve lo que se oye', () async {
      final MicChallenge challenge = await begin(MiniGameKind.playNote);
      await mic.listen();
      final int other = (challenge.pitchClasses.single + 1) % 12;
      await play(other, times: 4);
      expect(mic.state.phase, MiniGamePhase.listening);
      expect(mic.state.heard, other);
    });

    test('el eco avanza nota a nota y exige todas', () async {
      final MicChallenge challenge = await begin(MiniGameKind.echo);
      await mic.listen();
      await play(challenge.pitchClasses.first);
      expect(mic.state.progress, 1);
      expect(mic.state.phase, MiniGamePhase.listening);
      for (final int pc in challenge.pitchClasses.skip(1)) {
        await play(pc);
      }
      expect(mic.state.phase, MiniGamePhase.feedback);
      expect(mic.state.wasCorrect, isTrue);
    });

    test('sin permiso de micrófono se queda esperando con el aviso', () async {
      audio.accessResult = MicStatus.permissionDenied;
      await begin(MiniGameKind.playNote);
      await mic.listen();
      expect(mic.state.phase, MiniGamePhase.asking);
      expect(mic.state.micStatus, MicStatus.permissionDenied);
      audio.accessResult = MicStatus.listening;
      await mic.listen();
      expect(mic.state.phase, MiniGamePhase.listening);
    });

    test('saltar da el reto por fallado', () async {
      await begin(MiniGameKind.playStringFret);
      await mic.listen();
      await mic.skip();
      expect(mic.state.phase, MiniGamePhase.feedback);
      expect(mic.state.wasCorrect, isFalse);
      expect(mic.state.score.total, 1);
    });

    test('una partida completa guarda el resultado', () async {
      await begin(MiniGameKind.playNote);
      for (int i = 0; i < mic.state.total; i++) {
        await mic.listen();
        await play(mic.state.challenge!.pitchClasses.single);
        await mic.next();
      }
      expect(mic.state.phase, MiniGamePhase.finished);
      expect(mic.state.score.stars, 3);
      expect(preferences.miniGameBest('playNote_easy'), 100);
    });

    test('next no hace nada antes de resolver el reto', () async {
      await begin(MiniGameKind.playNote);
      await mic.next();
      expect(mic.state.index, 0);
    });
  });

  group('arma el acorde', () {
    late BuildChordController build;

    setUp(() {
      build = BuildChordController(
        bank,
        audio,
        progress,
        buildRounds: BuildChordRoundsUseCase(bank, random: math.Random(4)),
      );
    });

    Future<void> begin([MiniGameLevel level = MiniGameLevel.easy]) async {
      build.open();
      await build.start(level);
    }

    /// Coloca en el tablero la posición de la ronda actual.
    void placeTarget() {
      final ChordRound round = build.state.round!;
      final Chord chord = bank.chordById(round.chordId)!;
      final List<int> frets = chord.variants[round.variantIndex].frets;
      for (int s = 0; s < 6; s++) {
        if (frets[s] == -1) {
          continue;
        }
        if (frets[s] == 0) {
          build.toggleMark(s);
        } else {
          build.tapCell(s, frets[s]);
        }
      }
    }

    test('empieza con las cuerdas silenciadas', () async {
      await begin();
      expect(build.state.phase, MiniGamePhase.asking);
      expect(build.state.placed, BuildChordState.kEmptyBoard);
      expect(build.state.total, 6);
    });

    test(
      'tocar una casilla coloca el dedo y repetir la deja al aire',
      () async {
        await begin();
        build.tapCell(1, 3);
        expect(build.state.placed[1], 3);
        build.tapCell(1, 3);
        expect(build.state.placed[1], 0);
        build.toggleMark(1);
        expect(build.state.placed[1], -1);
        build.toggleMark(1);
        expect(build.state.placed[1], 0);
      },
    );

    test('colocar bien el acorde suma un acierto', () async {
      await begin();
      placeTarget();
      build.check();
      expect(build.state.phase, MiniGamePhase.feedback);
      expect(build.state.wasCorrect, isTrue);
      expect(build.state.solved, isTrue);
      expect(build.state.score.correct, 1);
    });

    test('un tablero incorrecto señala las cuerdas que fallan', () async {
      await begin();
      build.check();
      expect(build.state.phase, MiniGamePhase.asking);
      expect(build.state.wrong, isNotEmpty);
      build.tapCell(0, 1);
      expect(build.state.wrong, isEmpty);
    });

    test('clear vuelve a silenciar todas las cuerdas', () async {
      await begin();
      placeTarget();
      build.clear();
      expect(build.state.placed, BuildChordState.kEmptyBoard);
    });

    test('en fácil la pista es gratis; en medio quita el acierto', () async {
      await begin();
      build.showHint();
      expect(build.state.revealsTarget, isTrue);
      placeTarget();
      build.check();
      expect(build.state.wasCorrect, isTrue);

      await begin(MiniGameLevel.medium);
      build.showHint();
      placeTarget();
      build.check();
      expect(build.state.solved, isTrue);
      expect(build.state.wasCorrect, isFalse);
      expect(build.state.score.correct, 0);
    });

    test('en difícil no hay pista', () async {
      await begin(MiniGameLevel.hard);
      build.showHint();
      expect(build.state.hinted, isFalse);
      expect(build.state.hintsAllowed, isFalse);
    });

    test('rendirse enseña la posición y falla la ronda', () async {
      await begin();
      build.giveUp();
      expect(build.state.phase, MiniGamePhase.feedback);
      expect(build.state.wasCorrect, isFalse);
      expect(build.state.solved, isFalse);
      expect(build.state.revealsTarget, isTrue);
    });

    test('pasar de ronda limpia el tablero y la pista', () async {
      await begin();
      build.showHint();
      placeTarget();
      build.check();
      await build.next();
      expect(build.state.index, 1);
      expect(build.state.placed, BuildChordState.kEmptyBoard);
      expect(build.state.hinted, isFalse);
      expect(build.state.solved, isFalse);
    });

    test('una partida completa termina con resultado y récord', () async {
      await begin();
      for (int i = 0; i < build.state.total; i++) {
        placeTarget();
        build.check();
        await build.next();
      }
      expect(build.state.phase, MiniGamePhase.finished);
      expect(build.state.score.stars, 3);
      expect(build.state.isNewBest, isTrue);
      expect(preferences.miniGameBest('buildChord_easy'), 100);
    });

    test('playTarget suena el acorde de la ronda', () async {
      await begin();
      await build.playTarget();
      expect(audio.played, <String>[build.state.round!.chordId]);
    });

    test('acepta cualquier posición válida del mismo acorde', () async {
      await begin();
      final Chord chord = bank.chordById(build.state.round!.chordId)!;
      final List<int> other = chord.variants.last.frets;
      if (other.every((int f) => f <= kBuildFrets)) {
        for (int s = 0; s < 6; s++) {
          if (other[s] > 0) {
            build.tapCell(s, other[s]);
          } else if (other[s] == 0) {
            build.toggleMark(s);
          }
        }
        build.check();
        expect(build.state.phase, MiniGamePhase.feedback);
      }
    });
  });
}
