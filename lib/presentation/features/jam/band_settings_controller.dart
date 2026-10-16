import 'dart:async' show unawaited;

import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_mode.dart';
import 'package:chords/domain/band/entities/channel_mix.dart';
import 'package:chords/domain/preferences/repositories/band_preferences.dart';
import 'package:flutter/foundation.dart';

/// Ajustes de la banda del jam: el mezclador, el estilo y el ritmo.
///
/// Cada cambio se guarda al instante en las preferencias y avisa a quien
/// escucha (la pantalla de preparación, la escena y el controlador del jam,
/// que aplica en caliente lo que pueda).
class BandSettingsController extends ChangeNotifier {
  /// Crea el controlador leyendo lo guardado.
  BandSettingsController(this._preferences) : _config = _preferences.bandConfig;

  final BandPreferences _preferences;
  BandConfig _config;

  /// Configuración actual.
  BandConfig get config => _config;

  /// Sustituye la configuración y la guarda.
  void set(BandConfig config) {
    if (config == _config) {
      return;
    }
    _config = config;
    unawaited(_preferences.setBandConfig(config));
    notifyListeners();
  }

  /// Enciende o silencia un canal.
  void toggleChannel(BandChannel channel) => set(
    _config.withChannel(
      channel,
      _config.mixOf(channel).copyWith(enabled: !_config.isOn(channel)),
    ),
  );

  /// Fija el volumen (0-1) de un canal.
  void setVolume(BandChannel channel, double volume) => set(
    _config.withChannel(
      channel,
      _config.mixOf(channel).copyWith(volume: volume.clamp(0.0, 1.0)),
    ),
  );

  /// Aplica un atajo de mezcla (banda completa, solo ritmo…).
  void applyMode(BandMode mode) => set(applyBandMode(_config, mode));

  /// Vuelve a los valores de fábrica.
  void reset() => set(const BandConfig());

  /// Todos los canales con su ajuste (para pintar el mezclador).
  Map<BandChannel, ChannelMix> get mix => _config.mix;
}
