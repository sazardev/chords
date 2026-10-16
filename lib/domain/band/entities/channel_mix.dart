import 'package:meta/meta.dart';

/// Ajuste de un canal del mezclador: encendido y volumen.
@immutable
class ChannelMix {
  /// Crea el ajuste.
  const ChannelMix({this.enabled = true, this.volume = 0.8});

  /// Lee el ajuste de un JSON; lo que falte o esté fuera de rango se corrige.
  factory ChannelMix.fromJson(Object? json) {
    if (json is! Map<String, Object?>) {
      return const ChannelMix();
    }
    final Object? enabled = json['on'];
    final Object? volume = json['vol'];
    return ChannelMix(
      enabled: enabled is! bool || enabled,
      volume: volume is num ? volume.toDouble().clamp(0.0, 1.0) : 0.8,
    );
  }

  /// `true` si el canal suena.
  final bool enabled;

  /// Volumen (0-1).
  final double volume;

  /// Copia con cambios.
  ChannelMix copyWith({bool? enabled, double? volume}) => ChannelMix(
    enabled: enabled ?? this.enabled,
    volume: volume ?? this.volume,
  );

  /// Representación para guardar.
  Map<String, Object?> toJson() => <String, Object?>{
    'on': enabled,
    'vol': double.parse(volume.toStringAsFixed(3)),
  };

  @override
  bool operator ==(Object other) =>
      other is ChannelMix && other.enabled == enabled && other.volume == volume;

  @override
  int get hashCode => Object.hash(enabled, volume);
}
