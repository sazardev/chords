import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';

/// Caso de uso: evalúa si el micrófono está tocando el acorde objetivo.
///
/// Acumula las clases de tono detectadas y calcula la proporción de notas del
/// acorde objetivo que se han escuchado.
class EvaluateChordMatchUseCase {
  /// Crea el caso de uso.
  const EvaluateChordMatchUseCase();

  /// Proporción (0-1) de notas del acorde objetivo ya detectadas.
  double call(List<String> targetNotes, Set<int> detected) {
    if (targetNotes.isEmpty || detected.isEmpty) {
      return 0;
    }
    int hits = 0;
    for (final String note in targetNotes) {
      if (detected.contains(_pitchClassOf(note))) {
        hits++;
      }
    }
    return hits / targetNotes.length;
  }

  /// `true` si la lectura es lo bastante estable para puntuar.
  bool isUsable(PitchReading reading) => reading.isReliable;

  /// Resultado del juego a partir de la proporción detectada.
  GameResult resultFor(double ratio) {
    if (ratio >= 0.99) {
      return const GameResult.success();
    }
    if (ratio >= 0.5) {
      return GameResult(outcome: GameOutcome.partial, matchedRatio: ratio);
    }
    return const GameResult.fail();
  }

  int _pitchClassOf(String note) {
    const List<String> names = <String>[
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];
    return names.indexOf(note);
  }
}
