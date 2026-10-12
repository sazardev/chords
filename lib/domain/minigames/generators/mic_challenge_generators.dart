import 'dart:math' as math;

import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';

/// Fabrica los retos de un juego de micrófono.
abstract interface class MicChallengeGenerator {
  /// Genera el reto número [index] (desde 0) de una partida.
  MicChallenge generate(math.Random random, MiniGameLevel level, int index);
}

/// Toca la nota: se pide una nota y se puede tocar donde se quiera.
class PlayNoteGenerator implements MicChallengeGenerator {
  /// Crea el generador.
  const PlayNoteGenerator();

  @override
  MicChallenge generate(math.Random random, MiniGameLevel level, int index) {
    final FretPosition position = randomPosition(
      random,
      maxFret: 7,
      naturalsOnly: level != MiniGameLevel.hard,
    );
    return MicChallenge(
      kind: MiniGameKind.playNote,
      pitchClasses: <int>[position.pitchClass],
      timeLimitMs: _seconds(level, 15, 12, 10),
      cues: <SoundCue>[ToneCue(position.frequency)],
      stringNumber: position.stringNumber,
      fret: position.fret,
      showHint: level == MiniGameLevel.easy,
    );
  }
}

/// Cuerda y traste: se pide una posición exacta del mástil.
class PlayStringFretGenerator implements MicChallengeGenerator {
  /// Crea el generador.
  const PlayStringFretGenerator();

  @override
  MicChallenge generate(math.Random random, MiniGameLevel level, int index) {
    final int maxFret = switch (level) {
      MiniGameLevel.easy => 3,
      MiniGameLevel.medium => 7,
      MiniGameLevel.hard => kMaxFret,
    };
    final FretPosition position = randomPosition(random, maxFret: maxFret);
    return MicChallenge(
      kind: MiniGameKind.playStringFret,
      pitchClasses: <int>[position.pitchClass],
      timeLimitMs: _seconds(level, 18, 14, 12),
      cues: <SoundCue>[ToneCue(position.frequency)],
      stringNumber: position.stringNumber,
      fret: position.fret,
    );
  }
}

/// Eco: se escucha una melodía corta y hay que tocarla igual.
class EchoGenerator implements MicChallengeGenerator {
  /// Crea el generador.
  const EchoGenerator();

  @override
  MicChallenge generate(math.Random random, MiniGameLevel level, int index) {
    final int length = switch (level) {
      MiniGameLevel.easy => 3,
      MiniGameLevel.medium => 4,
      MiniGameLevel.hard => 5,
    };
    final List<FretPosition> notes = <FretPosition>[];
    while (notes.length < length) {
      final FretPosition next = randomPosition(
        random,
        maxFret: 4,
        naturalsOnly: level == MiniGameLevel.easy,
      );
      if (notes.isEmpty || notes.last.pitchClass != next.pitchClass) {
        notes.add(next);
      }
    }
    return MicChallenge(
      kind: MiniGameKind.echo,
      pitchClasses: <int>[for (final FretPosition n in notes) n.pitchClass],
      timeLimitMs: 8000 + length * 4000,
      cues: <SoundCue>[
        for (int i = 0; i < notes.length; i++)
          ToneCue(notes[i].frequency, delayMs: i == 0 ? 0 : 700),
      ],
    );
  }
}

int _seconds(MiniGameLevel level, int easy, int medium, int hard) =>
    1000 *
    switch (level) {
      MiniGameLevel.easy => easy,
      MiniGameLevel.medium => medium,
      MiniGameLevel.hard => hard,
    };
