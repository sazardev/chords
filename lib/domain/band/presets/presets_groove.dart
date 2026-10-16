/// Bandas de groove: jazz, funk, disco, reggae, ska, reggaeton y lofi.
library;

import 'package:chords/domain/band/clock/swing_grid.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/presets/drum_fills.dart';

/// Jazz: ride "spang-a-lang", bajo caminante, acordes de Freddie Green y
/// piano con comping.
const BandPreset kJazzPreset = BandPreset(
  id: 'jazz',
  trim: 0.64,
  baseStrum: 'D-D-D-D-',
  kit: DrumKit.jazz,
  bassKind: BassKind.upright,
  guitarKind: GuitarKind.clean,
  swing: 0.62,
  punch: 0.78,
  loopAccent: DrumVoice.rideBell,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.ride: 'X---x-x-X---x-x-',
      DrumVoice.hatPedal: '----x-------x---',
      DrumVoice.kick: 'o---o---o---o---',
      DrumVoice.snare: '--------.-----.-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.ride: 'X---x-x-X---x-x-',
      DrumVoice.hatPedal: '----x-------x---',
      DrumVoice.kick: 'o---o---o---o---',
      DrumVoice.snare: '------x---.-x---',
    }),
    fill: kFillJazz,
  ),
  bass: BassPattern.walk('W---W---W---W---'),
  guitar: ChordPattern('X---X---X---X---'),
  keys: ChordPattern('x-----s---------'),
);

/// Funk: semicorcheas de charles, bajo sincopado con notas apagadas, chop de
/// guitarra y piano eléctrico.
const BandPreset kFunkPreset = BandPreset(
  id: 'funk',
  trim: 0.42,
  baseStrum: 'DUDUDUDU',
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.rhodes,
  swing: 0.18,
  swingGrid: SwingGrid.sixteenth,
  punch: 0.95,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x--x-x----',
      DrumVoice.snare: '----X..x.x..X..x',
      DrumVoice.hatClosed: 'x.o.x.o.x.o.x.o.',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X--x--x-X-x--x--',
      DrumVoice.snare: '----X..x.x..X.x.',
      DrumVoice.hatClosed: 'x.o.x.----o.x.--',
      DrumVoice.hatOpen: '------x-------x-',
    }),
    fill: kFillFunk,
  ),
  bass: BassPattern('R--rR-r-R--rR-5-'),
  bassB: BassPattern('R-rRR-r-R--rO-5-'),
  guitar: ChordPattern('X-.XX-.XX-.XX-.X'),
  keys: ChordPattern('x-----s-----s---'),
);

/// Disco: bombo a negras, charles abierto a contratiempo, bajo de octavas y
/// cuerdas.
const BandPreset kDiscoPreset = BandPreset(
  id: 'disco',
  trim: 0.4,
  baseStrum: 'DUDUDUDU',
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.pad,
  swing: 0.08,
  swingGrid: SwingGrid.sixteenth,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X---X---X---',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x---x---x---x---',
      DrumVoice.hatOpen: '--x---x---x---x-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X---X---X---',
      DrumVoice.clap: '----X-------X---',
      DrumVoice.snare: '..o...o...o...o.',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
      DrumVoice.hatOpen: '--x---x---x---x-',
      DrumVoice.tambourine: 'o-o-o-o-o-o-o-o-',
    }),
    fill: kFillFunk,
  ),
  bass: BassPattern('R-O-R-O-R-O-R-O-'),
  bassB: BassPattern('R-O-R-O-R-O-5-O-'),
  guitar: ChordPattern('X-.XX-.XX-.XX-.X'),
  keys: ChordPattern('X---------------'),
  winds: ChordPattern('--------s-----s-'),
);

/// Reggae: one-drop con el aro en el tres, bajo melódico y espacioso,
/// skank de guitarra y órgano "bubble".
const BandPreset kReggaePreset = BandPreset(
  id: 'reggae',
  trim: 0.66,
  baseStrum: '--D---D-',
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.organ,
  punch: 0.85,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: '--------X-------',
      DrumVoice.rimshot: '--------x-------',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: '--------X-------',
      DrumVoice.rimshot: '--------x---x---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
      DrumVoice.shaker: '.o.o.o.o.o.o.o.o',
    }),
    fill: kFillReggae,
  ),
  bass: BassPattern('R-------5---R-5-'),
  bassB: BassPattern('R-----5-R---5-a-'),
  guitar: ChordPattern('----X-------X---'),
  keys: ChordPattern('--s---s---s---s-'),
);

/// Ska: contratiempos de guitarra y metales, bajo caminante y batería
/// rápida.
const BandPreset kSkaPreset = BandPreset(
  id: 'ska',
  trim: 0.39,
  baseStrum: '-U-U-U-U',
  guitarKind: GuitarKind.clean,
  punch: 0.95,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X---X---X---',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X---X---X---',
      DrumVoice.snare: '----X-x---x-X-x-',
      DrumVoice.ride: 'x-o-x-o-x-o-x-o-',
    }),
    fill: kFillPunk,
  ),
  bass: BassPattern.walk('W---W---W---W---'),
  guitar: ChordPattern('--X---X---X---X-'),
  winds: ChordPattern('------s-------s-'),
);

/// Reggaeton: dembow electrónico, sub grave de 808 y pad con guitarra de
/// nailon.
const BandPreset kReggaetonPreset = BandPreset(
  id: 'reggaeton',
  trim: 0.48,
  baseStrum: 'D-D-D-D-',
  kit: DrumKit.electronic,
  bassKind: BassKind.synth,
  guitarKind: GuitarKind.nylon,
  keysKind: KeysKind.pad,
  loopAccent: DrumVoice.clap,
  punch: 0.95,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X---X---X---',
      DrumVoice.snare: '---X--X----X--X-',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X---X---X---',
      DrumVoice.snare: '---X--X----X--X-',
      DrumVoice.clap: '------x-------x-',
      DrumVoice.hatClosed: 'xoxoxoxoxoxoxoxo',
      DrumVoice.shaker: 'o-o-o-o-o-o-o-o-',
    }),
    fill: kFillElectronic,
  ),
  bass: BassPattern('R-----R---R-----'),
  bassB: BassPattern('R--R--R---R-5---'),
  guitar: ChordPattern('---X--X----X--X-'),
  keys: ChordPattern('X---------------'),
);

/// Lofi: batería suelta con swing de semicorcheas, sub suave, piano
/// eléctrico y guitarra limpia.
const BandPreset kLofiPreset = BandPreset(
  id: 'lofi',
  trim: 0.89,
  baseStrum: 'D-------',
  bassKind: BassKind.synth,
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.rhodes,
  swing: 0.5,
  swingGrid: SwingGrid.sixteenth,
  punch: 0.62,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X------x--X-----',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X------x--X---x-',
      DrumVoice.snare: '----X-------X-.-',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
      DrumVoice.shaker: 'o.o.o.o.o.o.o.o.',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R-----------5---'),
  bassB: BassPattern('R-------R-----5-'),
  guitar: ChordPattern('D-----d-----U---'),
  keys: ChordPattern('X-----s---------'),
);
