import 'package:chords/config/route_paths.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/minigames/mini_game_page.dart';
import 'package:chords/presentation/features/minigames/mini_games_hub_page.dart';
import 'package:chords/presentation/features/minigames/quiz_choices.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/widgets/organisms/fretboard_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';
import '../../../fakes/mini_game_kit.dart';

/// Tests de las pantallas de los minijuegos con controladores reales.
void main() {
  late FakeAudioRepository audio;
  late FakeChordRepository bank;
  late PreferencesService preferences;
  late MiniGameKit kit;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    audio = FakeAudioRepository();
    bank = loadChordBank();
    kit = MiniGameKit(chords: bank, audio: audio, preferences: preferences);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    String location = kGamePath,
    Size size = const Size(360, 640),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final GoRouter router = GoRouter(
      initialLocation: location,
      routes: <RouteBase>[
        GoRoute(
          path: kGamePath,
          builder: (BuildContext context, GoRouterState state) =>
              const MiniGamesHubPage(),
        ),
        GoRoute(
          path: kMiniGamePath,
          builder: (BuildContext context, GoRouterState state) =>
              MiniGamePage(gameId: state.uri.queryParameters['kind']),
        ),
        GoRoute(
          path: kChordPracticePath,
          builder: (BuildContext context, GoRouterState state) =>
              Text('práctica ${state.uri.queryParameters['id']}'),
        ),
      ],
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(preferences),
            ),
            ...kit.providers,
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final Finder finder = find.text(text);
    await tester.scrollUntilVisible(finder, 200);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('catálogo', () {
    testWidgets('muestra los 17 juegos y el progreso en estrellas', (
      WidgetTester tester,
    ) async {
      await preferences.saveMiniGameBest('guessNote_easy', 95);
      await pumpApp(tester);
      expect(find.text('0 de 51 estrellas'), findsNothing);
      expect(find.text('3 de 51 estrellas'), findsOne);
      final Translations t = Translations.of(
        tester.element(find.byType(MiniGamesHubPage)),
      );
      for (final MiniGameKind kind in MiniGameKind.values) {
        final Finder title = find.text(t.minigames.titles[kind.id]!);
        await tester.scrollUntilVisible(title, 200);
        expect(title, findsOne, reason: kind.id);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('al pulsar un juego se abre su bienvenida', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tapText(tester, 'Intervalos');
      expect(find.text('Cómo se juega'), findsOne);
      expect(find.text('Empezar'), findsOne);
    });

    testWidgets('un juego desconocido muestra la pantalla de error', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=inventado');
      expect(find.text('Cómo se juega'), findsNothing);
      expect(find.byType(MiniGamePage), findsOne);
      expect(find.byIcon(Icons.explore_off_outlined), findsOne);
    });
  });

  group('preguntas de opciones', () {
    QuizQuestion current() => kit.quiz.state.question!;

    Future<void> choose(WidgetTester tester, int index) async {
      final Finder button = find
          .descendant(
            of: find.byType(QuizChoices),
            matching: find.byType(InkWell),
          )
          .at(index);
      await tester.scrollUntilVisible(button, 200);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    Future<void> answer(WidgetTester tester, {required bool right}) async {
      final QuizQuestion q = current();
      if (right) {
        for (final int step in q.answer) {
          await choose(tester, step);
        }
        return;
      }
      final int wrong = List<int>.generate(
        q.choices.length,
        (int i) => i,
      ).firstWhere((int i) => i != q.answer.first);
      await choose(tester, wrong);
    }

    for (final MiniGameKind kind in MiniGameKind.values.where(
      (MiniGameKind k) => BuildQuizUseCase(loadChordBank()).supports(k),
    )) {
      testWidgets('${kind.id} se juega sin desbordes en pantalla pequeña', (
        WidgetTester tester,
      ) async {
        await pumpApp(
          tester,
          location: '$kMiniGamePath?kind=${kind.id}',
          size: const Size(320, 480),
        );
        await tapText(tester, 'Empezar');
        expect(find.text('Pregunta 1 de ${kind.rounds}'), findsOne);
        expect(tester.takeException(), isNull, reason: 'pregunta');

        await answer(tester, right: false);
        expect(find.text('Siguiente'), findsOne);
        expect(tester.takeException(), isNull, reason: 'fallo');
        await tapText(tester, 'Siguiente');
        expect(find.text('Pregunta 2 de ${kind.rounds}'), findsOne);

        await answer(tester, right: true);
        expect(find.text('¡Correcto!'), findsOne);
        expect(tester.takeException(), isNull, reason: 'acierto');
      });
    }

    testWidgets('una partida perfecta termina con tres estrellas', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=guessNote');
      await tapText(tester, 'Empezar');
      for (int i = 0; i < 10; i++) {
        await answer(tester, right: true);
        await tapText(tester, i == 9 ? 'Ver resultado' : 'Siguiente');
      }
      expect(find.text('¡Perfecto!'), findsOne);
      expect(find.text('10 de 10 aciertos'), findsOne);
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
      expect(find.text('¡Nuevo récord!'), findsOne);
      expect(find.text('Jugar otra vez'), findsOne);
      expect(preferences.miniGameBest('guessNote_easy'), 100);
      expect(tester.takeException(), isNull);
    });

    testWidgets('el botón escuchar gasta una repetición', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=guessNote');
      await tapText(tester, 'Empezar');
      expect(audio.tones.length, 1);
      await tapText(tester, 'Escuchar');
      expect(audio.tones.length, 2);
      expect(kit.quiz.state.replaysLeft, 8);
      expect(find.text('Escuchar otra vez'), findsOne);
    });
  });

  group('arma el acorde', () {
    Offset padOrigin(WidgetTester tester) => tester.getTopLeft(
      find.descendant(
        of: find.byType(FretboardPad),
        matching: find.byType(GestureDetector),
      ),
    );

    double padWidth(WidgetTester tester) => tester
        .getSize(
          find.descendant(
            of: find.byType(FretboardPad),
            matching: find.byType(GestureDetector),
          ),
        )
        .width;

    Future<void> placeTarget(WidgetTester tester) async {
      final ChordRound round = kit.build.state.round!;
      final Chord chord = bank.chordById(round.chordId)!;
      final List<int> frets = chord.variants[round.variantIndex].frets;
      final Offset origin = padOrigin(tester);
      final double width = padWidth(tester);
      for (int s = 0; s < 6; s++) {
        if (frets[s] == -1) {
          continue;
        }
        final Offset cell = FretboardPad.cellCenter(width, s, frets[s]);
        await tester.tapAt(origin + cell);
        await tester.pump();
      }
    }

    testWidgets('colocar el acorde en el tablero lo da por bueno', (
      WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        location: '$kMiniGamePath?kind=buildChord',
        size: const Size(320, 480),
      );
      await tapText(tester, 'Empezar');
      expect(find.textContaining('Forma el acorde'), findsOne);
      await placeTarget(tester);
      await tapText(tester, 'Comprobar');
      expect(find.text('¡Así se hace!'), findsOne);
      expect(find.text('Ahora tócalo'), findsOne);
      expect(kit.build.state.score.correct, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('un tablero vacío marca los errores y no avanza', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=buildChord');
      await tapText(tester, 'Empezar');
      await tapText(tester, 'Comprobar');
      expect(find.text('Revisa las cuerdas marcadas en rojo.'), findsOne);
      expect(kit.build.state.wrong, isNotEmpty);
      expect(find.text('¡Así se hace!'), findsNothing);
    });

    testWidgets('la pista enseña el diagrama y rendirse muestra la solución', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=buildChord');
      await tapText(tester, 'Empezar');
      await tapText(tester, 'Ver pista');
      expect(find.text('Ver pista'), findsNothing);
      await tapText(tester, 'Saltar');
      expect(
        find.text(kit.build.state.round == null ? '' : 'Siguiente'),
        findsOne,
      );
      expect(find.text('Así se forma. ¡Memorízalo y sigue!'), findsOne);
      expect(tester.takeException(), isNull);
    });

    testWidgets('el botón ahora tócalo abre la práctica del acorde', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=buildChord');
      await tapText(tester, 'Empezar');
      final String id = kit.build.state.round!.chordId;
      await placeTarget(tester);
      await tapText(tester, 'Comprobar');
      await tapText(tester, 'Ahora tócalo');
      expect(find.text('práctica $id'), findsOne);
    });

    testWidgets('en difícil no hay botón de pista', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=buildChord');
      await tapText(tester, 'Difícil');
      await tapText(tester, 'Empezar');
      await tester.scrollUntilVisible(find.text('Comprobar'), 200);
      expect(find.text('Comprobar'), findsOne);
      expect(find.text('Saltar'), findsOne);
      expect(find.text('Ver pista'), findsNothing);
    });
  });

  group('juegos con micrófono', () {
    Future<void> emit(WidgetTester tester, int pitchClass, int times) async {
      for (int i = 0; i < times; i++) {
        audio.emitReading(noteNameOfPitchClass(pitchClass));
        await tester.pump(const Duration(milliseconds: 20));
      }
    }

    MicChallenge challenge() => kit.mic.state.challenge!;

    testWidgets('tocar la nota pedida supera el reto', (
      WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        location: '$kMiniGamePath?kind=playNote',
        size: const Size(320, 480),
      );
      await tapText(tester, 'Empezar');
      expect(find.text('Ronda 1 de 6'), findsOne);
      expect(find.text('Estoy listo'), findsOne);
      expect(find.textContaining('Pista:'), findsOne);
      await tapText(tester, 'Estoy listo');
      expect(find.text('Toca ahora…'), findsOne);
      await emit(tester, challenge().pitchClasses.single, 2);
      await tester.pumpAndSettle();
      expect(find.text('¡Bien tocado!'), findsOne);
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
    });

    testWidgets('si pasa el tiempo sin acertar se acaba el reto', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=playStringFret');
      await tapText(tester, 'Empezar');
      await tapText(tester, 'Estoy listo');
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(find.text('Se acabó el tiempo'), findsOne);
      expect(kit.mic.state.score.correct, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sin permiso se avisa y se puede reintentar', (
      WidgetTester tester,
    ) async {
      audio.accessResult = MicStatus.permissionDenied;
      await pumpApp(tester, location: '$kMiniGamePath?kind=echo');
      await tapText(tester, 'Empezar');
      await tapText(tester, 'Estoy listo');
      expect(find.text('Toca ahora…'), findsNothing);
      expect(find.byIcon(Icons.mic_off_rounded), findsOne);
      await tester.scrollUntilVisible(find.text('Escuchar la melodía'), 200);
      expect(find.text('Escuchar la melodía'), findsOne);
    });

    testWidgets('el eco muestra el avance nota a nota', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=echo');
      await tapText(tester, 'Empezar');
      await tapText(tester, 'Estoy listo');
      final List<int> notes = challenge().pitchClasses;
      await emit(tester, notes.first, 2);
      expect(find.text('1 de ${notes.length} notas'), findsOne);
      expect(find.textContaining('Oigo:'), findsOne);
    });
  });
}
