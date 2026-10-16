import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/services/chord_formula.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_game_sampler.dart';

/// Juegos con acordes: reglas comunes, deletreo, fórmulas, variantes y memoria.
void main() {
  final ChordGameSampler s = ChordGameSampler();

  group('todos los juegos con acordes', () {
    for (final MiniGameKind kind in kChordQuizGames) {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        test(
          '${kind.id} (${level.id}): opciones únicas y respuesta válida',
          () {
            for (final QuizQuestion q in s.sample(kind, level)) {
              expect(q.choices.toSet().length, q.choices.length);
              expect(q.choices.length, greaterThanOrEqualTo(2));
              for (final int index in q.answer) {
                expect(index, inInclusiveRange(0, q.choices.length - 1));
              }
              expect(q.kind, kind);
            }
          },
        );
      }

      test('${kind.id}: más opciones al subir de dificultad', () {
        double average(MiniGameLevel level) {
          final List<QuizQuestion> all = s.sample(kind, level);
          return all.fold<int>(
                0,
                (int s, QuizQuestion q) => s + q.choices.length,
              ) /
              all.length;
        }

        expect(
          average(MiniGameLevel.medium),
          greaterThanOrEqualTo(average(MiniGameLevel.easy) - 0.2),
        );
        expect(
          average(MiniGameLevel.hard),
          greaterThanOrEqualTo(average(MiniGameLevel.medium) - 0.2),
        );
      });
    }

    test('las calidades estudiadas crecen con el nivel', () {
      final int easy = studyQualities(s.bank, MiniGameLevel.easy).length;
      final int medium = studyQualities(s.bank, MiniGameLevel.medium).length;
      final int hard = studyQualities(s.bank, MiniGameLevel.hard).length;
      expect(easy, lessThan(medium));
      expect(medium, lessThanOrEqualTo(hard));
      expect(hard, bankQualities(s.bank).length);
    });

    test('las calidades se eligen por popularidad según la dificultad', () {
      for (final ChordQuality q in studyQualities(s.bank, MiniGameLevel.easy)) {
        expect(q.popularity, greaterThanOrEqualTo(5), reason: q.id);
      }
      final Set<ChordQuality> medium = studyQualities(
        s.bank,
        MiniGameLevel.medium,
      ).toSet();
      for (final ChordQuality q in medium) {
        expect(q.popularity, greaterThanOrEqualTo(4), reason: q.id);
      }
      expect(
        medium.containsAll(studyQualities(s.bank, MiniGameLevel.easy)),
        isTrue,
      );
      expect(
        studyQualities(
          s.bank,
          MiniGameLevel.hard,
        ).any((ChordQuality q) => q.popularity <= 2),
        isTrue,
        reason: 'en difícil salen las calidades raras',
      );
    });

    test('las preguntas de fácil usan las calidades imprescindibles', () {
      for (final MiniGameKind kind in <MiniGameKind>[
        MiniGameKind.spellChord,
        MiniGameKind.chordFormula,
        MiniGameKind.chordVariantEar,
      ]) {
        for (final QuizQuestion q in s.sample(kind, MiniGameLevel.easy)) {
          expect(s.chordOf(q).quality.popularity, greaterThanOrEqualTo(5));
        }
      }
    });
  });

  group('respuestas equivalentes', () {
    const List<MiniGameKind> chordNameKinds = <MiniGameKind>[
      MiniGameKind.nameChord,
      MiniGameKind.readDiagram,
      MiniGameKind.rushOpen,
      MiniGameKind.rushBarre,
      MiniGameKind.rushSeventh,
      MiniGameKind.fillProgression,
      MiniGameKind.romanDegree,
      MiniGameKind.transposeChord,
      MiniGameKind.chordNeighbors,
      MiniGameKind.chordFormula,
      MiniGameKind.chordVariantEar,
    ];

    for (final MiniGameKind kind in chordNameKinds) {
      test('${kind.id}: ningún distractor tiene las notas de la respuesta', () {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in s.sample(kind, level)) {
            if (q.choices.first.type != ChoiceType.chord) {
              continue;
            }
            final ChordSymbol answer = s.symbolOf(q.correctChoice.value);
            for (final QuizChoice c in q.choices) {
              if (c == q.correctChoice) {
                continue;
              }
              expect(
                sameNotes(answer, s.symbolOf(c.value)),
                isFalse,
                reason: '${kind.id}: ${c.label} suena como ${answer.name}',
              );
            }
          }
        }
      });
    }
  });

  group('deletrea el acorde', () {
    test(
      'el conjunto correcto son las notas del acorde y ningún otro coincide',
      () {
        for (final MiniGameLevel level in <MiniGameLevel>[
          MiniGameLevel.easy,
          MiniGameLevel.medium,
        ]) {
          for (final QuizQuestion q in s.sample(
            MiniGameKind.spellChord,
            level,
          )) {
            final Chord chord = s.chordOf(q);
            final Set<int> notes = pitchClassesOfChord(chord);
            expect(s.tonesOf(q.correctChoice).toSet(), notes);
            for (final QuizChoice other in q.choices) {
              if (other != q.correctChoice) {
                expect(
                  s.tonesOf(other).toSet(),
                  isNot(notes),
                  reason: chord.name,
                );
              }
            }
          }
        }
      },
    );

    test(
      'en difícil se tocan las notas del acorde de la raíz hacia arriba',
      () {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.spellChord,
          MiniGameLevel.hard,
        )) {
          final Chord chord = s.chordOf(q);
          expect(q.isSequence, isTrue);
          expect(<int>[
            for (final int i in q.answer)
              pitchClassOfNoteName(q.choices[i].value),
          ], chordTones(chord.root.pitchClass, chord.quality));
        }
      },
    );
  });

  group('fórmula del acorde', () {
    test('la fórmula correcta es la de sus intervalos', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.chordFormula,
          level,
        )) {
          final Chord chord = s.chordOf(q);
          if (q.detail == 'toFormula') {
            expect(q.correctChoice.value, formulaText(chord.quality.intervals));
          } else {
            expect(q.correctChoice.value, chord.id);
            expect(q.params['formula'], formulaText(chord.quality.intervals));
            for (final QuizChoice c in q.choices) {
              expect(s.bank.chordById(c.value)!.root, chord.root);
            }
          }
        }
      }
    });

    test('las fórmulas tienen el grado y la alteración correctos', () {
      expect(formulaText(<int>[0, 4, 7]), '1 – 3 – 5');
      expect(formulaText(<int>[0, 3, 7]), '1 – ♭3 – 5');
      expect(formulaText(<int>[0, 4, 7, 10]), '1 – 3 – 5 – ♭7');
      expect(formulaText(<int>[0, 4, 7, 11]), '1 – 3 – 5 – 7');
      expect(formulaText(<int>[0, 3, 7, 9]), '1 – ♭3 – 5 – 6');
      expect(formulaText(<int>[0, 4, 7, 10, 14]), '1 – 3 – 5 – ♭7 – 9');
      expect(formulaText(<int>[0, 5, 7]), '1 – 4 – 5');
      expect(formulaText(<int>[0, 3, 6]), '1 – ♭3 – ♭5');
      expect(formulaText(<int>[0, 4, 8]), '1 – 3 – ♯5');
      expect(formulaText(<int>[0, 3, 6, 9]), '1 – ♭3 – ♭5 – ♭♭7');
      expect(formulaText(<int>[0, 3, 6, 10]), '1 – ♭3 – ♭5 – ♭7');
      expect(formulaText(<int>[0, 4, 7, 10, 13]), '1 – 3 – 5 – ♭7 – ♭9');
      expect(
        formulaText(<int>[0, 4, 7, 10, 14, 17, 21]),
        '1 – 3 – 5 – ♭7 – 9 – 11 – 13',
      );
    });
  });

  group('¿qué variante es?', () {
    test(
      'suena el acorde de la respuesta y todas las opciones comparten raíz',
      () {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in s.sample(
            MiniGameKind.chordVariantEar,
            level,
          )) {
            final Chord chord = s.chordOf(q);
            expect((q.cues.single as ChordCue).chordId, chord.id);
            expect(q.correctChoice.value, chord.id);
            for (final QuizChoice c in q.choices) {
              expect(s.bank.chordById(c.value)!.root, chord.root);
            }
          }
        }
      },
    );
  });

  group('memoria de acordes', () {
    test('la secuencia suena en el orden de la respuesta', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.chordMemory,
          level,
        )) {
          expect(q.isSequence, isTrue);
          expect(q.cues.length, q.answer.length);
          for (int i = 0; i < q.answer.length; i++) {
            expect(
              (q.cues[i] as ChordCue).chordId,
              q.choices[q.answer[i]].value,
            );
          }
          final List<ChordSymbol> symbols = <ChordSymbol>[
            for (final QuizChoice c in q.choices) s.symbolOf(c.value),
          ];
          for (int a = 0; a < symbols.length; a++) {
            for (int b = a + 1; b < symbols.length; b++) {
              expect(sameNotes(symbols[a], symbols[b]), isFalse);
            }
          }
        }
      }
    });

    test('la secuencia se alarga con la dificultad', () {
      double length(MiniGameLevel level) {
        final List<QuizQuestion> all = s.sample(
          MiniGameKind.chordMemory,
          level,
        );
        return all.fold<int>(
              0,
              (int s, QuizQuestion q) => s + q.answer.length,
            ) /
            all.length;
      }

      expect(
        length(MiniGameLevel.easy),
        lessThan(length(MiniGameLevel.medium)),
      );
      expect(
        length(MiniGameLevel.medium),
        lessThan(length(MiniGameLevel.hard)),
      );
    });
  });

  group('retos con tiempo', () {
    test('cada tema muestra posiciones de su tipo', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(MiniGameKind.rushOpen, level)) {
          expect(s.chordOf(q).variants[q.variantIndex].tags, contains('open'));
        }
        for (final QuizQuestion q in s.sample(MiniGameKind.rushBarre, level)) {
          expect(s.chordOf(q).variants[q.variantIndex].tags, contains('barre'));
        }
        for (final QuizQuestion q in s.sample(
          MiniGameKind.rushSeventh,
          level,
        )) {
          final List<int> intervals = s.chordOf(q).quality.intervals;
          expect(
            intervals.any((int i) => i % 12 == 10 || i % 12 == 11),
            isTrue,
          );
        }
      }
    });

    test('los juegos con tiempo dan menos segundos al subir de nivel', () {
      const MiniGameKind kind = MiniGameKind.rushOpen;
      expect(kind.timed, isTrue);
      expect(
        kind.timeLimitMs(MiniGameLevel.easy),
        greaterThan(kind.timeLimitMs(MiniGameLevel.medium)),
      );
      expect(
        kind.timeLimitMs(MiniGameLevel.medium),
        greaterThan(kind.timeLimitMs(MiniGameLevel.hard)),
      );
    });
  });

  group('progresión al oído ampliada', () {
    test('en difícil aparecen progresiones de todo el catálogo', () {
      final Set<String> answers = <String>{
        for (final QuizQuestion q in s.sample(
          MiniGameKind.progressionEar,
          MiniGameLevel.hard,
        ))
          q.correctChoice.value,
      };
      expect(answers.length, greaterThan(6));
      for (final QuizQuestion q in s.sample(
        MiniGameKind.progressionEar,
        MiniGameLevel.hard,
      )) {
        expect(q.choices.length, 6);
        for (final SoundCue cue in q.cues) {
          expect(s.bank.chordById((cue as ChordCue).chordId), isNotNull);
        }
      }
    });
  });
}

/// Clase de tono de un nombre de nota inglés (`F#`).
int pitchClassOfNoteName(String note) => ChordSymbol.parse(note).root;
