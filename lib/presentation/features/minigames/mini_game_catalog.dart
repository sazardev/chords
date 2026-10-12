import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:flutter/material.dart';

/// Icono de cada minijuego en el catálogo y en sus pantallas.
const Map<MiniGameKind, IconData> kMiniGameIcons = <MiniGameKind, IconData>{
  MiniGameKind.guessNote: Icons.music_note_rounded,
  MiniGameKind.whichString: Icons.linear_scale_rounded,
  MiniGameKind.whichFret: Icons.pin_rounded,
  MiniGameKind.interval: Icons.unfold_more_rounded,
  MiniGameKind.higherLower: Icons.swap_vert_rounded,
  MiniGameKind.chordQuality: Icons.mood_rounded,
  MiniGameKind.nameChord: Icons.hearing_rounded,
  MiniGameKind.tuneEar: Icons.tune_rounded,
  MiniGameKind.memory: Icons.psychology_rounded,
  MiniGameKind.noteAtFret: Icons.grid_on_rounded,
  MiniGameKind.fretOfNote: Icons.search_rounded,
  MiniGameKind.fingerQuiz: Icons.back_hand_rounded,
  MiniGameKind.readDiagram: Icons.menu_book_rounded,
  MiniGameKind.buildChord: Icons.touch_app_rounded,
  MiniGameKind.playNote: Icons.mic_rounded,
  MiniGameKind.playStringFret: Icons.my_location_rounded,
  MiniGameKind.echo: Icons.graphic_eq_rounded,
};

/// Icono de un minijuego.
IconData miniGameIcon(MiniGameKind kind) =>
    kMiniGameIcons[kind] ?? Icons.sports_esports_rounded;
