import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Estrellas (0-3) que se ganan con un porcentaje de acierto.
int starsForPercent(int percent) {
  if (percent >= 90) {
    return 3;
  }
  if (percent >= 70) {
    return 2;
  }
  return percent >= 40 ? 1 : 0;
}

/// Marcador de una partida: aciertos, racha y puntos.
@immutable
class MiniGameScore {
  /// Crea el marcador.
  const MiniGameScore({
    this.correct = 0,
    this.total = 0,
    this.streak = 0,
    this.bestStreak = 0,
    this.points = 0,
  });

  /// Preguntas acertadas.
  final int correct;

  /// Preguntas respondidas.
  final int total;

  /// Aciertos seguidos en este momento.
  final int streak;

  /// Mejor racha de la partida.
  final int bestStreak;

  /// Puntos: 10 por acierto más un extra creciente por racha.
  final int points;

  /// Porcentaje de acierto (0-100).
  int get percent => total == 0 ? 0 : (correct * 100 / total).round();

  /// Estrellas ganadas (0-3).
  int get stars => starsForPercent(percent);

  /// Marcador tras una respuesta acertada o fallada.
  MiniGameScore record({required bool isCorrect}) {
    if (!isCorrect) {
      return MiniGameScore(
        correct: correct,
        total: total + 1,
        bestStreak: bestStreak,
        points: points,
      );
    }
    final int nextStreak = streak + 1;
    return MiniGameScore(
      correct: correct + 1,
      total: total + 1,
      streak: nextStreak,
      bestStreak: math.max(bestStreak, nextStreak),
      points: points + 10 + math.min(nextStreak - 1, 5) * 2,
    );
  }
}
