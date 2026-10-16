import 'package:meta/meta.dart';

/// Letras válidas de una pista de guitarra.
///
/// * `D` abajo, `U` arriba, `d` abajo fantasma;
/// * `M` palm-mute, `X` chop seco, `B` nota grave, `P` power chord,
///   `p` power chord con palm-mute, `R` rasgueado de flamenco;
/// * `-` el golpe sigue sonando y `.` silencio.
const String kGuitarTokens = 'DUdMXBPpR-.';

/// Letras válidas de una pista de teclado o de vientos.
///
/// * `X` acorde largo, `x` acorde medio, `s` acorde corto (stab) y `g`
///   acorde fantasma;
/// * `-` el acorde sigue sonando y `.` silencio.
const String kChordTokens = 'Xxsg-.';

/// Compás de acompañamiento armónico (guitarra, teclado o vientos).
@immutable
class ChordPattern {
  /// Crea el patrón.
  const ChordPattern(this.notation);

  /// Pasos de la rejilla (`D-DU-UDU` ampliado a semicorcheas).
  final String notation;

  /// Pasos del compás.
  int get steps => notation.length;

  /// Letra del paso [step], o `-` si cae fuera.
  String at(int step) =>
      step >= 0 && step < notation.length ? notation[step] : '-';
}
