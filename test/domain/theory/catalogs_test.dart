import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/songs/entities/song.dart';
import 'package:chords/domain/studio/theory_lesson.dart';
import 'package:chords/domain/theory/catalog/genre_catalog.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_progression.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// Los catálogos del estudio son coherentes con el banco y las traducciones.
void main() {
  final FakeChordRepository bank = loadChordBank();

  void expectInBank(ChordSymbol chord, String where) {
    final Chord? found = bank.chordById(chord.chordId);
    expect(found, isNotNull, reason: '$where: ${chord.chordId}');
  }

  test('cada progresión, en cualquier tono, usa acordes del banco', () {
    for (final ChordProgression p in kProgressions) {
      expect(genreGuideById(p.genre), isNotNull, reason: p.id);
      for (int tonic = 0; tonic < 12; tonic++) {
        for (final List<ChordSymbol> bar in p.barsIn(tonic)) {
          for (final ChordSymbol c in bar) {
            expectInBank(c, p.id);
          }
        }
      }
    }
  });

  test(
    'cada canción usa cifras válidas y acordes del banco al transportar',
    () {
      final Set<String> ids = <String>{};
      for (final Song song in kSongs) {
        expect(ids.add(song.id), isTrue, reason: 'id repetido ${song.id}');
        expect(genreGuideById(song.genre), isNotNull, reason: song.id);
        expect(song.difficulty, inInclusiveRange(1, 3));
        for (int t = -6; t <= 6; t++) {
          song
              .chords(transpose: t)
              .forEach((ChordSymbol c) => expectInBank(c, song.id));
        }
      }
    },
  );

  test('los acordes de cada género existen', () {
    for (final GenreGuide guide in kGenreGuides) {
      for (final String name in guide.chords) {
        expectInBank(ChordSymbol.parse(name), guide.id);
      }
      expect(guide.minBpm, lessThan(guide.maxBpm));
    }
  });

  test('las lecciones apuntan a juegos y progresiones que existen', () {
    final Set<String> ids = <String>{};
    for (final TheoryLesson lesson in kTheoryLessons) {
      expect(ids.add(lesson.id), isTrue);
      final String? progression = lesson.progressionId;
      if (progression != null) {
        expect(progressionById(progression), isNotNull, reason: lesson.id);
      }
    }
  });

  for (final AppLocale locale in AppLocale.values) {
    final Translations t = locale.buildSync();
    final String lang = locale.languageCode;

    test('$lang: cada lección tiene título, resumen, texto e ideas', () {
      for (final TheoryLesson lesson in kTheoryLessons) {
        expect(t.theory.lessonTitles[lesson.id], isNotEmpty);
        expect(t.theory.lessonSummaries[lesson.id], isNotEmpty);
        expect(
          t.theory.lessonBodies[lesson.id]!.split('\n\n').length,
          greaterThanOrEqualTo(2),
          reason: lesson.id,
        );
        expect(
          t.theory.lessonPoints[lesson.id]!.split('\n').length,
          greaterThanOrEqualTo(3),
          reason: lesson.id,
        );
      }
    });

    test('$lang: géneros, escalas, rasgueos y progresiones con nombre', () {
      for (final GenreGuide g in kGenreGuides) {
        expect(t.theory.genreNames[g.id], isNotEmpty, reason: g.id);
        expect(t.theory.genreAbout[g.id], isNotEmpty, reason: g.id);
        expect(t.theory.genreRhythm[g.id], isNotEmpty, reason: g.id);
        expect(t.theory.genreTip[g.id], isNotEmpty, reason: g.id);
      }
      for (final ScaleType s in ScaleType.values) {
        expect(t.theory.scaleNames[s.id], isNotEmpty, reason: s.id);
        expect(t.theory.scaleAbout[s.id], isNotEmpty, reason: s.id);
      }
      for (final StrumPattern p in StrumPattern.values) {
        expect(t.theory.strumNames[p.name], isNotEmpty, reason: p.name);
      }
      for (final ChordProgression p in kProgressions) {
        expect(t.theory.progressionNames[p.id], isNotEmpty, reason: p.id);
      }
      for (int d = 1; d <= 7; d++) {
        expect(t.theory.degreeNames['d$d'], isNotEmpty);
      }
    });

    test('$lang: ejercicios y partes de canción traducidos', () {
      for (final Song song in kExerciseSongs) {
        expect(t.songs.exercises[song.id], isNotEmpty, reason: song.id);
      }
      for (final SongPart part in SongPart.values) {
        expect(t.songs.parts[part.name], isNotEmpty);
      }
      for (final MiniGameKind kind in MiniGameKind.of(
        MiniGameCategory.theory,
      )) {
        expect(t.minigames.titles[kind.id], isNotEmpty);
      }
    });
  }
}
