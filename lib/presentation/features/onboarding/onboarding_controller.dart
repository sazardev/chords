import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:flutter/foundation.dart';

/// Estado del onboarding de primer uso.
/// Estado del onboarding de primer uso.
enum OnboardingStatus {
  /// Pendiente de mostrar.
  pending,

  /// Ya completado.
  done,
}

/// Controlador del onboarding.
///
/// Persiste si el usuario ya completó la introducción y permite reiniciarla
/// desde ajustes.
class OnboardingController extends ChangeNotifier {
  /// Crea el controlador.
  OnboardingController(this._preferences);

  final PreferencesRepository _preferences;

  OnboardingStatus _status = OnboardingStatus.pending;

  /// Estado actual.
  OnboardingStatus get status => _status;

  /// Si el onboarding está pendiente de mostrarse.
  bool get isPending => _status == OnboardingStatus.pending;

  /// Carga el estado persistido.
  void load() {
    _status = _preferences.onboardingCompleted
        ? OnboardingStatus.done
        : OnboardingStatus.pending;
    notifyListeners();
  }

  /// Marca el onboarding como completado.
  Future<void> complete() async {
    await _preferences.setOnboardingCompleted();
    _status = OnboardingStatus.done;
    notifyListeners();
  }

  /// Marca el onboarding como completado de forma sincrónica (para tests).
  void completeSync() {
    _status = OnboardingStatus.done;
    notifyListeners();
  }

  /// Reinicia el onboarding (desde ajustes).
  Future<void> reset() async {
    await _preferences.resetOnboarding();
    _status = OnboardingStatus.pending;
    notifyListeners();
  }
}
