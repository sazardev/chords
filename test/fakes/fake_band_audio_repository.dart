import 'dart:async';

import 'package:chords/domain/audio/repositories/band_audio_repository.dart';
import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_sound.dart';

/// Un golpe que recibió la banda falsa.
typedef BandPlay = ({BandSound sound, double volume, Duration delay});

/// Audio de la banda en memoria para pruebas: recuerda qué se pidió tocar.
class FakeBandAudioRepository implements BandAudioRepository {
  /// Golpes tocados, en orden.
  final List<BandPlay> plays = <BandPlay>[];

  /// Claves de las muestras "cargadas".
  final Set<String> ready = <String>{};

  /// Canales silenciados (`null` = toda la banda).
  final List<BandChannel?> silences = <BandChannel?>[];

  /// Veces que se pidió precargar.
  int preloads = 0;

  /// Si no es `null`, la precarga espera a que se complete.
  Completer<void>? gate;

  /// Si es `true`, la precarga falla.
  bool failPreload = false;

  /// Avances que se notificaron en la última precarga.
  final List<double> progress = <double>[];

  @override
  Future<void> preload(
    Iterable<BandSound> sounds, {
    void Function(double progress)? onProgress,
  }) async {
    preloads++;
    if (failPreload) {
      throw StateError('sin audio');
    }
    progress.clear();
    onProgress?.call(0.4);
    progress.add(0.4);
    await gate?.future;
    ready.addAll(sounds.map((BandSound s) => s.key));
    onProgress?.call(1);
    progress.add(1);
  }

  @override
  bool isReady(BandSound sound) => ready.contains(sound.key);

  @override
  void play(
    BandSound sound, {
    required double volume,
    Duration delay = Duration.zero,
  }) {
    plays.add((sound: sound, volume: volume, delay: delay));
  }

  @override
  void silence({BandChannel? channel}) => silences.add(channel);

  @override
  Future<void> release({Set<String> keep = const <String>{}}) async =>
      ready.removeWhere((String key) => !keep.contains(key));

  @override
  Future<void> dispose() async {}

  /// Golpes de un canal.
  Iterable<BandPlay> of(BandChannel channel) =>
      plays.where((BandPlay p) => p.sound.channel == channel);
}
