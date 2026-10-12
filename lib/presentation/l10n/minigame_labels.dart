/// Etiquetas traducidas de los minijuegos.
///
/// Convierten los datos del dominio (juegos, opciones, enunciados) en
/// textos del idioma activo sin que el dominio conozca ningún idioma.
library;

import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/pitch_classes.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/chord_labels.dart';
import 'package:chords/presentation/l10n/tuner_labels.dart';

/// Nombre traducido de un minijuego.
String gameTitle(Translations t, MiniGameKind kind) =>
    t.minigames.titles[kind.id] ?? kind.id;

/// Descripción corta de un minijuego (para su tarjeta).
String gameDescription(Translations t, MiniGameKind kind) =>
    t.minigames.descriptions[kind.id] ?? '';

/// Explicación de cómo se juega un minijuego.
String gameHowTo(Translations t, MiniGameKind kind) =>
    t.minigames.howTo[kind.id] ?? '';

/// Título traducido de una familia de juegos.
String categoryTitle(Translations t, MiniGameCategory category) =>
    switch (category) {
      MiniGameCategory.ear => t.minigames.earTitle,
      MiniGameCategory.fretboard => t.minigames.fretboardTitle,
      MiniGameCategory.play => t.minigames.playTitle,
    };

/// Subtítulo traducido de una familia de juegos.
String categorySubtitle(Translations t, MiniGameCategory category) =>
    switch (category) {
      MiniGameCategory.ear => t.minigames.earSubtitle,
      MiniGameCategory.fretboard => t.minigames.fretboardSubtitle,
      MiniGameCategory.play => t.minigames.playSubtitle,
    };

/// Nombre traducido de una dificultad.
String levelLabel(Translations t, MiniGameLevel level) => switch (level) {
  MiniGameLevel.easy => t.minigames.levelEasy,
  MiniGameLevel.medium => t.minigames.levelMedium,
  MiniGameLevel.hard => t.minigames.levelHard,
};

/// Título del resultado según las estrellas ganadas (0-3).
String resultTitle(Translations t, int stars) => switch (stars) {
  3 => t.minigames.resultTitle3,
  2 => t.minigames.resultTitle2,
  1 => t.minigames.resultTitle1,
  _ => t.minigames.resultTitle0,
};

/// Nombre de una nota por su clase de tono (`Do` en español, `C` en inglés).
String noteLabel(Translations t, int pitchClass) =>
    t.minigames.noteNames['n${pitchClass % 12}'] ??
    noteNameOfPitchClass(pitchClass);

/// Nombre de una nota dada en notación inglesa (`C#`).
String noteLabelOf(Translations t, String note) {
  final int pitchClass = pitchClassOfNote(note);
  return pitchClass < 0 ? note : noteLabel(t, pitchClass);
}

/// Texto de un traste: `Traste 3` o `Al aire`.
String fretLabel(Translations t, int fret) =>
    fret == 0 ? t.minigames.choice.fretOpen : t.minigames.choice.fret(n: fret);

/// Texto de una opción de respuesta.
String choiceLabel(Translations t, QuizChoice choice) =>
    choice.label ??
    switch (choice.type) {
      ChoiceType.note => noteLabelOf(t, choice.value),
      ChoiceType.stringNumber => _stringChoice(t, choice.value),
      ChoiceType.fret => fretLabel(t, int.tryParse(choice.value) ?? 0),
      ChoiceType.interval =>
        t.minigames.intervalNames['i${choice.value}'] ?? choice.value,
      ChoiceType.quality => _qualityChoice(t, choice.value),
      ChoiceType.chord => choice.value,
      ChoiceType.finger => _fingerChoice(t, choice.value),
      ChoiceType.order =>
        choice.value == 'first'
            ? t.minigames.choice.first
            : t.minigames.choice.second,
      ChoiceType.tuning => _tuningChoice(t, choice.value),
    };

String _stringChoice(Translations t, String value) {
  final int number = int.tryParse(value) ?? 1;
  return stringTitle(t, standardStringByNumber(number)!);
}

String _qualityChoice(Translations t, String id) {
  final ChordQuality? quality = ChordQuality.fromId(id);
  return quality == null ? id : qualityLabel(t, quality);
}

String _fingerChoice(Translations t, String value) => switch (value) {
  '1' => t.minigames.choice.finger1,
  '2' => t.minigames.choice.finger2,
  '3' => t.minigames.choice.finger3,
  _ => t.minigames.choice.finger4,
};

String _tuningChoice(Translations t, String value) => switch (value) {
  'flat' => t.minigames.choice.flat,
  'sharp' => t.minigames.choice.sharp,
  _ => t.minigames.choice.inTune,
};

/// Enunciado de una pregunta de opciones.
String questionPrompt(Translations t, QuizQuestion question) {
  final String string = stringShort(t, question.stringNumber ?? 1);
  final int fret = question.fret ?? 0;
  final String note = noteLabelOf(t, question.note ?? 'C');
  return switch (question.kind) {
    MiniGameKind.guessNote => t.minigames.prompt.guessNote,
    MiniGameKind.whichString => t.minigames.prompt.whichString,
    MiniGameKind.whichFret => t.minigames.prompt.whichFret(string: string),
    MiniGameKind.interval => t.minigames.prompt.interval,
    MiniGameKind.higherLower => t.minigames.prompt.higherLower,
    MiniGameKind.chordQuality => t.minigames.prompt.chordQuality,
    MiniGameKind.nameChord => t.minigames.prompt.nameChord,
    MiniGameKind.tuneEar => t.minigames.prompt.tuneEar,
    MiniGameKind.memory => t.minigames.prompt.memory,
    MiniGameKind.noteAtFret =>
      fret == 0
          ? t.minigames.prompt.noteAtOpen(string: string)
          : t.minigames.prompt.noteAtFret(string: string, fret: fret),
    MiniGameKind.fretOfNote => t.minigames.prompt.fretOfNote(
      string: string,
      note: note,
    ),
    MiniGameKind.fingerQuiz => t.minigames.prompt.fingerQuiz(string: string),
    MiniGameKind.readDiagram => t.minigames.prompt.readDiagram,
    _ => gameTitle(t, question.kind),
  };
}

/// Enunciado de un reto de micrófono.
String challengePrompt(Translations t, MicChallenge challenge) {
  final String string = stringShort(t, challenge.stringNumber ?? 1);
  final int fret = challenge.fret ?? 0;
  return switch (challenge.kind) {
    MiniGameKind.playNote => t.minigames.prompt.playNote(
      note: noteLabel(t, challenge.pitchClasses.first),
    ),
    MiniGameKind.playStringFret =>
      fret == 0
          ? t.minigames.prompt.playStringOpen(string: string)
          : t.minigames.prompt.playStringFret(string: string, fret: fret),
    _ => t.minigames.prompt.echo,
  };
}

/// Pista de dónde tocar la nota de un reto, si el reto la ofrece.
String? challengeHint(Translations t, MicChallenge challenge) {
  final int? number = challenge.stringNumber;
  final int? fret = challenge.fret;
  if (!challenge.showHint || number == null || fret == null) {
    return null;
  }
  final String string = stringShort(t, number);
  return fret == 0
      ? t.minigames.micHintOpen(string: string)
      : t.minigames.micHintFret(string: string, fret: fret);
}
