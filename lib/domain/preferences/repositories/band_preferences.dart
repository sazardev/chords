import 'package:chords/domain/band/entities/band_config.dart';

/// Preferencias de la banda del jam: mezclador, estilo y ritmo.
abstract interface class BandPreferences {
  /// Configuración guardada (la de fábrica si nunca se guardó).
  BandConfig get bandConfig;

  /// Guarda la configuración de la banda.
  Future<void> setBandConfig(BandConfig config);
}
