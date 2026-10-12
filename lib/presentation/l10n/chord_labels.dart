/// Etiquetas traducidas de los datos musicales.
///
/// El banco de acordes guarda sus textos en español como datos canónicos;
/// estas funciones los presentan en el idioma activo de la interfaz. Para dar
/// soporte a un idioma nuevo solo hay que añadir las claves a `lib/l10n`.
library;

import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/learning_level.dart';
import 'package:chords/l10n/translations.g.dart';

/// Nombre traducido de un género musical.
String genreLabel(Translations translations, String genre) => switch (genre) {
  'Pop' => translations.data.genre.pop,
  'Rock' => translations.data.genre.rock,
  'Blues' => translations.data.genre.blues,
  'Jazz' => translations.data.genre.jazz,
  'Funk' => translations.data.genre.funk,
  'Balada' => translations.data.genre.ballad,
  'Latino' => translations.data.genre.latin,
  'Metal' => translations.data.genre.metal,
  'R&B' => translations.data.genre.rnb,
  'Soul' => translations.data.genre.soul,
  'Bossa' => translations.data.genre.bossa,
  'Country' => translations.data.genre.country,
  'Infantil' => translations.data.genre.kids,
  'Ambient' => translations.data.genre.ambient,
  'Clásico' => translations.data.genre.classical,
  'Gospel' => translations.data.genre.gospel,
  'Punk' => translations.data.genre.punk,
  _ => genre,
};

/// Nombre traducido de una calidad de acorde.
String qualityLabel(Translations translations, ChordQuality quality) =>
    switch (quality) {
      ChordQuality.major => translations.data.quality.major,
      ChordQuality.minor => translations.data.quality.minor,
      ChordQuality.seven => translations.data.quality.seven,
      ChordQuality.minorSeven => translations.data.quality.minorSeven,
      ChordQuality.majorSeven => translations.data.quality.majorSeven,
      ChordQuality.suspendedFourth => translations.data.quality.suspendedFourth,
      ChordQuality.suspendedSecond => translations.data.quality.suspendedSecond,
      ChordQuality.power => translations.data.quality.power,
      ChordQuality.sixth => translations.data.quality.sixth,
      ChordQuality.minorSixth => translations.data.quality.minorSixth,
      ChordQuality.diminished => translations.data.quality.diminished,
      ChordQuality.augmented => translations.data.quality.augmented,
      ChordQuality.ninth => translations.data.quality.ninth,
    };

/// Descripción traducida de una calidad de acorde.
String qualityDescription(
  Translations translations,
  ChordQuality quality,
) => switch (quality) {
  ChordQuality.major => translations.data.qualityDescription.major,
  ChordQuality.minor => translations.data.qualityDescription.minor,
  ChordQuality.seven => translations.data.qualityDescription.seven,
  ChordQuality.minorSeven => translations.data.qualityDescription.minorSeven,
  ChordQuality.majorSeven => translations.data.qualityDescription.majorSeven,
  ChordQuality.suspendedFourth =>
    translations.data.qualityDescription.suspendedFourth,
  ChordQuality.suspendedSecond =>
    translations.data.qualityDescription.suspendedSecond,
  ChordQuality.power => translations.data.qualityDescription.power,
  ChordQuality.sixth => translations.data.qualityDescription.sixth,
  ChordQuality.minorSixth => translations.data.qualityDescription.minorSixth,
  ChordQuality.diminished => translations.data.qualityDescription.diminished,
  ChordQuality.augmented => translations.data.qualityDescription.augmented,
  ChordQuality.ninth => translations.data.qualityDescription.ninth,
};

/// Etiqueta traducida de un nivel de dificultad.
String difficultyLabel(Translations translations, Difficulty difficulty) =>
    switch (difficulty) {
      Difficulty.beginner => translations.data.difficulty.beginner,
      Difficulty.easy => translations.data.difficulty.easy,
      Difficulty.medium => translations.data.difficulty.medium,
      Difficulty.hard => translations.data.difficulty.hard,
      Difficulty.expert => translations.data.difficulty.expert,
    };

/// Ayuda traducida de un nivel de dificultad.
String difficultyHint(Translations translations, Difficulty difficulty) =>
    switch (difficulty) {
      Difficulty.beginner => translations.data.difficultyHint.beginner,
      Difficulty.easy => translations.data.difficultyHint.easy,
      Difficulty.medium => translations.data.difficultyHint.medium,
      Difficulty.hard => translations.data.difficultyHint.hard,
      Difficulty.expert => translations.data.difficultyHint.expert,
    };

/// Título traducido de un nivel del itinerario.
String learningLevelTitle(Translations translations, LearningLevel level) =>
    switch (level) {
      LearningLevel.first => translations.data.level.first,
      LearningLevel.second => translations.data.level.second,
      LearningLevel.third => translations.data.level.third,
      LearningLevel.fourth => translations.data.level.fourth,
      LearningLevel.fifth => translations.data.level.fifth,
    };

/// Objetivo traducido de un nivel del itinerario.
String learningLevelGoal(Translations translations, LearningLevel level) =>
    switch (level) {
      LearningLevel.first => translations.data.levelGoal.first,
      LearningLevel.second => translations.data.levelGoal.second,
      LearningLevel.third => translations.data.levelGoal.third,
      LearningLevel.fourth => translations.data.levelGoal.fourth,
      LearningLevel.fifth => translations.data.levelGoal.fifth,
    };

/// Nombre traducido de un patrón de arpegio.
String arpeggioLabel(Translations translations, ArpeggioPattern pattern) =>
    switch (pattern) {
      ArpeggioPattern.ascending => translations.data.arpeggio.ascending,
      ArpeggioPattern.descending => translations.data.arpeggio.descending,
      ArpeggioPattern.alternating => translations.data.arpeggio.alternating,
      ArpeggioPattern.fingerstyle => translations.data.arpeggio.fingerstyle,
      _ => pattern.label,
    };

/// Etiqueta traducida de un número de cuerda (1 = primera).
String guitarStringLabel(Translations translations, int stringNumber) =>
    switch (stringNumber) {
      1 => translations.game.stringFirst,
      2 => translations.game.stringSecond,
      3 => translations.game.stringThird,
      4 => translations.game.stringFourth,
      5 => translations.game.stringFifth,
      6 => translations.game.stringSixth,
      _ => '$stringNumber',
    };
