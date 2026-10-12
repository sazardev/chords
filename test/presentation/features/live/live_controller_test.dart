import 'package:chords/domain/audio/entities/mic_status.dart';
import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/presentation/features/live/live_controller.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_audio_repository.dart';
import '../../../fakes/fake_chord_repository.dart';

/// Tests del ciclo de escucha del controlador en vivo.
void main() {
  test('stopIfListening detiene la escucha solo cuando está activa', () async {
    final FakeAudioRepository audio = FakeAudioRepository();
    final LiveController controller = LiveController(
      audio,
      FakeChordRepository(const <Chord>[]),
    );

    await controller.stopIfListening();
    expect(controller.status, MicStatus.idle);

    await controller.start();
    await audio.startListening();
    await Future<void>.delayed(Duration.zero);
    expect(controller.status, MicStatus.listening);

    await controller.stopIfListening();
    expect(controller.status, MicStatus.idle);

    controller.dispose();
  });
}
