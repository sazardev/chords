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
  final List<String> _heard = <String>[];
  int _reliableReadings = 0;

  /// Proporción de notas detectadas (0-1).
  double get matchRatio => _match;

  /// Notas escuchadas en la ronda, en orden de detección.
  List<String> get heardNotes => List<String>.unmodifiable(_heard);

  /// Número de lecturas fiables recibidas en la ronda.
  int get reliableReadings => _reliableReadings;

  /// Escucha la ronda y expone el resultado en [matchRatio].
  Future<void> playRound({
    required List<String> targetNotes,
    required int timeLimitMs,
  }) async {
    _match = 0;
    _heard.clear();
    _reliableReadings = 0;
    notifyListeners();

    final Set<int> detected = <int>{};
    await _subscription?.cancel();
    _subscription = _audio.readings.listen((PitchReading reading) {
      if (!reading.isReliable) {
        return;
      }
      _reliableReadings++;
      final String note = _noteOf(reading.note);
      if (!_heard.contains(note)) {
        _heard.add(note);
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

  String _noteOf(String label) => label.replaceAll(RegExp('[0-9-]'), '');

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
    return names.indexOf(_noteOf(label));
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
