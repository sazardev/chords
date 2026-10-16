/// Progresiones típicas de cada género, listas para el modo jam.
library;

import 'package:chords/domain/theory/catalog/progressions_latin.dart';
import 'package:chords/domain/theory/catalog/progressions_pop.dart';
import 'package:chords/domain/theory/catalog/progressions_rock.dart';
import 'package:chords/domain/theory/catalog/progressions_roots.dart';
import 'package:chords/domain/theory/catalog/progressions_soul.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';

/// Todas las progresiones, agrupadas por familia de géneros.
const List<ChordProgression> kProgressions = <ChordProgression>[
  ...kRootsProgressions,
  ...kLatinProgressions,
  ...kRockProgressions,
  ...kSoulProgressions,
  ...kPopProgressions,
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
