import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/chord_pool.dart';
import 'package:chords/domain/minigames/generators/progression_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/style_duel_generator.dart';
import 'package:chords/domain/minigames/services/progression_tokens.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/roman_chord.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_game_sampler.dart';

/// Juegos de armonía: progresiones, grados, transporte, relativos y estilos.
void main() {
  final ChordGameSampler s = ChordGameSampler();

  group('completa la progresión', () {
    final Set<String> catalog = <String>{};
    for (final ChordProgression p in kProgressions) {
      catalog.add(progressionTokens(p).join(' '));
    }

    test(
      'al poner la respuesta en el hueco sale una progresión del catálogo',
      () {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in s.sample(
            MiniGameKind.fillProgression,
            level,
          )) {
            final int hole = q.bars.indexOf('?');
            expect(q.bars.where((String b) => b == '?').length, 1);
            final String answer = q.detail == 'roman'
                ? RomanChord.parse(q.correctChoice.value)
                      .inKey(q.keyTonic!)
                      .name
                : s.symbolOf(q.correctChoice.value).name;
            final List<String> filled = <String>[...q.bars]..[hole] = answer;
            final bool found = kProgressions.any(
              (ChordProgression p) =>
                  progressionTokens(p)
                      .map(
                        (String t) =>
                            RomanChord.parse(t).inKey(q.keyTonic!).name,
                      )
                      .join(' ') ==
                  filled.join(' '),
            );
            expect(found, isTrue, reason: filled.join(' '));
          }
        }
      },
    );

    test('ningún distractor suena igual que la respuesta', () {
      for (final QuizQuestion q in s.sample(
        MiniGameKind.fillProgression,
        MiniGameLevel.medium,
      )) {
        final ChordSymbol answer = s.symbolOf(q.correctChoice.value);
        for (final QuizChoice c in q.choices) {
          if (c != q.correctChoice) {
            expect(sameNotes(answer, s.symbolOf(c.value)), isFalse);
          }
        }
      }
    });

    test('en fácil y medio se oyen los acordes que no faltan', () {
      for (final QuizQuestion q in s.sample(
        MiniGameKind.fillProgression,
        MiniGameLevel.easy,
      )) {
        expect(q.cues.length, q.bars.length - 1);
      }
      for (final QuizQuestion q in s.sample(
        MiniGameKind.fillProgression,
        MiniGameLevel.hard,
      )) {
        expect(q.hasSound, isFalse);
      }
    });
  });

  group('grados romanos', () {
    test('el grado y el acorde se corresponden en la tonalidad', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.romanDegree,
          level,
        )) {
          if (q.detail == 'toChord') {
            final String token = <String>[
              ...kMajorRomans,
              ...kMinorRomans,
              'Imaj7',
              'ii7',
              'iii7',
              'IVmaj7',
              'vi7',
              'i7',
              'iv7',
              'v7',
              'bIII',
            ].firstWhere((String t) => romanLabel(t) == q.params['roman']);
            expect(
              q.correctChoice.value,
              RomanChord.parse(token).inKey(q.keyTonic!).chordId,
            );
          } else {
            final String name = RomanChord.parse(q.correctChoice.value)
                .inKey(q.keyTonic!)
                .name;
            expect(name, q.params['chord']);
          }
        }
      }
    });

    test('en fácil solo se pregunta I, IV y V en mayor', () {
      for (final QuizQuestion q in s.sample(
        MiniGameKind.romanDegree,
        MiniGameLevel.easy,
      )) {
        expect(q.scaleId, 'major');
        expect(q.choices.length, 3);
      }
    });
  });

  group('transporta', () {
    test('la aritmética de semitonos y capo es correcta', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.transposeChord,
          level,
        )) {
          final int n = int.parse(q.params['n']!);
          final ChordSymbol shown = s.symbolByName(q.params['chord']!);
          final ChordSymbol answer = s.symbolOf(q.correctChoice.value);
          final ChordSymbol expected = switch (q.detail) {
            'up' || 'capoSounds' => shown.transpose(n),
            _ => shown.transpose(-n),
          };
          expect(answer, expected, reason: '${q.detail} ${shown.name} $n');
          expect(answer.quality, shown.quality);
        }
      }
    });

    test('ningún distractor suena lo mismo que la respuesta', () {
      for (final QuizQuestion q in s.sample(
        MiniGameKind.transposeChord,
        MiniGameLevel.hard,
      )) {
        final ChordSymbol answer = s.symbolOf(q.correctChoice.value);
        for (final QuizChoice c in q.choices) {
          if (c != q.correctChoice) {
            expect(sameNotes(answer, s.symbolOf(c.value)), isFalse);
          }
        }
      }
    });
  });

  group('relativo, dominante y quintas', () {
    test('la respuesta cumple la relación preguntada', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.chordNeighbors,
          level,
        )) {
          final ChordSymbol source = s.symbolByName(q.params['chord']!);
          final ChordSymbol answer = s.symbolOf(q.correctChoice.value);
          final int step = (answer.root - source.root + 12) % 12;
          switch (q.detail) {
            case 'relativeMinor':
              expect(
                <Object>[step, answer.quality],
                <Object>[9, ChordQuality.minor],
              );
            case 'relativeMajor':
              expect(
                <Object>[step, answer.quality],
                <Object>[3, ChordQuality.major],
              );
            case 'dominant' || 'fifthUp':
              expect(step, 7);
            case 'subdominant' || 'fifthDown':
              expect(step, 5);
            case 'parallel':
              expect(step, 0);
              expect(answer.quality, isNot(source.quality));
            case 'tritone':
              expect(step, 6);
            default:
              fail('relación desconocida ${q.detail}');
          }
          for (final QuizChoice c in q.choices) {
            if (c != q.correctChoice) {
              expect(sameNotes(answer, s.symbolOf(c.value)), isFalse);
            }
          }
        }
      }
    });

    test('las relaciones crecen con el nivel', () {
      final Set<String?> easy = <String?>{
        for (final QuizQuestion q in s.sample(
          MiniGameKind.chordNeighbors,
          MiniGameLevel.easy,
        ))
          q.detail,
      };
      final Set<String?> hard = <String?>{
        for (final QuizQuestion q in s.sample(
          MiniGameKind.chordNeighbors,
          MiniGameLevel.hard,
        ))
          q.detail,
      };
      expect(easy.length, lessThan(hard.length));
      expect(hard, containsAll(<String>['parallel', 'tritone']));
    });
  });

  group('duelo de estilos', () {
    test('ningún género distractor tiene una progresión que suene igual', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(MiniGameKind.styleDuel, level)) {
          final String strum = q.params['strum']!;
          final List<ChordProgression> owners = kProgressions
              .where(
                (ChordProgression p) =>
                    p.genre == q.correctChoice.value && p.strum.name == strum,
              )
              .toList();
          expect(owners, isNotEmpty, reason: q.correctChoice.value);
          for (final QuizChoice c in q.choices) {
            if (c == q.correctChoice) {
              continue;
            }
            for (final ChordProgression p in kProgressions.where(
              (ChordProgression p) => p.genre == c.value,
            )) {
              expect(
                owners.any(
                  (ChordProgression o) =>
                      soundSignature(o) == soundSignature(p),
                ),
                isFalse,
                reason: '${c.value} suena como ${q.correctChoice.value}',
              );
            }
          }
        }
      }
    });

    test('el ritmo del rasgueo marca las pausas entre acordes', () {
      for (final QuizQuestion q in s.sample(
        MiniGameKind.styleDuel,
        MiniGameLevel.easy,
      )) {
        expect(q.cues.length, greaterThanOrEqualTo(4));
        expect(q.cues.first.delayMs, 0);
        expect(q.cues.skip(1).every((SoundCue c) => c.delayMs > 0), isTrue);
      }
    });
  });
}

/// Clase de tono de un nombre de nota inglés (`F#`).
int pitchClassOfNoteName(String note) => ChordSymbol.parse(note).root;
