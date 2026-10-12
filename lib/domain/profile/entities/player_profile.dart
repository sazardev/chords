import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:meta/meta.dart';

/// Perfil de la persona: guitarra, mano, estilo, géneros y experiencia.
///
/// Con él la app recomienda acordes y ajusta la dificultad y los diagramas.
@immutable
class PlayerProfile {
  /// Crea un perfil.
  const PlayerProfile({
    this.guitar = GuitarType.acoustic,
    this.hand = PlayingHand.right,
    this.style = PlayingStyle.both,
    this.genres = const <String>{},
    this.experience = ExperienceLevel.beginner,
    this.personalized = false,
  });

  /// Perfil por defecto de quien aún no lo ha configurado.
  const PlayerProfile.initial() : this();

  /// Tipo de guitarra.
  final GuitarType guitar;

  /// Mano con la que toca.
  final PlayingHand hand;

  /// Forma de atacar las cuerdas.
  final PlayingStyle style;

  /// Géneros favoritos (nombres canónicos, p. ej. `Rock`).
  final Set<String> genres;

  /// Experiencia.
  final ExperienceLevel experience;

  /// `true` si la persona ya eligió sus preferencias.
  final bool personalized;

  /// `true` si toca con la mano izquierda.
  bool get isLeftHanded => hand == PlayingHand.left;

  /// Copia el perfil cambiando lo indicado.
  PlayerProfile copyWith({
    GuitarType? guitar,
    PlayingHand? hand,
    PlayingStyle? style,
    Set<String>? genres,
    ExperienceLevel? experience,
    bool? personalized,
  }) => PlayerProfile(
    guitar: guitar ?? this.guitar,
    hand: hand ?? this.hand,
    style: style ?? this.style,
    genres: genres ?? this.genres,
    experience: experience ?? this.experience,
    personalized: personalized ?? this.personalized,
  );

  @override
  bool operator ==(Object other) =>
      other is PlayerProfile &&
      other.guitar == guitar &&
      other.hand == hand &&
      other.style == style &&
      other.experience == experience &&
      other.personalized == personalized &&
      other.genres.length == genres.length &&
      other.genres.containsAll(genres);

  @override
  int get hashCode => Object.hash(
    guitar,
    hand,
    style,
    experience,
    personalized,
    Object.hashAllUnordered(genres),
  );

  @override
  String toString() =>
      'PlayerProfile($guitar, $hand, $style, $experience, $genres)';
}
