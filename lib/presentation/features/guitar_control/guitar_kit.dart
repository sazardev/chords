import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_mic_keeper.dart';
import 'package:chords/presentation/features/guitar_control/guitar_nav_controller.dart';
import 'package:chords/presentation/features/settings/settings_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Las tres piezas del control con la guitarra, ya conectadas entre sí.
///
/// El [listener] reconoce las notas, el [keeper] mantiene el micrófono abierto
/// y [nav] es el menú global; todos siguen los ajustes de guitarra.
class GuitarKit {
  /// Construye las piezas sobre [audio] y los [settings].
  ///
  /// [onFired] da un aviso táctil al reconocer una nota; [clock] gobierna el
  /// tiempo en las pruebas.
  factory GuitarKit(
    AudioRepository audio,
    SettingsController settings, {
    VoidCallback? onFired,
    DateTime Function()? clock,
  }) {
    late final GuitarMicKeeper keeper;
    final GuitarNavController nav = GuitarNavController(
      settings,
      ({required bool open}) => open ? keeper.open() : keeper.close(),
      clock: clock,
    );
    final GuitarCommandListener listener = GuitarCommandListener(
      audio,
      clock: clock,
      onFired: onFired,
      nav: nav,
    )..enabled = settings.guitarControl;
    settings.addListener(() => listener.enabled = settings.guitarControl);
    keeper = GuitarMicKeeper(audio, listener);
    return GuitarKit._(listener, keeper, nav);
  }

  GuitarKit._(this.listener, this.keeper, this.nav);

  /// Oyente de las órdenes y notas de la guitarra.
  final GuitarCommandListener listener;

  /// Guardián del micrófono abierto.
  final GuitarMicKeeper keeper;

  /// Menú global del modo guitarra.
  final GuitarNavController nav;

  /// Proveedores para el árbol de widgets.
  List<SingleChildWidget> get providers => <SingleChildWidget>[
    ChangeNotifierProvider<GuitarCommandListener>.value(value: listener),
    ChangeNotifierProvider<GuitarNavController>.value(value: nav),
    Provider<GuitarMicKeeper>.value(value: keeper),
  ];
}
