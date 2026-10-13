import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:flutter/foundation.dart';

/// Lo que ve la interfaz de la escucha de órdenes de guitarra.
@immutable
class GuitarListenState {
  /// Crea el estado.
  const GuitarListenState({
    this.armed = false,
    this.hearing = false,
    this.level = 0,
    this.lastFired,
    this.listening = false,
    this.headline,
    this.actions = const <GuitarAction>[],
  });

  /// Ya se aceptan órdenes: pasó el silencio previo.
  final bool armed;

  /// Llega sonido del micrófono.
  final bool hearing;

  /// Nivel de entrada (0-1).
  final double level;

  /// Última orden reconocida, para animar su tarjeta.
  final GuitarCommand? lastFired;

  /// El oyente está suscrito al micrófono.
  final bool listening;

  /// Línea de contexto de la pantalla activa (p. ej. el juego elegido).
  final String? headline;

  /// Acciones de la pantalla activa (vacío si no hay ninguna).
  final List<GuitarAction> actions;

  /// `true` si la guitarra puede mandar ahora mismo.
  bool get ready => armed && hearing;
}
