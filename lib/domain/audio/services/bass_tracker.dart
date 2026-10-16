import 'dart:typed_data';

/// Sigue cuál es la nota del bajo con una votación suavizada en el tiempo.
///
/// La nota más grave de cada trama puede fallar (un armónico, un golpe de
/// púa); votar entre varias tramas evita que el bajo cambie por una trama
/// mala y por tanto que el acorde cambie de raíz sin motivo.
class BassTracker {
  /// Crea el seguidor; [smoothing] es el peso del voto de la trama nueva y
  /// [minVote] el voto mínimo (0-1) para dar el bajo por conocido.
  BassTracker({this.smoothing = 0.5, this.minVote = 0.35});

  /// Peso de la trama nueva (0-1).
  final double smoothing;

  /// Voto mínimo para aceptar una nota como bajo.
  final double minVote;

  final Float64List _votes = Float64List(12);

  /// Nota (0-11) del bajo; -1 si no se distingue ninguna.
  int get bass {
    int best = -1;
    double top = minVote;
    for (int i = 0; i < 12; i++) {
      if (_votes[i] > top) {
        top = _votes[i];
        best = i;
      }
    }
    return best;
  }

  /// Olvida los votos.
  void reset() => _votes.fillRange(0, 12, 0);

  /// Registra la nota [pitchClass] (o -1 si la trama no tiene bajo).
  void update(int pitchClass) {
    for (int i = 0; i < 12; i++) {
      final double vote = i == pitchClass ? 1 : 0;
      _votes[i] = (1 - smoothing) * _votes[i] + smoothing * vote;
    }
  }
}
