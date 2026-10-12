import 'package:meta/meta.dart';

/// Una ronda de "arma el acorde": poner los dedos de un acorde dado.
@immutable
class ChordRound {
  /// Crea la ronda.
  const ChordRound({required this.chordId, required this.variantIndex});

  /// Acorde que hay que formar.
  final String chordId;

  /// Posición de referencia del acorde.
  final int variantIndex;
}

/// Trastes que muestra el tablero de "arma el acorde".
const int kBuildFrets = 5;

/// Compara lo colocado con una posición.
///
/// Devuelve los índices (0 = sexta) de las cuerdas que no coinciden; vacío si
/// la posición es correcta.
List<int> wrongStrings(List<int> placed, List<int> target) => <int>[
  for (int s = 0; s < target.length; s++)
    if (placed[s] != target[s]) s,
];
