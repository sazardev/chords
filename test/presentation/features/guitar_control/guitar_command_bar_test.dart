import 'package:chords/domain/audio/entities/guitar_command.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:chords/presentation/features/guitar_control/guitar_action.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_bar.dart';
import 'package:chords/presentation/features/guitar_control/guitar_command_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../fakes/fake_audio_repository.dart';

/// Tests de la barra visual de órdenes de guitarra.
void main() {
  late FakeAudioRepository audio;
  late GuitarCommandListener listener;
  late DateTime now;
  late List<String> fired;

  List<GuitarAction> actions() => <GuitarAction>[
    GuitarAction(
      command: GuitarCommand.next,
      label: 'Continuar',
      icon: Icons.arrow_forward_rounded,
      emphasized: true,
      onTrigger: () => fired.add('next'),
    ),
    GuitarAction(
      command: GuitarCommand.retry,
      label: 'Reintentar',
      icon: Icons.replay_rounded,
      onTrigger: () => fired.add('retry'),
    ),
    GuitarAction(
      command: GuitarCommand.listen,
      label: 'Escuchar',
      icon: Icons.volume_up_rounded,
      onTrigger: () => fired.add('listen'),
    ),
    GuitarAction(
      command: GuitarCommand.exit,
      label: 'Salir',
      icon: Icons.logout_rounded,
      onTrigger: () => fired.add('exit'),
    ),
  ];

  Future<void> pumpBar(
    WidgetTester tester, {
    Size size = const Size(320, 640),
    bool tickers = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: ChangeNotifierProvider<GuitarCommandListener>.value(
          value: listener,
          child: MaterialApp(
            home: Scaffold(
              body: TickerMode(
                enabled: tickers,
                child: GuitarCommandBar(actions: actions()),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  setUp(() {
    audio = FakeAudioRepository();
    now = DateTime(2026);
    fired = <String>[];
    listener = GuitarCommandListener(audio, clock: () => now);
  });

  tearDown(() => listener.dispose());

  testWidgets('muestra la nota de cada cuerda y lo que hace', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester);
    for (final String label in <String>[
      'Continuar',
      'Reintentar',
      'Escuchar',
      'Salir',
    ]) {
      expect(find.text(label), findsOne);
    }
    expect(find.text('Mi'), findsOne);
    expect(find.text('La'), findsOne);
    expect(find.text('Re'), findsOne);
    expect(find.text('Si'), findsOne);
    expect(find.text('6ª cuerda al aire'), findsOne);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el encabezado guía: micrófono, silencio y toca', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester);
    expect(find.textContaining('No te oigo'), findsOne);

    audio.emitLevel(0.3);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Deja que se apague la nota…'), findsOne);

    now = now.add(const Duration(seconds: 1));
    audio.emitLevel(0.1);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Toca una cuerda al aire'), findsOne);
  });

  testWidgets('pulsar una tarjeta ejecuta la acción', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester);
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(fired, <String>['retry']);
  });

  testWidgets('una cuerda al aire ejecuta la acción de la tarjeta', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 200));
    for (int i = 0; i < 3; i++) {
      audio.emitReading('D3');
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(fired, <String>['listen']);
  });

  testWidgets('oculta o tapada, la barra no atiende la guitarra', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester, tickers: false);
    expect(listener.state.actions, isEmpty);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 200));
    for (int i = 0; i < 3; i++) {
      audio.emitReading('E2');
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(fired, isEmpty);
  });

  testWidgets('al quitar la barra se retiran las acciones', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester);
    expect(listener.state.actions, hasLength(4));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(listener.state.actions, isEmpty);
  });

  testWidgets('con el control desactivado quedan solo los botones', (
    WidgetTester tester,
  ) async {
    listener.enabled = false;
    await pumpBar(tester);
    expect(find.text('Mi'), findsNothing);
    expect(find.textContaining('No te oigo'), findsNothing);
    expect(find.byIcon(Icons.replay_rounded), findsOne);
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(fired, <String>['next']);
  });
}
