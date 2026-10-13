import 'dart:typed_data';

import 'package:chords/domain/audio/services/playback_echo_gate.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests de la puerta que evita oír el altavoz del propio teléfono.
void main() {
  late DateTime now;
  late PlaybackEchoGate gate;

  void advance(int ms) => now = now.add(Duration(milliseconds: ms));

  setUp(() {
    now = DateTime(2026);
    gate = PlaybackEchoGate(clock: () => now);
  });

  test('sin reproducción deja pasar todo', () {
    expect(gate.isMuting, isFalse);
    expect(gate.admits(0.5), isTrue);
  });

  test('mientras suena el altavoz descarta el audio', () {
    gate.playbackStarted(const Duration(seconds: 2));
    expect(gate.isMuting, isTrue);
    for (int i = 0; i < 20; i++) {
      advance(90);
      expect(gate.admits(0.2), isFalse, reason: 'a los ${i * 90} ms');
    }
  });

  test('respeta la cola mínima aunque ya no haya nivel', () {
    gate.playbackStarted(const Duration(seconds: 1));
    advance(900);
    gate.admits(0.2);
    advance(200);
    expect(gate.admits(0), isFalse, reason: 'aún dentro de la cola mínima');
    advance(200);
    expect(gate.admits(0), isTrue);
    expect(gate.isMuting, isFalse);
  });

  test('espera a que el eco baje respecto al nivel del altavoz', () {
    gate.playbackStarted(const Duration(seconds: 1));
    advance(500);
    gate.admits(0.2);
    advance(600);
    expect(gate.admits(0.12), isFalse, reason: 'el eco sigue alto');
    advance(200);
    expect(gate.admits(0.05), isTrue, reason: 'bajó del 30 % del máximo');
  });

  test('la cola máxima abre la puerta aunque haya ruido', () {
    gate.playbackStarted(const Duration(seconds: 1));
    advance(500);
    gate.admits(0.2);
    advance(1000);
    expect(gate.admits(0.19), isFalse);
    advance(600);
    expect(gate.admits(0.19), isTrue);
  });

  test('una reproducción nueva alarga el silencio', () {
    gate.playbackStarted(const Duration(seconds: 1));
    advance(800);
    gate.playbackStarted(const Duration(seconds: 2));
    advance(1500);
    expect(gate.admits(0.2), isFalse);
    advance(1200);
    expect(gate.admits(0), isTrue);
  });

  test('una reproducción corta no recorta la anterior', () {
    gate
      ..playbackStarted(const Duration(seconds: 3))
      ..playbackStarted(const Duration(milliseconds: 300));
    advance(2000);
    expect(gate.admits(0.2), isFalse);
  });

  test('la duración audible ignora la cola casi silenciosa', () {
    final Float64List samples = Float64List(1000);
    for (int i = 0; i < 400; i++) {
      samples[i] = 0.9 * (1 - i / 400);
    }
    samples[900] = 0.01;
    final Duration audible = PlaybackEchoGate.audibleLength(samples, 1000);
    expect(audible.inMilliseconds, inInclusiveRange(380, 400));
    expect(
      PlaybackEchoGate.audibleLength(Float64List(100), 1000),
      Duration.zero,
    );
  });
}
