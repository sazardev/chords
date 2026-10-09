/// Estado del micrófono en vivo.
enum MicStatus {
  /// Sin iniciar.
  idle,

  /// Escuchando.
  listening,

  /// Permiso denegado por el usuario o el sistema.
  permissionDenied,

  /// Error de captura o dispositivo.
  error,
}
