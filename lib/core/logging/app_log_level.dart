/// Nivel de severidad de un evento de log de Chords.
enum AppLogLevel {
  /// Detalle de depuración (desactivado en producción salvo diagnóstico).
  debug(500, 'DEBUG'),

  /// Suceso informativo del flujo normal.
  info(800, 'INFO'),

  /// Aviso: algo inesperado pero recuperable.
  warning(900, 'WARN'),

  /// Error: una operación falló.
  error(1000, 'ERROR');

  /// Crea el nivel con su valor numérico y etiqueta.
  const AppLogLevel(this.value, this.label);

  /// Valor numérico compatible con `package:logging`.
  final int value;

  /// Etiqueta corta para consola y almacén.
  final String label;

  /// Si el nivel es de error.
  bool get isError => this == AppLogLevel.error;

  /// Si el nivel es de aviso.
  bool get isWarning => this == AppLogLevel.warning;
}
