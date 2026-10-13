import 'dart:math' as math;
import 'dart:typed_data';

/// Puerta que impide que el micrófono oiga lo que suena por el altavoz.
///
/// Cuando la app reproduce un acorde o una nota, el micrófono del mismo
/// teléfono lo recoge y el detector lo tomaría por la guitarra. La puerta
/// descarta el audio de entrada mientras suena la reproducción y un rato
/// después, hasta que el eco de la habitación se apaga:
///
/// * mientras dura el sonido ([playbackStarted]) todo se descarta y se mide
///   el nivel más alto con el que el altavoz llega al micrófono;
/// * pasado el sonido hay una cola mínima ([minTail], cubre la latencia de
///   salida) y después la puerta se abre en cuanto el nivel baja de
///   [releaseRatio] veces ese máximo, o al llegar a [maxTail];
/// * una reproducción nueva con la puerta cerrada solo alarga el silencio.
///
/// Así la cola se adapta sola: una sala con mucho eco o un volumen alto
/// esperan más, y una guitarra tocada justo después del sonido pasa en cuanto
/// el altavoz ha callado de verdad.
class PlaybackEchoGate {
  /// Crea la puerta; [clock] permite controlar el tiempo en los tests.
  PlaybackEchoGate({
    this.minTail = const Duration(milliseconds: 250),
    this.maxTail = const Duration(milliseconds: 1000),
    this.releaseRatio = 0.3,
    this.noiseFloor = 0.004,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// Cola mínima tras el sonido (latencia de salida del altavoz).
  final Duration minTail;

  /// Cola máxima tras el sonido, aunque el eco no haya bajado.
  final Duration maxTail;

  /// Fracción del nivel máximo bajo la que se considera apagado el eco.
  final double releaseRatio;

  /// Nivel (RMS) por debajo del cual no hay nada que escuchar.
  final double noiseFloor;

  final DateTime Function() _clock;

  DateTime? _until;
  double _peak = 0;

  /// Indica si la puerta está descartando audio.
  bool get isMuting => _until != null;

  /// Avisa de que va a sonar algo durante [audible] desde este instante.
  void playbackStarted(Duration audible) {
    final DateTime end = _clock().add(audible);
    final DateTime? current = _until;
    if (current == null) {
      _peak = 0;
      _until = end;
    } else if (end.isAfter(current)) {
      _until = end;
    }
  }

  /// Dice si un bloque con nivel [rms] viene de la guitarra (`true`) o del
  /// altavoz del propio teléfono (`false`, hay que descartarlo).
  bool admits(double rms) {
    final DateTime? until = _until;
    if (until == null) {
      return true;
    }
    final DateTime now = _clock();
    if (now.isBefore(until)) {
      _peak = math.max(_peak, rms);
      return false;
    }
    final Duration elapsed = now.difference(until);
    final bool echoFading = rms <= math.max(noiseFloor, _peak * releaseRatio);
    if (elapsed < minTail || (elapsed < maxTail && !echoFading)) {
      return false;
    }
    _until = null;
    return true;
  }

  /// Duración audible de [samples]: hasta la última muestra que supera
  /// [floor] (relativo al máximo). La cola de una cuerda que se apaga no
  /// obliga a callar la guitarra.
  static Duration audibleLength(
    Float64List samples,
    int sampleRate, {
    double floor = 0.03,
  }) {
    double peak = 0;
    for (final double value in samples) {
      peak = math.max(peak, value.abs());
    }
    final double threshold = peak * floor;
    int last = samples.length;
    while (last > 0 && samples[last - 1].abs() <= threshold) {
      last--;
    }
    return Duration(
      microseconds: last * Duration.microsecondsPerSecond ~/ sampleRate,
    );
  }
}
