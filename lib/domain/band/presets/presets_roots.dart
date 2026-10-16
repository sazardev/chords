/// Bandas de raíces: blues, country, folk, gospel, soul y balada.
library;

import 'package:chords/domain/band/clock/swing_grid.dart';
import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/entities/instrument_kinds.dart';
import 'package:chords/domain/band/patterns/band_preset.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';
import 'package:chords/domain/band/presets/drum_fills.dart';

/// Blues: shuffle con swing, bajo de boogie o caminante, eléctrica limpia y
/// órgano.
const BandPreset kBluesPreset = BandPreset(
  id: 'blues',
  trim: 0.49,
  baseStrum: 'D-UD-UD-',
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.organ,
  swing: 0.62,
  punch: 0.9,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------x-------',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-------',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.ride: 'x-o-x-o-x-o-x-o-',
      DrumVoice.hatPedal: '----x-------x---',
    }),
    fill: kFillShuffle,
  ),
  bass: BassPattern('R-R-3-3-5-5-6-6-'),
  bassB: BassPattern.walk('W---W---W---W---'),
  guitar: ChordPattern('D---U-D---U-D---'),
  keys: ChordPattern('X---------------'),
);

/// Country: tren de caja, bajo de "boom-chick" y acústica.
const BandPreset kCountryPreset = BandPreset(
  id: 'country',
  trim: 0.5,
  baseStrum: 'B-D-B-D-',
  swing: 0.1,
  punch: 0.88,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-------',
      DrumVoice.snare: '----x-------x---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-------',
      DrumVoice.snare: '.-.-X-.-.-.-X-.-',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
    }),
    fill: kFillRock,
  ),
  bass: BassPattern('R-------5-------'),
  bassB: BassPattern('R-----3-5-----a-'),
  guitar: ChordPattern('B---D---B---D---'),
);

/// Folk: batería de salón, shaker y acústica con bajo caminante suave.
const BandPreset kFolkPreset = BandPreset(
  id: 'folk',
  trim: 0.63,
  baseStrum: 'D-D-D-D-',
  bassKind: BassKind.upright,
  punch: 0.72,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-------X-------',
      DrumVoice.rimshot: '----o-------o---',
      DrumVoice.shaker: 'o-o-o-o-o-o-o-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-------',
      DrumVoice.rimshot: '----o-------o---',
      DrumVoice.shaker: 'o-o-o-o-o-o-o-o-',
      DrumVoice.tambourine: 'x---x---x---x---',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R-------5-------'),
  bassB: BassPattern('R-----5-R---5---'),
  guitar: ChordPattern('D---D-d-D---D-d-'),
);

/// Gospel: palmas en el dos y el cuatro, órgano y swing ligero.
const BandPreset kGospelPreset = BandPreset(
  id: 'gospel',
  trim: 0.43,
  baseStrum: 'D-D-D-D-',
  keysKind: KeysKind.organ,
  swing: 0.3,
  punch: 0.95,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-------',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.clap: '----x-------x---',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-x-----',
      DrumVoice.snare: '----X-------X-.-',
      DrumVoice.clap: '----x-------x---',
      DrumVoice.ride: 'x-o-x-o-x-o-x-o-',
    }),
    fill: kFillShuffle,
  ),
  bass: BassPattern('R-----5-R-------'),
  bassB: BassPattern('R-----5-R-5-6-5-'),
  guitar: ChordPattern('D---D---D---D---'),
  keys: ChordPattern('X-------x-----x-'),
);

/// Soul: groove de Motown, pandereta, piano eléctrico y metales cortos.
const BandPreset kSoulPreset = BandPreset(
  id: 'soul',
  trim: 0.44,
  baseStrum: 'D-D-D-D-',
  guitarKind: GuitarKind.clean,
  keysKind: KeysKind.rhodes,
  swing: 0.15,
  swingGrid: SwingGrid.sixteenth,
  punch: 0.9,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X---x---',
      DrumVoice.snare: '----X-------X---',
      DrumVoice.hatClosed: 'x-x-x-x-x-x-x-x-',
      DrumVoice.tambourine: '----x-------x---',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x-X-x-x---',
      DrumVoice.snare: '----X--.----X--.',
      DrumVoice.hatClosed: 'x-o-x-o-x-o-x-o-',
      DrumVoice.tambourine: 'o-o-o-o-o-o-o-o-',
    }),
    fill: kFillRock,
  ),
  bass: BassPattern('R-----R-R-5-----'),
  bassB: BassPattern('R-R---5-R-R-6-5-'),
  guitar: ChordPattern('X-d-X-d-X-d-X-d-'),
  keys: ChordPattern('x-----s-x-----s-'),
  winds: ChordPattern('------s-------s-'),
);

/// Balada: batería suave con aro, bajo largo, acústica y cuerdas.
const BandPreset kBalladPreset = BandPreset(
  id: 'ballad',
  trim: 0.64,
  baseStrum: 'D-------',
  keysKind: KeysKind.pad,
  punch: 0.7,
  fillEvery: 8,
  drums: DrumGroove(
    a: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----------x---',
      DrumVoice.rimshot: '----o-------o---',
      DrumVoice.hatClosed: 'o---o---o---o---',
    }),
    b: DrumPattern(<DrumVoice, String>{
      DrumVoice.kick: 'X-----x---x-----',
      DrumVoice.snare: '----o-------o---',
      DrumVoice.hatClosed: 'o-o-o-o-o-o-o-o-',
    }),
    fill: kFillSoft,
  ),
  bass: BassPattern('R---------R-----'),
  bassB: BassPattern('R-------R-----5-'),
  guitar: ChordPattern('D-------d-----U-'),
  keys: ChordPattern('X---------------'),
);
