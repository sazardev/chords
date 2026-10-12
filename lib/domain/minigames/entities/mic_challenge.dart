import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:meta/meta.dart';

/// Un reto que se supera tocando la guitarra frente al micrófono.
@immutable
class MicChallenge {
  /// Crea el reto.
  const MicChallenge({
    required this.kind,
    required this.pitchClasses,
    required this.timeLimitMs,
    this.cues = const <SoundCue>[],
    this.stringNumber,
    this.fret,
    this.showHint = false,
  });

  /// Juego al que pertenece.
  final MiniGameKind kind;

  /// Notas que hay que tocar, en orden (una sola salvo en el eco).
  final List<int> pitchClasses;

  /// Tiempo disponible para tocarlas.
  final int timeLimitMs;

  /// Sonido de referencia que se puede escuchar.
  final List<SoundCue> cues;

  /// Cuerda pedida, si el reto fija una.
  final int? stringNumber;

  /// Traste pedido, si el reto fija uno.
  final int? fret;

  /// Si se enseña dónde tocar la nota (en el nivel fácil).
  final bool showHint;

  /// `true` si hay que tocar varias notas seguidas.
  bool get isSequence => pitchClasses.length > 1;
}
