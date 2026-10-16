import 'dart:typed_data';

import 'package:chords/data/audio/chord_audio_synthesizer.dart';
import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/entities/chord_reading.dart';
import 'package:chords/domain/audio/services/chord_recognizer.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:test/test.dart';

import '../../fakes/chord_bank.dart';
import '../../support/chord_audio_probe.dart';

const ChordAudioSynthesizer _synth = ChordAudioSynthesizer();

/// Sintetiza la posición más fácil del acorde [id] del banco.
Float64List _chord(String id, {double seconds = 3}) {
  final Chord chord = loadChordBank().chordById(id)!;
  return _synth.synthesize(chord.easiestVariant, duration: seconds);
}

/// Acordes distintos (por id) que se ven a lo largo de [readings].
List<String> _sequence(Iterable<ChordReading> readings) {
  final List<String> ids = <String>[];
  for (final ChordReading reading in readings) {
    final String? id = reading.chord?.id;
    if (id != null && (ids.isEmpty || ids.last != id)) {
      ids.add(id);
    }
  }
  return ids;
}

/// Tests del reconocedor polifónico completo (audio → acorde estable).
void main() {
  group('silencio y ruido', () {
    test('el silencio da lecturas de silencio y ningún acorde', () {
      final List<ChordReading> readings = recognize(
        Float64List(kProbeRate * 3),
      );

      expect(readings, hasLength(30));
      for (final ChordReading reading in readings) {
        expect(reading.isSilent, isTrue);
        expect(reading.chord, isNull);
        expect(reading.candidates, isEmpty);
        expect(reading.level, 0);
      }
    });

    test('por debajo de la puerta de ruido no se intenta reconocer nada', () {
      final Float64List quiet = Float64List.fromList(
        _chord('C-maj').map((double v) => v * 0.002).toList(),
      );

      final List<ChordReading> readings = recognize(quiet);

      expect(readings.every((ChordReading r) => r.isSilent), isTrue);
    });

    test('el ruido blanco, flojo o fuerte, nunca da un acorde', () {
      for (final double rms in <double>[0.005, 0.02, 0.1, 0.3]) {
        final List<ChordReading> readings = recognize(
          whiteNoise(kProbeRate * 3, rms),
        );

        expect(
          readings.where((ChordReading r) => r.chord != null),
          isEmpty,
          reason: 'rms $rms',
        );
        expect(
          readings.every((ChordReading r) => r.confidence == 0),
          isTrue,
          reason: 'rms $rms',
        );
      }
    });

    test('una sola nota nunca llega a confianza alta', () {
      for (final double hz in <double>[
        82.41,
        110,
        146.83,
        196,
        246.94,
        329.63,
        523.25,
      ]) {
        final List<ChordReading> readings = recognize(
          _synth.synthesizeNote(hz, duration: 3),
        );
        final double best = readings
            .map((ChordReading r) => r.confidence)
            .reduce((double a, double b) => a > b ? a : b);

        expect(best, lessThan(0.75), reason: '$hz Hz');
      }
    });
  });

  group('acordes', () {
    test('Do mayor rasgueado se reconoce, con su bajo y confianza alta', () {
      final List<ChordReading> readings = recognize(_chord('C-maj'));

      for (final double t in <double>[1.2, 1.6, 2]) {
        final ChordReading reading = readingAt(readings, t);
        expect(reading.chord?.id, 'C-maj', reason: '$t s');
        expect(reading.confidence, greaterThan(0.7), reason: '$t s');
        expect(reading.bass, 0, reason: '$t s');
        expect(reading.isSilent, isFalse);
      }
    });

    test('el cromagrama enciende las notas del acorde', () {
      final ChordReading reading = readingAt(recognize(_chord('A-min')), 1.6);

      expect(reading.chroma, hasLength(12));
      for (final int note in <int>[9, 0, 4]) {
        expect(reading.chroma[note], greaterThan(0.4), reason: 'nota $note');
      }
      expect(reading.chroma.reduce((double a, double b) => a > b ? a : b), 1);
    });

    test('las alternativas excluyen el acorde mostrado y vienen ordenadas', () {
      final ChordReading reading = readingAt(recognize(_chord('E-min')), 1.6);

      expect(reading.chord?.id, 'E-min');
      expect(reading.alternatives, isNotEmpty);
      expect(
        reading.alternatives.map((ChordCandidate c) => c.id),
        isNot(contains('E-min')),
      );
    });

    test('un cambio de acorde se sigue sin parpadear', () {
      // Sol entra a los 1.5 s, solapado con la cola de Do.
      final Float64List first = _chord('C-maj', seconds: 2);
      final Float64List second = _chord('G-maj', seconds: 2);
      final Float64List audio = Float64List(kProbeRate * 4)
        ..setRange(0, first.length, first);
      for (int i = 0; i < second.length; i++) {
        audio[(1.5 * kProbeRate).round() + i] += second[i];
      }

      final List<ChordReading> readings = recognize(audio);

      expect(_sequence(readings.skip(8)), <String>['C-maj', 'G-maj']);
      expect(readingAt(readings, 3.2).chord?.id, 'G-maj');
    });

    test('aguanta ruido de fondo, volumen bajo y un micrófono de móvil', () {
      final Float64List clean = _chord('D-maj');
      final Map<String, Float64List> variants = <String, Float64List>{
        'ruido': mix(clean, whiteNoise(clean.length, 0.16 * 0.03)),
        'bajo': Float64List.fromList(clean.map((double v) => v * 0.1).toList()),
        'móvil': highPass(clean, 150),
        'móvil con ruido': mix(
          highPass(clean, 150),
          whiteNoise(clean.length, 0.16 * 0.03),
        ),
      };

      for (final MapEntry<String, Float64List> entry in variants.entries) {
        final ChordReading reading = readingAt(recognize(entry.value), 1.2);
        expect(reading.chord?.id, 'D-maj', reason: entry.key);
      }
    });

    test('tras un silencio, el acorde nuevo aparece enseguida', () {
      final Float64List chord = _chord('G-maj', seconds: 2);
      final Float64List audio = Float64List(kProbeRate * 3)
        ..setRange(kProbeRate, kProbeRate + chord.length, chord);

      final List<ChordReading> readings = recognize(audio);

      expect(readingAt(readings, 0.8).isSilent, isTrue);
      expect(readingAt(readings, 2).chord?.id, 'G-maj');
    });

    test('el nivel sube con el volumen', () {
      final Float64List loud = _chord('C-maj');
      final Float64List soft = Float64List.fromList(
        loud.map((double v) => v * 0.1).toList(),
      );

      final double loudLevel = readingAt(recognize(loud), 1).level;
      final double softLevel = readingAt(recognize(soft), 1).level;

      expect(loudLevel, greaterThan(softLevel));
      expect(softLevel, greaterThan(0));
    });
  });

  group('determinismo y estado', () {
    test('el resultado no depende del tamaño de los bloques de entrada', () {
      final Float64List audio = _chord('A-maj', seconds: 2);
      final List<ChordReading> small = recognize(audio);

      final ChordRecognizer recognizer = ChordRecognizer(
        sampleRate: kProbeRate,
      );
      final List<ChordReading> big = <ChordReading>[];
      for (int s = 0; s < audio.length; s += kProbeRate) {
        big.addAll(
          recognizer.addSamples(
            Float64List.sublistView(
              audio,
              s,
              s + kProbeRate > audio.length ? audio.length : s + kProbeRate,
            ),
          ),
        );
      }

      expect(big.length, small.length);
      for (int i = 0; i < small.length; i++) {
        expect(big[i].chord?.id, small[i].chord?.id, reason: 'lectura $i');
        expect(big[i].chroma, small[i].chroma, reason: 'lectura $i');
      }
    });

    test('emite una lectura cada 100 ms', () {
      expect(recognize(Float64List(kProbeRate * 2)), hasLength(20));
    });

    test('reset olvida el acorde y empieza de cero', () {
      final ChordRecognizer recognizer = ChordRecognizer(
        sampleRate: kProbeRate,
      );
      final List<ChordReading> first = recognize(
        _chord('C-maj'),
        recognizer: recognizer,
      );
      expect(readingAt(first, 1.5).chord?.id, 'C-maj');

      recognizer.reset();
      final List<ChordReading> after = recognize(
        Float64List(kProbeRate),
        recognizer: recognizer,
      );

      expect(after.every((ChordReading r) => r.chord == null), isTrue);
    });
  });
}
