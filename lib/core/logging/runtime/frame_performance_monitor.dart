import 'package:chords/core/logging/app_logger.dart';
import 'package:chords/core/logging/frame_timings_analyzer.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:flutter/scheduler.dart';

/// Monitor de fluidez que detecta frames lentos y congelados.
///
/// Se engancha a los temporizadores de frames de Flutter y, cuando detecta
/// jank, lo registra en el canal de rendimiento con las estadísticas del lote.
/// El análisis en sí lo delega en [FrameTimingsAnalyzer], que es puro.
class FramePerformanceMonitor {
  /// Crea el monitor para el logger indicado.
  FramePerformanceMonitor(this._logger, {FrameTimingsAnalyzer? analyzer})
    : _analyzer = analyzer ?? const FrameTimingsAnalyzer();

  final AppLogger _logger;
  final FrameTimingsAnalyzer _analyzer;
  bool _attached = false;

  /// Registra el callback de temporizadores de frames.
  void start() {
    if (_attached) {
      return;
    }
    _attached = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  /// Detiene el monitor y libera el callback.
  void stop() {
    if (!_attached) {
      return;
    }
    _attached = false;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
  }

  void _onTimings(List<FrameTiming> timings) {
    final List<Duration> spans = timings
        .map((FrameTiming timing) => timing.totalSpan)
        .toList(growable: false);
    final FrameReport report = _analyzer.analyze(spans);
    if (report.slow == 0 && report.frozen == 0) {
      return;
    }
    if (report.frozen > 0) {
      _logger.error(
        'fluidez: ${report.frozen} congelados de ${report.total} frames',
        channel: LogChannel.performance,
        context: _contextOf(report),
      );
      return;
    }
    _logger.warning(
      'fluidez: ${report.slow} frames lentos de ${report.total}',
      channel: LogChannel.performance,
      context: _contextOf(report),
    );
  }

  Map<String, Object?> _contextOf(FrameReport report) => <String, Object?>{
    'worstMs': report.worst.inMilliseconds,
    'avgMs': report.average.inMilliseconds,
    'slow': report.slow,
    'frozen': report.frozen,
  };
}
