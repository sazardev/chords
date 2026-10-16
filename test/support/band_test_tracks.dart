import 'package:chords/domain/band/entities/band_channel.dart';
import 'package:chords/domain/band/entities/band_event.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';

/// Pista de prueba con un compás por acorde, repetida [loops] veces.
JamTrack trackOf(
  List<String> chords, {
  String? genre,
  StrumPattern strum = StrumPattern.quarters,
  int loops = 1,
}) => JamTrack(
  key: 'prueba',
  title: 'prueba',
  bars: <JamBar>[
    for (int loop = 0; loop < loops; loop++)
      for (final String chord in chords)
        (chords: <ChordSymbol>[ChordSymbol.parse(chord)], lyric: ''),
  ],
  bpm: 100,
  strum: strum,
  tonic: 0,
  genre: genre,
  loopLength: chords.length,
);

/// Todos los golpes del compás [bar].
List<BandEvent> barOf(BandArranger a, int bar) => <BandEvent>[
  for (int step = 0; step < a.context.track.stepsPerBar; step++)
    ...a.eventsAt(bar, step),
];

/// Los golpes de [events] que son del canal [c].
Iterable<BandEvent> channelOf(List<BandEvent> events, BandChannel c) =>
    events.where((BandEvent e) => e.channel == c);
