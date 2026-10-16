/// Bandas de la familia del pop y el rock: pop, rock, punk, metal, grunge e
/// indie.
library;

import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/presets/drum_fills.dart';

/// Pop: batería de estudio, bajo con los dedos, acústica y piano.
const BandPreset kPopPreset = BandPreset(
  id: 'pop',
  trim: 0.46,
  baseStrum: 'D-DU-UDU',
  punch: 0.9,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------x-x-----',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-x-x-----',
      DrumVoice.snare: '----X-------X-.-',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x---',
      DrumVoice.hatOpen: '--------------x-',
      DrumVoice.tambourine: 'o---o---o---o---',
    }),
    fill: kFillRock,
  ),
  bass: BassPattern('R-------R-R-----'),
  bassB: BassPattern('R-----R-R-R---5-'),
  guitar: ChordPattern('D---D-U---U-D-U-'),
  keys: ChordPattern('x-----s-x-----s-'),
);

/// Rock: caja con pegada, platos abiertos, bajo de púa y guitarra saturada.
const BandPreset kRockPreset = BandPreset(
  id: 'rock',
  trim: 0.42,
  baseStrum: 'DUDUDUDU',
  bassKind: BassKind.pick,
  guitarKind: GuitarKind.distorted,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-x-----',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-x---x-',
      DrumVoice.snare: '----X---.-.-X---',
      DrumVoice.ride: 'x-x-x-x-x-x-x-x-',
    }),
    fill: kFillRock,
  ),
  bass: BassPattern('R-R-R-R-R-R-R-R-'),
  bassB: BassPattern('R-R-O-R-R-R-O-R-'),
  guitar: ChordPattern('P-U-D-U-D-U-D-U-'),
);

/// Punk: rápido y recto, todo a golpe de bajada y platos a corcheas.
const BandPreset kPunkPreset = BandPreset(
  id: 'punk',
  trim: 0.35,
  baseStrum: 'DUDUDUDU',
  bassKind: BassKind.pick,
  guitarKind: GuitarKind.distorted,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----X-X-----X-',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---X-X-X---X-X-',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.ride: 'x-x-x-x-x-x-x-x-',
    }),
    fill: kFillPunk,
  ),
  bass: BassPattern('R-R-R-R-R-R-R-R-'),
  bassB: BassPattern('R-R-R-R-R-R-R-5-'),
  guitar: ChordPattern('P-P-P-P-P-P-P-P-'),
);

/// Metal: doble bombo a galope, platos y guitarra con palm-mute.
const BandPreset kMetalPreset = BandPreset(
  id: 'metal',
  trim: 0.33,
  baseStrum: 'DUDUDUDU',
  bassKind: BassKind.pick,
  guitarKind: GuitarKind.distorted,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-xxX-xxX-xxX-xx',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'XxXxXxXxXxXxXxXx',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.ride: 'x-x-x-x-x-x-x-x-',
    }),
    fill: kFillMetal,
  ),
  bass: BassPattern('R-rrR-rrR-rrR-rr'),
  bassB: BassPattern('RrRrRrRrRrRrRrRr'),
  guitar: ChordPattern('P-ppP-ppP-ppP-pp'),
);

/// Grunge: batería suelta y pesada, bajo grave y guitarra sucia.
const BandPreset kGrungePreset = BandPreset(
  id: 'grunge',
  trim: 0.43,
  baseStrum: 'DUDUDUDU',
  bassKind: BassKind.pick,
  guitarKind: GuitarKind.distorted,
  punch: 0.95,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-x---x-',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x---x---x---x---',
      DrumVoice.hatOpen: '------o-------o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-x---x-',
      DrumVoice.snare: '----X-----x-X---',
      DrumVoice.ride: 'x-x-x-x-x-x-x-x-',
    }),
    fill: kFillRock,
  ),
  bass: BassPattern('R-------R-R-----'),
  bassB: BassPattern('R-R---R-R-R---5-'),
  guitar: ChordPattern('P---P---P-M-P---'),
);

/// Indie: batería abierta, guitarra limpia y teclado eléctrico.
const BandPreset kIndiePreset = BandPreset(
  id: 'indie',
  trim: 0.48,
  baseStrum: 'D-DU-UDU',
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.rhodes,
  punch: 0.88,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-x-----',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
      DrumVoice.tambourine: 'o---o---o---o---',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-x-----',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x---',
      DrumVoice.hatOpen: '--------------x-',
      DrumVoice.tomLow: '------x-------x-',
    }),
    fill: kFillRock,
  ),
  bass: BassPattern('R-----R-R---R---'),
  bassB: BassPattern('R-R---R-R-R-R-5-'),
  guitar: ChordPattern('D---D-U---U-D-U-'),
  keys: ChordPattern('x-------x---s---'),
);
