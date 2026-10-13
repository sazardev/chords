import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes/fake_audio_repository.dart';

/// Tests del oyente que maneja la app con las cuerdas al aire.
void main() {
  late FakeAudioRepository audio;
  late DateTime now;
  late GuitarCommandListener listener;
  late List<String> fired;
  late int haptics;

  GuitarAction action(GuitarCommand command, {String? label}) => GuitarAction(
    command: command,
    label: label ?? command.name,
    icon: Icons.check,
    onTrigger: () => fired.add(command.name),
  );

  /// Deja pasar [by] y que el oyente note el silencio.
  Future<void> advance(Duration by) async {
    now = now.add(by);
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  Future<void> pluck(String note, {int times = 3}) async {
    for (int i = 0; i < times; i++) {
      audio.emitReading(note);
      await pumpEventQueue();
    }
  }

  setUp(() {
    audio = FakeAudioRepository();
    now = DateTime(2026);
    fired = <String>[];
    haptics = 0;
    listener = GuitarCommandListener(
      audio,
      clock: () => now,
      onFired: () => haptics++,
    );
  });

  tearDown(() {
    listener.dispose();
  });

  test(
    'una cuerda al aire ejecuta su acción tras el silencio previo',
    () async {
      final Object owner = Object();
      listener.attach(owner, <GuitarAction>[
        action(GuitarCommand.next),
        action(GuitarCommand.retry),
      ]);
      await pluck('E2');
      expect(fired, isEmpty, reason: 'aún suena la nota anterior');

      await advance(const Duration(seconds: 1));
      expect(listener.state.armed, isTrue);
      await pluck('A2');
      expect(fired, <String>['retry']);
      expect(haptics, 1);
      expect(listener.state.lastFired, GuitarCommand.retry);
    },
  );

  test('una cuerda que la pantalla no ofrece no hace nada', () async {
    listener.attach(Object(), <GuitarAction>[action(GuitarCommand.next)]);
    await advance(const Duration(seconds: 1));
    await pluck('D3');
    expect(fired, isEmpty);
  });

  test('tras ejecutar una acción hay que esperar otro silencio', () async {
    listener.attach(Object(), <GuitarAction>[action(GuitarCommand.next)]);
    await advance(const Duration(seconds: 1));
    await pluck('E2');
    expect(fired, <String>['next']);

    now = now.add(const Duration(milliseconds: 100));
    await pluck('E2');
    expect(fired, hasLength(1), reason: 'la nota sigue sonando');

    await advance(const Duration(seconds: 1));
    await pluck('E2');
    expect(fired, hasLength(2));
  });

  test('trigger ejecuta la acción sin guitarra (botón)', () {
    listener
      ..attach(Object(), <GuitarAction>[action(GuitarCommand.exit)])
      ..trigger(GuitarCommand.exit);
    expect(fired, <String>['exit']);
    expect(haptics, 0);
    listener.trigger(GuitarCommand.next);
    expect(fired, hasLength(1));
  });

  test('muteFor ignora lo que suena por el altavoz', () async {
    listener.attach(Object(), <GuitarAction>[action(GuitarCommand.next)]);
    await advance(const Duration(seconds: 1));
    listener.muteFor(const Duration(seconds: 2));
    await pluck('E2');
    expect(fired, isEmpty);

    await advance(const Duration(seconds: 4));
    await pluck('E2');
    expect(fired, <String>['next']);
  });

  test('sin acciones no escucha', () async {
    expect(listener.state.actions, isEmpty);
    await pluck('E2');
    expect(fired, isEmpty);
    expect(listener.state.armed, isFalse);
  });

  test('detach retira las acciones solo del dueño vigente', () async {
    final Object first = Object();
    final Object second = Object();
    listener
      ..attach(first, <GuitarAction>[action(GuitarCommand.next)])
      ..attach(second, <GuitarAction>[action(GuitarCommand.retry)])
      ..detach(first);
    expect(listener.state.actions.single.command, GuitarCommand.retry);
    listener.detach(second);
    expect(listener.state.actions, isEmpty);
  });

  test('desactivado no escucha pero los botones siguen', () async {
    listener
      ..enabled = false
      ..attach(Object(), <GuitarAction>[action(GuitarCommand.next)]);
    await advance(const Duration(seconds: 1));
    await pluck('E2');
    expect(fired, isEmpty);
    expect(listener.state.armed, isFalse);
    listener.trigger(GuitarCommand.next);
    expect(fired, <String>['next']);
  });

  test('sabe si llega sonido del micrófono', () async {
    listener.attach(Object(), <GuitarAction>[action(GuitarCommand.next)]);
    expect(listener.state.hearing, isFalse);
    audio.emitLevel(0.4);
    await pumpEventQueue();
    expect(listener.state.hearing, isTrue);
    expect(listener.state.level, 0.4);
  });
}
