import 'dart:async';

import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/usecases/evaluate_chord_match_use_case.dart';
import 'package:flutter/foundation.dart';

/// Captura de audio y afinación de una ronda del juego.
///
/// Responsabilidad única: escuchar el micrófono durante el tiempo de la ronda y
/// calcular la proporción de notas acertadas. Desconoce las rondas, la
/// puntuación y la interfaz.
class GameAudioController extends ChangeNotifier {
  /// Crea el controlador con el repositorio de audio.
  GameAudioController(this._audio)
    : _evaluate = const EvaluateChordMatchUseCase();

  final AudioRepository _audio;
  final EvaluateChordMatchUseCase _evaluate;

  double _match = 0;
  StreamSubscription<PitchReading>? _subscription;

  /// Proporción de notas detectadas (0-1).
  double get matchRatio => _match;

  /// Escucha la ronda y expone el resultado en [matchRatio].
  Future<void> playRound({
    required List<String> targetNotes,
    required int timeLimitMs,
  }) async {
    _match = 0;
    notifyListeners();

    final Set<int> detected = <int>{};
    await _subscription?.cancel();
    _subscription = _audio.readings.listen((PitchReading reading) {
      if (!reading.isReliable) {
        return;
      }
      detected.add(_pitchClassOf(reading.note));
      _match = _evaluate.call(targetNotes, detected);
      notifyListeners();
    });
    unawaited(_audio.startListening());

    await Future<void>.delayed(Duration(milliseconds: timeLimitMs));
    await _audio.stopListening();
    await _subscription?.cancel();
    _subscription = null;
  }

  int _pitchClassOf(String label) {
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
    final String note = label.replaceAll(RegExp('[0-9-]'), '');
    return names.indexOf(note);
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
