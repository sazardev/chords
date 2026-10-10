import 'dart:convert';
import 'dart:io';

import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests del catálogo de traducciones.
///
/// El primero comprueba que todos los idiomas declaran exactamente las mismas
/// claves: es la garantía que permite añadir idiomas sin romper la app.
void main() {
  final Map<String, Map<String, Object?>> catalogs =
      <String, Map<String, Object?>>{
        for (final String code in AppLocale.values.map(
          (AppLocale locale) => locale.languageCode,
        ))
          code: _loadKeys(code),
      };

  test('todos los idiomas del catálogo se pueden cargar', () {
    expect(catalogs.keys, containsAll(<String>['es', 'en']));
    for (final Map<String, Object?> catalog in catalogs.values) {
      expect(catalog, isNotEmpty);
    }
  });

  test('todos los idiomas declaran las mismas claves', () {
    final Set<String> reference = _flatten(catalogs.values.first).keys.toSet();
    for (final MapEntry<String, Map<String, Object?>> entry
        in catalogs.entries) {
      expect(
        _flatten(entry.value).keys.toSet(),
        reference,
        reason: 'el idioma ${entry.key} no coincide con el catálogo base',
      );
    }
  });

  test('los idiomas soportados no dejan textos sin traducir', () {
    for (final MapEntry<String, Map<String, Object?>> entry
        in catalogs.entries) {
      _flatten(entry.value).forEach((String key, Object? value) {
        expect(
          value is String && value.trim().isNotEmpty,
          isTrue,
          reason: '${entry.key}: "$key" está vacío',
        );
      });
    }
  });

  test('ningún texto admite dos interpolaciones del mismo parámetro', () {
    for (final MapEntry<String, Map<String, Object?>> entry
        in catalogs.entries) {
      _flatten(entry.value).forEach((String key, Object? value) {
        final List<String> params = RegExp(r'\$(\w+)')
            .allMatches(value.toString())
            .map((RegExpMatch match) => match.group(1)!)
            .toList();
        expect(
          params.toSet().length,
          params.length,
          reason: '${entry.key}: "$key" repite parámetros',
        );
      });
    }
  });

  test('slang conoce todos los idiomas del catálogo', () {
    for (final String code in catalogs.keys) {
      final AppLocale locale = AppLocaleUtils.parse(code);
      expect(locale.languageCode, code);
      expect(AppLocaleUtils.supportedLocalesRaw, contains(code));
    }
  });

  test('las traducciones se leen por getter tipado y por clave plana', () {
    final Translations spanish = AppLocale.es.buildSync();
    final Translations english = AppLocale.en.buildSync();

    expect(spanish.nav.home, 'Inicio');
    expect(english.nav.home, 'Home');
    expect(spanish['nav.home'], 'Inicio');
    expect(english['nav.home'], 'Home');
  });

  test('los plurales funcionan en cada idioma', () {
    expect(
      AppLocale.es.buildSync().home.masteredCount(n: 1),
      '1 acorde dominado',
    );
    expect(
      AppLocale.es.buildSync().home.masteredCount(n: 3),
      '3 acordes dominados',
    );
    expect(
      AppLocale.en.buildSync().home.masteredCount(n: 1),
      '1 chord mastered',
    );
    expect(
      AppLocale.en.buildSync().home.masteredCount(n: 3),
      '3 chords mastered',
    );
  });

  test('las claves inexistentes devuelven null en lugar de romper', () {
    expect(AppLocale.es.buildSync()['no.existe'], isNull);
  });
}

/// Carga un catálogo JSON del directorio `lib/l10n`.
Map<String, Object?> _loadKeys(String code) {
  final File file = File('lib/l10n/$code.i18n.json');
  final Object? decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    fail('lib/l10n/$code.i18n.json no contiene un objeto JSON');
  }
  return decoded;
}

/// Aplaza las claves anidadas a un mapa plano de `clave → texto`.
Map<String, Object?> _flatten(Map<String, Object?> source) =>
    _flattenInto(source, prefix: '');

Map<String, Object?> _flattenInto(
  Map<String, Object?> source, {
  required String prefix,
}) => <String, Object?>{
  for (final MapEntry<String, Object?> entry in source.entries)
    if (entry.value case final Map<String, Object?> nested)
      ..._flattenInto(nested, prefix: '$prefix${entry.key}.')
    else
      '$prefix${entry.key}': entry.value,
};
