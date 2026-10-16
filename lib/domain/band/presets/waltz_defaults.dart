/// Ritmos de vals (3/4, 12 pasos) que usan los géneros sin ritmo propio en
/// ternario.
library;

import 'package:chords/domain/band/entities/drum_voice.dart';
import 'package:chords/domain/band/patterns/bass_pattern.dart';
import 'package:chords/domain/band/patterns/chord_pattern.dart';
import 'package:chords/domain/band/patterns/drum_pattern.dart';

/// Vals: bombo en el uno, caja suave en dos y tres, charles a corcheas.
const DrumGroove kWaltzGroove = DrumGroove(
  a: DrumPattern(<DrumVoice, String>{
    DrumVoice.kick: 'X-----------',
    DrumVoice.rimshot: '----x---x---',
    DrumVoice.hatClosed: 'x-o-o-o-o-o-',
  }),
  b: DrumPattern(<DrumVoice, String>{
    DrumVoice.kick: 'X-----------',
    DrumVoice.snare: '----o---x-.-',
    DrumVoice.hatClosed: 'x-o-o-o-o-o-',
    DrumVoice.shaker: '..o...o...o.',
  }),
  fill: DrumPattern(<DrumVoice, String>{
    DrumVoice.kick: 'X-----------',
    DrumVoice.snare: '----o-o-xoxX',
    DrumVoice.tomMid: '--------x---',
  }),
);

/// Bajo de vals: raíz en el uno y quinta en dos y tres.
const BassPattern kWaltzBass = BassPattern('R---5---5---');

/// Teclado de vals: acorde en el uno, golpes cortos en dos y tres.
const ChordPattern kWaltzKeys = ChordPattern('x---s---s---');

/// Vientos de vals: golpes cortos en dos y tres.
const ChordPattern kWaltzWinds = ChordPattern('----s---s---');
