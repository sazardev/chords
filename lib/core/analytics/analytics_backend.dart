/// Destino remoto de las analíticas de la aplicación.
///
/// Define las primitivas que usa la fachada `AnalyticsService`: eventos,
/// pantallas, propiedades de usuario, errores y control de la recogida. Es la
/// frontera pura con el proveedor (Firebase u otro), de modo que el núcleo de
/// analíticas nunca depende de un SDK concreto y se puede probar con un doble.
abstract interface class AnalyticsBackend {
  /// Registra un evento con sus parámetros.
  void logEvent(
    String name, {
    Map<String, Object?> parameters = const <String, Object?>{},
  });

  /// Registra la visita a una pantalla y, si procede, la anterior.
  void logScreen(String name, {String? previous});

  /// Fija una propiedad de usuario; `null` la elimina.
  void setUserProperty(String name, String? value);

  /// Registra un error para su agrupación y seguimiento.
  ///
  /// [fatal] distingue los fallos que habrían tumbado la app de los que no, y
  /// [context] aporta claves legibles al informe.
  void recordError(
    Object error,
    StackTrace stackTrace, {
    required bool fatal,
    Map<String, Object?> context = const <String, Object?>{},
  });

  /// Activa o desactiva la recogida remota de datos.
  Future<void> setCollectionEnabled({required bool enabled});

  /// Fuerza el envío de lo que quede pendiente.
  Future<void> flush();
}
