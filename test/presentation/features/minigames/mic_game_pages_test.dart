import 'package:chords/config/route_paths.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';
import '../../../fakes/mini_game_kit.dart';
import '../../../fakes/mini_game_pump.dart';

/// Tests de las pantallas de los minijuegos de micrófono: el reto escucha
/// solo y la partida se maneja con las cuerdas al aire.
void main() {
  late FakeAudioRepository audio;
  late FakeChordRepository bank;
  late PreferencesService preferences;
  late MiniGameKit kit;
  late SettingsController settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
    settings = SettingsController(preferences);
    audio = FakeAudioRepository();
    bank = loadChordBank();
    final MiniGameKit initial = MiniGameKit(
      chords: bank,
      audio: audio,
      preferences: preferences,
      settings: settings,
    );
    kit = initial;
    addTearDown(initial.close);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    String location = kGamePath,
    Size size = const Size(360, 640),
  }) => pumpMiniGameApp(
    tester,
    kit: kit,
    settings: settings,
    location: location,
    size: size,
  );

  group('juegos con micrófono', () {
    Future<void> emit(WidgetTester tester, int pitchClass, int times) async {
      for (int i = 0; i < times; i++) {
        audio.emitReading(noteNameOfPitchClass(pitchClass));
        await tester.pump(const Duration(milliseconds: 20));
      }
    }

    MicChallenge challenge() => kit.mic.state.challenge!;

    testWidgets('al abrir el juego se ofrece empezar con la guitarra', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=playNote');
      await tester.scrollUntilVisible(find.text('Empezar'), 200);
      expect(find.text('Empezar'), findsOne);
      expect(find.text('Mi'), findsOne);
      expect(find.text('Dificultad: Fácil'), findsOne);
      await tapText(tester, 'Dificultad: Fácil');
      expect(find.text('Dificultad: Media'), findsOne);
    });

    testWidgets('el reto empieza a escuchar solo y se supera tocando', (
      WidgetTester tester,
    ) async {
      await pumpApp(
        tester,
        location: '$kMiniGamePath?kind=playNote',
        size: const Size(320, 480),
      );
      await tapText(tester, 'Empezar');
      expect(find.text('Ronda 1 de 6'), findsOne);
      expect(find.text('Estoy listo'), findsNothing);
      expect(find.text('Toca ahora…'), findsOne);
      expect(find.textContaining('Pista:'), findsOne);
      await emit(tester, challenge().pitchClasses.single, 2);
      await tester.pumpAndSettle();
      expect(find.text('¡Bien tocado!'), findsOne);
      expect(find.text('Continuar'), findsOne);
      expect(find.text('Reintentar'), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text('Ronda 2 de 6'), findsOne);
      expect(find.text('Toca ahora…'), findsOne);
    });

    testWidgets('si pasa el tiempo se puede reintentar sin volver a puntuar', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=playStringFret');
      await tapText(tester, 'Empezar');
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(find.text('Se acabó el tiempo'), findsOne);
      expect(kit.mic.state.score.total, 1);
      expect(find.text('Reintentar'), findsOne);

      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('Toca ahora…'), findsOne);
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(find.text('Se acabó el tiempo'), findsOne);
      expect(find.text('Esta vez no suma puntos'), findsOne);
      expect(kit.mic.state.score.total, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sin permiso se avisa y se puede reintentar', (
      WidgetTester tester,
    ) async {
      audio.accessResult = MicStatus.permissionDenied;
      await pumpApp(tester, location: '$kMiniGamePath?kind=echo');
      await tapText(tester, 'Empezar');
      expect(find.text('Toca ahora…'), findsNothing);
      expect(find.byIcon(Icons.mic_off_rounded), findsOne);
      audio.accessResult = MicStatus.listening;
      await tapText(tester, 'Reintentar');
      expect(find.text('Toca ahora…'), findsOne);
    });

    testWidgets('el eco muestra el avance nota a nota', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester, location: '$kMiniGamePath?kind=echo');
      await tapText(tester, 'Empezar');
      final List<int> notes = challenge().pitchClasses;
      await emit(tester, notes.first, 2);
      expect(find.text('1 de ${notes.length} notas'), findsOne);
      expect(find.textContaining('Oigo:'), findsOne);
    });

    testWidgets('una cuerda al aire continúa sin tocar la pantalla', (
      WidgetTester tester,
    ) async {
      DateTime now = DateTime(2026);
      kit = MiniGameKit(
        chords: bank,
        audio: audio,
        preferences: preferences,
        clock: () => now,
        settings: settings,
      );
      await pumpApp(tester, location: '$kMiniGamePath?kind=playNote');
      await tapText(tester, 'Empezar');
      await emit(tester, challenge().pitchClasses.single, 2);
      await tester.pumpAndSettle();
      expect(find.text('¡Bien tocado!'), findsOne);

      // Mientras la última nota suena, la guitarra aún no manda.
      await emit(tester, GuitarCommand.next.pitchClass, 3);
      expect(find.text('Ronda 1 de 6'), findsOne);

      // Tras el silencio, una cuerda Mi pasa al reto siguiente.
      now = now.add(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 200));
      await emit(tester, GuitarCommand.next.pitchClass, 3);
      await tester.pumpAndSettle();
      expect(find.text('Ronda 2 de 6'), findsOne);
      expect(tester.takeException(), isNull);
    });
  });
}
