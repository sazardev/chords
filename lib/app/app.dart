import 'package:chords/config/app_config.dart';
import 'package:chords/presentation/features/onboarding/onboarding_controller.dart';
import 'package:chords/presentation/features/onboarding/onboarding_page.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:chords/presentation/theme/app_theme.dart';
import 'package:chords/presentation/widgets/organisms/flavor_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Widget raíz de la aplicación.
///
/// Monta `MaterialApp.router` con el tema claro/oscuro y el banner de flavor.
/// Si el usuario no ha completado el onboarding, lo muestra a pantalla
/// completa sobre el contenido.
class ChordsApp extends StatelessWidget {
  /// Crea la aplicación.
  const ChordsApp({required this.config, required this.router, super.key});

  /// Configuración del flavor activo.
  final AppConfig config;

  /// Enrutador de navegación.
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = context.watch<SettingsController>();
    final OnboardingController onboarding = context
        .watch<OnboardingController>();
    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
      builder: (BuildContext context, Widget? child) => FlavorBanner(
        visible: config.showFlavorBanner,
        text: config.appName,
        child: onboarding.isPending
            ? const OnboardingPage()
            : child ?? const SizedBox.shrink(),
      ),
    );
  }
}
