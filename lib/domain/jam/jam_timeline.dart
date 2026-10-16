import 'package:meta/meta.dart';

/// En qué parte de la sesión cae una semicorchea.
enum CursorKind {
  /// Cuenta atrás.
  countIn,

  /// Tocando un compás de la pista.
  playing,

  /// Pasó el último compás.
  finished,
}

/// Posición de una semicorchea dentro de la sesión.
@immutable
class JamCursor {
  /// Crea la posición.
  const JamCursor(this.kind, {this.bar = 0, this.step = 0, this.countdown = 0});

  /// Dónde cae.
  final CursorKind kind;

  /// Compás de la pista (desde 0); 0 en la cuenta atrás.
  final int bar;

  /// Semicorchea dentro del compás (0-15 en 4/4, 0-11 en 3/4).
  final int step;

  /// Pulsos que faltan en la cuenta atrás (0 fuera de ella).
  final int countdown;

  @override
  bool operator ==(Object other) =>
      other is JamCursor &&
      other.kind == kind &&
      other.bar == bar &&
      other.step == step &&
      other.countdown == countdown;

  @override
  int get hashCode => Object.hash(kind, bar, step, countdown);

  @override
  String toString() => '$kind $bar:$step ($countdown)';
}

/// Traduce el número de semicorchea desde el arranque a una posición:
/// primero los compases de cuenta atrás y luego los de la pista.
@immutable
class JamTimeline {
  /// Crea la línea de tiempo.
  const JamTimeline({
    required this.stepsPerBar,
    required this.bars,
    required this.countInBars,
  });

  /// Semicorcheas por compás (16 o 12).
  final int stepsPerBar;

  /// Compases de la pista.
  final int bars;

  /// Compases de cuenta atrás.
  final int countInBars;

  /// Semicorcheas de la cuenta atrás.
  int get countInSteps => countInBars * stepsPerBar;

  /// Semicorcheas de toda la sesión (cuenta atrás incluida).
  int get totalSteps => countInSteps + bars * stepsPerBar;

  /// Posición de la semicorchea [tick].
  JamCursor cursorAt(int tick) {
    if (tick < countInSteps) {
      final int left = countInSteps - tick;
      return JamCursor(
        CursorKind.countIn,
        step: tick % stepsPerBar,
        countdown: (left + 3) ~/ 4,
      );
    }
    final int played = tick - countInSteps;
    final int bar = played ~/ stepsPerBar;
    if (bar >= bars) {
      return const JamCursor(CursorKind.finished);
    }
    return JamCursor(CursorKind.playing, bar: bar, step: played % stepsPerBar);
  }
}
