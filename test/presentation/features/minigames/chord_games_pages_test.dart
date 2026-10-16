import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/quiz_choices.dart';
import 'package:chords/presentation/features/minigames/quiz_progression_strip.dart';
import 'package:chords/presentation/l10n/chord_game_labels.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:chords/presentation/widgets/organisms/chord_diagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/mini_game_harness.dart';
import '../../../fakes/mini_game_pump.dart';

/// Las pantallas de los juegos con acordes: diagramas como opciones, notas en
/// orden, progresiones con un hueco y retos con reloj.
void main() {
  late MiniGameHarness h;

  setUp(() async => h = await MiniGameHarness.create());

  QuizQuestion current() => h.kit.quiz.state.question!;

  Finder choiceButtons() => find.descendant(
    of: find.byType(QuizChoices),
    matching: find.byType(InkWell),
  );

  Future<void> choose(WidgetTester tester, int index) async {
    await tester.scrollUntilVisible(
      find.byType(QuizChoices),
      200,
      scrollable: mainScrollable(),
    );
    await tester.ensureVisible(choiceButtons().at(index));
    await tester.pumpAndSettle();
    await tester.tap(choiceButtons().at(index));
    await tester.pumpAndSettle();
  }

  /// Abre un juego en la dificultad pedida y empieza.
  Future<void> open(
    WidgetTester tester,
    MiniGameKind kind, {
    String level = 'Fácil',
    Size size = const Size(360, 640),
  }) async {
    await h.pump(
      tester,
      location: MiniGameHarness.gamePath(kind.id),
      size: size,
    );
    if (level != 'Fácil') {
      await tapText(tester, level);
    }
    await tapText(tester, 'Empezar');
  }

  Translations t(WidgetTester tester) =>
      Translations.of(tester.element(find.byType(Scaffold).first));

  group('familia de acordes', () {
    testWidgets('"deletrea el acorde" en difícil marca las notas tocadas', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.spellChord, level: 'Difícil');
      final QuizQuestion q = current();
      expect(q.isSequence, isTrue);
      expect(find.textContaining('Toca las notas de'), findsOne);

      await choose(tester, q.answer.first);
      expect(h.kit.quiz.state.input, <int>[
        q.answer.first,
      ], reason: 'la nota tocada queda anotada');
      // Una nota ya tocada no se puede volver a pulsar.
      await choose(tester, q.answer.first);
      expect(h.kit.quiz.state.input.length, 1);

      for (final int step in q.answer.skip(1)) {
        await choose(tester, step);
      }
      expect(find.text('¡Correcto!'), findsOne);
      expect(tester.takeException(), isNull);
    });

    testWidgets('"deletrea el acorde" en difícil falla al saltarse una nota', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.spellChord, level: 'Difícil');
      final QuizQuestion q = current();
      await choose(tester, q.answer.last);
      expect(h.kit.quiz.state.wasCorrect, isFalse);
      expect(find.textContaining('→'), findsWidgets);
    });

    testWidgets('"diagrama incorrecto" dibuja los diagramas como opciones', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.wrongDiagram);
      final QuizQuestion q = current();
      expect(
        find.descendant(
          of: find.byType(QuizChoices),
          matching: find.byType(ChordDiagram),
        ),
        findsNWidgets(3),
      );
      await choose(tester, q.answer.single);
      expect(find.text('¡Correcto!'), findsOne);
      expect(find.text(questionExplanation(t(tester), q)!), findsOne);
      expect(tester.takeException(), isNull);
    });

    testWidgets('"diagrama incorrecto" explica el error al fallar', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.wrongDiagram, level: 'Difícil');
      final QuizQuestion q = current();
      expect(q.choices.length, 4);
      final int wrong = q.answer.single == 0 ? 1 : 0;
      await choose(tester, wrong);
      expect(find.text('Siguiente'), findsOne);
      expect(find.text(questionExplanation(t(tester), q)!), findsOne);
      expect(find.text('¡Correcto!'), findsNothing);
    });

    testWidgets('cada diagrama se anuncia con su número', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      await open(tester, MiniGameKind.wrongDiagram);
      expect(find.bySemanticsLabel(RegExp('Diagrama 1')), findsWidgets);
      expect(find.bySemanticsLabel(RegExp('Diagrama 3')), findsWidgets);
      semantics.dispose();
    });

    testWidgets('"raíz y bajo" muestra el diagrama con sus dedos', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.rootAndBass, size: const Size(320, 480));
      expect(find.byType(ChordDiagram), findsOne);
      await choose(tester, current().answer.single);
      expect(find.text('¡Correcto!'), findsOne);
    });

    testWidgets('"inversiones" en difícil solo se oyen, sin diagrama', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.inversion, level: 'Difícil');
      expect(find.byType(ChordDiagram), findsNothing);
      expect(find.text('Escuchar'), findsOne);
      expect(h.audio.played, hasLength(1));
    });

    testWidgets('"memoria de acordes" suena la sucesión y se repite', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.chordMemory);
      final QuizQuestion q = current();
      expect(h.audio.played.length, q.cues.length);
      for (final int step in q.answer) {
        await choose(tester, step);
      }
      expect(find.text('¡Correcto!'), findsOne);
    });
  });

  group('familia de progresiones y armonía', () {
    testWidgets('"completa la progresión" enseña los acordes y un hueco', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.fillProgression);
      expect(find.byType(QuizProgressionStrip), findsOne);
      expect(find.text('?'), findsOne);
      expect(find.textContaining('qué acorde falta'), findsOne);
      await choose(tester, current().answer.single);
      expect(find.text('¡Correcto!'), findsOne);
    });

    testWidgets('"grados romanos" pregunta el grado en una tonalidad', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.romanDegree, size: const Size(320, 480));
      expect(find.textContaining('En '), findsWidgets);
      await choose(tester, current().answer.single);
      expect(find.text('¡Correcto!'), findsOne);
      expect(tester.takeException(), isNull);
    });

    testWidgets('"transporta" y "relativos" se juegan sin sonido', (
      WidgetTester tester,
    ) async {
      for (final MiniGameKind kind in <MiniGameKind>[
        MiniGameKind.transposeChord,
        MiniGameKind.chordNeighbors,
      ]) {
        await open(tester, kind, size: const Size(320, 480));
        expect(find.text('Escuchar'), findsNothing, reason: kind.id);
        await choose(tester, current().answer.single);
        expect(find.text('¡Correcto!'), findsOne, reason: kind.id);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('"duelo de estilos" suena la progresión con su rasgueo', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.styleDuel);
      final QuizQuestion q = current();
      expect(q.cues.length, greaterThan(4));
      expect(h.audio.played.length + h.audio.tones.length, q.cues.length);
      await choose(tester, q.answer.single);
      expect(find.text('¡Correcto!'), findsOne);
      expect(find.textContaining('Era '), findsOne);
    });
  });

  group('retos con tiempo', () {
    testWidgets('la bienvenida dice los segundos de cada dificultad', (
      WidgetTester tester,
    ) async {
      await h.pump(tester, location: MiniGameHarness.gamePath('rushOpen'));
      expect(find.text('Tiempo por pregunta: 15 s'), findsOne);
      await tapText(tester, 'Media');
      expect(find.text('Tiempo por pregunta: 10 s'), findsOne);
      await tapText(tester, 'Difícil');
      expect(find.text('Tiempo por pregunta: 6 s'), findsOne);
    });

    testWidgets('la barra baja con el reloj y al agotarse se pierde', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.rushOpen);
      expect(find.text('15 s'), findsOne);
      h.kit.questionClock.elapse(5000);
      await tester.pump();
      expect(find.text('10 s'), findsOne);

      h.kit.questionClock.elapse(10000);
      await tester.pumpAndSettle();
      expect(find.textContaining('¡Se acabó el tiempo!'), findsOne);
      expect(find.text('Siguiente'), findsOne);
      expect(h.kit.quiz.state.timedOut, isTrue);
    });

    testWidgets('acertar rápido da puntos de rapidez', (
      WidgetTester tester,
    ) async {
      await open(tester, MiniGameKind.rushBarre);
      await choose(tester, current().answer.single);
      expect(h.kit.quiz.state.score.points, 15);
    });

    for (final MiniGameKind kind in <MiniGameKind>[
      MiniGameKind.rushOpen,
      MiniGameKind.rushBarre,
      MiniGameKind.rushSeventh,
    ]) {
      testWidgets('${kind.id} cabe en un móvil pequeño', (
        WidgetTester tester,
      ) async {
        await open(tester, kind, level: 'Difícil', size: const Size(320, 480));
        expect(find.byType(ChordDiagram), findsOne);
        expect(tester.takeException(), isNull);
        h.kit.questionClock.elapse(6000);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('en una tableta', () {
    testWidgets('los diagramas y las progresiones se ven bien', (
      WidgetTester tester,
    ) async {
      for (final MiniGameKind kind in <MiniGameKind>[
        MiniGameKind.wrongDiagram,
        MiniGameKind.fillProgression,
        MiniGameKind.cagedShape,
      ]) {
        await open(tester, kind, size: const Size(800, 1280));
        expect(tester.takeException(), isNull, reason: kind.id);
        await choose(tester, current().answer.first);
        expect(tester.takeException(), isNull, reason: kind.id);
      }
      expect(gameTitle(t(tester), MiniGameKind.cagedShape), 'Formas CAGED');
    });
  });
}
