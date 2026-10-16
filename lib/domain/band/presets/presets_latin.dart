/// Bandas latinas: latino, bossa, salsa, cumbia, ranchera, flamenco, tango y
/// bolero.
library;

import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/presets/drum_fills.dart';

/// Latino (pop latino): clave 3-2, shaker, congas y bajo de tumbao suave.
const BandPreset kLatinPreset = BandPreset(
  id: 'latin',
  baseStrum: 'D-D-D-D-',
  guitarKind: GuitarKind.nylon,
  punch: 0.9,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-----x-',
      DrumVoice.rimshot: '----x--x----x---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
      DrumVoice.congaMute: '--x---x---x---x-',
      DrumVoice.shaker: 'o.o.o.o.o.o.o.o.',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-----x-',
      DrumVoice.rimshot: '----x--x----x---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
      DrumVoice.congaOpen: '----x-------x-x-',
      DrumVoice.congaSlap: '------x---------',
      DrumVoice.claves: 'X--X--X---X-X---',
    }),
    fill: kFillLatin,
  ),
  bass: BassPattern('R-----5---R-----'),
  bassB: BassPattern('R-----5---R-5-a-'),
  guitar: ChordPattern('D---D---D---D---'),
  keys: ChordPattern('s--s--s---s-s---'),
);

/// Bossa nova: clave en el aro, bajo de dos notas y guitarra de nailon.
const BandPreset kBossaPreset = BandPreset(
  id: 'bossa',
  baseStrum: 'B-DB-DB-',
  kit: DrumKit.jazz,
  guitarKind: GuitarKind.nylon,
  bassKind: BassKind.upright,
  punch: 0.68,
  loopAccent: null,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-----x-',
      DrumVoice.rimshot: 'x--x--x---x--x--',
      DrumVoice.hatClosed: 'o-o-o-o-o-o-o-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-----x-',
      DrumVoice.rimshot: 'x--x--x---x--x--',
      DrumVoice.hatClosed: 'o-o-o-o-o-o-o-o-',
      DrumVoice.shaker: 'o.o.o.o.o.o.o.o.',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R-----5-R-----5-'),
  bassB: BassPattern('R-----5-R-----a-'),
  guitar: ChordPattern('B---D-B---D-B---'),
  keys: ChordPattern('s--s--s---s--s--'),
);

/// Salsa: clave, campana, bongó de martillo, tumbao, piano montuno y metales.
const BandPreset kSalsaPreset = BandPreset(
  id: 'salsa',
  baseStrum: 'D-D-D-D-',
  guitarKind: GuitarKind.nylon,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.claves: 'X--X--X---X-X---',
      DrumVoice.bongoLow: 'x---x---x---x---',
      DrumVoice.bongoHigh: '--o---o---o---o-',
      DrumVoice.congaMute: '--x---x---x---x-',
      DrumVoice.congaSlap: '----------x-----',
      DrumVoice.hatPedal: 'x---x---x---x---',
      DrumVoice.kick: 'o-------o-------',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.claves: 'X--X--X---X-X---',
      DrumVoice.cowbell: 'x-x-x-x-x-x-x-x-',
      DrumVoice.timbale: '----x-------x---',
      DrumVoice.congaMute: '--x---x---x---x-',
      DrumVoice.congaOpen: '----x-------x---',
      DrumVoice.congaSlap: '----------x-----',
      DrumVoice.kick: 'o-------o-------',
    }),
    fill: kFillLatin,
  ),
  bass: BassPattern('R-----5---R-5-a-'),
  bassB: BassPattern('R-----5-R-R-5-a-'),
  guitar: ChordPattern('--X---X---X---X-'),
  keys: ChordPattern('s-s--s-s-s--s---'),
  winds: ChordPattern('s--s----s-s-----'),
);

/// Cumbia: güiro continuo, congas alternadas, bajo "oom-pah" y acordeón.
const BandPreset kCumbiaPreset = BandPreset(
  id: 'cumbia',
  baseStrum: 'D-D-D-D-',
  windKind: WindKind.accordion,
  punch: 0.92,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-------',
      DrumVoice.rimshot: '----x-------x---',
      DrumVoice.guiro: 'x-o-x-o-x-o-x-o-',
      DrumVoice.congaMute: 'x---x---x---x---',
      DrumVoice.congaSlap: '--x---x---x---x-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-x-----',
      DrumVoice.snare: '----x-------x---',
      DrumVoice.guiro: 'x-o-x-o-x-o-x-o-',
      DrumVoice.congaMute: 'x---x---x---x---',
      DrumVoice.congaSlap: '--x---x---x---x-',
      DrumVoice.cowbell: 'x-------x-------',
    }),
    fill: kFillLatin,
  ),
  bass: BassPattern('R---5---R---5---'),
  bassB: BassPattern('R---5---R-R-5-5-'),
  guitar: ChordPattern('B---D-D-B---D-D-'),
  winds: ChordPattern('----x-x-----x-x-'),
);

/// Ranchera: guitarrón, guitarra de rasgueo, trompetas sostenidas y
/// batería ligera (en vals usa el ritmo ternario genérico).
const BandPreset kRancheraPreset = BandPreset(
  id: 'ranchera',
  baseStrum: 'D-D-D-D-',
  bassKind: BassKind.upright,
  punch: 0.78,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-----x-',
      DrumVoice.rimshot: '----o-------o---',
      DrumVoice.shaker: 'o-o-o-o-o-o-o-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-------',
      DrumVoice.snare: '----o-------o---',
      DrumVoice.shaker: 'o-o-o-o-o-o-o-o-',
      DrumVoice.tambourine: 'x---x---x---x---',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R-------5-------'),
  bassB: BassPattern('R-----5-R-----5-'),
  guitar: ChordPattern('B---D-D-B---D-D-'),
  winds: ChordPattern('X---------------'),
);

/// Flamenco (rumba): cajón, palmas, guitarra de nailon con rasgueado y bajo.
const BandPreset kFlamencoPreset = BandPreset(
  id: 'flamenco',
  baseStrum: 'D-DU-UDU',
  bassKind: BassKind.upright,
  guitarKind: GuitarKind.nylon,
  loopAccent: DrumVoice.palma,
  punch: 0.92,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.cajon: 'X-----x-X-----x-',
      DrumVoice.cajonSlap: '----x-x-----x-x-',
      DrumVoice.palma: '--x---x---x---x-',
      DrumVoice.palmaMuted: '-x-x-x-x-x-x-x-x',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.cajon: 'X-----x-X---x-x-',
      DrumVoice.cajonSlap: '----x-x-----x-xx',
      DrumVoice.palma: 'x-x-x-x-x-x-x-x-',
      DrumVoice.palmaMuted: '-x-x-x-x-x-x-x-x',
    }),
    fill: kFillFlamenco,
  ),
  bass: BassPattern('R-----5-R-----5-'),
  bassB: BassPattern('R---R-5-R---R-5-'),
  guitar: ChordPattern('R-----U-D-U-D-U-'),
);

/// Tango: marcato en cuatro, bajo de contrabajo, bandoneón y piano.
const BandPreset kTangoPreset = BandPreset(
  id: 'tango',
  baseStrum: 'D-D-D-D-',
  kit: DrumKit.jazz,
  bassKind: BassKind.upright,
  guitarKind: GuitarKind.nylon,
  windKind: WindKind.accordion,
  punch: 0.82,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'x---x---x---x---',
      DrumVoice.guiro: '--x---x---x---x-',
      DrumVoice.rimshot: '--------o-----o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X---x---X---x---',
      DrumVoice.guiro: 'o-x-o-x-o-x-o-x-',
      DrumVoice.rimshot: '--o---o---o---o-',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R---5---R-----a-'),
  bassB: BassPattern('R---R---5---R-a-'),
  guitar: ChordPattern('D---D---D---D---'),
  keys: ChordPattern('x---s-s-x---s-s-'),
  winds: ChordPattern('x-----s-x-------'),
);

/// Bolero: bongó y maracas, claves suaves, bajo largo y guitarra de nailon.
const BandPreset kBoleroPreset = BandPreset(
  id: 'bolero',
  baseStrum: 'D-D-D-D-',
  bassKind: BassKind.upright,
  guitarKind: GuitarKind.nylon,
  keysKind: KeysKind.pad,
  punch: 0.7,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-------',
      DrumVoice.rimshot: '----o-------o---',
      DrumVoice.shaker: 'x-o-x-o-x-o-x-o-',
      DrumVoice.bongoLow: 'x-------x-------',
      DrumVoice.bongoHigh: '--o-o---o-o-o---',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-------',
      DrumVoice.rimshot: '----o--o----o---',
      DrumVoice.shaker: 'x-o-x-o-x-o-x-o-',
      DrumVoice.bongoLow: 'x-------x-------',
      DrumVoice.bongoHigh: '--o-o---o-o-o---',
      DrumVoice.claves: 'x--x--x---x-x---',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R-------5---R-5-'),
  bassB: BassPattern('R-----5-R-----5-'),
  guitar: ChordPattern('B---D-D-B---D-D-'),
  keys: ChordPattern('X---------------'),
);
