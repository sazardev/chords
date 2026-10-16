import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/band_test_tracks.dart';

/// La partitura de la banda: bajo y armonía.
void main() {
  const BandConfig plain = BandConfig(humanize: 0);

  group('bajo', () {
    test('toca la raíz y la quinta del acorde que suena', () {
      final BandArranger arranger = BandArranger(
        trackOf(<String>['Am', 'G', 'F', 'E7'], genre: 'cumbia'),
        plain,
      );
      for (int bar = 0; bar < 4; bar++) {
        final ChordSymbol chord = arranger.context.track.chordAt(bar, 0);
        final Set<int> allowed = <int>{chord.root, (chord.root + 7) % 12};
        final List<BandEvent> notes = channelOf(
          barOf(arranger, bar),
          BandChannel.bass,
        ).toList();
        expect(notes, isNotEmpty);
        for (final BandEvent note in notes) {
          expect(
            allowed,
            contains(note.sound.notes.single % 12),
            reason: '${chord.name} compás $bar',
          );
        }
      }
    });

    test('el primer golpe del compás es la raíz en el registro grave', () {
      final BandArranger arranger = BandArranger(
        trackOf(<String>['C', 'G'], genre: 'pop'),
        plain,
      );
      expect(
        channelOf(barOf(arranger, 0), BandChannel.bass).first.sound.notes,
        <int>[36],
      );
      expect(
        channelOf(barOf(arranger, 1), BandChannel.bass).first.sound.notes,
        <int>[31],
      );
    });

    test(
      'el bajo caminante da cuatro notas por compás y aproxima al siguiente',
      () {
        final BandArranger arranger = BandArranger(
          trackOf(<String>['Dm7', 'G7', 'Cmaj7', 'Cmaj7'], genre: 'jazz'),
          plain,
        );
        final List<BandEvent> bar = channelOf(
          barOf(arranger, 0),
          BandChannel.bass,
        ).toList();
        expect(bar.length, 4);
        final List<int> notes = bar
            .map((BandEvent e) => e.sound.notes.single)
            .toList();
        expect(notes.first % 12, 2, reason: 'empieza en la raíz (Re)');
        // Última nota: a un semitono de la raíz de Sol (7).
        final int gap = (notes.last % 12 - 7).abs();
        expect(gap == 1 || gap == 11, isTrue, reason: 'aproximación cromática');
        for (final int note in notes) {
          expect(note, inInclusiveRange(28, 54));
        }
        for (int i = 1; i < notes.length; i++) {
          expect((notes[i] - notes[i - 1]).abs(), lessThanOrEqualTo(9));
        }
      },
    );

    test('las notas del bajo están siempre en el registro del instrumento', () {
      for (final String genre in kBandPresets.keys) {
        for (final String root in <String>['C', 'E', 'F#', 'A#', 'B', 'D#']) {
          final BandArranger arranger = BandArranger(
            trackOf(<String>[
              root,
              '${root}m7',
              '${root}7',
              '${root}sus4',
            ], genre: genre),
            plain,
          );
          for (int bar = 0; bar < 4; bar++) {
            for (final BandEvent e in channelOf(
              barOf(arranger, bar),
              BandChannel.bass,
            )) {
              expect(
                e.sound.notes.single,
                inInclusiveRange(28, 57),
                reason: '$genre $root',
              );
            }
          }
        }
      }
    });
  });

  group('armonía', () {
    test('guitarra, teclado y vientos tocan notas del acorde', () {
      for (final String genre in kBandPresets.keys) {
        final BandArranger arranger = BandArranger(
          trackOf(<String>['G', 'Em7', 'Cmaj7', 'D7'], genre: genre),
          plain,
        );
        for (int bar = 0; bar < 4; bar++) {
          final ChordSymbol chord = arranger.context.track.chordAt(bar, 0);
          final Set<int> pcs = <int>{
            ...chord.pitchClasses,
            for (final int i in chord.quality.intervals) (chord.root + i) % 12,
          };
          for (final BandEvent e in barOf(arranger, bar)) {
            if (e.sound.family == SoundFamily.drum ||
                e.sound.family == SoundFamily.bass ||
                e.sound.family == SoundFamily.click) {
              continue;
            }
            for (final int note in e.sound.notes) {
              expect(pcs, contains(note % 12), reason: '$genre ${chord.name}');
            }
            expect(
              e.sound.notes.first,
              inInclusiveRange(40, 80),
              reason: '$genre ${e.sound.family}',
            );
            expect(e.sound.notes.last, lessThanOrEqualTo(92));
          }
        }
      }
    });

    test('el power chord del rock es raíz, quinta y octava', () {
      final BandArranger arranger = BandArranger(
        trackOf(
          <String>['E5', 'A5'],
          genre: 'rock',
          strum: StrumPattern.eighths,
        ),
        plain,
      );
      final BandEvent first = channelOf(
        arranger.eventsAt(0, 0),
        BandChannel.guitar,
      ).single;
      expect(first.sound.shape, GuitarStroke.power);
      expect(first.sound.notes, <int>[40, 47, 52]);
    });

    test('la guitarra sigue el rasgueo de la pista si no es el del género', () {
      final BandArranger arranger = BandArranger(
        trackOf(<String>['G', 'D'], genre: 'rock', strum: StrumPattern.skank),
        plain,
      );
      final List<int> steps = <int>[
        for (int s = 0; s < 16; s++)
          if (channelOf(arranger.eventsAt(0, s), BandChannel.guitar).isNotEmpty)
            s,
      ];
      expect(steps, <int>[4, 12], reason: 'solo los golpes de la pista');
    });
  });
}
