import 'package:chords/domain/band/entities/band_channel.dart';

/// Cada sonido de batería o percusión que sabe tocar la banda.
enum DrumVoice {
  /// Bombo.
  kick(BandChannel.drums),

  /// Caja.
  snare(BandChannel.drums),

  /// Aro de la caja (cross-stick).
  rimshot(BandChannel.drums),

  /// Palmada electrónica.
  clap(BandChannel.drums),

  /// Charles cerrado.
  hatClosed(BandChannel.drums),

  /// Charles abierto.
  hatOpen(BandChannel.drums),

  /// Charles con el pedal.
  hatPedal(BandChannel.drums),

  /// Ride.
  ride(BandChannel.drums),

  /// Campana del ride.
  rideBell(BandChannel.drums),

  /// Crash.
  crash(BandChannel.drums),

  /// Tom agudo.
  tomHigh(BandChannel.drums),

  /// Tom medio.
  tomMid(BandChannel.drums),

  /// Tom grave.
  tomLow(BandChannel.drums),

  /// Shaker.
  shaker(BandChannel.percussion),

  /// Pandereta.
  tambourine(BandChannel.percussion),

  /// Cencerro.
  cowbell(BandChannel.percussion),

  /// Claves.
  claves(BandChannel.percussion),

  /// Conga abierta.
  congaOpen(BandChannel.percussion),

  /// Conga con golpe de palma (slap).
  congaSlap(BandChannel.percussion),

  /// Conga apagada.
  congaMute(BandChannel.percussion),

  /// Bongó agudo.
  bongoHigh(BandChannel.percussion),

  /// Bongó grave.
  bongoLow(BandChannel.percussion),

  /// Timbal (golpe de aro metálico).
  timbale(BandChannel.percussion),

  /// Güiro.
  guiro(BandChannel.percussion),

  /// Palmas claras (flamenco).
  palma(BandChannel.percussion),

  /// Palmas sordas (flamenco).
  palmaMuted(BandChannel.percussion),

  /// Cajón: golpe grave en el centro.
  cajon(BandChannel.percussion),

  /// Cajón: golpe seco y agudo en el borde.
  cajonSlap(BandChannel.percussion);

  /// Crea la voz.
  const DrumVoice(this.channel);

  /// Canal del mezclador.
  final BandChannel channel;
}
