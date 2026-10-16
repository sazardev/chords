/// Etiquetas traducidas de la escuela de teoría, el jam y el cancionero.
///
/// Convierten escalas, tonalidades, grados, géneros y lecciones del dominio
/// en textos del idioma activo.
library;

import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/l10n/minigame_labels.dart';

/// Pone en mayúscula la primera letra (`pentatónica menor` → `Pentatónica…`).
String capitalized(String text) =>
    text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';

/// Nombre de una escala en minúsculas (`pentatónica menor`).
String scaleName(Translations t, ScaleType scale) =>
    t.scalesPlus.names[scale.id] ?? t.theory.scaleNames[scale.id] ?? scale.id;

/// Nombre de una escala como título (`Pentatónica menor`).
String scaleTitle(Translations t, ScaleType scale) =>
    capitalized(scaleName(t, scale));

/// Escala con su tónica (`La pentatónica menor`, `A minor pentatonic`).
String scaleInKey(Translations t, ScaleType scale, int tonic) =>
    t.theory.scaleIn(note: noteLabel(t, tonic), scale: scaleName(t, scale));

/// Para qué sirve una escala.
String scaleAbout(Translations t, ScaleType scale) =>
    t.scalesPlus.about[scale.id] ?? t.theory.scaleAbout[scale.id] ?? '';

/// En qué estilos y contextos se usa una escala.
String scaleStyles(Translations t, ScaleType scale) =>
    t.scalesPlus.styles[scale.id] ?? '';

/// Nombre de un bloque del selector de escalas (`Mayor y modos`).
String scaleGroupName(Translations t, ScaleGroup group) =>
    t.scalesPlus.groups[group.name] ?? group.name;

/// Título de una sección del selector (`Modos de la menor armónica`).
String scaleSectionName(Translations t, String sectionId) =>
    t.scalesPlus.sections[sectionId] ?? sectionId;

/// Nombre de una tonalidad (`Sol mayor`, `Mi menor`).
String keyName(Translations t, int tonic, {bool minor = false}) =>
    t.theory.keyName(
      note: noteLabel(t, tonic),
      mode: minor ? t.theory.minorMode : t.theory.majorMode,
    );

/// Números romanos de los grados 1-7.
const List<String> kRomanNumerals = <String>[
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
];

/// Grado en romanos (`IV`).
String romanOf(int degree) => kRomanNumerals[(degree - 1) % 7];

/// Función de un grado (`subdominante`).
String degreeFunction(Translations t, int degree) =>
    t.theory.degreeNames['d$degree'] ?? '';

/// Opción de grado: `IV · subdominante`.
String degreeChoice(Translations t, int degree) =>
    '${romanOf(degree)} · ${degreeFunction(t, degree)}';

/// Nombre de un género de la guía.
String genreGuideName(Translations t, String id) =>
    t.theory.genreNames[id] ?? id;

/// Nombre propio de una progresión (`El eje del pop`).
String progressionName(Translations t, ChordProgression progression) =>
    t.theory.progressionNames[progression.id] ?? progression.summary;

/// Título de una lección.
String lessonTitle(Translations t, TheoryLesson lesson) =>
    t.theory.lessonTitles[lesson.id] ?? lesson.id;

/// Resumen de una lección.
String lessonSummary(Translations t, TheoryLesson lesson) =>
    t.theory.lessonSummaries[lesson.id] ?? '';

/// Párrafos de una lección.
List<String> lessonParagraphs(Translations t, TheoryLesson lesson) =>
    _split(t.theory.lessonBodies[lesson.id], '\n\n');

/// Ideas clave de una lección.
List<String> lessonPoints(Translations t, TheoryLesson lesson) =>
    _split(t.theory.lessonPoints[lesson.id], '\n');

List<String> _split(String? text, String separator) => <String>[
  for (final String part in (text ?? '').split(separator))
    if (part.trim().isNotEmpty) part.trim(),
];

/// Título de un bloque de lecciones.
String unitTitle(Translations t, LessonUnit unit) => switch (unit) {
  LessonUnit.basics => t.theory.unitBasics,
  LessonUnit.scales => t.theory.unitScales,
  LessonUnit.harmony => t.theory.unitHarmony,
};

/// Nombre de un patrón de rasgueo.
String strumName(Translations t, StrumPattern pattern) =>
    t.theory.strumNames[pattern.name] ?? pattern.name;

/// Flecha de un golpe de rasgueo.
String strokeGlyph(StrumStroke stroke) => switch (stroke) {
  StrumStroke.down => '↓',
  StrumStroke.up => '↑',
  StrumStroke.bass => '•',
  StrumStroke.rest => '·',
};

/// Nombre de una parte de canción.
String songPartName(Translations t, SongPart part) =>
    t.songs.parts[part.name] ?? part.name;

/// Título de una canción; los ejercicios propios se traducen.
String songTitle(Translations t, Song song) => song.author == kChordsAuthor
    ? (t.songs.exercises[song.id] ?? song.title)
    : song.title;

/// Autoría de una canción, o "Tradicional".
String songAuthor(Translations t, Song song) => switch (song.author) {
  null => t.songs.traditional,
  kChordsAuthor => t.songs.exercise,
  final String author => author,
};
