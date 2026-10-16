import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_sound.dart';

/// Audio de la banda del jam: prepara las muestras de cada instrumento y las
/// toca en el instante pedido.
///
/// Es independiente de `AudioRepository` (acordes, notas y micrófono): la
/// banda necesita cientos de muestras de golpes cortos, polifonía y cortes
/// entre notas que ese repositorio no ofrece.
abstract interface class BandAudioRepository {
  /// Sintetiza y carga en memoria todas las [sounds] que aún no estén.
  ///
  /// La síntesis pesada ocurre fuera del hilo de la interfaz. [onProgress]
  /// recibe una fracción creciente de 0 a 1; la llamada termina cuando todo
  /// está listo para tocar sin tirones.
  Future<void> preload(
    Iterable<BandSound> sounds, {
    void Function(double progress)? onProgress,
  });

  /// `true` si [sound] ya está cargado y sonará al instante.
  bool isReady(BandSound sound);

  /// Toca [sound] con [volume] (0-1) tras [delay].
  ///
  /// Un sonido con grupo de choke corta antes el anterior de su grupo (una
  /// nota de bajo calla a la anterior, un charles cerrado al abierto). Si
  /// la muestra no está cargada, no hace nada.
  void play(
    BandSound sound, {
    required double volume,
    Duration delay = Duration.zero,
  });

  /// Calla con un fundido corto lo que suena en [channel] (o en toda la
  /// banda si es `null`) y anula los golpes pendientes.
  void silence({BandChannel? channel});

  /// Libera las muestras cargadas que no están en [keep].
  Future<void> release({Set<String> keep = const <String>{}});

  /// Libera todos los recursos.
  Future<void> dispose();
}
