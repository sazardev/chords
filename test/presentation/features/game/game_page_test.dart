import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/game/game_audio_controller.dart';
import 'package:chords/presentation/features/game/game_controller.dart';
import 'package:chords/presentation/features/game/game_page.dart';
import 'package:chords/presentation/features/game/game_score_controller.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';

/// Tests de "toca el acorde": cuenta atrás y órdenes de guitarra.
void main() {
  late FakeAudioRepository audio;
  late GuitarCommandListener guitar;
  late GameController game;
  late DateTime now;

  Future<void> pumpPage(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    now = DateTime(2026);
    audio = FakeAudioRepository();
    guitar = GuitarCommandListener(audio, clock: () => now);
    final GameAudioController tuner = GameAudioController(audio, guitar);
    game = GameController(
      audio,
      loadChordBank(),
      GameScoreController(preferences),
      tuner,
      readyDelay: const Duration(seconds: 3),
      guitar: guitar,
    );
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const GamePage(),
        ),
      ],
    );
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: <ChangeNotifierProvider<ChangeNotifier>>[
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(preferences),
            ),
            ChangeNotifierProvider<GameController>.value(value: game),
            ChangeNotifierProvider<GameScoreController>.value(
              value: GameScoreController(preferences),
            ),
            ChangeNotifierProvider<GameAudioController>.value(value: tuner),
            ChangeNotifierProvider<GuitarCommandListener>.value(value: guitar),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Termina la partida y quita la pantalla para no dejar temporizadores.
  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  }

  testWidgets('la ronda empieza sola tras la cuenta atrás', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester);
    await tester.tap(find.text('Empezar serie'));
    await tester.pump();
    expect(find.text('Prepara el acorde'), findsOne);
    expect(find.text('Empiezo en 3'), findsOne);
    expect(find.text('Estoy listo'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Empiezo en 2'), findsOne);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Escuchando tu guitarra…'), findsOne);
    await tester.pump(const Duration(seconds: 6));
    await close(tester);
  });

  testWidgets('"¡Ya!" adelanta la escucha', (WidgetTester tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('Empezar serie'));
    await tester.pump();
    await tester.tap(find.text('¡Ya!'));
    await tester.pump();
    expect(find.text('Escuchando tu guitarra…'), findsOne);
    await tester.pump(const Duration(seconds: 6));
    await close(tester);
  });

  /// Juega una ronda entera con el reloj real y devuelve la pantalla al
  /// resultado. [notes] son las notas que se oyen durante la escucha.
  ///
  /// Se usa el reloj real porque cerrar un flujo de audio dentro del tiempo
  /// simulado de `testWidgets` no avanza.
  Future<void> playRound(
    WidgetTester tester, {
    List<String> notes = const <String>[],
  }) async {
    await tester.runAsync(() async {
      final Future<void> round = game.playRound();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      for (final String note in notes) {
        audio.emitReading(note);
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      await round;
    });
    await tester.pump();
  }

  /// Toca [note] tras el silencio previo, para que la guitarra mande.
  Future<void> pluck(WidgetTester tester, String note) async {
    now = now.add(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 200));
    for (int i = 0; i < 3; i++) {
      audio.emitReading(note);
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pump();
  }

  testWidgets('al fallar se ofrece reintentar con una cuerda al aire', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester);
    await tester.tap(find.text('Empezar serie'));
    await tester.pump();
    await playRound(tester);

    expect(game.phase, GamePhase.lost);
    for (final String label in <String>[
      'Reintentar',
      'Escuchar acorde',
      'Practicar cuerda a cuerda',
      'Salir',
    ]) {
      expect(find.text(label), findsOne, reason: label);
    }
    expect(find.text('La'), findsOne);

    // Tras el silencio, la cuerda La (5ª) repite la ronda.
    await pluck(tester, GuitarCommand.retry.note);
    expect(game.phase, GamePhase.idle);
    expect(find.text('Prepara el acorde'), findsOne);
    expect(tester.takeException(), isNull);
    await close(tester);
  });

  testWidgets('al superar la ronda se continúa con Mi', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester);
    await tester.tap(find.text('Empezar serie'));
    await tester.pump();
    final List<String> notes = loadChordBank()
        .chordById(game.currentRound!.chordId)!
        .easiestVariant
        .notes;
    await playRound(tester, notes: notes);

    expect(game.phase, GamePhase.won);
    expect(find.text('Mi'), findsOne);

    await pluck(tester, GuitarCommand.next.note);
    expect(game.currentRound!.index, 1);
    expect(game.phase, GamePhase.idle);
    await close(tester);
  });
}
