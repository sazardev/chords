import 'package:flutter/animation.dart';

/// Duraciones del sistema de movimiento expresivo.
/// Duración corta (micro-interacciones).
const Duration kMotionFast = Duration(milliseconds: 150);

/// Duración media (transiciones de pantalla).
const Duration kMotionMedium = Duration(milliseconds: 280);

/// Duración larga (expresiva/hero).
const Duration kMotionSlow = Duration(milliseconds: 450);

/// Curva de énfasis (aceleración suave y desaceleración marcada).
const Curve kEmphasizedCurve = Cubic(0.2, 0, 0, 1);

/// Curva estándar para transiciones de entrada/salida.
const Curve kStandardCurve = Cubic(0.2, 0, 0, 1);
