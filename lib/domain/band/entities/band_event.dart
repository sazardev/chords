import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:meta/meta.dart';

/// Un golpe concreto de la banda en un hueco de la rejilla.
@immutable
class BandEvent {
  /// Crea el evento.
  const BandEvent(this.sound, this.velocity);

  /// Qué suena.
  final BandSound sound;

  /// Fuerza del golpe (0-1).
  final double velocity;

  /// Canal del mezclador.
  BandChannel get channel => sound.channel;

  @override
  bool operator ==(Object other) =>
      other is BandEvent && other.sound == sound && other.velocity == velocity;

  @override
  int get hashCode => Object.hash(sound, velocity);

  @override
  String toString() => '$sound@${velocity.toStringAsFixed(2)}';
}
