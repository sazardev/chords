import 'package:chords/core/logging/frame_timings_analyzer.dart';
import 'package:test/test.dart';

/// Tests del análisis de fluidez por duración de frame.
void main() {
  group('FrameTimingsAnalyzer', () {
    test('un lote vacío devuelve un resumen a cero', () {
      const FrameTimingsAnalyzer analyzer = FrameTimingsAnalyzer();
      final FrameReport report = analyzer.analyze(const <Duration>[]);

      expect(report.total, 0);
      expect(report.slow, 0);
      expect(report.frozen, 0);
      expect(report.worst, Duration.zero);
    });

    test('clasifica frames lentos y congelados', () {
      const FrameTimingsAnalyzer analyzer = FrameTimingsAnalyzer();
      final FrameReport report = analyzer.analyze(const <Duration>[
        Duration(milliseconds: 5),
        Duration(milliseconds: 20),
        Duration(milliseconds: 500),
      ]);

      expect(report.total, 3);
      expect(report.slow, 2);
      expect(report.frozen, 1);
      expect(report.worst, const Duration(milliseconds: 500));
    });

    test('calcula el peor frame y la media', () {
      const FrameTimingsAnalyzer analyzer = FrameTimingsAnalyzer();
      final FrameReport report = analyzer.analyze(const <Duration>[
        Duration(milliseconds: 10),
        Duration(milliseconds: 20),
      ]);

      expect(report.slow, 1);
      expect(report.average, const Duration(milliseconds: 15));
    });

    test('respeta presupuestos personalizados', () {
      const FrameTimingsAnalyzer analyzer = FrameTimingsAnalyzer(
        frameBudget: Duration(milliseconds: 8),
      );

      final FrameReport report = analyzer.analyze(const <Duration>[
        Duration(milliseconds: 10),
      ]);

      expect(report.slow, 1);
    });
  });
}
