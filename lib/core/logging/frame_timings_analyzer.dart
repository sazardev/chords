/// Resumen del análisis de un lote de frames.
///
/// [total] es el número de frames, [slow] los que superan el presupuesto,
/// [frozen] los congelados, [worst] el frame más lento y [average] la media.
typedef FrameReport = ({
  int total,
  int slow,
  int frozen,
  Duration worst,
  Duration average,
});

/// Analiza duraciones de frame para detectar pérdidas de fluidez.
///
/// Es puro y sin Flutter: recibe una lista de duraciones (una por frame) y
/// devuelve un resumen, de modo que la lógica de detección se testea sin
/// necesidad del motor de render.
class FrameTimingsAnalyzer {
  /// Crea el analizador con los presupuestos indicados.
  const FrameTimingsAnalyzer({
    this.frameBudget = const Duration(milliseconds: 16),
    this.frozenBudget = const Duration(milliseconds: 400),
  });

  /// Presupuesto por frame (~60 Hz). Por encima se considera lento.
  final Duration frameBudget;

  /// Presupuesto de congelación: un frame muy por encima del budget.
  final Duration frozenBudget;

  /// Resume un lote de duraciones de frame.
  ///
  /// Devuelve el total de frames, cuántos superan [frameBudget] (`slow`),
  /// cuántos superan [frozenBudget] (`frozen`), el peor frame (`worst`) y la
  /// media (`average`).
  FrameReport analyze(List<Duration> durations) {
    if (durations.isEmpty) {
      return (
        total: 0,
        slow: 0,
        frozen: 0,
        worst: Duration.zero,
        average: Duration.zero,
      );
    }
    int slow = 0;
    int frozen = 0;
    Duration worst = Duration.zero;
    Duration total = Duration.zero;
    for (final Duration value in durations) {
      total += value;
      if (value > worst) {
        worst = value;
      }
      if (value > frameBudget) {
        slow++;
      }
      if (value > frozenBudget) {
        frozen++;
      }
    }
    return (
      total: durations.length,
      slow: slow,
      frozen: frozen,
      worst: worst,
      average: Duration(microseconds: total.inMicroseconds ~/ durations.length),
    );
  }
}
