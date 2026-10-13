import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:flutter/material.dart';

/// Una acción que la pantalla ofrece y se activa tocando una cuerda al aire.
@immutable
class GuitarAction {
  /// Crea la acción de [command] con su etiqueta, icono y efecto.
  const GuitarAction({
    required this.command,
    required this.label,
    required this.icon,
    required this.onTrigger,
    this.emphasized = false,
  });

  /// Cuerda (y orden) que la activa.
  final GuitarCommand command;

  /// Texto que ve la persona (p. ej. "Continuar").
  final String label;

  /// Icono de la acción.
  final IconData icon;

  /// Se ejecuta al tocar la cuerda o al pulsar la tarjeta.
  final VoidCallback onTrigger;

  /// Si es la acción recomendada en este momento (se pinta más fuerte).
  final bool emphasized;

  /// Identifica lo que se ve de la acción, sin mirar su efecto.
  String get signature => '${command.name}:$label:$emphasized';
}
