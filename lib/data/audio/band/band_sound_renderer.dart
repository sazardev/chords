import 'package:chords/data/audio/band/band_guitar_synthesizer.dart';
import 'package:chords/data/audio/band/bass_synthesizer.dart';
import 'package:chords/data/audio/band/click_synthesizer.dart';
import 'package:chords/data/audio/band/drums/drum_synthesizer.dart';
import 'package:chords/data/audio/band/keys_synthesizer.dart';
import 'package:chords/data/audio/band/rendered_sound.dart';
import 'package:chords/data/audio/band/wind_synthesizer.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/entities/sound_shapes.dart';

/// Sintetiza la muestra que describe [sound].
///
/// Es una función pura (sin estado) para poder ejecutarla en un isolate.
RenderedSound renderBandSound(BandSound sound) => switch (sound.family) {
  SoundFamily.drum => RenderedSound(
    renderDrum(
      sound.shape as DrumVoice,
      sound.kind as DrumKit,
      hard: sound.hard,
    ),
  ),
  SoundFamily.bass => RenderedSound(
    renderBass(
      sound.kind as BassKind,
      sound.notes.first,
      sound.shape as NoteLength,
    ),
  ),
  SoundFamily.guitar => RenderedSound(
    renderGuitar(
      sound.kind as GuitarKind,
      sound.shape as GuitarStroke,
      sound.notes,
    ),
  ),
  SoundFamily.keys => renderKeys(
    sound.kind as KeysKind,
    sound.shape as NoteLength,
    sound.notes,
  ),
  SoundFamily.wind => renderWind(
    sound.kind as WindKind,
    sound.shape as NoteLength,
    sound.notes,
  ),
  SoundFamily.click => RenderedSound(renderClick(sound.kind as ClickAccent)),
};
