/// Progresiones típicas de cada género, listas para el modo jam.
library;

import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Tonos de referencia (clase de tono) para que el catálogo se lea mejor.
const int _c = 0;
const int _d = 2;
const int _e = 4;
const int _g = 7;
const int _a = 9;

/// Todas las progresiones, agrupadas por género.
const List<ChordProgression> kProgressions = <ChordProgression>[
  ChordProgression(
    id: 'popAxis',
    genre: 'pop',
    bars: <String>['I', 'V', 'vi', 'IV'],
    tonic: _g,
    bpm: 92,
    strum: StrumPattern.pop,
    scale: ScaleType.majorPentatonic,
  ),
  ChordProgression(
    id: 'dooWop',
    genre: 'pop',
    bars: <String>['I', 'vi', 'IV', 'V'],
    tonic: _c,
    bpm: 84,
    strum: StrumPattern.quarters,
    scale: ScaleType.major,
  ),
  ChordProgression(
    id: 'rockClassic',
    genre: 'rock',
    bars: <String>['I', 'IV', 'V', 'IV'],
    tonic: _a,
    bpm: 112,
    strum: StrumPattern.eighths,
    scale: ScaleType.minorPentatonic,
  ),
  ChordProgression(
    id: 'rockMixo',
    genre: 'rock',
    bars: <String>['I', 'bVII', 'IV', 'I'],
    tonic: _d,
    bpm: 104,
    strum: StrumPattern.eighths,
    scale: ScaleType.mixolydian,
  ),
  ChordProgression(
    id: 'blues12',
    genre: 'blues',
    bars: <String>[
      'I7',
      'I7',
      'I7',
      'I7',
      'IV7',
      'IV7',
      'I7',
      'I7',
      'V7',
      'IV7',
      'I7',
      'V7',
    ],
    tonic: _a,
    bpm: 88,
    strum: StrumPattern.shuffle,
    scale: ScaleType.blues,
  ),
  ChordProgression(
    id: 'bluesMinor',
    genre: 'blues',
    bars: <String>[
      'i7',
      'i7',
      'i7',
      'i7',
      'iv7',
      'iv7',
      'i7',
      'i7',
      'bVI7',
      'V7',
      'i7',
      'V7',
    ],
    tonic: _e,
    minor: true,
    bpm: 72,
    strum: StrumPattern.shuffle,
    scale: ScaleType.minorPentatonic,
  ),
  ChordProgression(
    id: 'countryRoad',
    genre: 'country',
    bars: <String>['I', 'I', 'IV', 'I', 'I', 'I', 'V', 'V'],
    tonic: _g,
    bpm: 108,
    strum: StrumPattern.boomChick,
    scale: ScaleType.majorPentatonic,
  ),
  ChordProgression(
    id: 'countryTwoStep',
    genre: 'country',
    bars: <String>['I', 'IV', 'I', 'V7', 'I', 'IV', 'V7', 'I'],
    tonic: _d,
    bpm: 120,
    strum: StrumPattern.boomChick,
    scale: ScaleType.mixolydian,
  ),
  ChordProgression(
    id: 'jazz251',
    genre: 'jazz',
    bars: <String>['ii7', 'V7', 'Imaj7', 'Imaj7'],
    tonic: _c,
    bpm: 96,
    strum: StrumPattern.quarters,
    scale: ScaleType.major,
  ),
  ChordProgression(
    id: 'jazzTurnaround',
    genre: 'jazz',
    bars: <String>['Imaj7', 'vi7', 'ii7', 'V7'],
    tonic: _g,
    bpm: 100,
    strum: StrumPattern.quarters,
    scale: ScaleType.major,
  ),
  ChordProgression(
    id: 'funkDorian',
    genre: 'funk',
    bars: <String>['i7', 'i7', 'IV9', 'IV9'],
    tonic: _e,
    minor: true,
    bpm: 100,
    strum: StrumPattern.eighths,
    scale: ScaleType.dorian,
  ),
  ChordProgression(
    id: 'balladSad',
    genre: 'ballad',
    bars: <String>['vi', 'IV', 'I', 'V'],
    tonic: _c,
    bpm: 72,
    strum: StrumPattern.whole,
    scale: ScaleType.majorPentatonic,
  ),
  ChordProgression(
    id: 'canon',
    genre: 'ballad',
    bars: <String>['I', 'V', 'vi', 'iii', 'IV', 'I', 'IV', 'V'],
    tonic: _d,
    bpm: 76,
    strum: StrumPattern.quarters,
    scale: ScaleType.major,
  ),
  ChordProgression(
    id: 'andalusian',
    genre: 'latin',
    bars: <String>['i', 'bVII', 'bVI', 'V'],
    tonic: _a,
    minor: true,
    bpm: 96,
    strum: StrumPattern.quarters,
    scale: ScaleType.harmonicMinor,
  ),
  ChordProgression(
    id: 'ranchera',
    genre: 'latin',
    bars: <String>['I', 'I', 'V7', 'V7', 'V7', 'V7', 'I', 'I'],
    tonic: _c,
    bpm: 132,
    strum: StrumPattern.waltz,
    scale: ScaleType.major,
  ),
  ChordProgression(
    id: 'reggaeSkank',
    genre: 'reggae',
    bars: <String>['I', 'IV', 'V', 'IV'],
    tonic: _c,
    bpm: 76,
    strum: StrumPattern.skank,
    scale: ScaleType.majorPentatonic,
  ),
  ChordProgression(
    id: 'bossaCycle',
    genre: 'bossa',
    bars: <String>['Imaj7', 'VI7', 'ii7', 'V7'],
    tonic: _c,
    bpm: 120,
    strum: StrumPattern.bossa,
    scale: ScaleType.major,
  ),
  ChordProgression(
    id: 'metalMinor',
    genre: 'metal',
    bars: <String>['i5', 'bVI5', 'bVII5', 'i5'],
    tonic: _e,
    minor: true,
    bpm: 140,
    strum: StrumPattern.eighths,
    scale: ScaleType.naturalMinor,
  ),
  ChordProgression(
    id: 'metalPhrygian',
    genre: 'metal',
    bars: <String>['i5', 'bII5', 'i5', 'bVII5'],
    tonic: _e,
    minor: true,
    bpm: 150,
    strum: StrumPattern.eighths,
    scale: ScaleType.phrygian,
  ),
  ChordProgression(
    id: 'punkPower',
    genre: 'punk',
    bars: <String>['I5', 'IV5', 'V5', 'IV5'],
    tonic: _e,
    bpm: 168,
    strum: StrumPattern.eighths,
    scale: ScaleType.minorPentatonic,
  ),
  ChordProgression(
    id: 'soulGroove',
    genre: 'soul',
    bars: <String>['IVmaj7', 'iii7', 'ii7', 'Imaj7'],
    tonic: _c,
    bpm: 80,
    strum: StrumPattern.quarters,
    scale: ScaleType.majorPentatonic,
  ),
  ChordProgression(
    id: 'gospelPlagal',
    genre: 'gospel',
    bars: <String>['I', 'I7', 'IV', 'iv', 'I', 'V7', 'I', 'V7'],
    tonic: _c,
    bpm: 76,
    strum: StrumPattern.quarters,
    scale: ScaleType.majorPentatonic,
  ),
  ChordProgression(
    id: 'folkThree',
    genre: 'folk',
    bars: <String>['I', 'IV', 'V', 'I'],
    tonic: _g,
    bpm: 90,
    strum: StrumPattern.quarters,
    scale: ScaleType.major,
  ),
];

/// Progresión por identificador; `null` si no existe.
ChordProgression? progressionById(String? id) {
  for (final ChordProgression progression in kProgressions) {
    if (progression.id == id) {
      return progression;
    }
  }
  return null;
}

/// Progresiones de un género, en el orden del catálogo.
List<ChordProgression> progressionsOf(String genre) => <ChordProgression>[
  for (final ChordProgression progression in kProgressions)
    if (progression.genre == genre) progression,
];
