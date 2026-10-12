import 'package:chords/domain/profile/entities/player_profile.dart';

/// Preferencias del perfil de la persona (guitarra, mano, estilo, géneros y
/// experiencia).
abstract interface class ProfilePreferences {
  /// Perfil guardado (el inicial si nunca se configuró).
  PlayerProfile get playerProfile;

  /// Guarda el perfil completo.
  Future<void> setPlayerProfile(PlayerProfile profile);
}
