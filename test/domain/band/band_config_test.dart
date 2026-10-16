import 'dart:convert';

import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/domain/band/entities/channel_mix.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los ajustes de la banda: valores de fábrica, atajos y guardado en JSON.
void main() {
  test('de fábrica toda la banda suena, sin clic, con una cuenta atrás', () {
    const BandConfig config = BandConfig();
    for (final BandChannel channel in kBandChannels) {
      expect(config.isOn(channel), isTrue, reason: channel.name);
    }
    expect(config.isOn(BandChannel.click), isFalse);
    expect(config.countInBars, 1);
    expect(config.loops, 4);
    expect(config.transpose, 0);
    expect(config.swing, isNull, reason: 'el del género');
    expect(config.style, isNull);
    expect(config.fills, isTrue);
    expect(config.intensity, BandIntensity.normal);
    expect(bandModeOf(config), BandMode.fullBand);
  });

  test('ir y volver por JSON conserva todo', () {
    final BandConfig config = const BandConfig()
        .withChannel(
          BandChannel.bass,
          const ChannelMix(enabled: false, volume: 0.35),
        )
        .copyWith(
          style: (value: 'salsa'),
          kit: (value: DrumKit.electronic),
          bass: (value: BassKind.synth),
          guitar: (value: GuitarKind.nylon),
          keys: (value: KeysKind.organ),
          wind: (value: WindKind.accordion),
          swing: (value: 0.4),
          humanize: 0.8,
          countInBars: 2,
          loops: 6,
          transpose: -3,
          intensity: BandIntensity.strong,
          fills: false,
        );
    final BandConfig back = BandConfig.fromJson(
      jsonDecode(jsonEncode(config.toJson())),
    );
    expect(back, config);
    expect(back.mixOf(BandChannel.bass).volume, closeTo(0.35, 1e-9));
    expect(back.isOn(BandChannel.bass), isFalse);
    expect(back.style, 'salsa');
    expect(back.swing, closeTo(0.4, 1e-9));
    expect(back.transpose, -3);
    expect(back.wind, WindKind.accordion);
  });

  test('un JSON dañado o con valores absurdos se corrige', () {
    expect(BandConfig.fromJson(null), const BandConfig());
    expect(BandConfig.fromJson('basura'), const BandConfig());
    final BandConfig fixed = BandConfig.fromJson(const <String, Object?>{
      'loops': 99,
      'countIn': -4,
      'transpose': 40,
      'humanize': 7,
      'swing': -2,
      'kit': 'inventado',
      'intensity': 12,
      'mix': <String, Object?>{
        'drums': <String, Object?>{'on': 'no', 'vol': 9},
        'bass': 'roto',
      },
    });
    expect(fixed.loops, 8);
    expect(fixed.countInBars, 0);
    expect(fixed.transpose, 6);
    expect(fixed.humanize, 1);
    expect(fixed.swing, 0);
    expect(fixed.kit, isNull);
    expect(fixed.intensity, BandIntensity.normal);
    expect(fixed.mixOf(BandChannel.drums).volume, 1);
    expect(fixed.mixOf(BandChannel.bass), const ChannelMix());
  });

  test('"automático" se pide con un valor envuelto nulo', () {
    final BandConfig custom = const BandConfig().copyWith(
      kit: (value: DrumKit.jazz),
      swing: (value: 0.3),
      style: (value: 'rock'),
    );
    final BandConfig auto = custom.copyWith(
      kit: (value: null),
      swing: (value: null),
      style: (value: null),
    );
    expect(auto.kit, isNull);
    expect(auto.swing, isNull);
    expect(auto.style, isNull);
    expect(custom.copyWith(humanize: 0.1).kit, DrumKit.jazz);
  });

  group('atajos de mezcla', () {
    test('cada atajo enciende lo suyo y conserva los volúmenes', () {
      final BandConfig base = const BandConfig().withChannel(
        BandChannel.guitar,
        const ChannelMix(volume: 0.2),
      );
      final BandConfig rhythm = applyBandMode(base, BandMode.rhythm);
      expect(
        <BandChannel>{
          for (final BandChannel c in BandChannel.values)
            if (rhythm.isOn(c)) c,
        },
        <BandChannel>{
          BandChannel.drums,
          BandChannel.percussion,
          BandChannel.bass,
        },
      );
      expect(bandModeOf(rhythm), BandMode.rhythm);
      final BandConfig noGuitar = applyBandMode(base, BandMode.noGuitar);
      expect(noGuitar.isOn(BandChannel.guitar), isFalse);
      expect(noGuitar.isOn(BandChannel.keys), isTrue);
      expect(bandModeOf(noGuitar), BandMode.noGuitar);
      final BandConfig click = applyBandMode(base, BandMode.clickOnly);
      expect(
        <BandChannel>{
          for (final BandChannel c in BandChannel.values)
            if (click.isOn(c)) c,
        },
        <BandChannel>{BandChannel.click},
      );
      expect(bandModeOf(click), BandMode.clickOnly);
      expect(
        applyBandMode(
          rhythm,
          BandMode.fullBand,
        ).mixOf(BandChannel.guitar).volume,
        closeTo(0.2, 1e-9),
      );
    });

    test('una mezcla a medida no corresponde a ningún atajo', () {
      final BandConfig custom = const BandConfig().withChannel(
        BandChannel.keys,
        const ChannelMix(enabled: false),
      );
      expect(bandModeOf(custom), isNull);
    });
  });
}
