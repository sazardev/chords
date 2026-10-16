import 'dart:typed_data';

import 'package:chords/data/audio/band/band_voice_engine.dart';
import 'package:chords/data/audio/band_audio_repository_impl.dart';
import 'package:chords/domain/band/entities/band_config.dart';
import 'package:chords/domain/band/entities/band_sound.dart';
import 'package:chords/domain/band/presets/band_preset_catalog.dart';
import 'package:chords/domain/band/services/band_arranger.dart';
import 'package:chords/domain/jam/jam_track.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

/// Motor que solo cuenta bytes: el tiempo medido es el de síntesis y WAV.
class _CountingEngine implements BandVoiceEngine {
  int bytes = 0;
  int loads = 0;

  @override
  Future<void> ensureReady() async {}

  @override
  Future<Object> load(String name, Uint8List wav) async {
    bytes += wav.length;
    loads++;
    return name;
  }

  @override
  int play(Object source, {required double volume, Duration? loopStart}) => 0;

  @override
  void fadeOut(int handle, Duration fade) {}

  @override
  Future<void> unload(Object source) async {}
}

StrumPattern _strumOf(String notation) => StrumPattern.values.firstWhere(
  (StrumPattern p) => p.notation == notation,
  orElse: () => StrumPattern.quarters,
);

JamTrack _track(String genre, List<String> chords, int loops) => JamTrack(
  key: 'timing:$genre',
  title: genre,
  bars: <JamBar>[
    for (int loop = 0; loop < loops; loop++)
      for (final String chord in chords)
        (chords: <ChordSymbol>[ChordSymbol.parse(chord)], lyric: ''),
  ],
  bpm: 100,
  strum: _strumOf(bandPresetFor(genre).baseStrum),
  tonic: 0,
  genre: genre,
  loopLength: chords.length,
);

/// Cuánto tarda en sintetizar y preparar la banda de cada género.
///
/// En un equipo de escritorio; un móvil de gama media es entre 3 y 6 veces
/// más lento, pero los lotes se reparten entre varios núcleos.
void main() {
  Future<({int ms, int sounds, int kib})> measure(JamTrack track) async {
    final _CountingEngine engine = _CountingEngine();
    final BandAudioRepositoryImpl repo = BandAudioRepositoryImpl(
      engine: engine,
    );
    final List<BandSound> sounds = BandArranger(
      track,
      const BandConfig(humanize: 0),
    ).sounds();
    final Stopwatch watch = Stopwatch()..start();
    double last = 0;
    await repo.preload(
      sounds,
      onProgress: (double p) {
        expect(p, greaterThanOrEqualTo(last));
        last = p;
      },
    );
    watch.stop();
    expect(last, 1);
    expect(engine.loads, sounds.length);
    return (
      ms: watch.elapsedMilliseconds,
      sounds: sounds.length,
      kib: engine.bytes ~/ 1024,
    );
  }

  test('un compás de cada género se prepara en poco tiempo', () async {
    final List<String> report = <String>[];
    int worst = 0;
    for (final String genre in kBandPresets.keys) {
      final ({int ms, int sounds, int kib}) one = await measure(
        _track(genre, <String>['C'], 1),
      );
      worst = worst > one.ms ? worst : one.ms;
      report.add(
        '${genre.padRight(10)} 1 compás: ${one.sounds.toString().padLeft(3)} '
        'muestras ${one.ms.toString().padLeft(5)} ms ${one.kib} KiB',
      );
    }
    // ignore: avoid_print
    print(report.join('\n'));
    expect(worst, lessThan(4000));
  });

  test('una pista completa de cada género se prepara en segundos', () async {
    final List<String> report = <String>[];
    int worst = 0;
    int heaviest = 0;
    for (final String genre in kBandPresets.keys) {
      final ({int ms, int sounds, int kib}) full = await measure(
        _track(genre, <String>['C', 'Am', 'F', 'G', 'Dm', 'E7', 'Bb', 'A7'], 2),
      );
      worst = worst > full.ms ? worst : full.ms;
      heaviest = heaviest > full.kib ? heaviest : full.kib;
      report.add(
        '${genre.padRight(10)} 8 acordes: ${full.sounds.toString().padLeft(3)} '
        'muestras ${full.ms.toString().padLeft(5)} ms ${full.kib} KiB',
      );
    }
    // ignore: avoid_print
    print(report.join('\n'));
    expect(worst, lessThan(12000));
    expect(heaviest, lessThan(60 * 1024), reason: 'memoria de la precarga');
  });
}
