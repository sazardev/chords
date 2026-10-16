import 'dart:async';
import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/data/audio/mic_chord_analyzer.dart';
import 'package:chords/data/audio/mic_pitch_analyzer.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/services/chord_recognizer.dart';
import 'package:chords/domain/audio/services/playback_echo_gate.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../support/chord_audio_probe.dart';

/// Reconocedor que cuenta cuántas muestras analiza.
class _CountingRecognizer extends ChordRecognizer {
  _CountingRecognizer() : super(sampleRate: kProbeRate);

  int samples = 0;
  int resets = 0;

  @override
  List<ChordReading> addSamples(Float64List samples) {
    this.samples += samples.length;
    return super.addSamples(samples);
  }

  @override
  void reset() {
    resets++;
    super.reset();
  }
}

Float64List _cMajor({double seconds = 2.5}) =>
    const ChordAudioSynthesizer().synthesize(
      loadChordBank().chordById('C-maj')!.easiestVariant,
      duration: seconds,
    );

/// Tests de la integración del reconocedor de acordes con el micrófono.
void main() {
  test('reconoce un acorde a partir del flujo PCM16 del analizador', () async {
    final MicChordAnalyzer chords = MicChordAnalyzer(sampleRate: kProbeRate);
    final MicPitchAnalyzer analyzer = MicPitchAnalyzer(
      sampleRate: kProbeRate,
      sink: chords,
    );
    final List<ChordReading> readings = <ChordReading>[];
    final StreamSubscription<ChordReading> subscription = chords.readings
        .listen(readings.add);

    pcmChunks(_cMajor()).forEach(analyzer.addBytes);
    await Future<void>.delayed(Duration.zero);

    expect(readings, isNotEmpty);
    expect(readings[readings.length ~/ 2].chord?.id, 'C-maj');
    await subscription.cancel();
    await analyzer.dispose();
    await chords.dispose();
  });

  test(
    'el afinador sigue recibiendo sus lecturas con el reconocedor',
    () async {
      final MicChordAnalyzer chords = MicChordAnalyzer(sampleRate: kProbeRate);
      final MicPitchAnalyzer analyzer = MicPitchAnalyzer(
        sampleRate: kProbeRate,
        sink: chords,
      );
      final List<Object> pitches = <Object>[];
      final StreamSubscription<Object> subscription = analyzer.readings.listen(
        pitches.add,
      );
      final List<ChordReading> readings = <ChordReading>[];
      final StreamSubscription<ChordReading> chordSubscription = chords.readings
          .listen(readings.add);

      final Float64List note = const ChordAudioSynthesizer().synthesizeNote(
        110,
        duration: 1.5,
      );
      pcmChunks(note).forEach(analyzer.addBytes);
      await Future<void>.delayed(Duration.zero);

      expect(pitches, isNotEmpty);
      expect(readings, isNotEmpty);
      await subscription.cancel();
      await chordSubscription.cancel();
      await analyzer.dispose();
      await chords.dispose();
    },
  );

  test('sin nadie escuchando no gasta tiempo en acordes', () async {
    final _CountingRecognizer recognizer = _CountingRecognizer();
    final MicChordAnalyzer chords = MicChordAnalyzer(
      sampleRate: kProbeRate,
      recognizer: recognizer,
    );
    final MicPitchAnalyzer analyzer = MicPitchAnalyzer(
      sampleRate: kProbeRate,
      sink: chords,
    );

    pcmChunks(_cMajor(seconds: 1)).forEach(analyzer.addBytes);
    expect(recognizer.samples, 0);

    final StreamSubscription<ChordReading> subscription = chords.readings
        .listen((ChordReading _) {});
    pcmChunks(_cMajor(seconds: 1)).forEach(analyzer.addBytes);
    expect(recognizer.samples, greaterThan(0));

    await subscription.cancel();
    await analyzer.dispose();
    await chords.dispose();
  });

  test(
    'la puerta de eco calla el reconocedor y lo reinicia al abrirse',
    () async {
      int clock = 0;
      final PlaybackEchoGate gate = PlaybackEchoGate(
        clock: () => DateTime.fromMillisecondsSinceEpoch(clock),
      )..playbackStarted(const Duration(seconds: 1));
      final _CountingRecognizer recognizer = _CountingRecognizer();
      final MicChordAnalyzer chords = MicChordAnalyzer(
        sampleRate: kProbeRate,
        recognizer: recognizer,
      );
      final MicPitchAnalyzer analyzer = MicPitchAnalyzer(
        sampleRate: kProbeRate,
        clock: () => clock,
        echoGate: gate,
        sink: chords,
      );
      final List<ChordReading> readings = <ChordReading>[];
      final StreamSubscription<ChordReading> subscription = chords.readings
          .listen(readings.add);

      // Mientras suena el altavoz todo se descarta.
      for (final Uint8List chunk in pcmChunks(_cMajor(seconds: 0.6))) {
        clock += 20;
        analyzer.addBytes(chunk);
      }
      await Future<void>.delayed(Duration.zero);
      expect(recognizer.samples, 0);
      expect(readings.every((ChordReading r) => r.isSilent), isTrue);
      expect(readings, isNotEmpty);

      // Pasado el sonido y su cola, la guitarra vuelve a oírse.
      clock += 3000;
      for (final Uint8List chunk in pcmChunks(_cMajor())) {
        clock += 20;
        analyzer.addBytes(chunk);
      }
      await Future<void>.delayed(Duration.zero);

      expect(recognizer.samples, greaterThan(0));
      expect(readings.any((ChordReading r) => r.chord?.id == 'C-maj'), isTrue);
      await subscription.cancel();
      await analyzer.dispose();
      await chords.dispose();
    },
  );

  test('reset al detener la captura emite silencio y reinicia', () async {
    final _CountingRecognizer recognizer = _CountingRecognizer();
    final MicChordAnalyzer chords = MicChordAnalyzer(
      sampleRate: kProbeRate,
      recognizer: recognizer,
    );
    final List<ChordReading> readings = <ChordReading>[];
    final StreamSubscription<ChordReading> subscription = chords.readings
        .listen(readings.add);

    chords.reset();
    await Future<void>.delayed(Duration.zero);

    expect(readings.single.isSilent, isTrue);
    expect(recognizer.resets, 1);
    await subscription.cancel();
    await chords.dispose();
  });
}
