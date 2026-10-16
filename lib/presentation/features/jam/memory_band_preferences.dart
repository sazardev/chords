import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/preferences/repositories/band_preferences.dart';

/// Preferencias de la banda que viven solo en memoria.
///
/// Sirven de respaldo cuando no hay almacén persistente (pruebas, vistas
/// previas): la configuración se conserva mientras dura la sesión.
class MemoryBandPreferences implements BandPreferences {
  /// Crea las preferencias con una configuración inicial.
  MemoryBandPreferences([this._config = const BandConfig()]);

  BandConfig _config;

  @override
  BandConfig get bandConfig => _config;

  @override
  Future<void> setBandConfig(BandConfig config) async => _config = config;
}
