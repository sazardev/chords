import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// La guía de géneros: 27 estilos completos y traducidos.
void main() {
  final FakeChordRepository bank = loadChordBank();

  const List<String> newGenres = <String>[
    'cumbia',
    'salsa',
    'ranchera',
    'flamenco',
    'disco',
    'ska',
    'indie',
    'grunge',
    'reggaeton',
    'lofi',
    'tango',
    'bolero',
  ];

  test('hay 27 géneros con identificadores únicos y los 12 nuevos', () {
    expect(kGenreGuides, hasLength(27));
    final Set<String> ids = <String>{
      for (final GenreGuide g in kGenreGuides) g.id,
    };
    expect(ids, hasLength(27));
    expect(ids, containsAll(newGenres));
  });

  test('cada género tiene familia, tempo realista, escalas y acordes', () {
    for (final GenreGuide g in kGenreGuides) {
      expect(g.emoji, isNotEmpty, reason: g.id);
      expect(g.minBpm, greaterThanOrEqualTo(50), reason: g.id);
      expect(g.maxBpm, lessThanOrEqualTo(220), reason: g.id);
      expect(g.minBpm, lessThan(g.maxBpm), reason: g.id);
      expect(g.scales, isNotEmpty, reason: g.id);
      expect(g.chords.length, greaterThanOrEqualTo(3), reason: g.id);
      for (final String name in g.chords) {
        final ChordSymbol? chord = ChordSymbol.tryParse(name);
        expect(chord, isNotNull, reason: '${g.id}: $name');
        expect(bank.chordById(chord!.chordId), isNotNull, reason: name);
      }
      final String? library = g.libraryGenre;
      if (library != null) {
        expect(kChordGenres, contains(library), reason: g.id);
      }
    }
  });

  test('las familias agrupan todos los géneros y ninguna queda vacía', () {
    int total = 0;
    for (final GenreFamily family in GenreFamily.values) {
      final List<GenreGuide> guides = genreGuidesOf(family);
      expect(guides, isNotEmpty, reason: family.name);
      total += guides.length;
    }
    expect(total, kGenreGuides.length);
  });

  test(
    'cada género tiene al menos 2 progresiones y una canción o ejercicio',
    () {
      for (final GenreGuide g in kGenreGuides) {
        expect(
          progressionsOf(g.id).length,
          greaterThanOrEqualTo(2),
          reason: g.id,
        );
        expect(
          kSongs.where((Song s) => s.genre == g.id),
          isNotEmpty,
          reason: g.id,
        );
      }
    },
  );

  test('el rasgueo de cada género encaja con su tempo y compás', () {
    for (final GenreGuide g in kGenreGuides) {
      final int slots = g.strum.notation.length;
      expect(<int>[6, 8], contains(slots), reason: g.id);
      for (final ChordProgression progression in progressionsOf(g.id)) {
        expect(progression.strum.notation.length, anyOf(6, 8));
      }
    }
  });

  for (final AppLocale locale in AppLocale.values) {
    test('${locale.languageCode}: textos completos de cada género', () {
      final Translations t = locale.buildSync();
      for (final GenreGuide g in kGenreGuides) {
        expect(t.theory.genreNames[g.id], isNotEmpty, reason: g.id);
        expect(
          t.theory.genreAbout[g.id]!.length,
          greaterThan(40),
          reason: g.id,
        );
        expect(
          t.theory.genreRhythm[g.id]!.length,
          greaterThan(20),
          reason: g.id,
        );
        expect(t.theory.genreTip[g.id]!.length, greaterThan(20), reason: g.id);
      }
      for (final GenreFamily family in GenreFamily.values) {
        expect(t.theory.genreFamilies[family.name], isNotEmpty);
      }
    });
  }

  test('los textos nuevos están realmente traducidos (es ≠ en)', () {
    final Translations es = AppLocale.es.buildSync();
    final Translations en = AppLocale.en.buildSync();
    for (final String id in newGenres) {
      expect(es.theory.genreAbout[id], isNot(en.theory.genreAbout[id]));
      expect(es.theory.genreTip[id], isNot(en.theory.genreTip[id]));
    }
  });
}
