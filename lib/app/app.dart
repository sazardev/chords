import 'package:chords/config/app_config.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_page.dart';
import 'package:chords/presentation/features/settings/appearance_controller.dart';
import 'package:chords/presentation/l10n/locale_controller.dart';
import 'package:chords/presentation/theme/app_system_colors.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:chords/presentation/theme/app_theme_options.dart';
import 'package:chords/presentation/theme/system_color_scope.dart';
import 'package:chords/presentation/widgets/organisms/flavor_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Widget raíz de la aplicación.
///
/// Monta `MaterialApp.router` con el tema claro/oscuro, el idioma elegido y el
/// banner de flavor. Si el usuario no ha completado el onboarding, lo muestra
/// a pantalla completa sobre el contenido.
class ChordsApp extends StatelessWidget {
  /// Crea la aplicación.
  const ChordsApp({required this.config, required this.router, super.key});

  /// Configuración del flavor activo.
  final AppConfig config;

  /// Enrutador de navegación.
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final AppearanceController appearance = context
        .watch<AppearanceController>();
    final LocaleController locale = context.watch<LocaleController>();
    final OnboardingController onboarding = context
        .watch<OnboardingController>();
    return SystemColorScope(
      builder: (AppSystemColors? systemColors) {
        final AppThemeOptions options = appearance.themeOptions;
        final bool useDynamic = options.dynamicColor && systemColors != null;
        return MaterialApp.router(
          title: config.appName,
          debugShowCheckedModeBanner: false,
          themeMode: appearance.themeMode,
          locale: locale.locale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: buildLightTheme(
            dynamicScheme: useDynamic ? systemColors.light : null,
            options: options,
          ),
          darkTheme: buildDarkTheme(
            dynamicScheme: useDynamic ? systemColors.dark : null,
            options: options,
          ),
          routerConfig: router,
          builder: (BuildContext context, Widget? child) => FlavorBanner(
            visible: config.showFlavorBanner,
            text: config.appName,
            child: onboarding.isPending
                ? const OnboardingPage()
                : child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
