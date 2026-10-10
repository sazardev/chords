import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests del idioma de interfaz soportado.
void main() {
  group('AppLanguage', () {
    test('resuelve el idioma desde su código BCP-47', () {
      expect(AppLanguage.fromCode('es'), AppLanguage.spanish);
      expect(AppLanguage.fromCode('en'), AppLanguage.english);
      expect(AppLanguage.fromCode(null), AppLanguage.system);
    });

    test('cae en «sistema» con códigos desconocidos o antiguos', () {
      expect(AppLanguage.fromCode('fr'), AppLanguage.fallback);
      expect(AppLanguage.fromName('gallego'), AppLanguage.fallback);
    });

    test('resuelve el idioma desde el nombre persistido', () {
      expect(AppLanguage.fromName('spanish'), AppLanguage.spanish);
      expect(AppLanguage.fromName('english'), AppLanguage.english);
      expect(AppLanguage.fromName(null), AppLanguage.system);
    });

    test('el valor de sistema no tiene código y los demás sí', () {
      expect(AppLanguage.system.followsSystem, isTrue);
      expect(AppLanguage.system.languageCode, isNull);
      for (final AppLanguage language in AppLanguage.values) {
        if (language == AppLanguage.system) {
          continue;
        }
        expect(language.followsSystem, isFalse);
        expect(language.languageCode, isNotEmpty);
      }
    });
  });
}
