/// Guía de géneros: cómo suena cada estilo en la guitarra.
library;

import 'package:chords/domain/theory/catalog/genres_pop.dart';
import 'package:chords/domain/theory/catalog/genres_rock.dart';
import 'package:chords/domain/theory/catalog/genres_roots.dart';
import 'package:chords/domain/theory/catalog/genres_soul.dart';
import 'package:chords/domain/theory/entities/genre_guide.dart';

export 'package:chords/domain/theory/entities/genre_guide.dart';

/// Todos los géneros de la guía, agrupados por familia.
const List<GenreGuide> kGenreGuides = <GenreGuide>[
  ...kRootsGenres,
  ...kRockGenres,
  ...kSoulGenres,
  ...kPopGenres,
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

/// Géneros de una familia, en el orden de la guía.
List<GenreGuide> genreGuidesOf(GenreFamily family) => <GenreGuide>[
  for (final GenreGuide guide in kGenreGuides)
    if (guide.family == family) guide,
];
