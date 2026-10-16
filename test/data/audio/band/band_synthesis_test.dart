import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/band/band_sound_renderer.dart';
import 'package:chords/data/audio/band/dsp/dsp_kit.dart';
import 'package:chords/data/audio/band/rendered_sound.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cada instrumento sintetizado: sin NaN, con pico acotado y con sentido.
void main() {
  /// Comprueba que la muestra es sana.
  void expectHealthy(RenderedSound sound, String name, {double? maxSeconds}) {
    final Float64List s = sound.samples;
    double peak = 0;
    double energy = 0;
    for (final double v in s) {
      expect(v.isFinite, isTrue, reason: '$name tiene un valor no finito');
      peak = math.max(peak, v.abs());
      energy += v * v;
    }
    expect(peak, lessThanOrEqualTo(1), reason: '$name pasa de 1');
    expect(peak, greaterThan(0.04), reason: '$name casi no suena');
    expect(energy, greaterThan(0), reason: '$name no tiene energía');
    final double seconds = s.length / kBandRate;
    expect(seconds, greaterThan(0.04), reason: '$name es demasiado corto');
    expect(seconds, lessThan(maxSeconds ?? 3.5), reason: '$name es largo');
    // Sin clics: ni el primer ni el último valor saltan.
    expect(s.first.abs(), lessThan(0.05), reason: '$name arranca con clic');
    if (sound.loopStart == null) {
      expect(s.last.abs(), lessThan(0.05), reason: '$name acaba con clic');
    }
  }

  /// Energía a la frecuencia [hz] (Goertzel) en los primeros [seconds] s.
  double energyAt(Float64List s, double hz, double seconds) {
    final int n = math.min(s.length, (seconds * kBandRate).round());
    final double w = 2 * math.pi * hz / kBandRate;
    final double coeff = 2 * math.cos(w);
    double q1 = 0;
    double q2 = 0;
    for (int i = 0; i < n; i++) {
      final double q0 = coeff * q1 - q2 + s[i];
      q2 = q1;
      q1 = q0;
    }
    return (q1 * q1 + q2 * q2 - coeff * q1 * q2) / n;
  }

  group('batería y percusión', () {
    for (final DrumKit kit in DrumKit.values) {
      for (final DrumVoice voice in DrumVoice.values) {
        test('${kit.name} ${voice.name}', () {
          for (final bool hard in <bool>[true, false]) {
            final RenderedSound sound = renderBandSound(
              BandSound.drum(voice, kit, hard: hard),
            );
            expectHealthy(sound, '${voice.name} ${hard ? 'fuerte' : 'suave'}');
            expect(sound.loopStart, isNull);
          }
        });
      }
    }

    test('la capa fuerte suena más que la suave', () {
      for (final DrumVoice voice in DrumVoice.values) {
        double peak({required bool hard}) =>
            renderBandSound(BandSound.drum(voice, DrumKit.acoustic, hard: hard))
                .samples
                .fold<double>(0, (double m, double v) => math.max(m, v.abs()));
        expect(
          peak(hard: true),
          greaterThan(peak(hard: false)),
          reason: voice.name,
        );
      }
    });

    test('el bombo tiene su energía en graves y el charles en agudos', () {
      final Float64List kick = renderBandSound(
        BandSound.drum(DrumVoice.kick, DrumKit.acoustic, hard: true),
      ).samples;
      final Float64List hat = renderBandSound(
        BandSound.drum(DrumVoice.hatClosed, DrumKit.acoustic, hard: true),
      ).samples;
      expect(
        energyAt(kick, 60, 0.3),
        greaterThan(energyAt(kick, 6000, 0.3) * 50),
      );
      expect(
        energyAt(hat, 9000, 0.1),
        greaterThan(energyAt(hat, 120, 0.1) * 5),
      );
    });
  });

  group('bajo', () {
    for (final BassKind kind in BassKind.values) {
      test(kind.name, () {
        for (final NoteLength length in NoteLength.values) {
          for (final int midi in <int>[28, 33, 40, 47, 55]) {
            final RenderedSound sound = renderBandSound(
              BandSound.bass(kind, midi, length),
            );
            expectHealthy(sound, '${kind.name} $midi ${length.name}');
          }
        }
      });

      test('${kind.name} suena a la nota pedida', () {
        for (final int midi in <int>[33, 40, 45]) {
          final double hz = midiHz(midi);
          final Float64List s = renderBandSound(
            BandSound.bass(kind, midi, NoteLength.long),
          ).samples;
          final double target = energyAt(s, hz, 0.4);
          expect(
            target,
            greaterThan(energyAt(s, hz * 1.059, 0.4) * 1.5),
            reason: '${kind.name} $midi no está afinado',
          );
          expect(
            target,
            greaterThan(energyAt(s, hz * 0.944, 0.4) * 1.5),
            reason: '${kind.name} $midi no está afinado',
          );
        }
      });
    }
  });

  group('guitarra', () {
    const List<int> c = <int>[48, 55, 60, 64, 67];
    for (final GuitarKind kind in GuitarKind.values) {
      test(kind.name, () {
        for (final GuitarStroke stroke in GuitarStroke.values) {
          final RenderedSound sound = renderBandSound(
            BandSound.guitar(kind, stroke, c),
          );
          expectHealthy(sound, '${kind.name} ${stroke.name}');
        }
      });
    }

    test('el palm-mute es más corto que el power chord', () {
      int audible(GuitarStroke stroke) {
        final Float64List s = renderBandSound(
          BandSound.guitar(GuitarKind.distorted, stroke, const <int>[
            40,
            47,
            52,
          ]),
        ).samples;
        int last = s.length;
        while (last > 0 && s[last - 1].abs() < 0.03) {
          last--;
        }
        return last;
      }

      expect(
        audible(GuitarStroke.powerMute),
        lessThan(audible(GuitarStroke.power)),
      );
    });
  });

  group('teclados y vientos', () {
    const List<int> chord = <int>[52, 56, 59, 64];
    for (final KeysKind kind in KeysKind.values) {
      test(kind.name, () {
        for (final NoteLength length in NoteLength.values) {
          final RenderedSound sound = renderBandSound(
            BandSound.keys(kind, length, chord),
          );
          expectHealthy(sound, '${kind.name} ${length.name}');
        }
      });
    }

    for (final WindKind kind in WindKind.values) {
      test(kind.name, () {
        for (final NoteLength length in NoteLength.values) {
          final RenderedSound sound = renderBandSound(
            BandSound.wind(kind, length, const <int>[60, 64, 67]),
          );
          expectHealthy(sound, '${kind.name} ${length.name}');
        }
      });
    }

    test('los sostenidos empalman el bucle sin salto', () {
      final List<BandSound> sustained = <BandSound>[
        BandSound.keys(KeysKind.organ, NoteLength.long, chord),
        BandSound.keys(KeysKind.pad, NoteLength.long, chord),
        BandSound.wind(WindKind.accordion, NoteLength.long, chord),
        BandSound.wind(WindKind.brass, NoteLength.long, chord),
      ];
      for (final BandSound sound in sustained) {
        final RenderedSound r = renderBandSound(sound);
        expect(r.loopStart, isNotNull, reason: sound.key);
        final Float64List s = r.samples;
        final int start = r.loopStart!;
        final double step = s
            .sublist(start, start + 2000)
            .fold<double>(0, (double m, double v) => math.max(m, v.abs()));
        // El salto de empalme es del orden de un paso entre muestras.
        final double jump = (s.last - s[start - 1 + 0]).abs();
        expect(
          jump,
          lessThan(step * 0.25),
          reason: '${sound.key} salta al repetir',
        );
      }
    });

    test('un golpe suena en la misma tecla que se pide', () {
      final Float64List s = renderBandSound(
        BandSound.keys(KeysKind.piano, NoteLength.medium, const <int>[69]),
      ).samples;
      expect(energyAt(s, 440, 0.4), greaterThan(energyAt(s, 466.2, 0.4) * 3));
    });
  });

  test('el clic acentuado es más agudo', () {
    final RenderedSound normal = renderBandSound(
      BandSound.click(ClickAccent.normal),
    );
    final RenderedSound accent = renderBandSound(
      BandSound.click(ClickAccent.accent),
    );
    expectHealthy(normal, 'clic');
    expectHealthy(accent, 'clic acentuado');
    expect(
      energyAt(accent.samples, 2300, 0.05),
      greaterThan(energyAt(normal.samples, 2300, 0.05)),
    );
  });
}
