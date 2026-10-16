import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/band_test_tracks.dart';

/// La partitura de la banda: batería, géneros y detalles.
void main() {
  const BandConfig plain = BandConfig(humanize: 0);

  group('batería', () {
    test('un relleno cierra cada frase y se puede apagar', () {
      final JamTrack track = trackOf(
        <String>['A', 'D', 'E', 'D'],
        genre: 'rock',
        loops: 2,
      );
      final BandArranger fills = BandArranger(track, plain);
      final BandArranger none = BandArranger(
        track,
        plain.copyWith(fills: false),
      );
      List<String> toms(BandArranger a, int bar) =>
          channelOf(barOf(a, bar), BandChannel.drums)
              .where(
                (BandEvent e) =>
                    e.sound.shape == DrumVoice.tomLow ||
                    e.sound.shape == DrumVoice.tomMid,
              )
              .map((BandEvent e) => e.sound.key)
              .toList();
      expect(toms(fills, 3), isNotEmpty, reason: 'relleno al cerrar la frase');
      expect(toms(fills, 0), isEmpty);
      expect(toms(none, 3), isEmpty);
      expect(toms(fills, 7), isNotEmpty);
    });

    test('el relleno llega cada 4 compases y cada 8 en géneros lentos', () {
      final JamTrack long = trackOf(<String>[
        'C',
        'F',
        'G',
        'C',
        'C',
        'F',
        'G',
        'C',
      ], genre: 'bossa');
      final BandArranger arranger = BandArranger(long, plain);
      expect(arranger.context.isFillBar(3), isFalse, reason: 'bossa: cada 8');
      expect(arranger.context.isFillBar(7), isTrue);
      final BandArranger rock = BandArranger(
        trackOf(<String>['C', 'F', 'G', 'C'], genre: 'rock'),
        plain,
      );
      expect(rock.context.isFillBar(3), isTrue);
      expect(rock.context.isFillBar(2), isFalse);
    });

    test('el plato marca el principio de cada vuelta', () {
      final JamTrack track = trackOf(
        <String>['A', 'D'],
        genre: 'rock',
        loops: 3,
      );
      final BandArranger arranger = BandArranger(track, plain);
      bool crash(int bar) => channelOf(
        arranger.eventsAt(bar, 0),
        BandChannel.drums,
      ).any((BandEvent e) => e.sound.shape == DrumVoice.crash);
      expect(crash(0), isTrue);
      expect(crash(1), isFalse);
      expect(crash(2), isTrue, reason: 'segunda vuelta');
      expect(crash(4), isTrue);
      final BandArranger jazz = BandArranger(
        trackOf(<String>['Dm7', 'G7'], genre: 'jazz', loops: 2),
        plain,
      );
      expect(
        channelOf(
          jazz.eventsAt(2, 0),
          BandChannel.drums,
        ).any((BandEvent e) => e.sound.shape == DrumVoice.rideBell),
        isTrue,
        reason: 'el jazz marca con la campana, no con el crash',
      );
    });

    test('la intensidad cambia la fuerza y el uso de la variante B', () {
      double loudest(BandIntensity level) {
        final BandArranger a = BandArranger(
          trackOf(<String>['A', 'D', 'E', 'D'], genre: 'pop'),
          plain.copyWith(intensity: level),
        );
        return barOf(a, 1)
            .where((BandEvent e) => e.channel != BandChannel.click)
            .fold<double>(
              0,
              (double m, BandEvent e) => e.velocity > m ? e.velocity : m,
            );
      }

      expect(
        loudest(BandIntensity.soft),
        lessThan(loudest(BandIntensity.normal)),
      );
      expect(
        loudest(BandIntensity.normal),
        lessThan(loudest(BandIntensity.strong)),
      );
      final ArrangerLift soft = ArrangerLift(BandIntensity.soft);
      expect(
        soft.lifts(trackOf(<String>['A', 'D', 'E', 'D'], genre: 'pop'), 3),
        isFalse,
      );
    });

    test('un compás de 3/4 usa rejilla de 12 pasos', () {
      final JamTrack waltz = trackOf(
        <String>['C', 'G'],
        genre: 'country',
        strum: StrumPattern.waltz,
      );
      expect(waltz.stepsPerBar, 12);
      final BandArranger arranger = BandArranger(waltz, plain);
      final List<BandEvent> bar = barOf(arranger, 0);
      expect(
        channelOf(
          bar,
          BandChannel.drums,
        ).any((BandEvent e) => e.sound.shape == DrumVoice.kick),
        isTrue,
      );
      expect(
        channelOf(arranger.eventsAt(0, 0), BandChannel.bass).single.sound.notes,
        <int>[36],
      );
      expect(arranger.eventsAt(0, 4), isNotEmpty);
    });
  });

  group('géneros', () {
    test('cada género suena distinto: sus muestras no coinciden', () {
      final Map<String, Set<String>> byGenre = <String, Set<String>>{
        for (final String genre in kBandPresets.keys)
          genre: BandArranger(
            trackOf(<String>['C', 'Am', 'F', 'G'], genre: genre),
            plain,
          ).sounds().map((BandSound s) => s.key).toSet(),
      };
      final List<String> ids = byGenre.keys.toList();
      for (int i = 0; i < ids.length; i++) {
        for (int j = i + 1; j < ids.length; j++) {
          expect(
            byGenre[ids[i]],
            isNot(equals(byGenre[ids[j]])),
            reason: '${ids[i]} y ${ids[j]}',
          );
        }
      }
    });

    test('cada género usa sus propios instrumentos de percusión', () {
      Set<DrumVoice> voicesOf(String genre) =>
          BandArranger(
                trackOf(<String>['C', 'G', 'Am', 'F'], genre: genre, loops: 2),
                plain,
              )
              .sounds()
              .where((BandSound s) => s.family == SoundFamily.drum)
              .map((BandSound s) => s.shape as DrumVoice)
              .toSet();
      expect(
        voicesOf('salsa'),
        containsAll(<DrumVoice>[
          DrumVoice.claves,
          DrumVoice.bongoLow,
          DrumVoice.cowbell,
        ]),
      );
      expect(voicesOf('cumbia'), contains(DrumVoice.guiro));
      expect(
        voicesOf('flamenco'),
        containsAll(<DrumVoice>[DrumVoice.palma, DrumVoice.cajon]),
      );
      expect(voicesOf('reggaeton'), contains(DrumVoice.clap));
      expect(voicesOf('metal'), isNot(contains(DrumVoice.claves)));
    });

    test('el estilo elegido manda sobre el de la pista', () {
      final JamTrack track = trackOf(<String>['C', 'G'], genre: 'pop');
      expect(bandStyleOf(track, plain), 'pop');
      expect(
        bandStyleOf(track, plain.copyWith(style: (value: 'salsa'))),
        'salsa',
      );
      expect(
        bandStyleOf(trackOf(<String>['C'], strum: StrumPattern.skank), plain),
        'reggae',
        reason: 'sin género, lo sugiere el rasgueo',
      );
      expect(
        BandArranger(track, plain.copyWith(style: (value: 'salsa'))).preset.id,
        'salsa',
      );
    });

    test('los instrumentos elegidos sustituyen a los del género', () {
      final BandArranger arranger = BandArranger(
        trackOf(<String>['C', 'G'], genre: 'pop'),
        plain.copyWith(
          bass: (value: BassKind.upright),
          guitar: (value: GuitarKind.nylon),
          kit: (value: DrumKit.jazz),
          keys: (value: KeysKind.organ),
        ),
      );
      final List<BandEvent> bar = barOf(arranger, 0);
      expect(
        channelOf(bar, BandChannel.bass).first.sound.kind,
        BassKind.upright,
      );
      expect(
        channelOf(bar, BandChannel.guitar).first.sound.kind,
        GuitarKind.nylon,
      );
      expect(channelOf(bar, BandChannel.drums).first.sound.kind, DrumKit.jazz);
      expect(channelOf(bar, BandChannel.keys).first.sound.kind, KeysKind.organ);
    });

    test('el swing es el del género o el elegido', () {
      final JamTrack blues = trackOf(<String>['A7', 'D7'], genre: 'blues');
      expect(BandArranger(blues, plain).swing, closeTo(0.62, 1e-9));
      expect(
        BandArranger(blues, plain.copyWith(swing: (value: 0.1))).swing,
        closeTo(0.1, 1e-9),
      );
      expect(
        BandArranger(trackOf(<String>['C'], genre: 'rock'), plain).swing,
        0,
      );
    });
  });

  test(
    'las muestras de la pista son únicas, ordenadas y cubren cada golpe',
    () {
      final BandArranger arranger = BandArranger(
        trackOf(<String>['C', 'Am', 'F', 'G'], genre: 'funk', loops: 2),
        plain,
      );
      final List<BandSound> sounds = arranger.sounds();
      expect(sounds.toSet().length, sounds.length);
      final List<String> keys = sounds.map((BandSound s) => s.key).toList();
      expect(keys, <String>[...keys]..sort());
      final Set<String> known = keys.toSet();
      for (int bar = 0; bar < 8; bar++) {
        for (final BandEvent e in barOf(arranger, bar)) {
          expect(known, contains(e.sound.key));
        }
      }
    },
  );

  test('el clic marca los pulsos y acentúa el primero', () {
    final BandArranger arranger = BandArranger(trackOf(<String>['C']), plain);
    expect(arranger.clickAt(0).single.sound.shape, ClickAccent.accent);
    expect(arranger.clickAt(4).single.sound.shape, ClickAccent.normal);
    expect(arranger.clickAt(3), isEmpty);
    expect(arranger.clickAt(0).single.channel, BandChannel.click);
  });

  test('bajo, guitarra y charles tienen su grupo de corte', () {
    final BandSound bass = BandSound.bass(BassKind.finger, 36, NoteLength.long);
    final BandSound guitar = BandSound.guitar(
      GuitarKind.clean,
      GuitarStroke.down,
      const <int>[48],
    );
    expect(bass.chokeGroup, 'bass');
    expect(guitar.chokeGroup, 'guitar');
    expect(
      BandSound.drum(
        DrumVoice.hatOpen,
        DrumKit.acoustic,
        hard: true,
      ).chokeGroup,
      'hat',
    );
    expect(
      BandSound.drum(DrumVoice.crash, DrumKit.acoustic, hard: true).chokeGroup,
      isNull,
    );
  });
}

/// Ayuda de prueba: pregunta si un compás usa la variante fuerte.
class ArrangerLift {
  ArrangerLift(this.intensity);

  final BandIntensity intensity;

  bool lifts(JamTrack track, int bar) => BandArranger(
    track,
    BandConfig(humanize: 0, intensity: intensity),
  ).context.isLift(bar);
}
