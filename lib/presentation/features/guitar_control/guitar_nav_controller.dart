import 'dart:async';

import 'package:chords/config/route_paths.dart';
import 'package:chords/domain/audio/entities/guitar_nav_slot.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_sink.dart';
import 'package:chords/presentation/features/guitar_control/guitar_navigation.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/foundation.dart';

/// Abre o cierra el micrófono del modo guitarra.
typedef GuitarMicSwitch = Future<void> Function({required bool open});

/// Modo guitarra global: el menú que lleva a cualquier parte de la app.
///
/// Mientras el modo está encendido (ajuste `guitarBrowse`) el micrófono se
/// mantiene abierto y un panel fijo sustituye a la barra de navegación en
/// toda la app. Tocar una nota aguda (más allá del traste 14 de la 1ª cuerda)
/// abre el menú y volver a tocarla lo cierra; con el menú abierto cada nota
/// elige una opción (`GuitarNavSlot`) y el foco vuelve a la pantalla. Si nadie
/// toca nada, el menú se cierra solo tras [idleTimeout].
class GuitarNavController extends ChangeNotifier implements GuitarNavSink {
  /// Crea el menú sobre los [settings]; [micSwitch] abre y cierra el
  /// micrófono al encender y apagar el modo.
  ///
  /// [clock] permite controlar el tiempo en las pruebas.
  GuitarNavController(
    this._settings,
    this._micSwitch, {
    DateTime Function()? clock,
    this.idleTimeout = const Duration(seconds: 20),
  }) : _clock = clock ?? DateTime.now {
    _wasActive = active;
    _settings.addListener(_onSettings);
    if (_wasActive) {
      // El micrófono lo crea quien construye el menú justo después.
      scheduleMicrotask(() => unawaited(_micSwitch(open: true)));
    }
  }

  final SettingsController _settings;
  final GuitarMicSwitch _micSwitch;
  final DateTime Function() _clock;

  /// Tiempo sin tocar nada tras el que el menú se cierra solo.
  final Duration idleTimeout;

  /// Enrutador que ejecuta los destinos; su ruta marca el destino actual.
  GuitarNavigation? navigation;

  bool _menuOpen = false;
  bool _wasActive = false;
  DateTime _lastActivity = DateTime.fromMillisecondsSinceEpoch(0);

  /// Rutas de los destinos del menú.
  static const Map<GuitarNavSlot, String> paths = <GuitarNavSlot, String>{
    GuitarNavSlot.home: kHomePath,
    GuitarNavSlot.learn: kLearnPath,
    GuitarNavSlot.chords: kChordsPath,
    GuitarNavSlot.game: kGamePath,
    GuitarNavSlot.live: kLivePath,
    GuitarNavSlot.settings: kSettingsPath,
    GuitarNavSlot.profile: kProfilePath,
  };

  @override
  bool get active => _settings.guitarBrowse && _settings.guitarControl;

  @override
  bool get menuOpen => _menuOpen;

  /// Abre el menú.
  void openMenu() {
    if (_menuOpen || !active) {
      return;
    }
    _menuOpen = true;
    _lastActivity = _clock();
    notifyListeners();
  }

  /// Cierra el menú y devuelve el foco a la pantalla.
  void closeMenu() {
    if (!_menuOpen) {
      return;
    }
    _menuOpen = false;
    notifyListeners();
  }

  /// Ejecuta la opción [slot] y cierra el menú.
  void select(GuitarNavSlot slot) {
    closeMenu();
    switch (slot) {
      case GuitarNavSlot.close:
        return;
      case GuitarNavSlot.off:
        unawaited(_settings.setGuitarBrowse(value: false));
      case GuitarNavSlot.back:
        navigation?.back();
      case GuitarNavSlot.home ||
          GuitarNavSlot.learn ||
          GuitarNavSlot.chords ||
          GuitarNavSlot.game ||
          GuitarNavSlot.live ||
          GuitarNavSlot.settings ||
          GuitarNavSlot.profile:
        navigation?.go(paths[slot]!);
    }
  }

  @override
  void onWake() => _menuOpen ? closeMenu() : openMenu();

  @override
  void onMenuNote(int pitchClass) {
    final GuitarNavSlot? slot = GuitarNavSlot.ofPitchClass(pitchClass);
    if (slot != null) {
      select(slot);
    }
  }

  @override
  void tick(DateTime now) {
    if (_menuOpen && now.difference(_lastActivity) > idleTimeout) {
      closeMenu();
    }
  }

  void _onSettings() {
    final bool isActive = active;
    if (isActive == _wasActive) {
      return;
    }
    _wasActive = isActive;
    if (isActive) {
      unawaited(_micSwitch(open: true));
    } else {
      _menuOpen = false;
      unawaited(_micSwitch(open: false));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettings);
    super.dispose();
  }
}
