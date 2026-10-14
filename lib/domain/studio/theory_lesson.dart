import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:meta/meta.dart';

/// Bloque de la escuela de teoría al que pertenece una lección.
enum LessonUnit {
  /// Notas, intervalos, tónica y ritmo.
  basics,

  /// Escalas, pentatónicas, posiciones y modos.
  scales,

  /// Acordes de la tonalidad, funciones, progresiones y CAGED.
  harmony,
}

/// Una lección de teoría: texto (en las traducciones), demostración en el
/// mástil y un juego o un jam para practicarla.
@immutable
class TheoryLesson {
  /// Crea la lección.
  const TheoryLesson({
    required this.id,
    required this.unit,
    required this.emoji,
    this.scale,
    this.tonic = 0,
    this.showPositions = false,
    this.showHarmony = false,
    this.game,
    this.progressionId,
  });

  /// Identificador estable (traducciones y progreso).
  final String id;

  /// Bloque al que pertenece.
  final LessonUnit unit;

  /// Emoji que la representa.
  final String emoji;

  /// Escala que se dibuja en el mástil, si la lección la tiene.
  final ScaleType? scale;

  /// Tónica de la demostración (0 = Do).
  final int tonic;

  /// `true` si la demostración recorre las posiciones de la escala.
  final bool showPositions;

  /// `true` si muestra los acordes de la tonalidad.
  final bool showHarmony;

  /// Minijuego para practicar lo aprendido.
  final MiniGameKind? game;

  /// Progresión para practicar en el modo jam.
  final String? progressionId;
}

/// Las lecciones de la escuela, en orden de estudio.
const List<TheoryLesson> kTheoryLessons = <TheoryLesson>[
  TheoryLesson(
    id: 'notes',
    unit: LessonUnit.basics,
    emoji: '🎼',
    game: MiniGameKind.noteAtFret,
  ),
  TheoryLesson(
    id: 'intervals',
    unit: LessonUnit.basics,
    emoji: '📏',
    game: MiniGameKind.interval,
  ),
  TheoryLesson(
    id: 'tonic',
    unit: LessonUnit.basics,
    emoji: '🏠',
    scale: ScaleType.major,
    tonic: 7,
    game: MiniGameKind.findTonic,
  ),
  TheoryLesson(
    id: 'rhythm',
    unit: LessonUnit.basics,
    emoji: '🥁',
    progressionId: 'popAxis',
  ),
  TheoryLesson(
    id: 'majorScale',
    unit: LessonUnit.scales,
    emoji: '🎹',
    scale: ScaleType.major,
    game: MiniGameKind.scaleNote,
  ),
  TheoryLesson(
    id: 'minorScales',
    unit: LessonUnit.scales,
    emoji: '🌙',
    scale: ScaleType.naturalMinor,
    tonic: 9,
    progressionId: 'andalusian',
  ),
  TheoryLesson(
    id: 'pentatonic',
    unit: LessonUnit.scales,
    emoji: '⭐',
    scale: ScaleType.minorPentatonic,
    tonic: 9,
    progressionId: 'rockClassic',
  ),
  TheoryLesson(
    id: 'positions',
    unit: LessonUnit.scales,
    emoji: '🧩',
    scale: ScaleType.minorPentatonic,
    tonic: 9,
    showPositions: true,
    progressionId: 'bluesMinor',
  ),
  TheoryLesson(
    id: 'blues',
    unit: LessonUnit.scales,
    emoji: '🎷',
    scale: ScaleType.blues,
    tonic: 9,
    showPositions: true,
    progressionId: 'blues12',
  ),
  TheoryLesson(
    id: 'modes',
    unit: LessonUnit.scales,
    emoji: '🎨',
    scale: ScaleType.dorian,
    tonic: 2,
    progressionId: 'funkDorian',
  ),
  TheoryLesson(
    id: 'harmony',
    unit: LessonUnit.harmony,
    emoji: '🏛️',
    showHarmony: true,
    game: MiniGameKind.keyChord,
  ),
  TheoryLesson(
    id: 'degrees',
    unit: LessonUnit.harmony,
    emoji: '🧭',
    showHarmony: true,
    tonic: 7,
    game: MiniGameKind.scaleDegree,
  ),
  TheoryLesson(
    id: 'progressions',
    unit: LessonUnit.harmony,
    emoji: '🔁',
    game: MiniGameKind.progressionEar,
    progressionId: 'dooWop',
  ),
  TheoryLesson(
    id: 'caged',
    unit: LessonUnit.harmony,
    emoji: '🗺️',
    scale: ScaleType.majorPentatonic,
    showPositions: true,
    progressionId: 'countryRoad',
  ),
];

/// Lección por identificador; `null` si no existe.
TheoryLesson? lessonById(String? id) {
  for (final TheoryLesson lesson in kTheoryLessons) {
    if (lesson.id == id) {
      return lesson;
    }
  }
  return null;
}
