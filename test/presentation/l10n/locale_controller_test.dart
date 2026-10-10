import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/language_applier.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_locale_repository.dart';

/// Aplicador de idioma de mentira que solo registra lo aplicado.
class FakeLanguageApplier implements LanguageApplier {
  /// Idiomas aplicados, en orden.
  final List<AppLanguage> applied = <AppLanguage>[];

  @override
  void apply(AppLanguage language) => applied.add(language);
}

/// Tests del controlador de idioma.
void main() {
  test('carga el idioma persistido y lo aplica', () async {
    final FakeLanguageApplier applier = FakeLanguageApplier();
    final LocaleController controller = LocaleController(
      FakeLocaleRepository(AppLanguage.english),
      applier,
    );
    expect(controller.language, AppLanguage.system);

    await controller.load();

    expect(controller.language, AppLanguage.english);
    expect(applier.applied, <AppLanguage>[AppLanguage.english]);
    expect(controller.locale, const Locale('en'));
  });

  test('seleccionar un idioma lo persiste, lo aplica y notifica', () async {
    final FakeLocaleRepository repository = FakeLocaleRepository();
    final FakeLanguageApplier applier = FakeLanguageApplier();
    final LocaleController controller = LocaleController(repository, applier);
    int notifications = 0;
    controller.addListener(() => notifications++);

    await controller.select(AppLanguage.spanish);

    expect(repository.selectedLanguage, AppLanguage.spanish);
    expect(applier.applied, <AppLanguage>[AppLanguage.spanish]);
    expect(notifications, 1);
    expect(controller.locale, const Locale('es'));
  });

  test('volver al idioma del sistema deja el locale sin forzar', () async {
    final FakeLanguageApplier applier = FakeLanguageApplier();
    final LocaleController controller = LocaleController(
      FakeLocaleRepository(AppLanguage.spanish),
      applier,
    );
    await controller.load();

    await controller.select(AppLanguage.system);

    expect(controller.locale, isNull);
    expect(applier.applied.last, AppLanguage.system);
  });

  test('reseleccionar el idioma activo no hace nada', () async {
    final FakeLocaleRepository repository = FakeLocaleRepository(
      AppLanguage.spanish,
    );
    final FakeLanguageApplier applier = FakeLanguageApplier();
    final LocaleController controller = LocaleController(repository, applier);
    await controller.load();
    int notifications = 0;
    controller.addListener(() => notifications++);

    await controller.select(AppLanguage.spanish);

    expect(repository.saveCount, 0);
    expect(applier.applied, hasLength(1));
    expect(notifications, 0);
  });

  testWidgets('el aplicador por defecto usa slang', (
    WidgetTester tester,
  ) async {
    final LocaleController controller = LocaleController(
      FakeLocaleRepository(AppLanguage.english),
    );
    await controller.load();
    expect(LocaleSettings.currentLocale, AppLocale.en);

    await controller.select(AppLanguage.spanish);
    expect(LocaleSettings.currentLocale, AppLocale.es);
  });
}
