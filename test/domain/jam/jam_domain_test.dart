import 'package:chords/domain/jam/jam_scorer.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/songs/catalog/song_catalog.dart';
import 'package:chords/domain/studio/practice_streak.dart';
import 'package:chords/domain/theory/catalog/progression_catalog.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pistas, marcador y racha de práctica.
void main() {
  group('JamTrack', () {
    test('una progresión se repite las vueltas pedidas en su tono', () {
      final JamTrack track = JamTrack.fromProgression(
        progressionById('popAxis')!,
        tonic: 0,
        title: 'pop',
        loops: 2,
      );
      expect(track.bars.length, 8);
      expect(
        track.bars.take(4).map((JamBar b) => b.chords.single.name),
        <String>['C', 'G', 'Am', 'F'],
      );
      expect(track.key, 'prog:popAxis');
    });

    test('un compás partido cambia de acorde a mitad', () {
      final JamTrack track = JamTrack.fromSong(songById('bamba')!);
      expect(track.chordAt(0, 0).name, 'C');
      expect(track.chordAt(0, 7).name, 'F');
      expect(track.chordAt(1, 0).name, 'G');
    });

    test('la letra cae en el primer compás de cada línea', () {
      final JamTrack track = JamTrack.fromSong(songById('cumpleanos')!);
      expect(track.bars.first.lyric, 'Cumpleaños feliz,');
      expect(track.bars[1].lyric, isEmpty);
      expect(track.strum.beatsPerBar, 3);
    });

    test('transportar una canción mueve todos sus acordes', () {
      final JamTrack track = JamTrack.fromSong(
        songById('amazingGrace')!,
        transpose: 2,
      );
      expect(track.bars.first.chords.single.name, 'A');
    });

    test('una progresión propia tiene un compás por acorde', () {
      final JamTrack track = JamTrack.custom(
        <ChordSymbol>[ChordSymbol.parse('Am'), ChordSymbol.parse('F')],
        title: 'mía',
        loops: 3,
      );
      expect(track.bars.length, 6);
      expect(track.withBpm(120).bpm, 120);
    });
  });

  group('JamScore', () {
    test('la racha sube el multiplicador hasta ×4 y un fallo lo reinicia', () {
      JamScore score = const JamScore();
      for (int i = 0; i < 4; i++) {
        score = score.record(BarGrade.perfect);
      }
      expect(score.points, 400);
      expect(score.multiplier, 2);
      score = score.record(BarGrade.perfect);
      expect(score.points, 600);
      for (int i = 0; i < 20; i++) {
        score = score.record(BarGrade.good);
      }
      expect(score.multiplier, 4);
      score = score.record(BarGrade.miss);
      expect(score.multiplier, 1);
      expect(score.streak, 0);
      expect(score.bestStreak, 25);
    });

    test('precisión y estrellas', () {
      JamScore score = const JamScore();
      expect(score.stars, 0);
      score = score
          .record(BarGrade.perfect)
          .record(BarGrade.perfect)
          .record(BarGrade.good)
          .record(BarGrade.silent);
      expect(score.accuracy, closeTo(0.625, 1e-9));
      expect(score.stars, 2);
    });

    test('califica un compás por las notas oídas', () {
      final ChordSymbol g = ChordSymbol.parse('G');
      expect(gradeBar(g, <int, int>{}), BarGrade.silent);
      expect(gradeBar(g, <int, int>{7: 5, 11: 3, 2: 2}), BarGrade.perfect);
      expect(gradeBar(g, <int, int>{7: 4, 1: 2}), BarGrade.good);
      expect(gradeBar(g, <int, int>{1: 4, 3: 4}), BarGrade.miss);
    });
  });

  group('racha de práctica', () {
    final DateTime today = DateTime(2026, 10, 13, 18);

    test('cuenta los días seguidos hasta hoy', () {
      expect(
        practiceStreak(<String>{
          '2026-10-13',
          '2026-10-12',
          '2026-10-11',
          '2026-10-09',
        }, today),
        3,
      );
    });

    test('si hoy aún no tocaste, la racha de ayer sigue viva', () {
      expect(practiceStreak(<String>{'2026-10-12', '2026-10-11'}, today), 2);
      expect(practiceStreak(<String>{'2026-10-10'}, today), 0);
    });

    test('cruza meses y descarta días muy antiguos', () {
      expect(
        practiceStreak(<String>{
          '2026-10-02',
          '2026-10-01',
          '2026-09-30',
        }, DateTime(2026, 10, 2)),
        3,
      );
      expect(recentDays(<String>{'2020-01-01', '2026-10-13'}, today), <String>{
        '2026-10-13',
      });
      expect(dayKey(DateTime(2026, 3, 7)), '2026-03-07');
    });
  });
}
