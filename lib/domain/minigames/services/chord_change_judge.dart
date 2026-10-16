/// Juez de un cambio de acorde: decide si ya suena el acorde pedido.
///
/// Acumula las notas oídas desde que apareció el acorde y exige dos cosas: que
/// suene una proporción mínima de las notas del acorde y que estén las notas
/// nuevas, las que no tenía el acorde anterior. Sin lo segundo, el eco del
/// acorde que aún se apaga daría por buena una mano que no se ha movido
/// (`Am` tras `C` comparte `C` y `E`).
class ChordChangeJudge {
  /// Crea el juez del acorde de notas [target] tras el de notas [previous].
  ChordChangeJudge({
    required Set<int> target,
    required this.minRatio,
    Set<int> previous = const <int>{},
  }) : target = Set<int>.unmodifiable(target),
       _fresh = target.difference(previous);

  /// Clases de tono del acorde pedido.
  final Set<int> target;

  /// Proporción mínima de notas del acorde que tienen que sonar (0-1).
  final double minRatio;

  final Set<int> _fresh;
  final Set<int> _heard = <int>{};

  /// Notas del acorde pedido oídas hasta ahora.
  Set<int> get heardNotes => _heard.intersection(target);

  /// Proporción de notas del acorde oídas (0-1).
  double get ratio => target.isEmpty ? 0 : heardNotes.length / target.length;

  /// `true` si el acorde pedido ya suena.
  bool get isMatch =>
      target.isNotEmpty && ratio >= minRatio && heardNotes.containsAll(_fresh);

  /// Anota las notas oídas en un instante.
  void feed(Set<int> detected) => _heard.addAll(detected);
}
