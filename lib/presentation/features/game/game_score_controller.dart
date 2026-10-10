import 'dart:async' show unawaited;

import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';
import 'package:chords/domain/preferences/repositories/preferences_repository.dart';
import 'package:flutter/foundation.dart';

/// Puntuación y récord del modo juego.
///
/// Responsabilidad única: acumular puntos y racha a partir del resultado de
/// cada ronda y persistir la mejor puntuación.
class GameScoreController extends ChangeNotifier {
  /// Crea el controlador de puntuación.
  GameScoreController(this._preferences);

  final PreferencesRepository _preferences;

  int _score = 0;
  int _streak = 0;
  int _best = 0;

  /// Puntuación de la partida.
  int get score => _score;

  /// Racha de aciertos.
  int get streak => _streak;

  /// Mejor puntuación histórica.
  int get bestScore => _best;

  /// Carga la mejor puntuación persistida.
  void loadBestScore() {
    _best = _preferences.bestScore;
    notifyListeners();
  }

  /// Reinicia la puntuación y la racha para una nueva partida.
  void reset() {
    _score = 0;
    _streak = 0;
    notifyListeners();
  }

  /// Aplica el resultado de una ronda a la puntuación y la racha.
  void recognize(GameResult result) {
    if (result.scored) {
      _score += result.outcome == GameOutcome.success ? 100 : 50;
      _streak++;
    } else {
      _streak = 0;
    }
    unawaited(_preferences.saveBestScore(_score));
    _best = _preferences.bestScore;
    notifyListeners();
  }
}
