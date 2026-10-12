import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/minigames/entities/mic_challenge_judge.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:test/test.dart';

PitchReading _reading(String note, {double clarity = 0.9}) =>
    PitchReading(frequency: 440, note: note, cents: 0, clarity: clarity);

/// Tests del mástil, el marcador y el juez del micrófono.
void main() {
  group('mástil', () {
    test('las cuerdas al aire dan la afinación estándar', () {
      expect(
        <String>[for (int s = 6; s >= 1; s--) FretPosition(s, 0).note],
        <String>['E', 'A', 'D', 'G', 'B', 'E'],
      );
    });

    test('cada traste sube un semitono', () {
      expect(const FretPosition(6, 1).note, 'F');
      expect(const FretPosition(6, 5).note, 'A');
      expect(const FretPosition(5, 3).note, 'C');
      expect(const FretPosition(1, 5).note, 'A');
    });

    test('el traste 12 es la octava de la cuerda al aire', () {
      for (int s = 1; s <= 6; s++) {
        expect(
          const FretPosition(3, 12).frequency,
          closeTo(const FretPosition(3, 0).frequency * 2, 0.001),
        );
        expect(FretPosition(s, 12).pitchClass, FretPosition(s, 0).pitchClass);
      }
    });

    test('fretsOfPitchClass encuentra un solo traste por cuerda', () {
      for (int s = 1; s <= 6; s++) {
        for (int pc = 0; pc < 12; pc++) {
          final List<int> frets = fretsOfPitchClass(s, pc);
          expect(frets.length, 1);
          expect(FretPosition(s, frets.single).pitchClass, pc);
        }
      }
    });

    test('pitchClassOfLabel ignora la octava', () {
      expect(pitchClassOfLabel('A#3'), 10);
      expect(pitchClassOfLabel('C'), 0);
      expect(pitchClassOfLabel('??'), -1);
    });
  });

  group('marcador', () {
    test('las estrellas dependen del porcentaje', () {
      expect(starsForPercent(100), 3);
      expect(starsForPercent(90), 3);
      expect(starsForPercent(89), 2);
      expect(starsForPercent(70), 2);
      expect(starsForPercent(69), 1);
      expect(starsForPercent(40), 1);
      expect(starsForPercent(39), 0);
    });

    test('la racha suma puntos extra y un fallo la corta', () {
      MiniGameScore score = const MiniGameScore().record(isCorrect: true);
      expect(score.points, 10);
      score = score.record(isCorrect: true);
      expect(score.points, 10 + 12);
      score = score.record(isCorrect: false);
      expect(score.streak, 0);
      expect(score.bestStreak, 2);
      expect(score.total, 3);
      expect(score.correct, 2);
      expect(score.percent, 67);
    });

    test('un marcador vacío no divide por cero', () {
      expect(const MiniGameScore().percent, 0);
      expect(const MiniGameScore().stars, 0);
    });
  });

  group('juez del micrófono', () {
    test('exige varias lecturas seguidas de la misma nota', () {
      final MicChallengeJudge judge = MicChallengeJudge(<int>[0]);
      expect(judge.feed(_reading('C4')), isFalse);
      expect(judge.feed(_reading('C4')), isFalse);
      expect(judge.feed(_reading('C4')), isTrue);
      expect(judge.isComplete, isTrue);
    });

    test('una nota distinta reinicia la cuenta', () {
      final MicChallengeJudge judge = MicChallengeJudge(<int>[0]);
      final List<bool> hits = <bool>[
        for (final String note in <String>['C4', 'C4', 'D4', 'C4'])
          judge.feed(_reading(note)),
      ];
      expect(hits, everyElement(isFalse));
      expect(judge.progress, 0);
      expect(judge.lastHeard, 0);
    });

    test('ignora lecturas poco fiables', () {
      final MicChallengeJudge judge = MicChallengeJudge(<int>[
        0,
      ], confirmations: 1);
      expect(judge.feed(_reading('C4', clarity: 0.3)), isFalse);
      expect(judge.lastHeard, isNull);
    });

    test('una secuencia avanza nota a nota en orden', () {
      final MicChallengeJudge judge = MicChallengeJudge(<int>[
        0,
        4,
        7,
      ], confirmations: 1);
      expect(judge.feed(_reading('E3')), isFalse);
      expect(judge.feed(_reading('C3')), isTrue);
      expect(judge.next, 4);
      expect(judge.feed(_reading('E3')), isTrue);
      expect(judge.feed(_reading('G3')), isTrue);
      expect(judge.isComplete, isTrue);
      expect(judge.next, isNull);
    });
  });
}
