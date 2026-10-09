/// Flavors (variantes) de compilación soportados por la aplicación.
enum Flavor {
  /// Desarrollo: banner visible, diagnósticos de rutas activos.
  dev,

  /// Staging: pre-producción para pruebas internas.
  staging,

  /// Producción: sin extras de depuración.
  prod,
}
