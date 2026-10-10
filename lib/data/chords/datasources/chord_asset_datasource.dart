import 'dart:convert';

import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Origen de datos local: lee el banco de acordes de los assets.
class ChordAssetDataSource {
  /// Crea el origen de datos.
  const ChordAssetDataSource({this.assetPath = 'assets/chords/chords_db.json'});

  /// Ruta del asset con el banco de acordes.
  final String assetPath;

  /// Devuelve el JSON decodificado del banco de acordes.
  ///
  /// Registra la duración y el tamaño de la lectura; si el JSON no tiene la
  /// forma esperada lo propaga para que el repositorio y su llamador lo traten.
  Future<Map<String, Object?>> fetchDatabase() async {
    final Stopwatch watch = Stopwatch()..start();
    final String raw = await rootBundle.loadString(assetPath);
    final Object? decoded = jsonDecode(raw);
    watch.stop();
    appLogger.info(
      'banco leído desde assets',
      channel: LogChannel.chords,
      context: <String, Object?>{
        'bytes': raw.length,
        'durationMs': watch.elapsed.inMilliseconds,
      },
    );
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('El banco de acordes no es un objeto JSON');
    }
    return decoded;
  }
}
