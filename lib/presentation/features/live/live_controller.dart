import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/chords/usecases/match_chords_by_pitch_classes_use_case.dart';
import 'package:flutter/foundation.dart';

/// Controlador de la afinación en vivo con micrófono.
class LiveController extends ChangeNotifier {
  /// Crea el controlador.
  LiveController(this._audio, this._chords, this._matchChords);

  final AudioRepository _audio;
  final ChordRepository _chords;
  final MatchChordsByPitchClassesUseCase _matchChords;

  MicStatus _status = MicStatus.idle;
  PitchReading? _reading;
  List<Chord> _suggestions = const <Chord>[];
  final Set<int> _detected = <int>{};

  /// Estado del micrófono.
  MicStatus get status => _status;

  /// Última lectura de tono.
  PitchReading? get reading => _reading;

  /// Acordes sugeridos a partir de lo detectado.
  List<Chord> get suggestions => _suggestions;

  /// Clases de tono acumuladas.
  Set<int> get detected => _detected;

  /// Alterna entre escuchar y detener.
  Future<void> toggleListening() async {
    if (_status == MicStatus.listening) {
      await stop();
    } else {
      await start();
    }
  }

  /// Inicia la escucha del micrófono.
  Future<void> start() async {
    _detected.clear();
    _suggestions = const <Chord>[];
    _reading = null;
    notifyListeners();
    await _audio.requestAccess();
    _audio.readings.listen(_onReading);
    _audio.statusStream.listen((MicStatus status) {
      _status = status;
      notifyListeners();
    });
  }

  /// Detiene la escucha del micrófono.
  Future<void> stop() async {
    await _audio.stopListening();
    _status = MicStatus.idle;
    notifyListeners();
  }

  void _onReading(PitchReading reading) {
    _reading = reading;
    final int pitchClass = _pitchClassOfNote(reading.note);
    if (reading.isReliable) {
      _detected
        ..clear()
        ..add(pitchClass);
      _suggestions = _matchChords(_chords.chords, _detected);
    }
    notifyListeners();
  }

  int _pitchClassOfNote(String label) {
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
}
