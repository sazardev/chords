import 'package:chords/data/l10n/locale_repository_impl.dart';
import 'package:chords/data/local/preferences_service.dart';
import 'package:chords/domain/preferences/entities/app_accent_color.dart';
import 'package:chords/domain/preferences/entities/app_font_scale.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/settings/appearance_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/features/settings/settings_page.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests de la pantalla de ajustes: acento, tamaño de texto y tema.
void main() {
  testWidgets('cambiar el acento regenera el esquema de color', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final _Host host = await _host(tester);

    await tester.pumpWidget(host.widget);
    await tester.pumpAndSettle();

    final Color? initial = _primaryOf(tester);
    expect(initial, isNotNull);

    await tester.ensureVisible(find.bySemanticsLabel('Verde'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Verde'));
    await tester.pumpAndSettle();

    expect(host.appearance.accentColor, AppAccentColor.verde);
    expect(_primaryOf(tester), isNot(equals(initial)));
  });

  testWidgets('cambiar el tamaño de letra escala la tipografía', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final _Host host = await _host(tester);

    await tester.pumpWidget(host.widget);
    await tester.pumpAndSettle();

    final double before = _bodyFontSize(tester);

    final Finder chip = find.widgetWithText(ChoiceChip, 'Grande');
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();

    expect(host.appearance.fontScale, AppFontScale.grande);
    expect(_bodyFontSize(tester), greaterThan(before));
  });

  testWidgets('el tema oscuro se aplica al pulsar Oscuro', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final _Host host = await _host(tester);

    await tester.pumpWidget(host.widget);
    await tester.pumpAndSettle();

    final Finder dark = find.byTooltip('Oscuro');
    await tester.ensureVisible(dark);
    await tester.pumpAndSettle();
    await tester.tap(dark);
    await tester.pumpAndSettle();

    expect(host.appearance.themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(SettingsPage))).brightness,
      Brightness.dark,
    );
  });
}

/// Color primario del tema montado.
Color? _primaryOf(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(SettingsPage))).colorScheme.primary;

/// Tamaño del texto de cuerpo del tema montado.
double _bodyFontSize(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(SettingsPage)))
        .textTheme
        .bodyMedium!
        .fontSize!;

/// Prepara los controladores y el widget de la pantalla de ajustes.
Future<_Host> _host(WidgetTester tester) async {
  final PreferencesService preferences = await PreferencesService.create();
  final AppearanceController appearance = AppearanceController(preferences);
  final SettingsController settings = SettingsController(preferences);
  await appearance.load();
  await settings.load();
  return _Host(
    appearance: appearance,
    settings: settings,
    widget: _SettingsHost(
      appearance: appearance,
      settings: settings,
      locale: LocaleController(LocaleRepositoryImpl(preferences)),
      onboarding: OnboardingController(preferences),
    ),
  );
}

/// Controladores y widget listos para un caso.
class _Host {
  const _Host({
    required this.appearance,
    required this.settings,
    required this.widget,
  });

  final AppearanceController appearance;

  final SettingsController settings;

  final Widget widget;
}

/// Monta la pantalla de ajustes con el tema de la aplicación.
class _SettingsHost extends StatelessWidget {
  const _SettingsHost({
    required this.appearance,
    required this.settings,
    required this.locale,
    required this.onboarding,
  });

  final AppearanceController appearance;

  final SettingsController settings;

  final LocaleController locale;

  final OnboardingController onboarding;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<AppearanceController>.value(value: appearance),
      ChangeNotifierProvider<SettingsController>.value(value: settings),
      ChangeNotifierProvider<LocaleController>.value(value: locale),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
    ],
    child: Builder(
      builder: (BuildContext context) {
        final AppearanceController current = context
            .watch<AppearanceController>();
        final ThemeData theme = current.themeMode == ThemeMode.dark
            ? buildDarkTheme(options: current.themeOptions)
            : buildLightTheme(options: current.themeOptions);
        return TranslationProvider(
          child: MaterialApp(
            theme: theme,
            darkTheme: theme,
            themeMode: current.themeMode,
            home: const SettingsPage(),
          ),
        );
      },
    ),
  );
}
