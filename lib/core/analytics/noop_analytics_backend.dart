import 'package:chords/core/analytics/analytics_backend.dart';

/// Backend de analíticas silencioso.
///
/// Se usa cuando no hay proveedor disponible (flavor de desarrollo, escritorio
/// sin soporte o fallo de arranque del SDK) para que el resto de la app llame a
/// las analíticas sin ramas condicionales y sin coste.
class NoopAnalyticsBackend implements AnalyticsBackend {
  /// Crea el backend silencioso.
  const NoopAnalyticsBackend();

  @override
  void logEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  }) {}

  @override
  void logScreen(String name, {String? previous}) {}

  @override
  void setUserProperty(String name, String? value) {}

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    Map<String, Object?> context = const <String, Object?>{},
  }) {}

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async {}

  @override
  Future<void> flush() async {}
}
