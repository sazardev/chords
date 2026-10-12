import 'dart:async' show unawaited;

import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/settings_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/foundation.dart';

/// Controlador del perfil de la persona.
///
/// Guarda cada elección al instante (el onboarding y la pantalla de perfil
/// comparten estos métodos) y mantiene sincronizado el espejo de los
/// diagramas con la mano elegida.
class ProfileController extends ChangeNotifier {
  /// Crea el controlador.
  ProfileController(this._preferences, this._settings);

  final PreferencesRepository _preferences;
  final SettingsController _settings;

  PlayerProfile _profile = const PlayerProfile.initial();

  /// Perfil actual.
  PlayerProfile get profile => _profile;

  /// Carga el perfil persistido.
  void load() {
    _profile = _preferences.playerProfile;
    notifyListeners();
  }

  /// Elige el tipo de guitarra.
  void setGuitar(GuitarType value) => _apply(_profile.copyWith(guitar: value));

  /// Elige la mano y ajusta el espejo de los diagramas.
  void setHand(PlayingHand value) {
    _apply(_profile.copyWith(hand: value));
    unawaited(_settings.setMirrorChords(value: value == PlayingHand.left));
  }

  /// Elige cómo ataca las cuerdas.
  void setStyle(PlayingStyle value) => _apply(_profile.copyWith(style: value));

  /// Añade o quita un género favorito.
  void toggleGenre(String genre) {
    final Set<String> genres = <String>{..._profile.genres};
    if (!genres.remove(genre)) {
      genres.add(genre);
    }
    _apply(_profile.copyWith(genres: genres));
  }

  /// Elige la experiencia.
  void setExperience(ExperienceLevel value) =>
      _apply(_profile.copyWith(experience: value));

  /// Da por buenas las elecciones actuales (al terminar el onboarding).
  void confirm() => _apply(_profile.copyWith(personalized: true));

  void _apply(PlayerProfile next) {
    if (next == _profile && _profile.personalized) {
      return;
    }
    _profile = next.copyWith(personalized: true);
    unawaited(_preferences.setPlayerProfile(_profile));
    appLogger.debug('perfil actualizado: $_profile');
    analytics.profileUpdated(
      guitar: _profile.guitar.name,
      hand: _profile.hand.name,
      style: _profile.style.name,
      experience: _profile.experience.name,
      genres: _profile.genres.length,
    );
    notifyListeners();
  }
}
