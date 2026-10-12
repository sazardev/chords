import 'package:chords/core/analytics/analytics_backend.dart';

/// Backend de analíticas en memoria para pruebas.
///
/// Registra cada llamada para poder afirmar sobre eventos, pantallas,
/// propiedades, errores y control de recogida sin depender de ningún SDK.
class FakeAnalyticsBackend implements AnalyticsBackend {
  /// Nombres de los eventos registrados, en orden.
  final List<String> events = <String>[];

  /// Parámetros del último evento registrado con cada nombre.
  final Map<String, Map<String, Object?>> lastParameters =
      <String, Map<String, Object?>>{};

  /// Pantallas registradas, en orden.
  final List<String> screens = <String>[];

  /// Pantalla anterior asociada a cada visita.
  final List<String?> previousScreens = <String?>[];

  /// Propiedades de usuario fijadas (`clave=valor`).
  final List<String> properties = <String>[];

  /// Mensajes de los errores registrados.
  final List<String> errors = <String>[];

  /// Si cada error se registró como fatal.
  final List<bool> fatals = <bool>[];

  /// Último estado de recogida solicitado.
  bool? collectionEnabled;

  /// Número de volcados solicitados.
  int flushes = 0;

  @override
  void logEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  }) {
    events.add(name);
    lastParameters[name] = parameters;
  }

  @override
  void logScreen(String name, {String? previous}) {
    screens.add(name);
    previousScreens.add(previous);
  }

  @override
  void setUserProperty(String name, String? value) {
    properties.add('$name=$value');
  }

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    Map<String, Object?> context = const <String, Object?>{},
  }) {
    errors.add(error.toString());
    fatals.add(fatal);
  }

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async {
    collectionEnabled = enabled;
  }

  @override
  Future<void> flush() async {
    flushes++;
  }
}
