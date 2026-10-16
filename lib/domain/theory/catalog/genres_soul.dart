/// Géneros de blues, jazz, soul, funk y gospel de la guía.
library;

import 'package:chords/domain/theory/entities/genre_guide.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Blues, jazz, soul, funk y gospel.
const List<GenreGuide> kSoulGenres = <GenreGuide>[
  GenreGuide(
    id: 'blues',
    family: GenreFamily.soulJazz,
    emoji: '🎷',
    minBpm: 60,
    maxBpm: 110,
    strum: StrumPattern.shuffle,
    scales: <ScaleType>[ScaleType.blues, ScaleType.minorPentatonic],
    chords: <String>['A7', 'D7', 'E7'],
    libraryGenre: 'Blues',
  ),
  GenreGuide(
    id: 'jazz',
    family: GenreFamily.soulJazz,
    emoji: '🎹',
    minBpm: 80,
    maxBpm: 200,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.major, ScaleType.dorian],
    chords: <String>['Dm7', 'G7', 'Cmaj7', 'A7'],
    libraryGenre: 'Jazz',
  ),
  GenreGuide(
    id: 'soul',
    family: GenreFamily.soulJazz,
    emoji: '✨',
    minBpm: 65,
    maxBpm: 100,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.dorian],
    chords: <String>['Fmaj7', 'Em7', 'Dm7', 'Cmaj7'],
    libraryGenre: 'Soul',
  ),
  GenreGuide(
    id: 'funk',
    family: GenreFamily.soulJazz,
    emoji: '🕺',
    minBpm: 90,
    maxBpm: 115,
    strum: StrumPattern.funkMuted,
    scales: <ScaleType>[ScaleType.dorian, ScaleType.minorPentatonic],
    chords: <String>['E9', 'Em7', 'A9'],
    libraryGenre: 'Funk',
  ),
  GenreGuide(
    id: 'gospel',
    family: GenreFamily.soulJazz,
    emoji: '🙌',
    minBpm: 60,
    maxBpm: 120,
    strum: StrumPattern.quarters,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.blues],
    chords: <String>['C', 'C7', 'F', 'Fm'],
    libraryGenre: 'Gospel',
  ),
];
