import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los textos de los minijuegos están completos en todos los idiomas.
void main() {
  for (final AppLocale locale in AppLocale.values) {
    final Translations t = locale.buildSync();

    test('${locale.languageCode}: cada juego tiene título, resumen y guía', () {
      for (final MiniGameKind kind in MiniGameKind.values) {
        expect(gameTitle(t, kind), isNot(kind.id), reason: kind.id);
        expect(gameDescription(t, kind), isNotEmpty, reason: kind.id);
        expect(gameHowTo(t, kind), isNotEmpty, reason: kind.id);
      }
    });

    test('${locale.languageCode}: están las 12 notas y los 12 intervalos', () {
      for (int i = 0; i < 12; i++) {
        expect(t.minigames.noteNames['n$i'], isNotEmpty);
        expect(t.minigames.intervalNames['i${i + 1}'], isNotEmpty);
      }
    });

    test('${locale.languageCode}: las tres dificultades se distinguen', () {
      expect(
        <String>{
          t.minigames.levelEasy,
          t.minigames.levelMedium,
          t.minigames.levelHard,
        }.length,
        MiniGameLevel.values.length,
      );
    });
  }
}
