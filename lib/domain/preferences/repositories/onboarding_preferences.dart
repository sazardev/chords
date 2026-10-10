/// Preferencias de incorporación (onboarding) de primer uso.
abstract interface class OnboardingPreferences {
  /// Si el usuario ya completó el onboarding.
  bool get onboardingCompleted;

  /// Marca el onboarding como completado.
  Future<void> setOnboardingCompleted();

  /// Reinicia el onboarding.
  Future<void> resetOnboarding();
}
