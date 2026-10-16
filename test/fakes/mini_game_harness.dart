import 'package:chords/config/route_paths.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chord_bank.dart';
import 'fake_audio_repository.dart';
import 'fake_chord_repository.dart';
import 'mini_game_kit.dart';
import 'mini_game_pump.dart';

/// Lo necesario para probar las pantallas de los minijuegos: audio y
/// banco falsos, preferencias en memoria, ajustes y los controladores reales.
class MiniGameHarness {
  MiniGameHarness._({
    required this.audio,
    required this.bank,
    required this.preferences,
    required this.settings,
    required this.kit,
  });

  /// Crea el conjunto con preferencias vacías.
  static Future<MiniGameHarness> create() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    final SettingsController settings = SettingsController(preferences);
    final FakeAudioRepository audio = FakeAudioRepository();
    final FakeChordRepository bank = loadChordBank();
    return MiniGameHarness._(
      audio: audio,
      bank: bank,
      preferences: preferences,
      settings: settings,
      kit: MiniGameKit(
        chords: bank,
        audio: audio,
        preferences: preferences,
        settings: settings,
      ),
    );
  }

  /// Audio falso.
  final FakeAudioRepository audio;

  /// Banco real de acordes en memoria.
  final FakeChordRepository bank;

  /// Preferencias en memoria.
  final PreferencesService preferences;

  /// Ajustes de la app.
  final SettingsController settings;

  /// Controladores de los minijuegos.
  final MiniGameKit kit;

  /// Monta el catálogo o un juego en una pantalla del [size] dado.
  Future<void> pump(
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

  /// Ruta de un juego por su identificador.
  static String gamePath(String kindId) => '$kMiniGamePath?kind=$kindId';
}
