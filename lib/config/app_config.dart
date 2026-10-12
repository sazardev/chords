import 'package:chords/config/flavor.dart';

/// Configuración de la aplicación resuelta según el flavor activo.
class AppConfig {
  const AppConfig._({
    required this.flavor,
    required this.appName,
    required this.applicationId,
    required this.showFlavorBanner,
    required this.enableLiveMicrophone,
    required this.enableRouteLogs,
    required this.enableAnalytics,
  });

  /// Configuración del flavor de desarrollo.
  const AppConfig.dev()
    : this._(
        flavor: Flavor.dev,
        appName: 'Chords Dev',
        applicationId: 'app.chords.chords.dev',
        showFlavorBanner: true,
        enableLiveMicrophone: true,
        enableRouteLogs: true,
        enableAnalytics: false,
      );

  /// Configuración del flavor de staging.
  const AppConfig.staging()
    : this._(
        flavor: Flavor.staging,
        appName: 'Chords Staging',
        applicationId: 'app.chords.chords.staging',
        showFlavorBanner: true,
        enableLiveMicrophone: true,
        enableRouteLogs: true,
        enableAnalytics: true,
      );

  /// Configuración del flavor de producción.
  const AppConfig.prod()
    : this._(
        flavor: Flavor.prod,
        appName: 'Chords',
        applicationId: 'app.chords.chords',
        showFlavorBanner: false,
        enableLiveMicrophone: true,
        enableRouteLogs: false,
        enableAnalytics: true,
      );

  /// Resuelve la configuración desde la variable de entorno `FLAVOR`.
  factory AppConfig.fromEnvironment() {
    const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    return switch (flavor) {
      'dev' => const AppConfig.dev(),
      'staging' => const AppConfig.staging(),
      'prod' => const AppConfig.prod(),
      _ => const AppConfig.dev(),
    };
  }

  /// Flavor activo.
  final Flavor flavor;

  /// Nombre visible de la aplicación.
  final String appName;

  /// Identificador de aplicación por plataforma.
  final String applicationId;

  /// Si se muestra el banner de flavor en la parte superior.
  final bool showFlavorBanner;

  /// Si la afinación en vivo por micrófono está disponible.
  final bool enableLiveMicrophone;

  /// Si se registran diagnósticos de navegación.
  final bool enableRouteLogs;

  /// Si se envían analíticas y errores al proveedor remoto (Firebase).
  final bool enableAnalytics;

  /// Si el favor es de producción.
  bool get isProduction => flavor == Flavor.prod;
}
