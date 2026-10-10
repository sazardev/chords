/// Preferencias de sonido de la aplicación.
abstract interface class SoundPreferences {
  /// Si el sonido de los acordes está activado.
  bool get soundEnabled;

  /// Activa o desactiva el sonido.
  Future<void> setSoundEnabled({required bool value});
}
