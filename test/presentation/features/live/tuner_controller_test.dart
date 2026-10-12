import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/audio/entities/string_tuning.dart';
import 'package:chords/presentation/features/live/tuner_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_audio_repository.dart';

/// Deja correr los flujos asíncronos de un test.
Future<void> _settle() => Future<void>.delayed(Duration.zero);

/// Tests del controlador del afinador por cuerdas.
void main() {
  late FakeAudioRepository audio;
  late TunerController tuner;

  setUp(() {
    audio = FakeAudioRepository();
    tuner = TunerController(
      audio,
      signalTimeout: const Duration(milliseconds: 40),
    );
  });

  tearDown(() => tuner.dispose());

  test(
    'reconoce la cuerda que suena y dice hacia dónde mover la clavija',
    () async {
      await tuner.start();
      audio.emitFrequency(kStandardTuning[1].frequency * 0.985);
      await _settle();

      final StringTuningReading reading = tuner.state.reading!;
      expect(reading.string.number, 5);
      expect(reading.direction, TuneDirection.up);
      expect(tuner.state.isListening, isTrue);
    },
  );

  test(
    'marca la cuerda como afinada tras varias lecturas dentro de margen',
    () async {
      await tuner.start();
      for (int i = 0; i < 3; i++) {
        audio.emitFrequency(kStandardTuning[0].frequency);
        await _settle();
      }
      expect(tuner.state.tuned, isEmpty);

      audio.emitFrequency(kStandardTuning[0].frequency);
      await _settle();
      expect(tuner.state.tuned, <int>{6});
    },
  );

  test(
    'una cuerda afinada que se desafina vuelve a quedar pendiente',
    () async {
      await tuner.start();
      for (int i = 0; i < 4; i++) {
        audio.emitFrequency(kStandardTuning[3].frequency);
        await _settle();
      }
      expect(tuner.state.tuned, <int>{3});

      for (int i = 0; i < 5; i++) {
        audio.emitFrequency(kStandardTuning[3].frequency * 1.04);
        await _settle();
      }
      expect(tuner.state.tuned, isEmpty);
    },
  );

  test('las seis cuerdas afinadas completan la sesión', () async {
    await tuner.start();
    for (final GuitarString string in kStandardTuning) {
      for (int i = 0; i < 4; i++) {
        audio.emitFrequency(string.frequency);
        await _settle();
      }
    }
    expect(tuner.state.allTuned, isTrue);
  });

  test(
    'en modo manual mide contra la cuerda elegida y avisa de otra',
    () async {
      await tuner.start();
      tuner.selectString(kStandardTuning[2]);
      audio.emitFrequency(kStandardTuning[2].frequency * 1.01);
      await _settle();
      expect(tuner.state.reading?.string.number, 4);

      audio.emitFrequency(kStandardTuning[5].frequency);
      await _settle();
      expect(tuner.state.reading, isNull);
      expect(tuner.state.heardOther?.number, 1);

      tuner.selectString(kStandardTuning[2]);
      expect(tuner.state.target, isNull);
    },
  );

  test(
    'sin señal la lectura desaparece pero el progreso se conserva',
    () async {
      await tuner.start();
      for (int i = 0; i < 4; i++) {
        audio.emitFrequency(kStandardTuning[1].frequency);
        await _settle();
      }
      expect(tuner.state.reading, isNotNull);

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(tuner.state.reading, isNull);
      expect(tuner.state.tuned, <int>{5});
    },
  );

  test('ignora lecturas poco fiables y el nivel llega al estado', () async {
    await tuner.start();
    audio
      ..emitFrequency(kStandardTuning[1].frequency, clarity: 0.3)
      ..emitLevel(0.5);
    await _settle();
    expect(tuner.state.reading, isNull);
    expect(tuner.state.level, 0.5);
  });

  test('si el permiso se deniega el estado lo refleja', () async {
    audio.accessResult = MicStatus.permissionDenied;
    await tuner.start();
    expect(tuner.state.status, MicStatus.permissionDenied);
    expect(tuner.state.isListening, isFalse);
  });

  test('al reproducir una referencia ignora el micrófono un rato', () async {
    await tuner.start();
    await tuner.playReference(kStandardTuning[0]);
    expect(audio.tones, <double>[kStandardTuning[0].frequency]);

    audio.emitFrequency(kStandardTuning[0].frequency);
    await _settle();
    expect(tuner.state.reading, isNull);
  });

  test('stop deja el estado en reposo y conserva lo afinado', () async {
    await tuner.start();
    for (int i = 0; i < 4; i++) {
      audio.emitFrequency(kStandardTuning[4].frequency);
      await _settle();
    }
    await tuner.stop();
    expect(tuner.state.status, MicStatus.idle);
    expect(tuner.state.tuned, <int>{2});
  });
}
