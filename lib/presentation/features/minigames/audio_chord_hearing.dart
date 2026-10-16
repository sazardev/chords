import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/minigames/services/chord_hearing.dart';

/// Oído de acordes sobre el detector de tono del micrófono.
///
/// El detector actual oye una nota cada vez: cada lectura fiable es un
/// conjunto de una sola clase de tono y el juez de cambios las va sumando
/// mientras la persona rasguea. Un detector polifónico implementaría
/// [ChordHearing] emitiendo varias notas a la vez y el juego no cambiaría.
class AudioChordHearing implements ChordHearing {
  /// Crea el oído sobre [_audio]; [ignore] descarta lecturas que no son del
  /// acorde (p. ej. las notas con las que se maneja la app con la guitarra).
  AudioChordHearing(this._audio, {this._ignore});

  final AudioRepository _audio;
  final bool Function(PitchReading reading)? _ignore;

  @override
  Future<MicStatus> open() => _audio.requestAccess();

  @override
  Stream<Set<int>> get detections => _audio.readings
      .where(
        (PitchReading reading) =>
            reading.isReliable && !(_ignore?.call(reading) ?? false),
      )
      .map((PitchReading reading) => pitchClassOfLabel(reading.note))
      .where((int pitchClass) => pitchClass >= 0)
      .map((int pitchClass) => <int>{pitchClass});

  @override
  Stream<double> get levels => _audio.levels;

  @override
  Future<void> close() => _audio.stopListening();
}
