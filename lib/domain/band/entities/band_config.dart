import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/channel_mix.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:meta/meta.dart';

/// Los ajustes de la banda del jam.
///
/// Los instrumentos y el swing en `null` significan "los del género"
/// (automático). Se guarda como JSON en las preferencias.
@immutable
class BandConfig {
  /// Crea la configuración (por defecto, banda completa sin clic).
  const BandConfig({
    this.mix = kDefaultMix,
    this.style,
    this.kit,
    this.bass,
    this.guitar,
    this.keys,
    this.wind,
    this.swing,
    this.humanize = 0.35,
    this.countInBars = 1,
    this.loops = 4,
    this.transpose = 0,
    this.intensity = BandIntensity.normal,
    this.fills = true,
  });

  /// Lee la configuración de un JSON tolerante a datos viejos o dañados.
  factory BandConfig.fromJson(Object? json) {
    if (json is! Map<String, Object?>) {
      return const BandConfig();
    }
    final Object? mixJson = json['mix'];
    final Map<String, Object?> mixes = mixJson is Map<String, Object?>
        ? mixJson
        : const <String, Object?>{};
    final Object? swing = json['swing'];
    final Object? humanize = json['humanize'];
    return BandConfig(
      mix: <BandChannel, ChannelMix>{
        for (final BandChannel channel in BandChannel.values)
          channel: mixes.containsKey(channel.name)
              ? ChannelMix.fromJson(mixes[channel.name])
              : kDefaultMix[channel]!,
      },
      style: json['style'] is String ? json['style']! as String : null,
      kit: _byName(DrumKit.values, json['kit']),
      bass: _byName(BassKind.values, json['bass']),
      guitar: _byName(GuitarKind.values, json['guitar']),
      keys: _byName(KeysKind.values, json['keys']),
      wind: _byName(WindKind.values, json['wind']),
      swing: swing is num ? swing.toDouble().clamp(0.0, 1.0) : null,
      humanize: humanize is num ? humanize.toDouble().clamp(0.0, 1.0) : 0.35,
      countInBars: _int(json['countIn'], 1).clamp(0, 2),
      loops: _int(json['loops'], 4).clamp(1, 8),
      transpose: _int(json['transpose'], 0).clamp(-6, 6),
      intensity:
          _byName(BandIntensity.values, json['intensity']) ??
          BandIntensity.normal,
      fills: json['fills'] is! bool || json['fills']! as bool,
    );
  }

  /// Mezcla inicial: todo encendido salvo el clic.
  static const Map<BandChannel, ChannelMix> kDefaultMix =
      <BandChannel, ChannelMix>{
        BandChannel.drums: ChannelMix(volume: 0.85),
        BandChannel.percussion: ChannelMix(volume: 0.85),
        BandChannel.bass: ChannelMix(volume: 0.85),
        BandChannel.guitar: ChannelMix(volume: 0.85),
        BandChannel.keys: ChannelMix(volume: 0.65),
        BandChannel.winds: ChannelMix(volume: 0.75),
        BandChannel.click: ChannelMix(enabled: false, volume: 0.6),
      };

  /// Ajuste de cada canal.
  final Map<BandChannel, ChannelMix> mix;

  /// Género de la banda (`salsa`); `null` = el de la pista.
  final String? style;

  /// Kit de batería; `null` = el del género.
  final DrumKit? kit;

  /// Tipo de bajo; `null` = el del género.
  final BassKind? bass;

  /// Tipo de guitarra; `null` = el del género.
  final GuitarKind? guitar;

  /// Tipo de teclado; `null` = el del género.
  final KeysKind? keys;

  /// Tipo de viento; `null` = el del género.
  final WindKind? wind;

  /// Swing (0 recto, 1 tresillo); `null` = el del género.
  final double? swing;

  /// Humanización: variación de tiempo y fuerza (0-1).
  final double humanize;

  /// Compases de cuenta atrás (0-2).
  final int countInBars;

  /// Vueltas de las progresiones y de las pistas propias (1-8).
  final int loops;

  /// Semitonos de transposición o capo (-6 a 6).
  final int transpose;

  /// Intensidad.
  final BandIntensity intensity;

  /// `true` si la batería hace rellenos al cerrar cada frase.
  final bool fills;

  /// Ajuste del canal [channel].
  ChannelMix mixOf(BandChannel channel) => mix[channel] ?? const ChannelMix();

  /// `true` si [channel] suena.
  bool isOn(BandChannel channel) => mixOf(channel).enabled;

  /// Copia con otro ajuste en [channel].
  BandConfig withChannel(BandChannel channel, ChannelMix value) =>
      copyWith(mix: <BandChannel, ChannelMix>{...mix, channel: value});

  /// Copia con cambios.
  ///
  /// Los ajustes que admiten "automático" se pasan envueltos
  /// (`kit: (value: null)` vuelve al kit del género).
  BandConfig copyWith({
    Map<BandChannel, ChannelMix>? mix,
    ({String? value})? style,
    ({DrumKit? value})? kit,
    ({BassKind? value})? bass,
    ({GuitarKind? value})? guitar,
    ({KeysKind? value})? keys,
    ({WindKind? value})? wind,
    ({double? value})? swing,
    double? humanize,
    int? countInBars,
    int? loops,
    int? transpose,
    BandIntensity? intensity,
    bool? fills,
  }) => BandConfig(
    mix: mix ?? this.mix,
    style: style == null ? this.style : style.value,
    kit: kit == null ? this.kit : kit.value,
    bass: bass == null ? this.bass : bass.value,
    guitar: guitar == null ? this.guitar : guitar.value,
    keys: keys == null ? this.keys : keys.value,
    wind: wind == null ? this.wind : wind.value,
    swing: swing == null ? this.swing : swing.value,
    humanize: humanize ?? this.humanize,
    countInBars: countInBars ?? this.countInBars,
    loops: loops ?? this.loops,
    transpose: transpose ?? this.transpose,
    intensity: intensity ?? this.intensity,
    fills: fills ?? this.fills,
  );

  /// Representación para guardar.
  Map<String, Object?> toJson() => <String, Object?>{
    'mix': <String, Object?>{
      for (final BandChannel channel in BandChannel.values)
        channel.name: mixOf(channel).toJson(),
    },
    'style': style,
    'kit': kit?.name,
    'bass': bass?.name,
    'guitar': guitar?.name,
    'keys': keys?.name,
    'wind': wind?.name,
    'swing': swing,
    'humanize': humanize,
    'countIn': countInBars,
    'loops': loops,
    'transpose': transpose,
    'intensity': intensity.name,
    'fills': fills,
  };

  @override
  bool operator ==(Object other) =>
      other is BandConfig && other.toJson().toString() == toJson().toString();

  @override
  int get hashCode => toJson().toString().hashCode;

  static int _int(Object? value, int fallback) =>
      value is num ? value.round() : fallback;

  static T? _byName<T extends Enum>(List<T> values, Object? name) {
    for (final T value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}
