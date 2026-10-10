import 'package:chords/data/l10n/locale_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/l10n/entities/app_language.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/settings/settings_page.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test de integración del selector de idioma con la interfaz real.
void main() {
  testWidgets('los ajustes cambian el idioma de toda la interfaz', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final PreferencesService preferences = await PreferencesService.create();
    final SettingsController settings = SettingsController(preferences);
    final OnboardingController onboarding = OnboardingController(preferences);
    final LocaleController locale = LocaleController(
      LocaleRepositoryImpl(preferences),
    );
    await locale.load();

    final List<SingleChildWidget> providers = <SingleChildWidget>[
      ChangeNotifierProvider<LocaleController>.value(value: locale),
      ChangeNotifierProvider<SettingsController>.value(value: settings),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
    ];

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: providers,
          child: const _SettingsHost(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Sin preferencia guardada se sigue al dispositivo (inglés en los tests).
    expect(locale.language, AppLanguage.system);
    expect(locale.locale, isNull);
    expect(find.text('Settings'), findsOneWidget);

    // Al elegir español, la interfaz se reescribe sin reiniciar la app.
    await _selectLanguage(tester, 'Spanish');
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(locale.language, AppLanguage.spanish);
    expect(preferences.languageName, 'spanish');

    // Y se puede volver al idioma del sistema.
    await _selectLanguage(tester, 'Idioma del sistema');
    expect(locale.language, AppLanguage.system);
    expect(find.text('Settings'), findsOneWidget);
  });
}

/// Lleva a la vista la fila del idioma y la selecciona.
Future<void> _selectLanguage(WidgetTester tester, String option) async {
  final Finder optionFinder = find.text(option);
  await tester.dragUntilVisible(
    optionFinder,
    find.byType(ListView).first,
    const Offset(0, -60),
  );
  await tester.pumpAndSettle();
  await tester.tap(optionFinder);
  await tester.pumpAndSettle();
}

/// Contenedor mínimo equivalente al de la app para montar los ajustes.
class _SettingsHost extends StatelessWidget {
  const _SettingsHost();

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: context.watch<LocaleController>().locale,
    supportedLocales: AppLocaleUtils.supportedLocales,
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: const SettingsPage(),
  );
}
