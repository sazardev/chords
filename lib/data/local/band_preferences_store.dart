import 'dart:convert';

import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/preferences/repositories/band_preferences.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda en `SharedPreferences` la configuración de la banda del jam.
///
/// Es un mixin para que [PreferencesService] siga siendo el único punto de
/// acceso a las preferencias sin crecer más de la cuenta. La configuración
/// va en un solo JSON: si está dañado o es de una versión antigua, se
/// recupera lo que se pueda y el resto vuelve a los valores de fábrica.
mixin BandPreferencesStore implements BandPreferences {
  /// Clave de la configuración de la banda.
  static const String kBandConfigKey = 'band_config_v1';

  /// Almacén donde se guardan los valores.
  @protected
  SharedPreferences get store;

  @override
  BandConfig get bandConfig {
    final String? raw = store.getString(kBandConfigKey);
    if (raw == null) {
      return const BandConfig();
    }
    try {
      return BandConfig.fromJson(jsonDecode(raw));
    } on FormatException {
      return const BandConfig();
    }
  }

  @override
  Future<void> setBandConfig(BandConfig config) =>
      store.setString(kBandConfigKey, jsonEncode(config.toJson()));
}
