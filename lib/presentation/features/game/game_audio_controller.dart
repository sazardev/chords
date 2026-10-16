import 'dart:async';

import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord_match_feedback.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/domain/chords/usecases/build_chord_feedback_use_case.dart';
import 'package:chords/domain/chords/usecases/evaluate_chord_match_use_case.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:flutter/foundation.dart';

/// Captura de audio y afinación de una ronda del juego.
///
/// Responsabilidad única: escuchar el micrófono durante el tiempo de la ronda,
/// calcular la proporción de notas acertadas y describir en vivo el objetivo
/// —notas acertadas, pendientes, cuerdas que las producen y notas sobrantes—
/// para que el jugador sepa cómo acomodarse. Desconoce las rondas, la
/// puntuación y la interfaz.
///
/// Si la persona maneja la app con la guitarra, el micrófono se deja abierto
/// al terminar la ronda para oír su orden; quien cierra la partida lo cierra.
class GameAudioController extends ChangeNotifier {
  /// Crea el controlador con el repositorio de audio.
  GameAudioController(this._audio, [this._guitar])
    : _evaluate = const EvaluateChordMatchUseCase();

  final AudioRepository _audio;
  final GuitarCommandListener? _guitar;
  final EvaluateChordMatchUseCase _evaluate;
  final BuildChordFeedbackUseCase _buildFeedback =
      const BuildChordFeedbackUseCase();

  double _match = 0;
  StreamSubscription<PitchReading>? _subscription;
  final List<String> _heard = <String>[];
  int _reliableReadings = 0;
  List<String> _targetNotes = const <String>[];
  List<int> _targetFrets = const <int>[];
  MicStatus _micStatus = MicStatus.idle;
  double _level = 0;
  StreamSubscription<double>? _levelSubscription;
  StreamSubscription<ChordReading>? _chordSubscription;

  /// Proporción de notas detectadas (0-1).
  double get matchRatio => _match;

  /// Notas escuchadas en la ronda, en orden de detección.
  List<String> get heardNotes => List<String>.unmodifiable(_heard);

  /// Número de lecturas fiables recibidas en la ronda.
  int get reliableReadings => _reliableReadings;

  /// Estado del micrófono en la última ronda.
  MicStatus get micStatus => _micStatus;

  /// Nivel de entrada del micrófono (0-1).
  double get level => _level;

  /// Estado de cada cuerda del objetivo, de la sexta a la primera.
  List<PracticeStringStatus> get stringStatuses => _buildFeedback
      .stringStatuses(frets: _targetFrets, heardNotes: _heard.toSet());

  /// Feedback del objetivo de la ronda frente a lo escuchado.
  ChordMatchFeedback get feedback => _buildFeedback(
    frets: _targetFrets,
    targetNotes: _targetNotes,
    heardNotes: _heard.toSet(),
  );

  /// Escucha la ronda y expone el resultado en [matchRatio].
  ///
  /// Devuelve `false` sin esperar si el micrófono no está disponible, para
  /// que el juego no dé la ronda por fallada cuando en realidad no pudo oír.
  ///
  /// [frets] describe la posición objetivo (índice 0 = sexta cuerda) para
  /// poder señalar la cuerda de cada nota en el feedback.
  Future<bool> playRound({
    required List<String> targetNotes,
    required List<int> frets,
    required int timeLimitMs,
  }) async {
    _match = 0;
    _heard.clear();
    _reliableReadings = 0;
    _targetNotes = targetNotes;
    _targetFrets = frets;
    _level = 0;
    notifyListeners();

    final Set<int> detected = <int>{};
    await _subscription?.cancel();
    _subscription = _audio.readings.listen((PitchReading reading) {
      if (!reading.isReliable || (_guitar?.claims(reading) ?? false)) {
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
    await _chordSubscription?.cancel();
    _chordSubscription = _audio.chordReadings.listen(
      (ChordReading reading) => _onChord(reading, targetNotes, detected),
    );
    await _levelSubscription?.cancel();
    _levelSubscription = _audio.levels.listen((double level) {
      _level = level;
      notifyListeners();
    });
    _micStatus = await _audio.requestAccess();
    if (_micStatus != MicStatus.listening) {
      await _release();
      notifyListeners();
      return false;
    }
    notifyListeners();

    await Future<void>.delayed(Duration(milliseconds: timeLimitMs));
    await _release();
    if (!_keepsMic) {
      await _audio.stopListening();
    }
    return true;
  }

  /// Si el reconocedor polifónico oye justo el acorde pedido, da por
  /// escuchadas todas sus notas de una vez (un rasgueo suena junto y el
  /// detector de una sola nota solo las pillaría de una en una).
  void _onChord(
    ChordReading reading,
    List<String> targetNotes,
    Set<int> detected,
  ) {
    if (!_evaluate.recognizes(targetNotes, reading)) {
      return;
    }
    _reliableReadings++;
    for (final String note in targetNotes) {
      if (!_heard.contains(note)) {
        _heard.add(note);
      }
      detected.add(_pitchClassOf(note));
    }
    _match = _evaluate.call(targetNotes, detected);
    notifyListeners();
  }

  /// Si el micrófono se queda abierto entre rondas para oír órdenes.
  bool get _keepsMic => _guitar?.enabled ?? false;

  Future<void> _release() async {
    await _subscription?.cancel();
    _subscription = null;
    await _chordSubscription?.cancel();
    _chordSubscription = null;
    await _levelSubscription?.cancel();
    _levelSubscription = null;
    _level = 0;
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
    unawaited(_chordSubscription?.cancel());
    unawaited(_levelSubscription?.cancel());
    super.dispose();
  }
}
