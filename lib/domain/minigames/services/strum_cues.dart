import 'package:chords/domain/audio/services/fretboard.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Golpes sonoros (no silencios) de un patrón por compás.
int hitsPerBar(StrumPattern pattern) => pattern.strokes
    .where((StrumStroke stroke) => stroke != StrumStroke.rest)
    .length;

/// Sonidos de [chords] (un acorde por compás) rasgueados con [pattern].
///
/// Cada golpe es un acorde (o el bajo, si el golpe es de bajo) y las pausas
/// entre ellos respetan el ritmo del patrón a [bpm] pulsos por minuto, así
/// que el patrón se reconoce por cuándo suena y no por cómo.
List<SoundCue> strumCues(
  ChordRepository repository,
  List<ChordSymbol> chords,
  StrumPattern pattern,
  int bpm,
) {
  final int slotMs = (30000 / bpm).round();
  final List<StrumStroke> strokes = pattern.strokes;
  final List<SoundCue> cues = <SoundCue>[];
  int lastSlot = 0;
  for (int bar = 0; bar < chords.length; bar++) {
    final Chord? chord = repository.chordById(chords[bar].chordId);
    if (chord == null) {
      continue;
    }
    for (int i = 0; i < strokes.length; i++) {
      if (strokes[i] == StrumStroke.rest) {
        continue;
      }
      final int slot = bar * strokes.length + i;
      final int delay = cues.isEmpty ? 0 : (slot - lastSlot) * slotMs;
      cues.add(_cue(chord, strokes[i], delay));
      lastSlot = slot;
    }
  }
  return cues;
}

SoundCue _cue(Chord chord, StrumStroke stroke, int delayMs) {
  if (stroke == StrumStroke.bass) {
    final int fret = (chord.root.pitchClass - 4 + 12) % 12;
    return ToneCue(FretPosition(6, fret).frequency, delayMs: delayMs);
  }
  return ChordCue(
    chord.id,
    variantIndex: chord.variants.indexOf(chord.easiestVariant),
    delayMs: delayMs,
  );
}
