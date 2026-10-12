import 'dart:math' as math;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:test/test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

double _tone(QuizQuestion q, int i) => (q.cues[i] as ToneCue).frequency;

int _pitchClassOf(double frequency) =>
    (12 * math.log(frequency / 440) / math.ln2 + 69).round() % 12;

double _semitones(double from, double to) =>
    12 * math.log(to / from) / math.ln2;

/// Tests de los generadores de preguntas y retos de los minijuegos.
void main() {
  final FakeChordRepository bank = loadChordBank();
  final BuildQuizUseCase quiz = BuildQuizUseCase(bank, random: math.Random(3));

  final List<MiniGameKind> quizKinds = <MiniGameKind>[
    for (final MiniGameKind kind in MiniGameKind.values)
      if (quiz.supports(kind)) kind,
  ];

  test('hay 17 minijuegos repartidos en tres familias', () {
    expect(MiniGameKind.values.length, 17);
    expect(MiniGameKind.of(MiniGameCategory.ear).length, 9);
    expect(MiniGameKind.of(MiniGameCategory.fretboard).length, 5);
    expect(MiniGameKind.of(MiniGameCategory.play).length, 3);
  });

  test('cada juego es de opciones, del tablero o de micrófono', () {
    final BuildMicChallengesUseCase mic = BuildMicChallengesUseCase();
    for (final MiniGameKind kind in MiniGameKind.values) {
      final int handlers =
          (quiz.supports(kind) ? 1 : 0) +
          (mic.supports(kind) ? 1 : 0) +
          (kind == MiniGameKind.buildChord ? 1 : 0);
      expect(handlers, 1, reason: '${kind.id} debe tener un solo motor');
    }
  });

  group('preguntas de opciones', () {
    for (final MiniGameKind kind in quizKinds) {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        test('${kind.id} (${level.id}) es coherente', () {
          for (int round = 0; round < 8; round++) {
            final List<QuizQuestion> questions = quiz(kind, level);
            expect(questions.length, kind.rounds);
            for (final QuizQuestion q in questions) {
              final Set<QuizChoice> unique = q.choices.toSet();
              expect(unique.length, q.choices.length, reason: 'repetidas');
              expect(q.choices.length, greaterThanOrEqualTo(2));
              for (final int index in q.answer) {
                expect(index, inInclusiveRange(0, q.choices.length - 1));
              }
              expect(q.kind, kind);
            }
          }
        });
      }
    }

    test('no repite la misma pregunta dos veces seguidas', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        final List<QuizQuestion> questions = quiz(
          MiniGameKind.whichString,
          level,
        );
        for (int i = 1; i < questions.length; i++) {
          expect(questions[i].signature, isNot(questions[i - 1].signature));
        }
      }
    });
  });

  group('la respuesta correcta coincide con lo que suena', () {
    test('adivina la nota', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.guessNote, level)) {
          final String note = q.correctChoice.value;
          expect(noteOf(_tone(q, 0)), note);
          if (level == MiniGameLevel.easy) {
            expect(note.contains('#'), isFalse);
            expect(q.choices.length, 4);
          }
          if (level == MiniGameLevel.hard) {
            expect(q.choices.length, 12);
          }
        }
      }
    });

    test('qué cuerda', () {
      for (final QuizQuestion q in quiz(
        MiniGameKind.whichString,
        MiniGameLevel.medium,
      )) {
        final int string = int.parse(q.correctChoice.value);
        expect(_tone(q, 0), closeTo(FretPosition(string, 0).frequency, 0.01));
        expect(q.choices.length, 6);
      }
      for (final QuizQuestion q in quiz(
        MiniGameKind.whichString,
        MiniGameLevel.easy,
      )) {
        expect(q.choices.length, 3);
      }
    });

    test('qué traste', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.whichFret, level)) {
          final int fret = int.parse(q.correctChoice.value);
          expect(_semitones(_tone(q, 0), _tone(q, 1)), closeTo(fret, 0.001));
          expect(
            _tone(q, 0),
            closeTo(FretPosition(q.stringNumber!, 0).frequency, 0.01),
          );
          final List<int> values = <int>[
            for (final QuizChoice c in q.choices) int.parse(c.value),
          ];
          expect(values, <int>[...values]..sort());
        }
      }
    });

    test('intervalos', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.interval, level)) {
          final int semitones = int.parse(q.correctChoice.value);
          expect(
            _semitones(_tone(q, 0), _tone(q, 1)),
            closeTo(semitones, 0.001),
          );
        }
      }
    });

    test('agudo o grave', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.higherLower, level)) {
          final bool secondHigher = _tone(q, 1) > _tone(q, 0);
          expect(q.correctChoice.value, secondHigher ? 'second' : 'first');
          expect(
            _semitones(_tone(q, 0), _tone(q, 1)).abs(),
            greaterThanOrEqualTo(1 - 1e-9),
          );
        }
      }
    });

    test('oído de afinador', () {
      for (final QuizQuestion q in quiz(
        MiniGameKind.tuneEar,
        MiniGameLevel.hard,
      )) {
        final double cents = 100 * _semitones(_tone(q, 0), _tone(q, 1));
        final String verdict = switch (q.correctChoice.value) {
          'flat' => 'flat',
          'sharp' => 'sharp',
          _ => 'inTune',
        };
        expect(verdict, cents < -5 ? 'flat' : (cents > 5 ? 'sharp' : 'inTune'));
      }
    });

    test('mayor o menor y reconoce el acorde', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.chordQuality, level)) {
          final Chord chord = bank.chordById(
            (q.cues.single as ChordCue).chordId,
          )!;
          expect(chord.quality.id, q.correctChoice.value);
        }
        for (final QuizQuestion q in quiz(MiniGameKind.nameChord, level)) {
          expect((q.cues.single as ChordCue).chordId, q.correctChoice.value);
          expect(q.correctChoice.label, bank.chordById(q.chordId!)!.name);
        }
      }
    });

    test('memoria de cuerdas crece y no repite seguidas', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        final List<QuizQuestion> questions = quiz(MiniGameKind.memory, level);
        expect(
          questions.last.answer.length,
          greaterThan(questions.first.answer.length),
        );
        for (final QuizQuestion q in questions) {
          for (int i = 0; i < q.answer.length; i++) {
            final int string = int.parse(q.choices[q.answer[i]].value);
            expect(
              _tone(q, i),
              closeTo(FretPosition(string, 0).frequency, 0.01),
            );
            if (i > 0) {
              expect(q.answer[i], isNot(q.answer[i - 1]));
            }
          }
        }
      }
    });

    test('notas del mástil y busca la nota', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.noteAtFret, level)) {
          expect(
            FretPosition(q.stringNumber!, q.fret!).note,
            q.correctChoice.value,
          );
        }
        for (final QuizQuestion q in quiz(MiniGameKind.fretOfNote, level)) {
          final int fret = int.parse(q.correctChoice.value);
          expect(FretPosition(q.stringNumber!, fret).note, q.note);
        }
      }
    });

    test('qué dedo y lee el diagrama', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in quiz(MiniGameKind.fingerQuiz, level)) {
          final Chord chord = bank.chordById(q.chordId!)!;
          final int index = 6 - q.stringNumber!;
          expect(
            chord.variants[q.variantIndex].fingers[index],
            int.parse(q.correctChoice.value),
          );
          expect(chord.variants[q.variantIndex].frets[index], greaterThan(0));
        }
        for (final QuizQuestion q in quiz(MiniGameKind.readDiagram, level)) {
          expect(q.chordId, q.correctChoice.value);
        }
      }
    });
  });

  group('retos de micrófono', () {
    final BuildMicChallengesUseCase mic = BuildMicChallengesUseCase(
      random: math.Random(5),
    );

    test('toca la nota y cuerda y traste apuntan a la nota que suena', () {
      for (final MiniGameKind kind in <MiniGameKind>[
        MiniGameKind.playNote,
        MiniGameKind.playStringFret,
      ]) {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final MicChallenge c in mic(kind, level)) {
            expect(c.pitchClasses.length, 1);
            expect(
              FretPosition(c.stringNumber!, c.fret!).pitchClass,
              c.pitchClasses.single,
            );
            expect(c.timeLimitMs, greaterThanOrEqualTo(10000));
          }
        }
      }
    });

    test('el eco tiene tantas notas como sonidos y no repite seguidas', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final MicChallenge c in mic(MiniGameKind.echo, level)) {
          expect(c.cues.length, c.pitchClasses.length);
          expect(c.isSequence, isTrue);
          for (int i = 0; i < c.pitchClasses.length; i++) {
            expect(
              _pitchClassOf((c.cues[i] as ToneCue).frequency),
              c.pitchClasses[i],
            );
            if (i > 0) {
              expect(c.pitchClasses[i], isNot(c.pitchClasses[i - 1]));
            }
          }
        }
      }
    });

    test('solo el nivel fácil enseña pista en toca la nota', () {
      expect(
        mic(
          MiniGameKind.playNote,
          MiniGameLevel.easy,
        ).every((MicChallenge c) => c.showHint),
        isTrue,
      );
      expect(
        mic(
          MiniGameKind.playNote,
          MiniGameLevel.hard,
        ).any((MicChallenge c) => c.showHint),
        isFalse,
      );
    });
  });

  test('arma el acorde propone acordes que caben en el tablero', () {
    final BuildChordRoundsUseCase rounds = BuildChordRoundsUseCase(
      bank,
      random: math.Random(1),
    );
    for (final MiniGameLevel level in MiniGameLevel.values) {
      final List<ChordRound> list = rounds(level);
      expect(list.length, MiniGameKind.buildChord.rounds);
      for (final ChordRound round in list) {
        final Chord chord = bank.chordById(round.chordId)!;
        expect(
          chord.variants[round.variantIndex].frets.every(
            (int f) => f <= kBuildFrets,
          ),
          isTrue,
        );
      }
    }
  });

  test('wrongStrings señala las cuerdas que no coinciden', () {
    expect(
      wrongStrings(<int>[-1, 3, 2, 0, 1, 0], <int>[-1, 3, 2, 0, 1, 0]),
      isEmpty,
    );
    expect(
      wrongStrings(<int>[-1, 3, 2, 0, 1, 0], <int>[0, 3, 2, 0, 2, 0]),
      <int>[0, 4],
    );
  });
}

/// Nombre de la nota (notación inglesa) más cercana a una frecuencia.
String noteOf(double frequency) => const <String>[
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B',
][_pitchClassOf(frequency)];
