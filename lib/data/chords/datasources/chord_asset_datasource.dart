import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Origen de datos local: lee el banco de acordes de los assets.
class ChordAssetDataSource {
  /// Crea el origen de datos.
  const ChordAssetDataSource({this.assetPath = 'assets/chords/chords_db.json'});

  /// Ruta del asset con el banco de acordes.
  final String assetPath;

  /// Devuelve el texto JSON del banco de acordes sin decodificar.
  ///
  /// Registra la duración y el tamaño de la lectura. Decodificarlo (que es lo
  /// caro) lo hace quien lo pida, para poder moverlo a otro isolate.
  Future<String> fetchRaw() async {
    final Stopwatch watch = Stopwatch()..start();
    final String raw = await rootBundle.loadString(assetPath);
    watch.stop();
    appLogger.info(
      'banco leído desde assets',
      channel: LogChannel.chords,
      context: <String, Object?>{
        'bytes': raw.length,
        'durationMs': watch.elapsed.inMilliseconds,
      },
    );
    return raw;
  }
}
