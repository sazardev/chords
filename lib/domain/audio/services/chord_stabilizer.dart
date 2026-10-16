import 'dart:math' as math;

import 'package:chords/domain/audio/entities/chord_candidate.dart';

/// Histéresis sobre los candidatos: evita que el acorde parpadee.
///
/// Entre C, Cmaj7 y Am7 las puntuaciones son parecidas y bailan de trama en
/// trama. El estabilizador mantiene el acorde actual y solo cambia cuando el
/// aspirante lo supera con claridad y se mantiene primero unas tramas
/// seguidas (pocas si la ventaja es grande, más si es corta o si el acorde es
/// raro). Si la confianza
/// se queda baja varias tramas seguidas, suelta el acorde.
class ChordStabilizer {
  /// Crea el estabilizador con los umbrales indicados.
  ChordStabilizer({
    this.switchMargin = 0.06,
    this.fastFrames = 2,
    this.slowFrames = 5,
    this.minConfidence = 0.3,
    this.dropFrames = 4,
  });

  /// Ventaja de puntuación que permite un cambio rápido.
  final double switchMargin;

  /// Tramas seguidas para cambiar con ventaja clara.
  final int fastFrames;

  /// Tramas seguidas para cambiar con ventaja corta.
  final int slowFrames;

  /// Confianza mínima de un candidato para sostener un acorde.
  final double minConfidence;

  /// Tramas seguidas sin confianza tras las cuales se suelta el acorde.
  final int dropFrames;

  ChordCandidate? _current;
  ChordCandidate? _challenger;
  int _streak = 0;
  int _weak = 0;

  /// Acorde actual sin refrescar (el último confirmado).
  ChordCandidate? get current => _current;

  /// Olvida el acorde actual.
  void reset() {
    _current = null;
    _challenger = null;
    _streak = 0;
    _weak = 0;
  }

  /// Procesa los candidatos de una trama y devuelve el acorde estable.
  ChordCandidate? update(List<ChordCandidate> ranked) {
    if (ranked.isEmpty || ranked.first.confidence < minConfidence) {
      return _weakFrame();
    }
    _weak = 0;
    final ChordCandidate top = ranked.first;
    final ChordCandidate? held = _current;
    if (held == null || top == held) {
      _current = top;
      _challenger = null;
      _streak = 0;
      return top;
    }
    final ChordCandidate? incumbent = _find(ranked, held);
    final double lead = top.score - (incumbent?.score ?? 0);
    _streak = top == _challenger ? _streak + 1 : 1;
    _challenger = top;
    // Un acorde raro necesita más tramas: en un cambio, la mezcla de los dos
    // acordes se parece a una extensión (C + G ≈ Em9) durante un instante.
    final int rarity = 5 - top.quality.popularity;
    final int needed = lead >= switchMargin
        ? math.min(slowFrames, fastFrames + rarity)
        : slowFrames;
    if (_streak >= needed) {
      _current = top;
      _challenger = null;
      _streak = 0;
      return top;
    }
    return incumbent ?? held;
  }

  ChordCandidate? _weakFrame() {
    _weak++;
    if (_weak >= dropFrames) {
      _current = null;
      _challenger = null;
      _streak = 0;
    }
    return _current;
  }

  ChordCandidate? _find(List<ChordCandidate> ranked, ChordCandidate wanted) {
    for (final ChordCandidate candidate in ranked) {
      if (candidate == wanted) {
        return candidate;
      }
    }
    return null;
  }
}
