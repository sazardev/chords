import 'package:chords/data/local/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests de la persistencia del mejor resultado de cada minijuego.
void main() {
  late PreferencesService preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    preferences = await PreferencesService.create();
  });

  test('sin partidas el mejor resultado es cero', () {
    expect(preferences.miniGameBest('guessNote_easy'), 0);
  });

  test('solo se guarda un resultado si supera al anterior', () async {
    await preferences.saveMiniGameBest('guessNote_easy', 60);
    await preferences.saveMiniGameBest('guessNote_easy', 40);
    expect(preferences.miniGameBest('guessNote_easy'), 60);
    await preferences.saveMiniGameBest('guessNote_easy', 90);
    expect(preferences.miniGameBest('guessNote_easy'), 90);
  });

  test('cada juego y nivel guarda su propio récord', () async {
    await preferences.saveMiniGameBest('guessNote_easy', 70);
    await preferences.saveMiniGameBest('guessNote_hard', 30);
    expect(preferences.miniGameBest('guessNote_easy'), 70);
    expect(preferences.miniGameBest('guessNote_hard'), 30);
    expect(preferences.miniGameBest('interval_easy'), 0);
  });
}
