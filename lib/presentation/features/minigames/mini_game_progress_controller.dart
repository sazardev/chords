import 'package:chords/core/analytics/analytics.dart' show analytics;
import 'package:chords/core/analytics/minigame_analytics_events.dart';
import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/mini_game_score.dart';
import 'package:chords/domain/preferences/repositories/progress_preferences.dart';
import 'package:flutter/foundation.dart';

/// Progreso de los minijuegos: mejor resultado y estrellas de cada uno.
///
/// Responsabilidad única: leer y guardar el récord de cada pareja juego-nivel
/// y registrar el final de una partida. Los controladores de juego lo llaman
/// al terminar, sin saber cómo se persiste.
class MiniGameProgressController extends ChangeNotifier {
  /// Crea el controlador de progreso.
  MiniGameProgressController(this._preferences);

  final ProgressPreferences _preferences;

  /// Total de estrellas posibles (tres por juego).
  int get maxStars => MiniGameKind.values.length * 3;

  /// Estrellas ganadas entre todos los juegos.
  int get totalStars => MiniGameKind.values.fold<int>(
    0,
    (int sum, MiniGameKind kind) => sum + starsFor(kind),
  );

  /// Mejor porcentaje de acierto (0-100) de un juego en un nivel.
  int bestFor(MiniGameKind kind, MiniGameLevel level) =>
      _preferences.miniGameBest(_key(kind, level));

  /// Mejores estrellas (0-3) de un juego entre todos los niveles.
  int starsFor(MiniGameKind kind) => MiniGameLevel.values
      .map((MiniGameLevel level) => starsForPercent(bestFor(kind, level)))
      .fold<int>(0, (int best, int stars) => stars > best ? stars : best);

  /// Anota el inicio de una partida.
  void started(MiniGameKind kind, MiniGameLevel level) {
    appLogger.info(
      'minijuego: ${kind.id} (${level.id}) iniciado',
      channel: LogChannel.game,
    );
    analytics.miniGameStarted(game: kind.id, level: level.id);
  }

  /// Guarda el resultado; devuelve `true` si es un nuevo récord.
  Future<bool> finished(
    MiniGameKind kind,
    MiniGameLevel level,
    MiniGameScore score,
  ) async {
    final bool isRecord = score.percent > bestFor(kind, level);
    await _preferences.saveMiniGameBest(_key(kind, level), score.percent);
    appLogger.info(
      'minijuego: ${kind.id} (${level.id}) terminado — '
      '${score.correct}/${score.total} (${score.percent}%)',
      channel: LogChannel.game,
    );
    analytics.miniGameFinished(
      game: kind.id,
      level: level.id,
      percent: score.percent,
      stars: score.stars,
      correct: score.correct,
      total: score.total,
      bestStreak: score.bestStreak,
    );
    notifyListeners();
    return isRecord && score.percent > 0;
  }

  String _key(MiniGameKind kind, MiniGameLevel level) =>
      '${kind.id}_${level.id}';
}
