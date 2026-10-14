/// Guía de géneros: cómo suena cada estilo en la guitarra.
library;

import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:meta/meta.dart';

/// Lo esencial de un género para tocarlo: tempo, ritmo, escalas y acordes.
///
/// Los textos (qué lo caracteriza, cómo se rasguea, un consejo) viven en las
/// traducciones bajo `theory.genres.<id>`.
@immutable
class GenreGuide {
  /// Crea la guía.
  const GenreGuide({
    required this.id,
    required this.emoji,
    required this.minBpm,
    required this.maxBpm,
    required this.strum,
    required this.scales,
    required this.chords,
    this.libraryGenre,
  });

  /// Identificador estable (`country`).
  final String id;

  /// Emoji que lo representa.
  final String emoji;

  /// Tempo habitual mínimo.
  final int minBpm;

  /// Tempo habitual máximo.
  final int maxBpm;

  /// Rasgueo característico.
  final StrumPattern strum;

  /// Escalas para improvisar o hacer riffs.
  final List<ScaleType> scales;

  /// Acordes que lo definen, como cifras de ejemplo (`E7`, `A9`).
  final List<String> chords;

  /// Género equivalente en la biblioteca de acordes (`Country`), si lo hay.
  final String? libraryGenre;
}

/// Todos los géneros de la guía.
const List<GenreGuide> kGenreGuides = <GenreGuide>[
  GenreGuide(
    id: 'pop',
    emoji: '🎤',
    minBpm: 80,
    maxBpm: 120,
    strum: StrumPattern.pop,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.major],
    chords: <String>['G', 'D', 'Em', 'C'],
    libraryGenre: 'Pop',
  ),
  GenreGuide(
    id: 'rock',
    emoji: '🎸',
    minBpm: 100,
    maxBpm: 150,
    strum: StrumPattern.eighths,
    scales: <ScaleType>[ScaleType.minorPentatonic, ScaleType.mixolydian],
    chords: <String>['A5', 'D5', 'E5', 'G'],
    libraryGenre: 'Rock',
  ),
  GenreGuide(
    id: 'blues',
    emoji: '🎷',
    minBpm: 60,
    maxBpm: 110,
    strum: StrumPattern.shuffle,
    scales: <ScaleType>[ScaleType.blues, ScaleType.minorPentatonic],
    chords: <String>['A7', 'D7', 'E7'],
    libraryGenre: 'Blues',
  ),
  GenreGuide(
    id: 'country',
    emoji: '🤠',
    minBpm: 90,
    maxBpm: 140,
    strum: StrumPattern.boomChick,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.mixolydian],
    chords: <String>['G', 'C', 'D7', 'A7'],
    libraryGenre: 'Country',
  ),
  GenreGuide(
    id: 'jazz',
    emoji: '🎹',
    minBpm: 80,
    maxBpm: 200,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.major, ScaleType.dorian],
    chords: <String>['Dm7', 'G7', 'Cmaj7', 'A7'],
    libraryGenre: 'Jazz',
  ),
  GenreGuide(
    id: 'funk',
    emoji: '🕺',
    minBpm: 90,
    maxBpm: 115,
    strum: StrumPattern.eighths,
    scales: <ScaleType>[ScaleType.dorian, ScaleType.minorPentatonic],
    chords: <String>['E9', 'Em7', 'A9'],
    libraryGenre: 'Funk',
  ),
  GenreGuide(
    id: 'ballad',
    emoji: '💗',
    minBpm: 60,
    maxBpm: 85,
    strum: StrumPattern.whole,
    scales: <ScaleType>[ScaleType.major, ScaleType.majorPentatonic],
    chords: <String>['C', 'Am', 'F', 'G'],
    libraryGenre: 'Balada',
  ),
  GenreGuide(
    id: 'latin',
    emoji: '💃',
    minBpm: 90,
    maxBpm: 140,
    strum: StrumPattern.waltz,
    scales: <ScaleType>[ScaleType.harmonicMinor, ScaleType.phrygian],
    chords: <String>['Am', 'G', 'F', 'E7'],
    libraryGenre: 'Latino',
  ),
  GenreGuide(
    id: 'reggae',
    emoji: '🌴',
    minBpm: 60,
    maxBpm: 90,
    strum: StrumPattern.skank,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.minorPentatonic],
    chords: <String>['C', 'F', 'G', 'Am'],
  ),
  GenreGuide(
    id: 'bossa',
    emoji: '🌊',
    minBpm: 110,
    maxBpm: 140,
    strum: StrumPattern.bossa,
    scales: <ScaleType>[ScaleType.major, ScaleType.lydian],
    chords: <String>['Cmaj7', 'A7', 'Dm7', 'G7'],
    libraryGenre: 'Bossa',
  ),
  GenreGuide(
    id: 'metal',
    emoji: '🤘',
    minBpm: 120,
    maxBpm: 200,
    strum: StrumPattern.eighths,
    scales: <ScaleType>[ScaleType.naturalMinor, ScaleType.phrygian],
    chords: <String>['E5', 'C5', 'D5', 'F5'],
    libraryGenre: 'Metal',
  ),
  GenreGuide(
    id: 'punk',
    emoji: '⚡',
    minBpm: 150,
    maxBpm: 200,
    strum: StrumPattern.eighths,
    scales: <ScaleType>[ScaleType.minorPentatonic],
    chords: <String>['E5', 'A5', 'B5', 'D5'],
    libraryGenre: 'Punk',
  ),
  GenreGuide(
    id: 'soul',
    emoji: '✨',
    minBpm: 65,
    maxBpm: 100,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.dorian],
    chords: <String>['Fmaj7', 'Em7', 'Dm7', 'Cmaj7'],
    libraryGenre: 'Soul',
  ),
  GenreGuide(
    id: 'gospel',
    emoji: '🙌',
    minBpm: 60,
    maxBpm: 120,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.blues],
    chords: <String>['C', 'C7', 'F', 'Fm'],
    libraryGenre: 'Gospel',
  ),
  GenreGuide(
    id: 'folk',
    emoji: '🪕',
    minBpm: 70,
    maxBpm: 120,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.major, ScaleType.majorPentatonic],
    chords: <String>['G', 'C', 'D', 'Em'],
    libraryGenre: 'Infantil',
  ),
];

/// Guía de un género por identificador; `null` si no existe.
GenreGuide? genreGuideById(String? id) {
  for (final GenreGuide guide in kGenreGuides) {
    if (guide.id == id) {
      return guide;
    }
  }
  return null;
}
