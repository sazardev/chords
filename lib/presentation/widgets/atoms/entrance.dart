import 'package:chords/presentation/theme/app_motion.dart';
import 'package:flutter/material.dart';

/// Aparición animada: el contenido se desliza hacia arriba y se desvanece.
///
/// Con [index] se escalona respecto a sus vecinos para que las listas y los
/// paneles entren en cascada. Respeta la preferencia del sistema de reducir
/// animaciones.
class Entrance extends StatefulWidget {
  /// Crea la animación de entrada.
  const Entrance({
    required this.child,
    super.key,
    this.index = 0,
    this.offset = 24,
  });

  /// Contenido que aparece.
  final Widget child;

  /// Posición en la cascada (0 = primero).
  final int index;

  /// Desplazamiento vertical inicial en píxeles.
  final double offset;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  /// Retardo máximo para que las listas largas no tarden en mostrarse.
  static const int _maxStaggered = 8;

  @override
  void initState() {
    super.initState();
    final int steps = widget.index.clamp(0, _maxStaggered);
    final Duration delay = kMotionStagger * steps;
    final Duration total = kMotionEntrance + delay;
    _controller = AnimationController(vsync: this, duration: total);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: kEmphasizedCurve,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _progress,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => Opacity(
        opacity: _progress.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - _progress.value) * widget.offset),
          child: child,
        ),
      ),
    );
  }
}
