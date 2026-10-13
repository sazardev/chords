import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:chords/presentation/features/guitar_control/guitar_mic_keeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_audio_repository.dart';

/// Tests del guardián del micrófono del catálogo.
void main() {
  late FakeAudioRepository audio;
  late GuitarCommandListener listener;
  late GuitarMicKeeper keeper;

  setUp(() {
    audio = FakeAudioRepository();
    listener = GuitarCommandListener(audio);
    keeper = GuitarMicKeeper(audio, listener);
  });

  tearDown(() async {
    await keeper.close();
    listener.dispose();
  });

  test('close solo cierra lo que abrió open', () async {
    await keeper.close();
    expect(audio.stops, 0);
    await keeper.open();
    expect(audio.requests, 1);
    await keeper.close();
    expect(audio.stops, 1);
    await keeper.close();
    expect(audio.stops, 1);
  });

  testWidgets('reabre el micrófono si deja de llegar sonido con barra', (
    WidgetTester tester,
  ) async {
    final Object owner = Object();
    listener.attach(owner, <GuitarAction>[
      GuitarAction(
        command: GuitarCommand.next,
        label: 'Abrir',
        icon: Icons.check,
        onTrigger: () {},
      ),
    ]);
    await keeper.open();
    expect(audio.requests, 1);

    await tester.pump(const Duration(seconds: 5));
    expect(audio.requests, greaterThan(1));

    await keeper.close();
    listener.detach(owner);
  });

  testWidgets('sin barra a la vista no toca el micrófono', (
    WidgetTester tester,
  ) async {
    await keeper.open();
    await tester.pump(const Duration(seconds: 5));
    expect(audio.requests, 1);
    await keeper.close();
  });
}
