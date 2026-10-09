import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Repositorio de audio: captura de micrófono y reproducción de acordes.
abstract interface class AudioRepository {
  /// Estado actual del micrófono.
  Stream<MicStatus> get statusStream;

  /// Lecturas de tono detectadas.
  Stream<PitchReading> get readings;

  /// Solicita permiso de micrófono.
  Future<MicStatus> requestAccess();

  /// Inicia la escucha del micrófono.
  Future<void> startListening();

  /// Detiene la escucha del micrófono.
  Future<void> stopListening();

  /// Reproduce el sonido de una posición de acorde (rasgueo).
  Future<void> playChord(Chord chord, ChordVariant variant);

  /// Reproduce la posición como arpegio siguiendo el patrón indicado.
  Future<void> playArpeggio(
    Chord chord,
    ChordVariant variant,
    ArpeggioPattern pattern,
  );

  /// Libera los recursos de audio.
  Future<void> dispose();
}
