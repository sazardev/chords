import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/channel_mix.dart';

/// Atajos de mezcla: qué canales suenan.
enum BandMode {
  /// Toda la banda.
  fullBand,

  /// Solo batería, percusión y bajo: para tocar encima.
  rhythm,

  /// Banda completa menos la guitarra.
  noGuitar,

  /// Solo el clic del metrónomo.
  clickOnly,
}

/// Canales de la banda (todos menos el clic).
const List<BandChannel> kBandChannels = <BandChannel>[
  BandChannel.drums,
  BandChannel.percussion,
  BandChannel.bass,
  BandChannel.guitar,
  BandChannel.keys,
  BandChannel.winds,
];

/// Canales de la base rítmica: batería, percusión y bajo.
const List<BandChannel> kRhythmChannels = <BandChannel>[
  BandChannel.drums,
  BandChannel.percussion,
  BandChannel.bass,
];

/// Canales encendidos en el atajo [mode].
Set<BandChannel> channelsOf(BandMode mode) => switch (mode) {
  BandMode.fullBand => <BandChannel>{...kBandChannels},
  BandMode.rhythm => <BandChannel>{...kRhythmChannels},
  BandMode.noGuitar => <BandChannel>{
    ...kBandChannels,
  }..remove(BandChannel.guitar),
  BandMode.clickOnly => <BandChannel>{BandChannel.click},
};

/// La configuración con los canales del atajo [mode] (los volúmenes se
/// conservan).
BandConfig applyBandMode(BandConfig config, BandMode mode) {
  final Set<BandChannel> on = channelsOf(mode);
  return config.copyWith(
    mix: <BandChannel, ChannelMix>{
      for (final BandChannel channel in BandChannel.values)
        channel: config.mixOf(channel).copyWith(enabled: on.contains(channel)),
    },
  );
}

/// Atajo que describe la mezcla de [config]; `null` si es a medida.
BandMode? bandModeOf(BandConfig config) {
  for (final BandMode mode in BandMode.values) {
    final Set<BandChannel> on = channelsOf(mode);
    if (BandChannel.values.every(
      (BandChannel c) => config.isOn(c) == on.contains(c),
    )) {
      return mode;
    }
  }
  return null;
}
