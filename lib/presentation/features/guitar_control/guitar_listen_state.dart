import 'package:chords/domain/audio/entities/guitar_command.dart';
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
  });

  /// Ya se aceptan órdenes: pasó el silencio previo.
  final bool armed;

  /// Llega sonido del micrófono.
  final bool hearing;

  /// Nivel de entrada (0-1).
  final double level;

  /// Última orden reconocida, para animar su tarjeta.
  final GuitarCommand? lastFired;

  /// `true` si la guitarra puede mandar ahora mismo.
  bool get ready => armed && hearing;
}
