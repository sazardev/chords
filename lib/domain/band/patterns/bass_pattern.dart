import 'package:meta/meta.dart';

/// Letras válidas de una pista de bajo.
///
/// Cada carácter es un paso de la rejilla:
///
/// * `R` raíz, `5` quinta, `O` octava, `3` tercera, `7` séptima, `6` sexta,
///   `F` quinta por debajo de la raíz, `u` raíz una octava abajo;
/// * `a` nota de aproximación cromática a la raíz del acorde que viene;
/// * `r` raíz apagada (fantasma, muy corta);
/// * `W` nota del bajo caminante (solo con `walking`);
/// * `-` la nota anterior sigue sonando y `.` silencio (corta la nota).
const String kBassTokens = 'R5O376FuarW-.';

/// Línea de bajo de un compás.
///
/// Con [walking] el bajo camina a negras (jazz y blues): los pasos de
/// [notation] solo marcan dónde caen las negras (`W`) y las notas salen del
/// acorde y del siguiente.
@immutable
class BassPattern {
  /// Crea el patrón.
  const BassPattern(this.notation, {this.walking = false});

  /// Una nota por negra que camina entre acordes.
  const BassPattern.walk(this.notation) : walking = true;

  /// Pasos de la rejilla (`R---5---R---5---`).
  final String notation;

  /// `true` si es un bajo caminante.
  final bool walking;

  /// Pasos del compás.
  int get steps => notation.length;
}
