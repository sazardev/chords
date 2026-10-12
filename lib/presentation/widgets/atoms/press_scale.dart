import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// Encoge ligeramente el contenido mientras se mantiene pulsado.
///
/// Escucha el puntero sin consumirlo, así que convive con `InkWell` y
/// `GestureDetector` y da una respuesta táctil expresiva a las tarjetas.
class PressScale extends StatefulWidget {
  /// Crea el envoltorio.
  const PressScale({required this.child, super.key, this.scale = 0.97});

  /// Contenido interactivo.
  final Widget child;

  /// Escala al pulsar.
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) => _set(true),
    onPointerUp: (_) => _set(false),
    onPointerCancel: (_) => _set(false),
    child: AnimatedScale(
      scale: _pressed ? widget.scale : 1,
      duration: kMotionFast,
      curve: kSpringCurve,
      child: widget.child,
    ),
  );
}
