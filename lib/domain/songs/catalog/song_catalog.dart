/// Cancionero completo: canciones tradicionales y ejercicios de Chords.
library;

import 'package:chords/domain/songs/catalog/songs_blues_en.dart';
import 'package:chords/domain/songs/catalog/songs_children_es.dart';
import 'package:chords/domain/songs/catalog/songs_country_en.dart';
import 'package:chords/domain/songs/catalog/songs_english.dart';
import 'package:chords/domain/songs/catalog/songs_exercises_classic.dart';
import 'package:chords/domain/songs/catalog/songs_exercises_core.dart';
import 'package:chords/domain/songs/catalog/songs_exercises_latin.dart';
import 'package:chords/domain/songs/catalog/songs_exercises_modern.dart';
import 'package:chords/domain/songs/catalog/songs_folk_en.dart';
import 'package:chords/domain/songs/catalog/songs_gospel_en.dart';
import 'package:chords/domain/songs/catalog/songs_ranchera.dart';
import 'package:chords/domain/songs/catalog/songs_spanish.dart';
import 'package:chords/domain/songs/entities/song.dart';

export 'package:chords/domain/songs/catalog/song_authors.dart';

/// Temas instrumentales (solo acordes) para practicar cada género.
const List<Song> kExerciseSongs = <Song>[
  ...kCoreExercises,
  ...kClassicExercises,
  ...kLatinExercises,
  ...kModernExercises,
];

/// Canciones tradicionales en español: clásicos, rancheras e infantiles.
const List<Song> kSpanishCatalog = <Song>[
  ...kSpanishSongs,
  ...kRancheraSongs,
  ...kChildrenSongsEs,
];

/// Canciones tradicionales en inglés: folk, country, blues y gospel.
const List<Song> kEnglishCatalog = <Song>[
  ...kEnglishSongs,
  ...kFolkSongsEn,
  ...kCountrySongsEn,
  ...kBluesSongsEn,
  ...kGospelSongsEn,
];

/// Todas las canciones: ejercicios, en español y en inglés.
const List<Song> kSongs = <Song>[
  ...kExerciseSongs,
  ...kSpanishCatalog,
  ...kEnglishCatalog,
];

/// Canción por identificador; `null` si no existe.
Song? songById(String? id) {
  for (final Song song in kSongs) {
    if (song.id == id) {
      return song;
    }
  }
  return null;
}
