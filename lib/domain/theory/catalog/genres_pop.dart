/// Géneros de pop, balada y baile de la guía.
library;

import 'package:chords/domain/theory/entities/genre_guide.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Pop, balada, disco, reggaetón y lo-fi.
const List<GenreGuide> kPopGenres = <GenreGuide>[
  GenreGuide(
    id: 'pop',
    family: GenreFamily.pop,
    emoji: '🎤',
    minBpm: 80,
    maxBpm: 120,
    strum: StrumPattern.pop,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.major],
    chords: <String>['G', 'D', 'Em', 'C'],
    libraryGenre: 'Pop',
  ),
  GenreGuide(
    id: 'ballad',
    family: GenreFamily.pop,
    emoji: '💗',
    minBpm: 60,
    maxBpm: 85,
    strum: StrumPattern.whole,
    scales: <ScaleType>[ScaleType.major, ScaleType.majorPentatonic],
    chords: <String>['C', 'Am', 'F', 'G'],
    libraryGenre: 'Balada',
  ),
  GenreGuide(
    id: 'disco',
    family: GenreFamily.pop,
    emoji: '🪩',
    minBpm: 110,
    maxBpm: 130,
    strum: StrumPattern.disco,
    scales: <ScaleType>[ScaleType.minorPentatonic, ScaleType.dorian],
    chords: <String>['Am7', 'Dm7', 'G7', 'Cmaj7'],
    libraryGenre: 'Funk',
  ),
  GenreGuide(
    id: 'reggaeton',
    family: GenreFamily.pop,
    emoji: '🔊',
    minBpm: 85,
    maxBpm: 100,
    strum: StrumPattern.reggaeton,
    scales: <ScaleType>[ScaleType.minorPentatonic, ScaleType.naturalMinor],
    chords: <String>['Am', 'F', 'C', 'G'],
    libraryGenre: 'Latino',
  ),
  GenreGuide(
    id: 'lofi',
    family: GenreFamily.pop,
    emoji: '☕',
    minBpm: 60,
    maxBpm: 90,
    strum: StrumPattern.lofi,
    scales: <ScaleType>[ScaleType.majorPentatonic, ScaleType.dorian],
    chords: <String>['Cmaj7', 'Em7', 'Fmaj7', 'Dm7'],
    libraryGenre: 'Ambient',
  ),
];
