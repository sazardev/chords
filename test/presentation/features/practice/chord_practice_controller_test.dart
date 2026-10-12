import 'package:chords/domain/audio/entities/guitar_string.dart';
import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:chords/domain/chords/entities/practice_string.dart';
import 'package:chords/presentation/features/practice/chord_practice_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';

Future<void> _settle() => Future<void>.delayed(Duration.zero);

/// Frecuencia de la cuerda [number] en el traste [fret].
double _note(int number, int fret) =>
    standardStringByNumber(number)!.frequency * _semitones(fret);

double _semitones(int fret) {
  double ratio = 1;
  for (int i = 0; i < fret; i++) {
    ratio *= 1.0594630943592953;
  }
  return ratio;
}

/// Tests del controlador del modo práctica.
void main() {
  late FakeAudioRepository audio;
  late ChordPracticeController controller;

  const Chord cMajor = Chord(
    id: 'C-maj',
    root: ChordRoot.c,
    quality: ChordQuality.major,
    variants: <ChordVariant>[
      ChordVariant(
        id: 'c-open',
        positionLabel: 'Abierto',
        frets: <int>[-1, 3, 2, 0, 1, 0],
        fingers: <int>[0, 3, 2, 0, 1, 0],
        difficulty: Difficulty.beginner,
        notes: <String>['C', 'E', 'G'],
      ),
    ],
  );

  setUp(() {
    audio = FakeAudioRepository();
    controller = ChordPracticeController(
      audio,
      FakeChordRepository(<Chord>[cMajor]),
      silenceGap: const Duration(milliseconds: 20),
    );
  });

  tearDown(() => controller.dispose());

  /// Emite una nota estable (lo bastante larga para pasar la puerta).
  Future<void> pluck(double frequency) async {
    for (int i = 0; i < 3; i++) {
      audio.emitFrequency(frequency);
      await _settle();
    }
    await Future<void>.delayed(const Duration(milliseconds: 40));
  }

  test(
    'abre el acorde y prepara una sesión con las cuerdas pendientes',
    () async {
      expect(await controller.open('C-maj', 0), isTrue);
      expect(controller.session?.total, 5);
      expect(controller.session?.focus?.number, 5);
      expect(await controller.open('no-existe', 0), isFalse);
    },
  );

  test('reconoce cada cuerda al tocarla y completa el acorde', () async {
    await controller.open('C-maj', 0);
    await controller.start();

    await pluck(_note(5, 3));
    expect(controller.session?.matchedCount, 1);
    await pluck(_note(4, 2));
    await pluck(_note(3, 0));
    await pluck(_note(2, 1));
    await pluck(_note(1, 0));
    expect(controller.session?.isComplete, isTrue);
    await _settle();
    expect(controller.status, MicStatus.idle);
  });

  test('una cuerda mal pulsada deja un consejo en la cuerda en foco', () async {
    await controller.open('C-maj', 0);
    await controller.start();

    await pluck(_note(5, 2));
    expect(controller.session?.matchedCount, 0);
    expect(controller.session?.tip?.kind, PracticeTipKind.moveUp);
    expect(controller.session?.tip?.stringNumber, 5);
  });

  test('una nota sostenida cuenta una sola vez', () async {
    await controller.open('C-maj', 0);
    await controller.start();

    for (int i = 0; i < 10; i++) {
      audio.emitFrequency(_note(5, 3));
      await _settle();
    }
    expect(controller.session?.matchedCount, 1);
  });

  test('ignora el micrófono mientras suena una referencia', () async {
    await controller.open('C-maj', 0);
    await controller.start();
    await controller.playString(controller.session!.focus!);
    expect(audio.tones, hasLength(1));

    await pluck(_note(5, 3));
    expect(controller.session?.matchedCount, 0);
  });

  test('el permiso denegado deja el estado visible', () async {
    audio.accessResult = MicStatus.permissionDenied;
    await controller.open('C-maj', 0);
    await controller.start();
    expect(controller.status, MicStatus.permissionDenied);
    expect(controller.status.isListening, isFalse);
  });

  test('restart borra el progreso y mantiene la escucha', () async {
    await controller.open('C-maj', 0);
    await controller.start();
    await pluck(_note(5, 3));
    await controller.start();
    expect(controller.session?.matchedCount, 0);
    expect(controller.status.isListening, isTrue);
  });
}
