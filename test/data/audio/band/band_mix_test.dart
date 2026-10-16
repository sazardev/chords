import 'dart:io';

import 'package:chords/data/audio/wav_encoder.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/band_offline_mixer.dart';

/// Tempo de ejemplo de cada género para las pruebas de mezcla.
const Map<String, int> _bpm = <String, int>{
  'pop': 92,
  'rock': 112,
  'blues': 88,
  'country': 108,
  'jazz': 120,
  'funk': 100,
  'ballad': 72,
  'latin': 96,
  'reggae': 76,
  'bossa': 120,
  'metal': 150,
  'punk': 168,
  'soul': 80,
  'gospel': 76,
  'folk': 90,
  'cumbia': 96,
  'salsa': 180,
  'ranchera': 84,
  'flamenco': 110,
  'disco': 118,
  'ska': 150,
  'indie': 110,
  'grunge': 100,
  'reggaeton': 94,
  'lofi': 78,
  'tango': 100,
  'bolero': 70,
};

StrumPattern _strumOf(String notation) => StrumPattern.values.firstWhere(
  (StrumPattern p) => p.notation == notation,
  orElse: () => StrumPattern.quarters,
);

JamTrack _trackOf(String genre) {
  final List<ChordSymbol> chords = <ChordSymbol>[
    for (final String name in <String>['C', 'Am', 'F', 'G'])
      ChordSymbol.parse(name),
  ];
  return JamTrack(
    key: 'demo:$genre',
    title: genre,
    bars: <JamBar>[
      for (final ChordSymbol chord in chords)
        (chords: <ChordSymbol>[chord], lyric: ''),
    ],
    bpm: _bpm[genre]!,
    strum: _strumOf(bandPresetFor(genre).baseStrum),
    tonic: 0,
    genre: genre,
  );
}

/// La banda entera de cada género, mezclada sin motor de audio.
void main() {
  final String? dump = Platform.environment['BAND_DEMO_DIR'];

  test('la mezcla de cada género no satura y suena con nivel razonable', () {
    final List<String> report = <String>[];
    final List<String> problems = <String>[];
    for (final String genre in kBandPresets.keys) {
      final OfflineMix mix = mixTrack(
        _trackOf(genre),
        const BandConfig(humanize: 0),
        masterGain: bandPresetFor(genre).trim,
      );
      report.add(
        '${genre.padRight(10)} pico ${mix.peak.toStringAsFixed(2)} '
        'rms ${mix.rms.toStringAsFixed(3)} '
        'síntesis ${mix.renderMillis} ms',
      );
      problems.addAll(<String>[
        if (mix.peak >= 1.0) '$genre satura (${mix.peak})',
        if (mix.peak <= 0.3) '$genre suena muy bajo (${mix.peak})',
        if (mix.rms <= 0.03) '$genre tiene poco cuerpo (${mix.rms})',
      ]);
      if (dump != null) {
        Directory(dump).createSync(recursive: true);
        File('$dump/$genre.wav')
            .writeAsBytesSync(const WavEncoder().encode(mix.samples));
      }
    }
    // ignore: avoid_print
    print(report.join('\n'));
    expect(problems, isEmpty);
  });
}
