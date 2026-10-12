import 'package:chords/config/app_config.dart';
import 'package:chords/config/flavor.dart';
import 'package:chords/core/analytics/analytics_service.dart';
import 'package:chords/core/analytics/noop_analytics_backend.dart';
import 'package:chords/data/analytics/firebase_analytics_backend.dart';
import 'package:chords/firebase_options_dev.dart' as dev;
import 'package:chords/firebase_options_prod.dart' as prod;
import 'package:chords/firebase_options_staging.dart' as staging;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Resultado del arranque de analíticas.
///
/// Siempre incluye un [service] utilizable (real o silencioso). Si el SDK no
/// pudo arrancar, [problem] y [stackTrace] conservan el fallo para que el
/// registro de arranque lo cuente una vez disponible.
class AnalyticsBootstrapResult {
  /// Crea el resultado del arranque.
  const AnalyticsBootstrapResult({
    required this.service,
    this.active = false,
    this.problem,
    this.stackTrace,
  });

  /// Servicio de analíticas listo para usar.
  final AnalyticsService service;

  /// Si hay un backend remoto real detrás del servicio.
  final bool active;

  /// Fallo de arranque del SDK, si lo hubo.
  final Object? problem;

  /// Traza del fallo de arranque, si lo hubo.
  final StackTrace? stackTrace;
}

/// Prepara el servicio de analíticas según el flavor y la plataforma.
///
/// En flavor de desarrollo, en plataformas sin soporte (Linux, Windows) o si
/// Firebase falla al arrancar, devuelve un servicio silencioso en lugar de
/// romper el arranque de la app.
Future<AnalyticsBootstrapResult> bootstrapAnalytics({
  required AppConfig config,
}) async {
  if (!config.enableAnalytics || !_isSupported) {
    return AnalyticsBootstrapResult(service: _silentService());
  }
  try {
    await Firebase.initializeApp(options: _optionsFor(config.flavor));
    final FirebaseAnalyticsBackend backend = FirebaseAnalyticsBackend(
      analytics: FirebaseAnalytics.instance,
      crashlytics: _supportsCrashlytics ? FirebaseCrashlytics.instance : null,
    );
    await backend.setCollectionEnabled(enabled: true);
    final AnalyticsService service = AnalyticsService(backend)
      ..setUserProperty('flavor', config.flavor.name);
    return AnalyticsBootstrapResult(service: service, active: true);
  } on Object catch (error, stackTrace) {
    return AnalyticsBootstrapResult(
      service: _silentService(),
      problem: error,
      stackTrace: stackTrace,
    );
  }
}

AnalyticsService _silentService() =>
    AnalyticsService(const NoopAnalyticsBackend());

bool get _isSupported =>
    kIsWeb ||
    switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };

bool get _supportsCrashlytics =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };

FirebaseOptions _optionsFor(Flavor flavor) => switch (flavor) {
  Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
  Flavor.staging => staging.DefaultFirebaseOptions.currentPlatform,
  Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
};
