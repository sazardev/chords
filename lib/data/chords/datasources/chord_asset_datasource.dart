import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Origen de datos local: lee el banco de acordes de los assets.
class ChordAssetDataSource {
  /// Crea el origen de datos.
  const ChordAssetDataSource({this.assetPath = 'assets/chords/chords_db.json'});

  /// Ruta del asset con el banco de acordes.
  final String assetPath;

  /// Devuelve el JSON decodificado del banco de acordes.
  Future<Map<String, Object?>> fetchDatabase() async {
    final String raw = await rootBundle.loadString(assetPath);
    final Object? decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('El banco de acordes no es un objeto JSON');
    }
    return decoded;
  }
}
