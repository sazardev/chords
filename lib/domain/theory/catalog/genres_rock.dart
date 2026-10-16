/// Géneros de la familia del rock de la guía.
library;

import 'package:chords/domain/theory/entities/genre_guide.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Rock, grunge, indie, punk, ska y metal.
const List<GenreGuide> kRockGenres = <GenreGuide>[
  GenreGuide(
    id: 'rock',
    family: GenreFamily.rock,
    emoji: '🎸',
    minBpm: 100,
    maxBpm: 150,
    strum: StrumPattern.eighths,
    scales: <ScaleType>[ScaleType.minorPentatonic, ScaleType.mixolydian],
    chords: <String>['A5', 'D5', 'E5', 'G'],
    libraryGenre: 'Rock',
  ),
  GenreGuide(
    id: 'grunge',
    family: GenreFamily.rock,
    emoji: '🧥',
    minBpm: 90,
    maxBpm: 130,
    strum: StrumPattern.downstrokes,
    scales: <ScaleType>[ScaleType.minorPentatonic, ScaleType.blues],
    chords: <String>['E5', 'C5', 'G5', 'D5'],
    libraryGenre: 'Rock',
  ),
  GenreGuide(
    id: 'indie',
    family: GenreFamily.rock,
    emoji: '🌫️',
    minBpm: 100,
    maxBpm: 150,
    strum: StrumPattern.campfire,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.major],
    chords: <String>['Dsus2', 'A', 'Bm', 'G'],
    libraryGenre: 'Rock',
  ),
  GenreGuide(
    id: 'punk',
    family: GenreFamily.rock,
    emoji: '⚡',
    minBpm: 150,
    maxBpm: 200,
    strum: StrumPattern.downstrokes,
    scales: <ScaleType>[ScaleType.minorPentatonic],
    chords: <String>['E5', 'A5', 'B5', 'D5'],
    libraryGenre: 'Punk',
  ),
  GenreGuide(
    id: 'ska',
    family: GenreFamily.rock,
    emoji: '🏁',
    minBpm: 120,
    maxBpm: 180,
    strum: StrumPattern.ska,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.major],
    chords: <String>['G', 'C', 'D', 'Em'],
    libraryGenre: 'Punk',
  ),
  GenreGuide(
    id: 'metal',
    family: GenreFamily.rock,
    emoji: '🤘',
    minBpm: 120,
    maxBpm: 200,
    strum: StrumPattern.gallop,
    scales: <ScaleType>[ScaleType.naturalMinor, ScaleType.phrygian],
    chords: <String>['E5', 'C5', 'D5', 'F5'],
    libraryGenre: 'Metal',
  ),
];
