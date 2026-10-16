import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/chord_changes_rules.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/domain/minigames/services/chord_change_judge.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';
import 'package:chords/domain/minigames/usecases/next_chord_change_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// El juez de cambios, las reglas por dificultad y el acorde siguiente.
void main() {
  final FakeChordRepository bank = loadChordBank();

  Set<int> notesOf(String id) => pitchClassesOfChord(bank.chordById(id)!);

  group('juez de cambios', () {
    test('da por bueno el acorde cuando suenan todas sus notas', () {
      final ChordChangeJudge judge =
          ChordChangeJudge(target: notesOf('G-maj'), minRatio: 1)
            ..feed(<int>{7})
            ..feed(<int>{11});
      expect(judge.isMatch, isFalse);
      expect(judge.ratio, closeTo(2 / 3, 0.001));
      judge.feed(<int>{2});
      expect(judge.isMatch, isTrue);
      expect(judge.heardNotes, notesOf('G-maj'));
    });

    test(
      'el eco del acorde anterior no vale: hacen falta las notas nuevas',
      () {
        // Am (La Do Mi) tras C (Do Mi Sol): Do y Mi ya sonaban.
        final ChordChangeJudge judge = ChordChangeJudge(
          target: notesOf('A-min'),
          previous: notesOf('C-maj'),
          minRatio: 0.6,
        )..feed(<int>{0, 4});
        expect(judge.ratio, closeTo(2 / 3, 0.001));
        expect(judge.isMatch, isFalse, reason: 'falta el La, la nota nueva');
        judge.feed(<int>{9});
        expect(judge.isMatch, isTrue);
      },
    );

    test('una proporción baja basta en fácil y no en difícil', () {
      final Set<int> c = notesOf('C-maj');
      final ChordChangeJudge easy = ChordChangeJudge(target: c, minRatio: 0.6);
      final ChordChangeJudge hard = ChordChangeJudge(target: c, minRatio: 1);
      for (final ChordChangeJudge judge in <ChordChangeJudge>[easy, hard]) {
        judge.feed(<int>{0, 4});
      }
      expect(easy.isMatch, isTrue);
      expect(hard.isMatch, isFalse);
    });

    test('las notas ajenas al acorde no cuentan', () {
      final ChordChangeJudge judge = ChordChangeJudge(
        target: notesOf('C-maj'),
        minRatio: 1,
      )..feed(<int>{1, 3, 6});
      expect(judge.heardNotes, isEmpty);
      expect(judge.isMatch, isFalse);
    });

    test('sin notas objetivo nunca da por bueno nada', () {
      final ChordChangeJudge judge = ChordChangeJudge(
        target: const <int>{},
        minRatio: 0,
      )..feed(<int>{0});
      expect(judge.isMatch, isFalse);
      expect(judge.ratio, 0);
    });
  });

  group('reglas por dificultad', () {
    test(
      'la meta crece y el tiempo por acorde y la tolerancia se aprietan',
      () {
        final ChordChangesRules easy = ChordChangesRules.of(MiniGameLevel.easy);
        final ChordChangesRules medium = ChordChangesRules.of(
          MiniGameLevel.medium,
        );
        final ChordChangesRules hard = ChordChangesRules.of(MiniGameLevel.hard);
        expect(easy.goal, lessThan(medium.goal));
        expect(medium.goal, lessThan(hard.goal));
        expect(easy.perChordMs, greaterThan(medium.perChordMs));
        expect(medium.perChordMs, greaterThan(hard.perChordMs));
        expect(easy.minRatio, lessThan(medium.minRatio));
        expect(medium.minRatio, lessThan(hard.minRatio));
        expect(<int>{easy.totalMs, medium.totalMs, hard.totalMs}, <int>{60000});
      },
    );

    test('el marcador cuenta los cambios sobre la meta sin pasarse', () {
      const MiniGameScore played = MiniGameScore(
        correct: 20,
        total: 25,
        streak: 3,
        bestStreak: 9,
        points: 240,
      );
      final MiniGameScore result = played.againstGoal(16);
      expect(result.correct, 16);
      expect(result.total, 16);
      expect(result.percent, 100);
      expect(result.stars, 3);
      expect(result.bestStreak, 9);
      expect(result.points, 240);
      expect(played.againstGoal(40).percent, 50);
    });
  });

  group('acorde siguiente', () {
    test('nunca repite el anterior ni uno que suene igual', () {
      final NextChordChangeUseCase next = NextChordChangeUseCase(
        bank,
        random: math.Random(5),
      );
      for (final MiniGameLevel level in MiniGameLevel.values) {
        Chord? previous;
        for (int i = 0; i < 80; i++) {
          final Chord chord = next(level, previous: previous);
          if (previous != null) {
            expect(chord.id, isNot(previous.id));
            expect(
              pitchClassesOfChord(chord),
              isNot(pitchClassesOfChord(previous)),
            );
          }
          previous = chord;
        }
      }
    });

    test('los acordes fáciles son los de menor dificultad del banco', () {
      final NextChordChangeUseCase next = NextChordChangeUseCase(bank);
      for (final Chord chord in next.poolFor(MiniGameLevel.easy)) {
        expect(chord.difficulty.level, 1);
        expect(chord.quality.intervals.length, greaterThanOrEqualTo(3));
      }
      expect(
        next.poolFor(MiniGameLevel.easy).length,
        lessThan(next.poolFor(MiniGameLevel.hard).length),
      );
    });
  });
}
