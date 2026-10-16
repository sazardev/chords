import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/services/caged_shape.dart';
import 'package:chords/domain/minigames/services/chord_inversion.dart';
import 'package:chords/domain/minigames/services/chord_tones.dart';
import 'package:chords/domain/minigames/services/voicing_flaws.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_game_sampler.dart';

/// Juegos de diagramas: CAGED, raíz y bajo, inversiones y diagrama incorrecto.
void main() {
  final ChordGameSampler s = ChordGameSampler();

  group('formas CAGED', () {
    test(
      'la forma del diagrama y el traste de la cejilla son los correctos',
      () {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in s.sample(
            MiniGameKind.cagedShape,
            level,
          )) {
            final Chord chord = s.chordOf(q);
            if (q.detail == 'shape') {
              final ChordVariant variant = chord.variants[q.variantIndex];
              expect(
                CagedShape.ofVariant(variant)!.letter,
                q.correctChoice.value,
              );
            } else {
              final CagedShape shape = CagedShape.fromLetter(
                q.params['shape']!,
              )!;
              final int fret = int.parse(q.correctChoice.value);
              expect(fret, shape.barreFretFor(chord.root.pitchClass));
              expect(fret, inInclusiveRange(1, 11));
              for (final QuizChoice c in q.choices) {
                expect(int.parse(c.value), inInclusiveRange(1, 12));
              }
            }
          }
        }
      },
    );

    test('las formas se reconocen por el identificador de la posición', () {
      final ChordVariant open = s.bank.chordById('C-maj')!.variants.first;
      expect(CagedShape.ofVariant(open), CagedShape.c);
      expect(CagedShape.e.barreFretFor(5), 1);
      expect(CagedShape.a.barreFretFor(0), 3);
      expect(CagedShape.g.barreFretFor(7), 0);
    });
  });

  group('raíz y bajo', () {
    test('la cuerda y la nota respondidas salen del diagrama', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.rootAndBass,
          level,
        )) {
          final Chord chord = s.chordOf(q);
          final ChordVariant variant = chord.variants[q.variantIndex];
          if (q.detail == 'rootString') {
            final int answer = int.parse(q.correctChoice.value);
            expect(answer, 6 - rootStringIndex(chord, variant)!);
            for (final QuizChoice c in q.choices) {
              final int s = int.parse(c.value);
              expect(variant.frets[6 - s], greaterThanOrEqualTo(0));
              if (s != answer) {
                expect(
                  pitchClassAtString(6 - s, variant.frets[6 - s]),
                  isNot(chord.root.pitchClass),
                );
              }
            }
          } else {
            expect(
              pitchClassOfNoteName(q.correctChoice.value),
              bassPitchClass(variant),
            );
          }
        }
      }
    });
  });

  group('posiciones nuevas del banco', () {
    test('raíz y bajo y las inversiones usan tríadas, shells y drops', () {
      final Set<VariantKind> kinds = <VariantKind>{};
      final Set<int> bassStrings = <int>{};
      for (final MiniGameKind kind in <MiniGameKind>[
        MiniGameKind.rootAndBass,
        MiniGameKind.inversion,
        MiniGameKind.wrongDiagram,
      ]) {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in s.sample(kind, level)) {
            final Chord chord = s.chordOf(q);
            final ChordVariant variant = chord.variants[q.variantIndex];
            kinds.add(variant.kind);
            bassStrings.add(soundingStrings(variant.frets).first);
          }
        }
      }
      expect(kinds.length, greaterThan(2), reason: '$kinds');
      expect(
        bassStrings.length,
        greaterThan(1),
        reason: 'bajos en varias cuerdas',
      );
    });

    test('la raíz suena siempre en las posiciones de los juegos de bajo', () {
      for (final QuizQuestion q in s.sample(
        MiniGameKind.rootAndBass,
        MiniGameLevel.hard,
      )) {
        final Chord chord = s.chordOf(q);
        expect(
          rootStringIndex(chord, chord.variants[q.variantIndex]),
          isNotNull,
        );
      }
    });
  });

  group('inversiones', () {
    test('la respuesta es la inversión del diagrama', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(MiniGameKind.inversion, level)) {
          final Chord chord = s.chordOf(q);
          expect(
            q.correctChoice.value,
            variantInversion(chord, chord.variants[q.variantIndex])!.name,
          );
          expect(q.diagram == QuizDiagram.none, level == MiniGameLevel.hard);
          expect(q.hasSound, level == MiniGameLevel.hard);
        }
      }
    });

    test('salen todas las inversiones, no solo el estado fundamental', () {
      final Set<String> seen = <String>{
        for (final QuizQuestion q in s.sample(
          MiniGameKind.inversion,
          MiniGameLevel.medium,
        ))
          q.correctChoice.value,
      };
      expect(seen, containsAll(<String>['root', 'first', 'second']));
    });
  });

  group('diagrama incorrecto', () {
    test('solo el diagrama de la respuesta tiene error', () {
      for (final MiniGameLevel level in MiniGameLevel.values) {
        for (final QuizQuestion q in s.sample(
          MiniGameKind.wrongDiagram,
          level,
        )) {
          final Chord chord = s.chordOf(q);
          for (int i = 0; i < q.choices.length; i++) {
            final List<int> frets = <int>[
              for (final String f in q.choices[i].value.split(','))
                int.parse(f),
            ];
            expect(
              isValidVoicing(chord, frets),
              !q.answer.contains(i),
              reason: '${chord.name} ${q.choices[i].value}',
            );
          }
          expect(q.choices.length, level == MiniGameLevel.easy ? 3 : 4);
          expect(<String?>[
            'alienNote',
            'unmutedString',
            'missingNote',
          ], contains(q.detail));
        }
      }
    });

    test('aparecen los tres tipos de error', () {
      final Set<String?> errors = <String?>{
        for (final QuizQuestion q in s.sample(
          MiniGameKind.wrongDiagram,
          MiniGameLevel.hard,
        ))
          q.detail,
      };
      expect(errors, containsAll(<String>['alienNote', 'missingNote']));
    });
  });
}

/// Clase de tono de un nombre de nota inglés (`F#`).
int pitchClassOfNoteName(String note) => ChordSymbol.parse(note).root;
