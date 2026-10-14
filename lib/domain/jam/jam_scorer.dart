import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:meta/meta.dart';

/// Cómo fue un compás tocado con el micrófono.
enum BarGrade {
  /// No se oyó nada.
  silent,

  /// Se oyeron sobre todo notas fuera del acorde.
  miss,

  /// Algo del acorde, pero incompleto o con notas de más.
  good,

  /// Las notas del acorde, limpias.
  perfect,
}

/// Marcador de una sesión de jam al estilo de los juegos de ritmo.
///
/// Cada compás bien tocado suma puntos y alarga la racha; la racha sube el
/// multiplicador (×1 → ×4) y un fallo lo reinicia.
@immutable
class JamScore {
  /// Crea el marcador.
  const JamScore({
    this.points = 0,
    this.streak = 0,
    this.bestStreak = 0,
    this.perfect = 0,
    this.good = 0,
    this.missed = 0,
  });

  /// Puntos acumulados.
  final int points;

  /// Compases seguidos acertados.
  final int streak;

  /// Mejor racha de la sesión.
  final int bestStreak;

  /// Compases perfectos.
  final int perfect;

  /// Compases buenos.
  final int good;

  /// Compases fallados o en silencio.
  final int missed;

  /// Multiplicador actual: ×1 y uno más cada 4 aciertos seguidos, hasta ×4.
  int get multiplier => (1 + streak ~/ 4).clamp(1, 4);

  /// Compases evaluados.
  int get total => perfect + good + missed;

  /// Precisión (0-1): un perfecto vale 1 y un bueno, medio.
  double get accuracy => total == 0 ? 0 : (perfect + good * 0.5) / total;

  /// Estrellas de 0 a 3 según la precisión.
  int get stars => switch (accuracy) {
    >= 0.85 => 3,
    >= 0.6 => 2,
    >= 0.3 => 1,
    _ => 0,
  };

  /// Suma un compás con nota [grade].
  JamScore record(BarGrade grade) {
    final bool hit = grade == BarGrade.good || grade == BarGrade.perfect;
    final int base = switch (grade) {
      BarGrade.perfect => 100,
      BarGrade.good => 50,
      _ => 0,
    };
    final int nextStreak = hit ? streak + 1 : 0;
    return JamScore(
      points: points + base * multiplier,
      streak: nextStreak,
      bestStreak: nextStreak > bestStreak ? nextStreak : bestStreak,
      perfect: perfect + (grade == BarGrade.perfect ? 1 : 0),
      good: good + (grade == BarGrade.good ? 1 : 0),
      missed: missed + (hit ? 0 : 1),
    );
  }
}

/// Califica un compás según las notas que oyó el micrófono.
///
/// [heard] cuenta cuántas lecturas fiables cayeron en cada clase de tono.
/// Un compás es perfecto si se oyen al menos dos notas del acorde y casi
/// nada fuera; bueno si al menos una nota del acorde domina.
BarGrade gradeBar(ChordSymbol chord, Map<int, int> heard) {
  final int total = heard.values.fold<int>(0, (int a, int b) => a + b);
  if (total == 0) {
    return BarGrade.silent;
  }
  final Set<int> tones = chord.pitchClasses;
  int inside = 0;
  int distinct = 0;
  heard.forEach((int pitchClass, int count) {
    if (tones.contains(pitchClass)) {
      inside += count;
      distinct++;
    }
  });
  final double ratio = inside / total;
  if (distinct >= 2 && ratio >= 0.75) {
    return BarGrade.perfect;
  }
  if (ratio >= 0.5) {
    return BarGrade.good;
  }
  return BarGrade.miss;
}
