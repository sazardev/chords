import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_menu.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fakes/chord_bank.dart';
import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';
import '../../../fakes/mini_game_kit.dart';
import '../../../fakes/mini_game_pump.dart';

/// Tests del catálogo de juegos con el modo guitarra (panel fijo y menú).
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

  Future<void> pumpApp(WidgetTester tester) =>
      pumpMiniGameApp(tester, kit: kit, settings: settings);

  testWidgets('con la guitarra se recorre el catálogo y se abre un juego', (
    WidgetTester tester,
  ) async {
    DateTime now = DateTime(2026);
    await kit.close();
    kit = MiniGameKit(
      chords: bank,
      audio: audio,
      preferences: preferences,
      clock: () => now,
      settings: settings,
    );
    await settings.setGuitarBrowse(value: true);
    await pumpApp(tester);
    expect(find.text('Abrir'), findsOne);
    expect(find.text('Anterior'), findsOne);
    expect(audio.requests, greaterThan(0));

    Future<void> pluck(String note) async {
      now = now.add(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 200));
      for (int i = 0; i < 3; i++) {
        audio.emitReading(note);
        await tester.pump(const Duration(milliseconds: 20));
      }
      await tester.pumpAndSettle();
    }

    // Re pasa al juego siguiente (el primero de los minijuegos) y Mi lo abre.
    await pluck('D3');
    await pluck('E2');
    expect(find.text('Adivina la nota'), findsWidgets);
    expect(find.text('Cómo se juega'), findsOne);
    await kit.close();
  });

  testWidgets('el panel fijo dice qué juego está elegido y abre el menú', (
    WidgetTester tester,
  ) async {
    await settings.setGuitarBrowse(value: true);
    await pumpApp(tester);
    expect(find.textContaining('1 de 40'), findsOne);
    expect(find.text('Menú'), findsOne);
    expect(find.text('Siguiente'), findsOne);

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.textContaining('2 de 40'), findsOne);

    await tester.tap(find.text('Menú'));
    await tester.pumpAndSettle();
    expect(find.text('Menú de la guitarra'), findsOne);
    for (final String label in <String>[
      'Inicio',
      'Aprender',
      'Acordes',
      'Jugar',
      'Afinar',
      'Ajustes',
      'Perfil',
      'Atrás',
      'Cerrar',
      'Apagar',
    ]) {
      expect(
        find.descendant(
          of: find.byType(GuitarNavMenu),
          matching: find.text(label),
        ),
        findsOne,
        reason: label,
      );
    }

    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();
    expect(settings.guitarBrowse, isFalse);
    expect(find.text('Menú'), findsNothing);
    expect(find.text('Abrir'), findsNothing);
  });

  testWidgets('una nota aguda abre el menú y Do♯ apaga el modo', (
    WidgetTester tester,
  ) async {
    DateTime now = DateTime(2026);
    await kit.close();
    kit = MiniGameKit(
      chords: bank,
      audio: audio,
      preferences: preferences,
      clock: () => now,
      settings: settings,
    );
    await settings.setGuitarBrowse(value: true);
    await pumpApp(tester);

    Future<void> pluck(String note, {double frequency = 440}) async {
      now = now.add(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 200));
      for (int i = 0; i < 3; i++) {
        audio.emitReading(note, frequency: frequency);
        await tester.pump(const Duration(milliseconds: 20));
      }
      await tester.pumpAndSettle();
    }

    await pluck('G', frequency: 784);
    expect(find.text('Menú de la guitarra'), findsOne);
    await pluck('C#');
    expect(settings.guitarBrowse, isFalse);
    expect(find.text('Menú de la guitarra'), findsNothing);
    await kit.close();
  });

  testWidgets('con la guitarra, Mi abre primero la serie de acordes', (
    WidgetTester tester,
  ) async {
    DateTime now = DateTime(2026);
    await kit.close();
    kit = MiniGameKit(
      chords: bank,
      audio: audio,
      preferences: preferences,
      clock: () => now,
      settings: settings,
    );
    await settings.setGuitarBrowse(value: true);
    await pumpApp(tester);
    now = now.add(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 200));
    for (int i = 0; i < 3; i++) {
      audio.emitReading('E2');
      await tester.pump(const Duration(milliseconds: 20));
    }
    await tester.pumpAndSettle();
    expect(find.text('serie de acordes'), findsOne);
    await kit.close();
  });

  testWidgets('sin activar la guitarra el catálogo no usa el micrófono', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Abrir'), findsNothing);
    expect(audio.requests, 0);
  });
}
