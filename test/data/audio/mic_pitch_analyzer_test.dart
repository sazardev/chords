import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/data/audio/mic_pitch_analyzer.dart';
import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/pitch_reading.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/domain/audio/services/playback_echo_gate.dart';
import 'package:chords/domain/audio/usecases/analyze_tuning_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

const int _sampleRate = 44100;

/// Convierte muestras (-1..1) a bloques PCM16 little-endian de 20 ms.
List<Uint8List> _toPcmChunks(Float64List samples, {double gain = 1}) {
  const int chunk = _sampleRate ~/ 50;
  final List<Uint8List> out = <Uint8List>[];
  for (int start = 0; start + chunk <= samples.length; start += chunk) {
    final ByteData data = ByteData(chunk * 2);
    for (int i = 0; i < chunk; i++) {
      final double value = (samples[start + i] * gain).clamp(-1.0, 1.0);
      data.setInt16(i * 2, (value * 32767).round(), Endian.little);
    }
    out.add(data.buffer.asUint8List());
  }
  return out;
}

/// Reproduce [samples] por el analizador y devuelve lo que publica.
///
/// Con [echoed] el teléfono "reproduce" esa duración al empezar, y la puerta
/// de eco usa el mismo reloj simulado que el analizador.
Future<({List<PitchReading> readings, List<double> levels})> _listen(
  Float64List samples, {
  double gain = 1,
  Duration? echoed,
}) async {
  int clock = 0;
  final PlaybackEchoGate gate = PlaybackEchoGate(
    clock: () => DateTime.fromMillisecondsSinceEpoch(clock),
  );
  if (echoed != null) {
    gate.playbackStarted(echoed);
  }
  final MicPitchAnalyzer analyzer = MicPitchAnalyzer(
    sampleRate: _sampleRate,
    clock: () => clock,
    echoGate: gate,
  );
  final List<PitchReading> readings = <PitchReading>[];
  final List<double> levels = <double>[];
  final StreamSubscription<PitchReading> a = analyzer.readings.listen(
    readings.add,
  );
  final StreamSubscription<double> b = analyzer.levels.listen(levels.add);
  for (final Uint8List chunk in _toPcmChunks(samples, gain: gain)) {
    clock += 20;
    analyzer.addBytes(chunk);
  }
  await Future<void>.delayed(Duration.zero);
  await a.cancel();
  await b.cancel();
  await analyzer.dispose();
  return (readings: readings, levels: levels);
}

/// Tests de precisión del análisis de micrófono con cuerdas sintetizadas.
void main() {
  const ChordAudioSynthesizer synth = ChordAudioSynthesizer();
  const AnalyzeTuningUseCase analyze = AnalyzeTuningUseCase();

  for (final GuitarString string in kStandardTuning) {
    test(
      'afina con precisión la cuerda ${string.number} (${string.label})',
      () async {
        final Float64List samples = synth.synthesizeNote(
          string.frequency,
          duration: 2,
        );
        final ({List<PitchReading> readings, List<double> levels}) result =
            await _listen(samples);

        expect(result.readings, isNotEmpty);
        final List<double> cents = <double>[
          for (final PitchReading r in result.readings)
            analyze(r.frequency)!.cents,
        ]..sort();
        final double median = cents[cents.length ~/ 2];
        final StringTuningReading best = analyze(
          string.frequency * math.pow(2, median / 1200),
        )!;
        expect(best.string, string);
        expect(median.abs(), lessThan(5), reason: '${string.label}: $median¢');
      },
    );
  }

  test('una nota suave sigue detectándose (micrófono de móvil)', () async {
    final Float64List samples = synth.synthesizeNote(
      kStandardTuning[2].frequency,
      duration: 2,
    );
    final ({List<PitchReading> readings, List<double> levels}) result =
        await _listen(samples, gain: 0.08);
    expect(result.readings, isNotEmpty);
    expect(result.readings.every((PitchReading r) => r.isReliable), isTrue);
  });

  test('el silencio publica nivel bajo y ninguna lectura', () async {
    final ({List<PitchReading> readings, List<double> levels}) result =
        await _listen(Float64List(_sampleRate));
    expect(result.readings, isEmpty);
    expect(result.levels, isNotEmpty);
    expect(result.levels.every((double l) => l < 0.05), isTrue);
  });

  test('no toma por guitarra el sonido que emite el propio móvil', () async {
    final Float64List samples = synth.synthesizeNote(
      kStandardTuning[1].frequency,
      duration: 2,
    );
    final ({List<PitchReading> readings, List<double> levels}) result =
        await _listen(samples, echoed: const Duration(seconds: 2));
    expect(result.readings, isEmpty);
    expect(result.levels.every((double l) => l == 0), isTrue);
  });

  test('tras la reproducción vuelve a oír la guitarra', () async {
    final Float64List samples = synth.synthesizeNote(
      kStandardTuning[1].frequency,
      duration: 3,
    );
    final ({List<PitchReading> readings, List<double> levels}) result =
        await _listen(samples, echoed: const Duration(seconds: 1));
    expect(result.readings, isNotEmpty);
    expect(result.readings.first.note, startsWith('A'));
  });
}
