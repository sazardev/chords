import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/chords/entities/game_outcome.dart';
import 'package:chords/domain/chords/entities/game_round.dart';

/// Caso de uso: evalúa si el micrófono está tocando el acorde objetivo.
///
/// Acumula las clases de tono detectadas y calcula la proporción de notas del
/// acorde objetivo que se han escuchado. Además sabe decir si el
/// reconocedor polifónico oyó, con seguridad, justo el acorde objetivo.
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

  /// `true` si [reading] reconoce con seguridad el acorde objetivo.
  ///
  /// Cuenta como el mismo acorde el que tiene exactamente las mismas notas
  /// (Am7 y C6 suenan igual), pero no uno que tenga notas de más o de menos.
  /// Es la prueba que no se deja engañar por los armónicos: solo da por
  /// buena la ronda si el cromagrama entero encaja con el acorde pedido.
  bool recognizes(
    List<String> targetNotes,
    ChordReading reading, {
    double minConfidence = 0.55,
  }) {
    final ChordCandidate? chord = reading.chord;
    if (chord == null ||
        chord.confidence < minConfidence ||
        targetNotes.isEmpty) {
      return false;
    }
    final Set<int> target = targetNotes.map(_pitchClassOf).toSet();
    final Set<int> heard = chord.pitchClasses;
    return target.length == heard.length && target.containsAll(heard);
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
