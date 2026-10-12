/// Etiquetas traducidas del perfil de la persona.
library;

import 'package:chords/domain/profile/entities/experience_level.dart';
import 'package:chords/domain/profile/entities/guitar_type.dart';
import 'package:chords/domain/profile/entities/player_profile.dart';
import 'package:chords/domain/profile/entities/playing_hand.dart';
import 'package:chords/domain/profile/entities/playing_style.dart';
import 'package:chords/l10n/translations.g.dart';

/// Nombre del tipo de guitarra.
String guitarTypeLabel(Translations t, GuitarType value) => switch (value) {
  GuitarType.acoustic => t.onboarding.guitarAcoustic,
  GuitarType.electric => t.onboarding.guitarElectric,
  GuitarType.classical => t.onboarding.guitarClassical,
};

/// Descripción corta del tipo de guitarra.
String guitarTypeHint(Translations t, GuitarType value) => switch (value) {
  GuitarType.acoustic => t.onboarding.guitarAcousticHint,
  GuitarType.electric => t.onboarding.guitarElectricHint,
  GuitarType.classical => t.onboarding.guitarClassicalHint,
};

/// Nombre de la mano.
String playingHandLabel(Translations t, PlayingHand value) => switch (value) {
  PlayingHand.right => t.onboarding.handRight,
  PlayingHand.left => t.onboarding.handLeft,
};

/// Descripción corta de la mano.
String playingHandHint(Translations t, PlayingHand value) => switch (value) {
  PlayingHand.right => t.onboarding.handRightHint,
  PlayingHand.left => t.onboarding.handLeftHint,
};

/// Nombre del estilo de ataque.
String playingStyleLabel(Translations t, PlayingStyle value) => switch (value) {
  PlayingStyle.pick => t.onboarding.stylePick,
  PlayingStyle.fingers => t.onboarding.styleFingers,
  PlayingStyle.both => t.onboarding.styleBoth,
};

/// Nombre del nivel de experiencia.
String experienceLabel(Translations t, ExperienceLevel value) =>
    switch (value) {
      ExperienceLevel.beginner => t.onboarding.levelBeginner,
      ExperienceLevel.intermediate => t.onboarding.levelIntermediate,
      ExperienceLevel.advanced => t.onboarding.levelAdvanced,
    };

/// Descripción corta del nivel de experiencia.
String experienceHint(Translations t, ExperienceLevel value) => switch (value) {
  ExperienceLevel.beginner => t.onboarding.levelBeginnerHint,
  ExperienceLevel.intermediate => t.onboarding.levelIntermediateHint,
  ExperienceLevel.advanced => t.onboarding.levelAdvancedHint,
};

/// Resumen de una línea del perfil (p. ej. `Acústica · Estoy empezando`).
String profileSummary(Translations t, PlayerProfile profile) =>
    t.profile.summary(
      guitar: guitarTypeLabel(t, profile.guitar),
      level: experienceLabel(t, profile.experience),
    );

/// Géneros que se ofrecen al elegir gustos musicales.
const List<String> kProfileGenres = <String>[
  'Pop',
  'Rock',
  'Blues',
  'Jazz',
  'Funk',
  'Balada',
  'Latino',
  'Metal',
  'Country',
  'R&B',
];
