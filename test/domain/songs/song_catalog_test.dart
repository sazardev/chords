import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// El cancionero: canciones de dominio público y ejercicios por género.
void main() {
  final FakeChordRepository bank = loadChordBank();

  test('hay un cancionero amplio con identificadores únicos', () {
    expect(kSongs.length, greaterThanOrEqualTo(80));
    final Set<String> ids = <String>{};
    for (final Song s in kSongs) {
      expect(ids.add(s.id), isTrue, reason: 'id repetido ${s.id}');
      expect(songById(s.id), same(s));
      expect(s.title.trim(), isNotEmpty);
    }
  });

  test('cada canción tiene género, nivel, tempo y compases bien medidos', () {
    for (final Song s in kSongs) {
      expect(genreGuideById(s.genre), isNotNull, reason: s.id);
      expect(s.difficulty, inInclusiveRange(1, 3), reason: s.id);
      expect(s.bpm, inInclusiveRange(55, 190), reason: s.id);
      expect(<int>[6, 8], contains(s.strum.notation.length), reason: s.id);
      expect(s.sections, isNotEmpty, reason: s.id);
      for (final SongSection section in s.sections) {
        expect(section.lines, isNotEmpty, reason: s.id);
        for (final SongLine line in section.lines) {
          expect(line.bars, isNotEmpty, reason: s.id);
        }
      }
      for (final List<ChordSymbol> bar in s.bars()) {
        expect(bar.length, inInclusiveRange(1, 4), reason: s.id);
      }
    }
  });

  test('todos los acordes existen en el banco en cada transporte', () {
    for (final Song s in kSongs) {
      for (int t = -6; t <= 6; t++) {
        for (final ChordSymbol chord in s.chords(transpose: t)) {
          expect(
            bank.chordById(chord.chordId),
            isNotNull,
            reason: '${s.id} (${t >= 0 ? '+' : ''}$t): ${chord.chordId}',
          );
        }
      }
    }
  });

  test('los ejercicios son solo acordes y todos los géneros tienen uno', () {
    final Set<String> covered = <String>{};
    for (final Song s in kExerciseSongs) {
      expect(s.author, kChordsAuthor, reason: s.id);
      for (final SongSection section in s.sections) {
        for (final SongLine line in section.lines) {
          expect(line.lyric, isEmpty, reason: '${s.id} no lleva letra');
        }
      }
      covered.add(s.genre);
    }
    for (final GenreGuide g in kGenreGuides) {
      expect(covered, contains(g.id), reason: 'falta ejercicio de ${g.id}');
    }
  });

  test('las canciones tradicionales llevan letra y no son ejercicios', () {
    final List<Song> traditional = kSongs
        .where((Song s) => s.author != kChordsAuthor)
        .toList();
    expect(traditional.length, greaterThanOrEqualTo(50));
    for (final Song s in traditional) {
      final int lyrics = s.sections
          .expand((SongSection section) => section.lines)
          .where((SongLine line) => line.lyric.isNotEmpty)
          .length;
      expect(lyrics, greaterThanOrEqualTo(2), reason: s.id);
    }
  });

  test('hay variedad de géneros, idiomas y compases', () {
    expect(
      kSongs.map((Song s) => s.genre).toSet().length,
      greaterThanOrEqualTo(25),
    );
    expect(
      kSongs.where((Song s) => s.strum.beatsPerBar == 3).length,
      greaterThanOrEqualTo(15),
    );
    expect(kSpanishCatalog.length, greaterThanOrEqualTo(20));
    expect(kEnglishCatalog.length, greaterThanOrEqualTo(30));
  });

  for (final AppLocale locale in AppLocale.values) {
    test('${locale.languageCode}: cada ejercicio tiene título', () {
      final Translations t = locale.buildSync();
      for (final Song s in kExerciseSongs) {
        expect(t.songs.exercises[s.id], isNotEmpty, reason: s.id);
      }
    });
  }
}
