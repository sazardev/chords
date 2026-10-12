import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/services/fretboard.dart';

/// Juez de un reto de micrófono: decide si tocaste las notas pedidas.
///
/// Solo mira la clase de tono, porque el detector se equivoca de octava con
/// frecuencia; una nota se da por tocada tras [confirmations] lecturas
/// fiables seguidas, para no premiar un ruido suelto.
class MicChallengeJudge {
  /// Crea el juez de la secuencia [expected] de clases de tono.
  MicChallengeJudge(this.expected, {this.confirmations = 3});

  /// Notas que hay que tocar, en orden.
  final List<int> expected;

  /// Lecturas seguidas que confirman una nota.
  final int confirmations;

  int _progress = 0;
  int _streak = 0;
  int? _lastHeard;

  /// Notas ya acertadas de la secuencia.
  int get progress => _progress;

  /// Última clase de tono fiable que se oyó.
  int? get lastHeard => _lastHeard;

  /// `true` cuando se tocaron todas las notas.
  bool get isComplete => _progress >= expected.length;

  /// Nota que toca ahora; `null` si ya terminó.
  int? get next => isComplete ? null : expected[_progress];

  /// Procesa una lectura; devuelve `true` si acaba de acertar una nota.
  bool feed(PitchReading reading) {
    if (isComplete || !reading.isReliable) {
      return false;
    }
    final int heard = pitchClassOfLabel(reading.note);
    if (heard < 0) {
      return false;
    }
    _lastHeard = heard;
    _streak = heard == expected[_progress] ? _streak + 1 : 0;
    if (_streak < confirmations) {
      return false;
    }
    _progress++;
    _streak = 0;
    return true;
  }
}
