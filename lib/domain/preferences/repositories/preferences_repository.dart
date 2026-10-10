import 'package:chords/domain/preferences/repositories/appearance_preferences.dart';
import 'package:chords/domain/preferences/repositories/onboarding_preferences.dart';
import 'package:chords/domain/preferences/repositories/progress_preferences.dart';
import 'package:chords/domain/preferences/repositories/sound_preferences.dart';

/// Contrato completo de preferencias que consume la presentación.
///
/// Compone áreas cohesivas ([OnboardingPreferences], [ProgressPreferences],
/// [AppearancePreferences] y [SoundPreferences]) para que cada controlador
/// dependa solo de lo que usa, manteniendo una única abstracción de dominio.
abstract interface class PreferencesRepository
    implements
        AppearancePreferences,
        OnboardingPreferences,
        ProgressPreferences,
        SoundPreferences {}
