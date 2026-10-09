import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/domain/chords/entities/arpeggio_pattern.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:test/test.dart';

/// Tests del sintetizador de arpegios.
void main() {
  /// Posición de prueba: C mayor con cejilla en el traste 8.
  const ChordVariant variant = ChordVariant(
    id: 'test',
    positionLabel: 'Prueba',
    frets: <int>[8, 10, 10, 9, 8, 8],
    fingers: <int>[1, 3, 4, 2, 1, 1],
    difficulty: Difficulty.medium,
  );

  group('synthesizeArpeggio', () {
    test('genera audio con la duración del patrón', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      final Float64List samples = synthesizer.synthesizeArpeggio(
        variant,
        ArpeggioPattern.ascending.stringOrder,
        ArpeggioPattern.ascending.intervalMs,
        duration: 2,
      );
      // La duración total es la pedida (2 s), con las notas escalonadas.
      expect(samples.length, synthesizer.sampleRate * 2);
      double peak = 0;
      for (final double value in samples) {
        expect(value.abs() <= 1, isTrue);
        peak = peak > value.abs() ? peak : value.abs();
      }
      expect(peak, greaterThan(0.1));
    });

    test('el arpegio ascendente suena una nota a la vez', () {
      const ChordAudioSynthesizer synthesizer = ChordAudioSynthesizer();
      final Float64List samples = synthesizer.synthesizeArpeggio(
        variant,
        const <int>[0, 1, 2, 3, 4, 5],
        400,
      );
      // Tras cada nota hay un ataque claro: el pico primero es mayor.
      final double firstPeak = samples
          .sublist(0, 44100 ~/ 10)
          .fold<double>(0, (double a, double b) => a > b ? a : b);
      final double midSilence = samples
          .sublist(44100 ~/ 5, 44100 ~/ 5 + 44100 ~/ 50)
          .fold<double>(0, (double a, double b) => a > b ? a : b);
      expect(firstPeak, greaterThan(midSilence));
    });

    test('los patrones disponibles cubren dificultades progresivas', () {
      expect(ArpeggioPattern.all.length, 4);
      expect(
        ArpeggioPattern.all.map((ArpeggioPattern p) => p.difficulty).toList(),
        orderedEquals(<int>[1, 1, 2, 3]),
      );
    });
  });
}
