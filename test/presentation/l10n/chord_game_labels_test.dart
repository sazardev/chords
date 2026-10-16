import 'dart:math' as math;

import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_game_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';

/// Los textos de los juegos con acordes: cada pregunta de cada juego tiene su
/// enunciado, sus opciones y sus explicaciones en todos los idiomas.
void main() {
  final BuildQuizUseCase quiz = BuildQuizUseCase(
    loadChordBank(),
    random: math.Random(21),
  );

  final List<MiniGameKind> newKinds = <MiniGameKind>[
    for (final MiniGameKind kind in MiniGameKind.values)
      if (kind.isNew && quiz.supports(kind)) kind,
  ];

  for (final AppLocale locale in AppLocale.values) {
    final Translations t = locale.buildSync();

    group('${locale.languageCode}: textos de los juegos nuevos', () {
      test('cada pregunta tiene enunciado propio, sin marcas sueltas', () {
        for (final MiniGameKind kind in newKinds) {
          for (final MiniGameLevel level in MiniGameLevel.values) {
            for (int round = 0; round < 3; round++) {
              for (final QuizQuestion q in quiz(kind, level)) {
                final String prompt = questionPrompt(t, q);
                expect(prompt, isNotEmpty, reason: kind.id);
                expect(prompt, isNot(gameTitle(t, kind)), reason: kind.id);
                expect(prompt, isNot(contains(r'$')), reason: prompt);
                expect(prompt, isNot(contains('null')), reason: prompt);
              }
            }
          }
        }
      });

      test('cada opción se puede leer', () {
        for (final MiniGameKind kind in newKinds) {
          for (final MiniGameLevel level in MiniGameLevel.values) {
            for (final QuizQuestion q in quiz(kind, level)) {
              for (final QuizChoice choice in q.choices) {
                expect(choiceLabel(t, choice), isNotEmpty, reason: kind.id);
              }
            }
          }
        }
      });

      test('las notas de un conjunto salen en el idioma de la interfaz', () {
        const QuizChoice choice = QuizChoice(ChoiceType.noteSet, '0,4,7');
        expect(
          chordGameChoiceLabel(t, choice),
          locale == AppLocale.es ? 'Do – Mi – Sol' : 'C – E – G',
        );
      });

      test('los errores del diagrama y el género se explican', () {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in quiz(MiniGameKind.wrongDiagram, level)) {
            final String? why = questionExplanation(t, q);
            expect(why, isNotEmpty);
            expect(why, isNot(contains(r'$')));
          }
          for (final QuizQuestion q in quiz(MiniGameKind.styleDuel, level)) {
            expect(questionExplanation(t, q), isNotEmpty);
          }
        }
      });

      test('las inversiones tienen nombre', () {
        final Set<String> labels = <String>{
          for (final String id in <String>['root', 'first', 'second', 'third'])
            chordGameChoiceLabel(t, QuizChoice(ChoiceType.inversion, id)),
        };
        expect(labels.length, 4);
        expect(labels, isNot(contains('root')));
      });

      test('los plurales de transporte distinguen uno de varios', () {
        expect(
          t.chordGames.prompt.transposeUp(n: 1, chord: 'C'),
          isNot(t.chordGames.prompt.transposeUp(n: 3, chord: 'C')),
        );
        expect(
          t.chordGames.prompt.transposeUp(n: 3, chord: 'C'),
          contains('3'),
        );
        expect(
          t.chordGames.prompt.transposeDown(n: 2, chord: 'C'),
          contains('2'),
        );
      });

      test('las familias nuevas y el buscador tienen texto', () {
        expect(t.chordGames.chordsTitle, isNotEmpty);
        expect(t.chordGames.harmonyTitle, isNotEmpty);
        expect(t.chordGames.newBadge, isNotEmpty);
        expect(t.chordGames.searchHint, isNotEmpty);
        expect(
          t.chordGames.gamesCount(n: 1),
          isNot(t.chordGames.gamesCount(n: 4)),
        );
      });
    });
  }
}
