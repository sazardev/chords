/// Estado del micrófono en vivo.
enum MicStatus {
  /// Sin iniciar.
  idle,

  /// Escuchando.
  listening,

  /// Permiso denegado por el usuario o el sistema.
  permissionDenied,

  /// Error de captura o dispositivo.
  error;

  /// `true` si el micrófono está escuchando.
  bool get isListening => this == MicStatus.listening;
}
