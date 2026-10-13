import 'package:chords/core/logging/app_log.dart';
import 'package:chords/core/logging/log_channel.dart';
import 'package:chords/domain/audio/repositories/audio_repository.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';

/// Reproduce los sonidos de una pregunta con sus pausas.
///
/// Responsabilidad única: traducir una lista de [SoundCue] en llamadas al
/// repositorio de audio respetando las esperas. Si se pide otra reproducción
/// o se cancela, la anterior se interrumpe antes de su siguiente nota.
class SoundCuePlayer {
  /// Crea el reproductor; [wait] permite acelerar las esperas en pruebas.
  SoundCuePlayer(
    this._audio,
    this._chords, {
    Future<void> Function(Duration duration)? wait,
  }) : _wait = wait ?? Future<void>.delayed;

  final AudioRepository _audio;
  final ChordRepository _chords;
  final Future<void> Function(Duration duration) _wait;

  int _run = 0;

  /// Reproduce [cues] en orden; termina cuando suena el último.
  Future<void> play(List<SoundCue> cues) async {
    final int run = ++_run;
    for (final SoundCue cue in cues) {
      if (cue.delayMs > 0) {
        await _wait(Duration(milliseconds: cue.delayMs));
      }
      if (run != _run) {
        return;
      }
      try {
        await _emit(cue);
      } on Object catch (error, stackTrace) {
        appLogger.warning(
          'minijuego: no se pudo reproducir el sonido',
          channel: LogChannel.audio,
          error: error,
          stackTrace: stackTrace,
        );
        return;
      }
    }
  }

  /// Lo que tarda en dejar de sonar [cues]: sus esperas más la cola de la
  /// última nota (≈ 2,2 s al sonar).
  Duration lengthOf(List<SoundCue> cues) => Duration(
    milliseconds:
        cues.fold<int>(0, (int total, SoundCue cue) => total + cue.delayMs) +
        2400,
  );

  /// Interrumpe la reproducción en curso.
  void cancel() => _run++;

  Future<void> _emit(SoundCue cue) => switch (cue) {
    ToneCue() => _audio.playReferenceTone(cue.frequency),
    ChordCue() => _playChord(cue),
  };

  Future<void> _playChord(ChordCue cue) async {
    final Chord? chord = _chords.chordById(cue.chordId);
    if (chord == null) {
      return;
    }
    final int last = chord.variants.length - 1;
    await _audio.playChord(
      chord,
      chord.variants[cue.variantIndex.clamp(0, last)],
    );
  }
}
